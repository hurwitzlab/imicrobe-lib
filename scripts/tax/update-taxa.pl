#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use JSON::XS;
use Perl6::Slurp 'slurp';
use Data::Dump 'dump';
use IMicrobe::DB;
use Text::TabularDisplay;

my %take = (
    superkingdom    => 1,
    class           => 1,
    order           => 'torder',
    phylum          => 1,
    strain          => 1,
    genus           => 1,
    species         => 1,
    scientificname  => 'strain',
);

my $file = shift or die "No file\n";
my $data = decode_json(slurp($file));
my $db   = IMicrobe::DB->new->dbh;
my $i    = 0;

JSON:
for my $json (@$data) {
    my $tax_id = $json->{'taxid'} or next;
    my $name   = $json->{'scientificname'} 
              || join(' ', $json->{'genus'}, $json->{'species'});

    printf "%5d: %s (%s)\n", ++$i, $name, $tax_id;

    my %new;
    while (my ($fld, $db_fld) = each %take) {
        # check for alternate name
        if ($db_fld eq '1') {
            $db_fld = $fld;
        }

        $new{ $db_fld } = trim($json->{$fld});
    }

    #say dump(\%new);
    my @flds = keys %new;
    my $sql  = sprintf
        'update sample set %s where taxon_id=%s',
        join(', ', map { sprintf "$_=%s", $db->quote($new{$_}) } @flds),
        $tax_id
    ;

    say $sql, "\n";
    my $rows = $db->do($sql, {}, $tax_id);
    $i += $rows;
}

say STDERR "Done, updated $i samples.";

# ----------------------------------------------------------------------
sub trim {
    my $s = shift || '';
    $s =~ s/^\s+|\s+$//g; 
    return $s;
}
