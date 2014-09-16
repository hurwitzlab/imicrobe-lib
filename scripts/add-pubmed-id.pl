#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use IMicrobe::DB;
use LWP::Simple 'get';
use JSON::XS 'decode_json';

my $url  = "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?"
         . "db=pubmed&retmode=json&term=%%22%s%%22";
my $db   = IMicrobe::DB->new->dbh;
my $pubs = $db->selectall_arrayref(
    'select * from publication', { Columns => {} }
);

for my $pub (@$pubs) {
    next if $pub->{'pubmed_id'};
    my $journal = $pub->{'journal'};
    my $json    = get(sprintf($url, $journal)) or next;
    my $pubmed  = decode_json($json);
    my @id_list = @{ $pubmed->{'esearchresult'}{'idlist'} || [] };

    if (@id_list == 1) {
        my $pubmed_id = shift @id_list;
        say "$journal => $pubmed_id";
        $db->do(
            'update publication set pubmed_id=? where publication_id=?', {},
            ($pubmed_id, $pub->{'publication_id'})
        );
    }
}

say "Done";
