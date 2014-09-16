#!/usr/bin/env perl

$| = 1;

use strict;
use warnings;
use feature 'say';
use autodie;
use IMicrobe::DB;
use Readonly;

Readonly my %INDEX_FLDS = (
    assembly => [qw(assembly_code assembly_name organism)],
    project  => [qw(project_code project_name pi institution description)],
    pub      => [qw(journal pub_code author title)],
    sample   => [qw(
        sample_acc sample_description sample_name comments taxon_id
        biomaterial_name description material_acc site_name site_description
        country_name region habitat_name host_taxon_id host_description 
        host_organism library_acc
    )],
);

my $db = IMicrobe::DB->new->dbh;

for my $table (sort keys %INDEX_FLDS) {
    my @flds    = @{ $INDEX_FLDS{$table} } or next;
    my $pk_name = $table . '_id'; 
    unshift @flds, $pk_name;

    my $records = $db->selectall_arrayref(
        sprintf('select %s from %s', join(', ', @flds), $table), 
        { Columns => {} }
    );

    printf "Processing %s from %s\n", scalar @$records, $table;

    $db->do('delete from search where table_name=?', {}, $table);

    my $i;
    for my $rec (@$records) {
        my $text = join(' ', map { $rec->{$_} || '' } @flds) or next;
        my $pk   = $rec->{ $pk_name } or next;

        printf "%-78s\r", ++$i;

        $db->do(
            q[
                insert
                into   search (table_name, primary_key, search_text)
                values (?, ?, ?)
            ],
            {},
            ($table, $pk, $text)
        );
    }
    print "\n";
}

say "Done.";
