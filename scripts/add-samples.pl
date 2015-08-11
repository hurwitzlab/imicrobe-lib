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
Readonly my @SAMPLE_TABLE_FIELDS => qw(latitude longitude);

main();

# --------------------------------------------------
sub get_args {
    my %args = (
        project_id  => 0,
        sample_file => '',
        site_file   => '',
        fasta_dir   => '',
        help        => 0,
        man_page    => 0,
    );

    GetOptions(\%args,
        'project_id|p=i',
        'sample_file|s=s',
        'site_file|i:s',
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
sub file_parse {
    my $file = shift;

    if ($file && -e $file) {
        my $p = Text::RecordParser::Tab->new($file);
        $p->header_filter(sub { $_ = shift; s/\s+/_/g; lc $_ });
        return $p->fetchall_arrayref({ Columns => {} });
    }
    else {
        return [];
    }
}

# --------------------------------------------------
sub main {
    my %args   = get_args;
    my $db     = IMicrobe::DB->new;
    my $schema = $db->schema;

    my $Project = $schema->resultset('Project')->find($args{'project_id'})
        or die "Cannot find project id '$args{project_id}'\n";

    printf "Project '%s' (%s)\n", $Project->project_name, $Project->id;

    my $samples    = file_parse($args{'sample_file'});
    my $sites      = file_parse($args{'site_file'});
    my %attr_fld   = map { $_->type, $_->id } 
                     $schema->resultset('SampleAttrType')->all;
    my $iplant_dir = sprintf(
        '/iplant/home/shared/imicrobe/projects/%s/samples/', $Project->id
    );
    my $ReadsType = $schema->resultset('SampleFileType')->find_or_create({ 
        type => 'Reads'
    });


    printf "%s samples, %s sites\n", scalar @$samples, scalar @$sites;

    my $nsamples = scalar @$samples;
    for my $i (0..$nsamples - 1) {
        my $sample = $samples->[$i];
        my $site   = @$sites 
                     ? defined $sites->[$i] ? $sites->[$i] : $sites->[0]
                     : {};

        next unless $sample->{'sample_name'};

        my $Sample = $schema->resultset('Sample')->find_or_create({
            project_id   => $Project->id,
            sample_name  => $sample->{'sample_name'},
            sample_acc   => join('_', 
                $Project->project_code, $sample->{'sample_name'}
            ),
        });

        for my $fld (@SAMPLE_TABLE_FIELDS) {
            my $val = trim($sample->{$fld} // $site->{$fld});
            if (defined $val && $val ne '') {
                $Sample->$fld($val);
                $Sample->update;
            }
        } 

        printf "%5d: Sample '%s' (%s)\n", 
            $i + 1, $Sample->sample_name, $Sample->id;

        for my $fld (keys %attr_fld) {
            my @vals = ($sample->{ $fld } // $site->{ $fld });
            if ($SPLITTABLE_FIELDS{ $fld }) {
                @vals = map { split(/\s*,\s*/, $_) } @vals; 
            }

            for my $val (@vals) {
                if (defined $val && $val ne '') {
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
        }

#        for my $fld (
#            $schema->resultset('Sample')->result_source->columns
#        ) {
#            next if $fld =~ /_file$/;
#            my $val = $sample->{ $fld } // $site->{ $fld };
#            if (defined $val && $val ne '') {
#                printf "       %25s => %s\n", $fld, substr($val, 0, 25);
#                $Sample->$fld($val);
#            }
#        }

        my @reads = split(/\s*,\s*/, $sample->{'reads_file'});

        if (!@reads && defined $args{'fasta_dir'} && -d $args{'fasta_dir'}) {
            my $reads_file = 
                catfile($args{'fasta_dir'}, $Sample->sample_name . '.fa');

            if (-e $reads_file) {
                push @reads, $reads_file;
            }
        }

        for my $reads_file (@reads) {
            printf "       %25s => %s\n", 'reads_file', $reads_file;
            $Sample->reads_file($reads_file);
            $schema->resultset('SampleFile')->find_or_create({
                sample_id           => $Sample->id,
                sample_file_type_id => $ReadsType->id,
                file                => catfile($iplant_dir, $reads_file),
            });
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

  add-samples.pl -p 129 -s samples.tab [-i sites.tab]

Required Arguments:

  -p|--project_id   Project ID (integer)
  -s|--sample_file  Sample file name

Options:

  -i|--site_file    Site file name 
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
