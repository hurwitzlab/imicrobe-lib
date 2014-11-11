#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use IMicrobe::DB;
use LWP::Simple 'get';
use JSON::XS 'decode_json';

my $url  = "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?"
         . "db=pubmed&id=%s&retmode=json";
my $db   = IMicrobe::DB->new->dbh;
my $pubs = $db->selectall_arrayref('select * from publication', { Columns => {} });

for my $pub (@$pubs) {
    my $pubmed_id = $pub->{'pubmed_id'} or next;
    my $json      = decode_json(get(sprintf($url, $pubmed_id)));
    my $pubmed    = $json->{'result'}{ $pubmed_id } or next;

#    if (my $journal = $pubmed->{'fulljournalname'}) {
#        printf "%s => %s\n", $pub->{'publication_id'}, $journal;
#        $db->do(
#            'update publication set journal=?, pub_date=? where publication_id=?', 
#            {},
#            $journal,
#            $pubmed->{'pubdate'},
#            $pub->{'publication_id'}
#        );
#    }

    my $title = $pubmed->{'title'} or next;
    $title    =~ s/\.$//;

    printf "%s =>\n%s\n\n", $pub->{'title'}, $title;

    $db->do(
        'update publication set title=? where publication_id=?', {},
        ($title, $pub->{'publication_id'})
    );
}

say "Done";
