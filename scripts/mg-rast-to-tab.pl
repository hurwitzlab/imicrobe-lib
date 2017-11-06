#!/usr/bin/env perl

use common::sense;
use autodie;
use Data::Dump 'dump';
use Getopt::Long;
use Pod::Usage;
use Readonly;
use Text::RecordParser::Tab;

main();

# --------------------------------------------------
sub get_args {
    my %args;

    GetOptions(\%args,
        'out:s',
        'help',
        'man',
    ) or pod2usage(2);

    return %args;
}

# --------------------------------------------------
sub main {
    my %args = get_args;

    if ($args{'help'} || $args{'man_page'}) {
        pod2usage({
            -exitval => 0,
            -verbose => $args{'man_page'} ? 2 : 1
        });
    }; 

    @ARGV or pod2usage('No input file(s)');

    my $fh = open_fh($args{'out'});

    my (@data, %fields);
    for my $file (@ARGV) {
        my $data = process_file($file, $fh);    
        map { $fields{$_}++ } keys %$data;
        push @data, $data;
    }

    unless (@data) {
        die "No data from input files.\n"; 
    }

    my @fld_names = sort keys %fields;
    say $fh join "\t", @fld_names;
    for my $rec (@data) {
        say $fh join "\t", map { $rec->{ $_ } } @fld_names; 
    }

    say "Done.";
}

# --------------------------------------------------
sub process_file {
    my ($file, $fh) = @_;

    my %data;
    if ($file =~ /\.min.tab$/) {
        open my $fh, '<', $file;
        while (my $line = <$fh>) {
            chomp($line);
            my ($name, $val) = split /\t/, $line;
            next if !defined($val) || $val eq '' || $val eq 'None';
            $data{ lc($name) } = $val;
        }
    }
    else {
        my $p = Text::RecordParser::Tab->new($file);
        while (my $rec = $p->fetchrow_hashref) {
            next unless defined($rec->{'value'}) 
                 &&     $rec->{'value'} ne ' - ' 
                 &&     $rec->{'value'} ne 'None';

            $data{ lc($rec->{'category'}) }{ lc($rec->{'label'}) } 
                = $rec->{'value'};
        }
    }

    my $project_name 
        = $data{'project'}{'project_name'} || $data{'project_name'};

    return unless $project_name;

    my $project = $data{'project'} || \%data;
    my $sample  = $data{'sample'}  || \%data;
    my %return = (
        project_name => $project_name,
        project_desc => $project->{'project_description'} || '',
        institution  => $project->{'pi_organization'}     || '',
        funding      => $project->{'project_funding'}     || '',
    );

    for my $fld (qw[biome]) {
        my $val = $sample->{$fld};
        next if !defined($val) || $val eq '';
        $return{$fld} = $val;
    }

    my $pi_fname = $project->{'pi_firstname'} || '';
    my $pi_lname = $project->{'pi_lastname'}  || '';
    if ($pi_fname && $pi_lname) {
        $return{'pi'} = join " ", $pi_fname, $pi_lname; 
    }

    ($return{'sample_name'} = $file) =~ s/(\.min)?\.[^.]+?$//;

    ($return{'mgrast_metagenome_id'} = $return{'sample_name'}) =~ s/^mgm//;

    #say dump(\%return);
    \%return;
}

# --------------------------------------------------
sub open_fh {
    my $fh;
    if (my $out_file = shift(@_)) {
        open $fh, '>', $out_file;
    }
    else {
        $fh = \*STDOUT;
    }

    return $fh;
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

mg-rast-to-tab.pl - convert MG-RAST metadata download to tab

=head1 SYNOPSIS

  mg-rast-to-tab.pl file1.tab [file2.tab ...] > out

Options:

  --out    Output file
  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Converts MG-RAST metadata download file(s) to tab-delimited format 
for "add-samples.pl" script.

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
