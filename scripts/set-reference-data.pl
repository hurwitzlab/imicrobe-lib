#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use Data::Dump 'dump';
use WWW::Mechanize;
use HTML::TableExtract;
use IMicrobe::DB;
use List::MoreUtils 'zip';

my $db  = IMicrobe::DB->new->dbh;
my $www = WWW::Mechanize->new;
my $url = 'http://camera.crbs.ucsd.edu/reference-datasets/';
my $res = $www->get($url);

if ($res->is_success) {
    my $tx = HTML::TableExtract->new;
    $tx->parse($res->decoded_content);
    
    for my $tbl ($tx->tables) {
        my @rows = $tbl->rows;
        my @hdr  = map { s/ /_/g; lc $_ } @{ shift @rows };

        for my $row (@rows) {
            my %data = zip @hdr, @$row;

            for my $fld (qw[ length seq_count ]) {
                $data{$fld} =~ s/,//g;
            }

            my $ref_id = $db->selectrow_array(
                'select reference_id from reference where name=?', {},
                $data{'dataset'}
            );
            say "$data{'dataset'} -> $ref_id";
            say dump(\%data);
            $db->do(
                q[
                    update reference 
                    set    build_date=?, length=?, revision=?, seq_count=?
                    where  reference_id=?
                ],
                {},
                ($data{'build_date'}, $data{'length'},
                 $data{'rev_#'}, $data{'seq_count'}, $ref_id)
            );
        }
    }
}
