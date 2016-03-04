#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';
use Data::Dump 'dump';
use Getopt::Long;
use IMicrobe::DB;
use Pod::Usage;
use Perl6::Junction 'none';
use Readonly;
use Text::RecordParser::Tab;

Readonly my $MAX_ATTR_VALUE_LEN => 255;

main(@ARGV);

# --------------------------------------------------
sub main {
    my %args   = get_args();
    my $schema = IMicrobe::DB->new->schema;

    if (@ARGV) {
        process_files($schema, \%args, @ARGV);
    }
    else {
        process_db($schema, \%args); 
    }

    say "Done.";
}

# --------------------------------------------------
sub process_db {
    my ($schema, $args) = @_;

    say 'Processing database records.';

    my %attr_fld = map {$_->type, 1} $schema->resultset('SampleAttrType')->all;
    my %search_args = ($args->{'project_id'}) 
        ? (project_id => $args->{'project_id'})
        : ();
    my $Samples = $schema->resultset('Sample')->search(\%search_args);

    my $i = 0;
    while (my $Sample = $Samples->next) {
        printf("%5d: %s\n", ++$i, $Sample->sample_name);

        for my $fld ($Sample->result_source->columns) {
            next if $fld =~ /_(file|time|date)$/;

            my $val = $Sample->$fld();

            next unless defined $val && $val ne '';

            my ($attr_type) = 
                defined $attr_fld{ $fld } 
                ? $fld
                : (grep { $fld =~ /$_/ } keys %attr_fld);

            next unless $attr_type;

            add_attr( $schema, {
                sample_id  => $Sample->id,
                attr_type  => $attr_type,
                attr_value => $val,
                args       => $args,
            });
        }
    }
}

# --------------------------------------------------
sub process_files {
    my $schema = shift;
    my $args   = shift;
    my @files  = @_;

    my $i = 0;
    for my $file (@files) {
        my $p = Text::RecordParser::Tab->new($file);
        say "Processing '$file'";

        while (my $rec = $p->fetchrow_hashref) {
            my $SampleAttr = add_attr($schema, $rec, $args);
        }

        say '';
    }
}

# --------------------------------------------------
sub trim {
    my $s = shift // '';
    $s =~ s/^\s*|\s*$//g;
    return $s;
}

# --------------------------------------------------
sub add_attr {
    my ($schema, $rec, $args) = @_;

    my $sample_rs = $schema->resultset('Sample');
    my $Sample;
    if (my $sample_id = $rec->{'sample_id'}) {
        ($Sample) = $sample_rs->find($sample_id);
    }
    elsif (my $sample_name = $rec->{'sample_name'}) {
        my @Samples = $sample_rs->search({
            sample_name => $sample_name
        });

        if (@Samples == 0) {
            warn "Cannot find sample '$sample_name'\n";
            return;
        }
        elsif (@Samples > 1) {
            warn sprintf "Found %s samples for '%s'\n", 
                scalar(@Samples), $sample_name;
            return;
        }

        $Sample = shift @Samples;
    }

    unless ($Sample) {
        warn "No sample ID/name\n";
        return;
    }

    my $attr_type = trim($rec->{'attr_type'})  or die "No attr_type\n";
    my $attr_val  = trim($rec->{'attr_value'}) or die "No attr_value\n";
    my $unit      = trim($rec->{'unit'});

    if (!$Sample) {
        warn "Cannot find sample\n", dump($rec);
        return;
    }

    my ($SampleAttrType) 
        = $schema->resultset('SampleAttrType')->find_or_create({
            type     => $attr_type,
        });

    if (my $attr_cat = trim($rec->{'attr_category'})) {
        $SampleAttrType->category($attr_cat);
        $SampleAttrType->update;
    }

    if (my $desc = trim($rec->{'attr_description'})) {
        $SampleAttrType->description($desc);
        $SampleAttrType->update;
    }

    if (my $url = trim($rec->{'attr_url'})) {
        $SampleAttrType->url($url);
        $SampleAttrType->update;
    }

    if ($args->{'verbose'}) {
        printf "Sample %s: %s => %s\n", 
            $Sample->id, $SampleAttrType->type, $attr_val;
    }

    my ($SampleAttr) =
        $schema->resultset('SampleAttr')->find_or_create({
            sample_id           => $Sample->id,
            sample_attr_type_id => $SampleAttrType->id,
            attr_value          => substr($attr_val,0, $MAX_ATTR_VALUE_LEN - 1),
            unit                => $unit,
        });

    return $SampleAttr;
}

# --------------------------------------------------
sub get_args {
    my %args = (
        project_id => 0,
        help       => 0,
        man_page   => 0,
        verbose    => 0,
    );

    GetOptions(\%args,
        'project_id|p=i',
        'verbose',
        'help',
        'man'
    );

    if ($args{'help'} || $args{'man_page'}) {
        pod2usage({
            -exitval => 0,
            -verbose => $args{'man_page'} ? 2 : 1
        });
    };

    return %args;
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

add-sample-attr.pl - Add sample_attr/type records

=head1 SYNOPSIS

  add-sample-attr.pl [file1 file2 ...]

Options:

  --help        Show brief help and exit
  --man         Show full documentation

=head1 DESCRIPTION

Accepts a tab-delimited files on the command line like so:

    ************ Record 1 ************
        sample_id: 3
       attr_value: PNEC
        attr_type: Longhurst Province
    attr_category: Environment

Creates the appropriate "sample_attr/type" records.

Or will process all the samples in the db.

=head1 AUTHOR

Ken Youens-Clark E<lt>E<gt>.

=head1 COPYRIGHT

Copyright (c) 2015 Ken Youens-Clark

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
