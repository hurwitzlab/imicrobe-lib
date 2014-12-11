#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';
use Getopt::Long;
use HTML::LinkExtractor;
use HTML::Strip;
use JSON::XS qw'decode_json encode_json';
use Pod::Usage;
use Readonly;
use WWW::Mechanize;

Readonly my $FETCH_URL   
    => 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi' 
    .  '?db=taxonomy&retmode=json&id=';

Readonly my $DETAILS_URL 
    => 'http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi'
    .  '?mode=Info&lvl=3&keep=1&srchmode=1&unlock&lin=f&id=';

my ( $help, $man_page );
GetOptions(
    'help' => \$help,
    'man'  => \$man_page,
) or pod2usage(2);

if ( $help || $man_page ) {
    pod2usage({
        -exitval => 0,
        -verbose => $man_page ? 2 : 1
    });
}; 

my $file = shift or die "No file\n";

main($file);
exit 0;

# ----------------------------------------------------------------------
sub main {
    my $www  = WWW::Mechanize->new;
    my $hs   = HTML::Strip->new;
    my $lx   = HTML::LinkExtractor->new;
    my %want = map { $_, 1 } qw[ superkingdom phylum class order family ];
    my $i    = 0;
    my %seen = ();
    my @taxa = ();

    open my $fh, '<', $file;
    while (my $tax_id = <$fh>) {
        chomp $tax_id;

        next unless $tax_id && $tax_id =~ /^\d+$/;
        next if $seen{ $tax_id }++;

        printf STDERR "%5d: %s\n", ++$i, $tax_id;

        if (my $json = get($www, $FETCH_URL . $tax_id)) {
            my $content = decode_json($json);
            my %data    = %{ $content->{'result'}{ $tax_id } || {} };

            if (!%data) {
                say STDERR "Got nothin for '$tax_id'";
            }

            if (my $details = get($www, $DETAILS_URL . $tax_id)) {
                $lx->parse(\$details);

                for my $link (@{ $lx->links }) {
                    my $alt = lc($link->{'alt'} || '') or next;

                    if ($want{ $alt }) {
                        (my $val = $hs->parse($link->{'_TEXT'})) 
                            =~ s/^\s+|\s+$//g;

                        $data{ $alt } = $val if $val;
                    }
                }
            }

            push @taxa, \%data;
        }
    }
    close $fh;

    my $coder = JSON::XS->new->ascii->pretty->allow_nonref;
    say $fh $coder->encode(\@taxa);

    say STDERR "Done, fetched $i taxa.";
}

# ----------------------------------------------------------------------
sub get {
    my ($www, $url) = @_;
    my $res = $www->get($url);
    if ($res->is_success) {
        return $res->decoded_content;
    }
    else {
        die "Couldn't fetch URL ($url)\n";
    }
}


__END__

# ----------------------------------------------------

=pod

=head1 NAME

fetch-taxa.pl - get NCBI tax id info

=head1 SYNOPSIS

  fetch-taxa.pl file-of-ncbi-tax-ids.txt

Options:

  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

For a file containing a list of NCBI tax IDs, get the data and print it
in JSON format.

=head1 AUTHOR

Ken Youens-Clark E<lt>kyclark@gmail.com<gt>.

=head1 COPYRIGHT

Copyright (c) 2014 Ken Youens-Clark

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
