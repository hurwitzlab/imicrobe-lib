#!/usr/bin/env perl

use common::sense;
use autodie;
use Data::Dump 'dump';
use Getopt::Long;
use IMicrobe::DB;
use Pod::Usage;
use Readonly;
use Text::RecordParser::Tab;

main();

# --------------------------------------------------
sub main {
    my %args = get_args();

    if ($args{'help'} || $args{'man_page'}) {
        pod2usage({
            -exitval => 0,
            -verbose => $args{'man_page'} ? 2 : 1
        });
    }; 

    my $project_id = $args{'project_id'} or pod2usage('Missing --project_id');
    my $file       = $args{'file'}       or pod2usage('Missing --file');
    my $p          = Text::RecordParser::Tab->new($file);
    my $schema     = IMicrobe::DB->new->schema;
    my $Project    = $schema->resultset('Project')->find($project_id)
                     or die "Bad project_id ($project_id)\n";

    my $i = 0;
    REC:
    while (my $rec = $p->fetchrow_hashref) {
        $i++;

        my $Sample;
        if (my $sample_id = $rec->{'sample_id'}) {
            $Sample = $schema->resultset('Sample')->find($sample_id);
        }
        elsif (my $sample_name = $rec->{'sample_name'}) {
            ($Sample) = $schema->resultset('Sample')->search({
                sample_name => $sample_name,
                project_id  => $project_id,
            });
        }

        unless ($Sample) {
            say "$i: Cannot find sample";
            next REC;
        }

        my $file_type =  $rec->{'file_type'} 
                      || $rec->{'type'} 
                      || $rec->{'sample_file_type'};

        unless ($file_type) {
            say "$i: No file type\n";
            next REC;
        }

        my $file_name = $rec->{'file'} || $rec->{'file_name'};

        unless ($file_name) {
            say "$i: No file_name\n";
            next REC;
        }

        printf "%3d: %s (%s) -> %s (%s)\n",
            $i,
            $Sample->sample_name,
            $Sample->id,
            $file_name,
            $file_type
        ;

        my $FileType = $schema->resultset('SampleFileType')->find_or_create({
            type => $file_type
        }) or die "Cannot get sample_file_type for type '$file_type'\n";

        my $SampleFile = $schema->resultset('SampleFile')->find_or_create({
            sample_file_type_id => $FileType->id,
            sample_id           => $Sample->id,
            file                => $file_name,
        });
    }

    say "Done, processed $i.";
}

# --------------------------------------------------
sub get_args {
    my %args;
    GetOptions(
        \%args,
        'project_id|p=i',
        'file|f=s',
        'help',
        'man',
    ) or pod2usage(2);

    return %args;
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

sample-file-linker.pl - a script

=head1 SYNOPSIS

  sample-file-linker.pl --project_id 261 --file ~/files.txt

Options:

  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Links samples and files.

    ************ Record 1 ************
           file_name: ftp://ftp.imicrobe.us/projects/261/samples/5171/TARA0-
                      30-PROT-SRF.megahit_asm.fasta.tar.gz
         sample_name: TARA030
    sample_file_type: Assmebly

=head1 AUTHOR

Ken Youens-Clark E<lt>kyclark@email.arizona.eduE<gt>.

=head1 COPYRIGHT

Copyright (c) 2016 kyclark

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
