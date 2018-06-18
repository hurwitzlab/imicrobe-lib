#!/usr/bin/env perl

use common::sense;
use autodie;
use Data::Dump 'dump';
use Getopt::Long;
use File::Spec::Functions 'catfile';
use Pod::Usage;
use Readonly;
use Text::RecordParser::Tab;
use IMicrobe::DB;
use String::Trim 'trim';

Readonly my $MAX_ATTR_VALUE_LEN => 255;
Readonly my %SPLITTABLE_FIELDS  => map { $_, 1 } qw(
    ncbi_sra_seq_run
);
Readonly my @SAMPLE_TABLE_FIELDS => qw();
Readonly my $COMMA_SPACE => qr/\s*,\s*/;

main();

# --------------------------------------------------
sub get_args {
    my %args = (
        project_id  => 0,
        sample_file => '',
        fasta_dir   => '',
        help        => 0,
        man_page    => 0,
    );

    GetOptions(\%args,
        'project_id|p=i',
        'sample_file|s=s',
        'fasta_dir|f:s',
        'help',
        'man'
    );

    if ($args{'help'} || $args{'man_page'}) {
        pod2usage({
            -exitval => 0,
            -verbose => $args{'man_page'} ? 2 : 1
        });
    }; 

    unless ($args{'project_id'}) {
        pod2usage('Missing project_id');
    }

    unless ($args{'sample_file'}) {
        pod2usage('Missing sample file argument');
    }

    return %args;
}

# --------------------------------------------------
sub main {
    my %args      = get_args;
    my $db        = IMicrobe::DB->new;
    my $schema    = $db->schema;
    my $meta_file = $args{'sample_file'};

    unless (-f $meta_file) {
        die "-s $meta_file is not a file\n";
    }

    my $Project = $schema->resultset('Project')->find($args{'project_id'})
        or die "Cannot find project id '$args{project_id}'\n";

    printf "Project '%s' (%s)\n", $Project->project_name, $Project->id;

    my $p = Text::RecordParser::Tab->new($meta_file);
    $p->header_filter(sub { $_ = shift; s/\s+/_/g; lc $_ });

    #
    # Get all the possible sample_attr/aliases
    #
    my %attr_fld = map { $_->type, $_->id } 
                   $schema->resultset('SampleAttrType')->all;

    for my $Alias ($schema->resultset('SampleAttrTypeAlias')->all) {
        $attr_fld{ $Alias->alias } = $Alias->sample_attr_type_id;
    }

    my $ReadsType = $schema->resultset('SampleFileType')->find_or_create({ 
        type => 'Reads'
    });

    my $i = 0;
    while (my $sample = $p->fetchrow_hashref) {
        next unless $sample->{'sample_name'};

        my $Sample = $schema->resultset('Sample')->find_or_create({
            project_id   => $Project->id,
            sample_name  => $sample->{'sample_name'},
        });

        my $sample_type = $sample->{'sequence_type'} 
                       || $sample->{'sample_type'};

        if ($sample_type) {
            $Sample->sample_type($sample_type);
            $Sample->update;
        }

        printf "%5d: Sample '%s' (%s)\n", 
            ++$i, $Sample->sample_name, $Sample->id;

        my @PIs;
        if (my $pis = $sample->{'pi'}) {
            for my $pi_name (split $COMMA_SPACE, $pis) {
                my $PI;
                if ($pi_name =~ /^\d+$/) {
                    ($PI) = $schema->resultset('Investigator')->find($pi_name);
                }
                else {
                    ($PI) = $schema->resultset('Investigator')->find_or_create(
                        { investigator_name => $pi_name }
                    );
                }

                if ($PI) {
                    $schema->resultset('SampleToInvestigator')->find_or_create(
                        { investigator_id => $PI->id 
                        , sample_id       => $Sample->id
                        }
                    );
                }
                else {
                    warn "Cannot find or create PI '$pi_name'\n";
                }
            }
        }
        elsif (my @ProjectToInvs = $Project->project_to_investigators) {
            for my $P2I (@ProjectToInvs) {
                $schema->resultset('SampleToInvestigator')->find_or_create(
                    { investigator_id => $P2I->investigaor->id 
                    , sample_id       => $Sample->id
                    }
                );
            }
        }

        for my $fld (@SAMPLE_TABLE_FIELDS) {
            my $val = trim($sample->{$fld});
            if (defined $val && $val ne '') {
                $Sample->$fld($val);
                $Sample->update;
            }
        } 

        for my $fld (keys %attr_fld) {
            my @tmp;
            if ($SPLITTABLE_FIELDS{ $fld }) {
                @tmp = map { split($COMMA_SPACE, $_) } $sample->{ $fld };
            }
            else {
                @tmp = ($sample->{ $fld });
            }

            my @vals = grep { defined $_ && $_ ne '' } @tmp;

            ($fld = lc $fld) =~ s/\s+/_/g; # to match normalization in parser

            for my $val (@vals) {
                my $attr_id = $attr_fld{ $fld };
                printf "       %25s (%s) => %s\n", 
                       $fld, $attr_id, substr($val, 0, 25);

                my ($SampleAttr) =
                $schema->resultset('SampleAttr')->find_or_create({
                    sample_id           => $Sample->id,
                    sample_attr_type_id => $attr_id,
                    attr_value          => 
                        length($val) > $MAX_ATTR_VALUE_LEN
                        ? substr($val, 0, $MAX_ATTR_VALUE_LEN - 1)
                        : $val
                });
            }
        }

        if (my $reads = $sample->{'seq_name'} || $sample->{'reads_file'}) {
            for my $file (split($COMMA_SPACE, $reads)) {
                printf "       %25s => %s\n", 'Reads', $file;
                $schema->resultset('SampleFile')->find_or_create({
                    sample_id           => $Sample->id,
                    sample_file_type_id => $ReadsType->id,
                    file                => $file,
                });
            }
        }

        $Sample->update;
    }

    say "Done.";
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

process.pl - a script

=head1 SYNOPSIS

  add-samples.pl -p 129 -s samples.tab

Required Arguments:

  -p|--project_id   Project ID (integer)
  -s|--sample_file  Sample file name

Options:

  -f|--fasta_dir    Directory of sample FASTA files
  --help            Show brief help and exit
  --man             Show full documentation

=head1 DESCRIPTION

Adds samples from a tab-delimited file to the indicated project.

=head1 SEE ALSO

create-project.pl

=head1 AUTHOR

Ken Youens-Clark E<lt>kyclark@email.arizona.eduE<gt>.

=head1 COPYRIGHT

Copyright (c) 2015 kyclark

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
