#!/usr/bin/env perl

$| = 1;

use strict;
use warnings;
use feature 'say';
use autodie;
use IMicrobe::DB;
use Readonly;

Readonly my %INDEX_FLDS = (
    assembly    => [qw(assembly_code assembly_name organism)],
    project     => [qw(project_code project_name pi institution description)],
    publication => [qw(journal pub_code author title)],
    sample      => [qw(
        genbank_acc isolation_method
        sample_acc sample_type volume_unit
        sample_description sample_name comments taxon_id
        biomaterial_name description material_acc
        site_name site_description country_name region
        host_description host_organism library_acc
        sequencing_method dna_type other
        additional_citations assembly_accession_number
        combined_assembly_name country
        envo_term_for_habitat_primary_term
        envo_term_for_habitat_secondary_term genus
        growth_medium habitat habitat_description
        importance investigation_type
        modifications_to_growth_medium
        other_collection_site_info
        other_environmental_metadata_available
        other_experimental_metadata_available
        prey_organism_if_applicable primary_citation
        principle_investigator sample_collection_site
        sample_material species strain pi
        environmental_salinity environmental_temperature
        experimental_salinity experimental_temperature
        class family mmetsp_id phylum torder superkingdom
        comment current_land_use filter_type gene_name
        habitat_name host_name host_species host_tissue
        other_habitat phage_type plant_cover
        template_preparation_method treatment
    )],
    combined_assembly => [qw( 
        assembly_name phylum class family genus species strain
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
