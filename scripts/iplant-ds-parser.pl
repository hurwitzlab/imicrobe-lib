#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';
use Data::Dump 'dump';
use Getopt::Long;
use File::Basename 'basename';
use File::Spec::Functions 'catfile';
use Pod::Usage;
use Readonly;
use JSON::XS;

main();

# --------------------------------------------------
sub main {
    my $wanted_ft = '';
    my $output    = 'line';
    my ($help, $man_page);

    GetOptions(
        'o|out:s' => \$output,
        'f|ft:s'  => \$wanted_ft,
        'help'    => \$help,
        'man'     => \$man_page,
    ) or pod2usage(2);

    if ($help || $man_page) {
        pod2usage({
            -exitval => 0,
            -verbose => $man_page ? 2 : 1
        });
    }; 

    my $file  = shift @ARGV or pod2usage('No file');
    my $data  = parse($file, $wanted_ft);

    if (lc $output eq 'json') {
        my $coder = JSON::XS->new->ascii->pretty->allow_nonref;
        say $coder->encode($data);
    }
    else {
        for my $dir (sort keys %$data) {
            say join "\n", map { catfile($dir, $_) } @{ $data->{$dir} };
        }
    }
}

# --------------------------------------------------
sub parse {
    my $input = shift;

    my $wanted = sub { 1 };
    if (my $wanted_ft = shift) {
        my %types = map { lc $_, 1 } split /\s*,\s*/, $wanted_ft;
        $wanted = sub {
            my $arg      = shift          or return;
            my $basename = basename($arg) or return;

            if ($basename =~ m/\.(\w+)/) {
                my $suffix = lc $1;
                return $types{ $suffix };
            }
        };
    }

    my $dir = '';
    my %data; 
    open my $fh, '<', $input;

    LINE:
    for my $line (<$fh>) {
        chomp $line;

        if ($line =~ m{^(/[^:]+)}) {
            $dir = $1;
            next LINE;
        }
        elsif ($line =~ m{^\s{2}C-\s+}) {
            next LINE;
        }
        elsif ($line =~ m!^\s{2}([^/]+)! && $dir) {
            my $file = $1;
            if ( $wanted->($file) ) {
                push @{ $data{ $dir } }, $1;
            }
        }
    }
    close $fh;
    return \%data;
}

__END__

# ----------------------------------------------------

=pod

=head1 NAME

iplant-ds-parser.pl - parses the output of "ils"

=head1 SYNOPSIS

  ils -r /iplant/home/shared/imicrobe/projects > files
  iplant-ds-parser.pl -f 'fa,csv' files > out

Options:

  -f|--ft  Comma-separated list of wanted file extensions
  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Parses the output of the iRODS "ils" command.

=head1 SEE ALSO

iRODS.

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
