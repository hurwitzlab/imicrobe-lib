#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use IMicrobe::DB;
use LWP::Simple 'get';
use XML::Simple 'XMLin';
use Data::Dump 'dump';

my $url  = "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed"
         . "&id=%s&rettype=xml"; #&retmode=text";
my $db   = IMicrobe::DB->new->dbh;
my $pubs = $db->selectall_arrayref('select * from publication', { Columns => {} });

print join("\t", qw[pubmed author email]), "\n";
for my $pub (@$pubs) {
    my $pubmed_id = $pub->{'pubmed_id'} or next;
    my $xml  = get(sprintf($url, $pubmed_id)) or next;
    my $pubmed = XMLin($xml);
#    my $pubmed    = $json->{'result'}{ $pubmed_id } or next;
    #print dump($pubmed);

    #printf "%s =>\n%s\n\n", $pub->{'title'}, $title;
    for my $author (@{ 
        $pubmed->{'PubmedArticle'}{'MedlineCitation'}{'Article'}
        {'AuthorList'}{'Author'}
    }) {
        my $aff = $author->{'Affiliation'} or next;
        if ($aff =~ /\b([\w_.]+@[\w_.]+)\b/) {
            print join("\t", 
                $pubmed_id,
                join(' ', $author->{'ForeName'}, $author->{'LastName'}), 
                lc $1
            ), "\n";
        }
    }
}
