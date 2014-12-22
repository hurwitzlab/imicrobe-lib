#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';
use Data::Dump 'dump';
use Getopt::Long;
use Pod::Usage;
use Readonly;
use IMicrobe::DB;
use Data::Dump 'dump';
use Readonly;

Readonly my $WANTED_BASE_DIR => '/iplant/home/shared/imicrobe/projects';

Readonly my %SAMPLE_TYPE_TO_FIELD => (
    nt  => 'reads_file',
    pep => 'peptides_file',
    cds => 'cds_file',
);

my %PROJECT_TYPE_TO_FIELD = (
    asm      => 'assembly_file',
    csv      => 'meta_file',
    pep      => 'peptide_file',
    read     => 'read_file',
    read_pep => 'read_pep_file',
    nt       => 'nt_file',
    fastq    => 'fastq_file',
);

main();

# --------------------------------------------------
sub main {
    my ($help, $man_page);
    GetOptions(
        'help' => \$help,
        'man'  => \$man_page,
    ) or pod2usage(2);

    if ($help || $man_page) {
        pod2usage({
            -exitval => 0,
            -verbose => $man_page ? 2 : 1
        });
    }; 

    my $file = shift @ARGV or pod2usage('No input file');
    run($file);
}

# --------------------------------------------------
sub run {
    my $file = shift or die "No file\n";
    open my $in, '<', $file;

    my $db  = IMicrobe::DB->new;
    my $i   = 0;
    my $max = 60;

    while (my $line = <$in>) {
        chomp $line;

        printf "%8d: %s\n", 
            ++$i, 
            length $line > $max ? substr($line, 0, $max - 3) . '...' : $line
        ;

        process($db, $line);
    }

    printf "Done, processed %s line%s.\n", $i, $i == 1 ? '' : 's';
}

# --------------------------------------------------
sub process {
    my $db   = shift;
    my $path = shift or return;

    my ($project_id, @path);
    if ($path =~ m!^$WANTED_BASE_DIR/(\d+)/(.+)!) {
        $project_id = $1;
        @path       = split /\//, $2;
    }
    else {
        return;
    }

    my $file = pop @path;
    my ($obj_name, $type, $ext) = split /\./, $file;

    if (!@path) {
        my $Project = $db->schema->resultset('Project')->find($project_id) 
                      or die "Bad project id ($project_id)";

        if (my $fld = $PROJECT_TYPE_TO_FIELD{ $type }) {
            compare($Project, $fld, $path);
        }
        else {
            print STDERR "Unknown type ($type) for file ($file)\n";
        }
    }
    else {
        if ($path[0] =~ /^(samples|transcriptomes)/) {
            my $Sample = get_sample($obj_name) or return;

            if (my $fld = $SAMPLE_TYPE_TO_FIELD{ $type }) {
                compare($Sample, $fld, $path);
            }
            else {
                print STDERR "Unknown type ($type) for file ($file)\n";
            }
        }
    }

    return 1;
}

# --------------------------------------------------
sub compare {
    my ($object, $fld, $new) = @_;
    my $cur = $object->$fld() or return;

    if ($cur ne $new) {
        printf STDERR "%s (%s) %s =>\n%s\n%s\n\n",
            ref $object,
            $object->id, 
            $fld,
            $cur,
            $new,
        ;

        $object->$fld($new);
        $object->update;
    }
}

# --------------------------------------------------
sub trim {
    my $s = shift || '';
    $s =~ s/^\s+|\s+$//g;
    return $s;
}

# ----------------------------------------------------------------------
my %sample_name_to_sample;
sub get_sample {
    my ($db, $sample_name) = @_;

    return unless $sample_name;

    my @suffixes = ('', 'C', '_2', '_2C');
    if (!$sample_name_to_sample{ $sample_name }) {
        my $sample_id;
        for my $name ( map { join('', $sample_name, $_) } @suffixes ) {
            $sample_id = $db->dbh->selectrow_array(
                'select sample_id from sample where sample_name=?', {}, 
                $name
            );

            last if $sample_id;
        }

        return unless $sample_id;

        if (my $Sample = $db->schema->resultset('Sample')->find($sample_id)) {
            $sample_name_to_sample{ $sample_name } = $Sample;
        }
        else {
            say STDERR "Bad sample_id ($sample_id)";
        }

    }

    return $sample_name_to_sample{ $sample_name };
}


__END__

# --------------------------------------------------

=pod

=head1 NAME

update-meta-files.pl - updates project/sample meta file locations

=head1 SYNOPSIS

  update-meta-files.pl file-locations

Options:

  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Takes the output of "iplant-ds-parser.pl" (line format, not JSON) and 
updates the iMicrobe db with the location of the files.

=head1 AUTHOR

Ken Youens-Clark E<lt>E<gt>.

=head1 COPYRIGHT

Copyright (c) 2014 Ken Youens-Clark

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
