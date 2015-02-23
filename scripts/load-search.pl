#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';
use Data::Dump 'dump';
use Getopt::Long;
use HTTP::Request;
use IMicrobe::DB;
use MongoDB;
use JSON::XS;
use LWP::UserAgent;
use Pod::Usage;
use Readonly;
use String::Trim qw(trim);

Readonly my %INDEX_FLDS = (
    assembly     => [qw(assembly_code assembly_name organism)],
    project      => [qw(project_code project_name pi institution description)],
    project_page => [qw(title contents)],
    publication  => [qw(journal pub_code author title pubmed_id doi)],
    sample       => [qw(
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

Readonly my %MONGO_SQL => {
    sample => [
        q'select t.type as name, a.attr_value as value
          from   sample_attr a, sample_attr_type t
          where  a.sample_attr_type_id=t.sample_attr_type_id
          and    a.sample_id=?
        ',
        q'select "ontology_acc" as name, o.ontology_acc as value
          from   ontology o, sample_to_ontology s2o
          where  s2o.sample_id=?
          and    s2o.ontology_id=o.ontology_id
        ',
        q'select "ontology_label" as name, o.label as value
          from   ontology o, sample_to_ontology s2o
          where  s2o.sample_id=?
          and    s2o.ontology_id=o.ontology_id
        ',
        q'select "is_metagenome" as name, 
                 sample_type like "metagenome" as value
          from   sample
          where  sample_id=?
        ',
        q'select "publication" as name, 
                 concat_ws(" ", p.title, p.author) as value
          from   publication p, sample s, project pr
          where  s.sample_id=?
          and    s.project_id=pr.project_id
          and    pr.project_id=p.project_id
        ',
    ],
};

$MongoDB::BSON::looks_like_number = 1;

main();

# --------------------------------------------------
sub main {
    my $tables = '';
    my $list   = '';
    my ($help, $man_page);
    GetOptions(
        'l|list'     => \$list,
        't|tables:s' => \$tables,
        'help'       => \$help,
        'man'        => \$man_page,
    ) or pod2usage(2);

    if ($help || $man_page) {
        pod2usage({
            -exitval => 0,
            -verbose => $man_page ? 2 : 1
        });
    }; 

    if ($list) {
        say join "\n", 
            "Valid tables:",
            (map { " - $_" } sort keys %INDEX_FLDS),
            '',
        ;
        exit 0;
    }

    my %valid  = map { $_, 1 } keys %INDEX_FLDS;
    my @tables = $tables ? split /\s*,\s*/, $tables : keys %valid;
    my @bad    = grep { !$valid{ $_ } } @tables;
    
    if (@bad) {
        die join "\n", "Bad tables:", (map { "  - $_" } @bad), '';
    }

    process(@tables);
}

# --------------------------------------------------
sub process {
    my @tables = @_;
    my $db     = IMicrobe::DB->new->dbh;
    my $mongo  = MongoDB::MongoClient->new(host => 'localhost', port => 27017);
    my $mdb    = $mongo->get_database('imicrobe');

    for my $table (@tables) {
        my $coll = $mdb->get_collection($table);
        $coll->drop();

        my @flds    = @{ $INDEX_FLDS{$table} } or next;
        my $pk_name = $table . '_id'; 
        unshift @flds, $pk_name;

        my @records = @{$db->selectall_arrayref(
            sprintf('select %s from %s', join(', ', @flds), $table), 
            { Columns => {} }
        )};

        printf "Processing %s from %s\n", scalar @records, $table;

        $db->do('delete from search where table_name=?', {}, $table);

        my @mongo_sql = @{ $MONGO_SQL{ $table } || [] };

        my $i;
        for my $rec (@records) {
            my $pk   = $rec->{ $pk_name } or next;
            my $text = join(' ', map { $rec->{$_} || '' } @flds) or next;

            $rec->{'primary_key'} = $pk;

            $text =~ s/\s+/ /g;

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

            my %mongo_rec;
            for my $sql (@mongo_sql) {
                my $data 
                    = $db->selectall_arrayref($sql, { Columns => {} }, $pk);

                for my $rec (@$data) {
                    my $key = normalize($rec->{'name'}) or next;
                    my $val = trim($rec->{'value'})     or next;
                    $mongo_rec{ $key } = $val;
                }
            }

            $mongo_rec{'text'} = join ' ', values %mongo_rec;

            $coll->insert(\%mongo_rec);
        }
        print "\n";
    }

    say "Done.";
}

# --------------------------------------------------
sub lean_hash {
    my $in = shift;
    my %out;
    while (my ($k, $v) = each %$in) {
        if (defined $v && $v ne '') {
            $out{ $k } = $v;
        }
    }
    return \%out;
}

# --------------------------------------------------
sub normalize {
    my $s   = shift or return;
    my $ret = lc trim($s);
    $ret    =~ s/[\s,-]+/_/g;
    $ret    =~ s/[^\w_]//g;
    return $ret;
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

load-search.pl - a script

=head1 SYNOPSIS

  load-search.pl 

Options:

  -t|--tables  Comma-separated list of tables to index
  --help       Show brief help and exit
  --man        Show full documentation

=head1 DESCRIPTION

Indexes the iMicrobe "search" table.

=head1 AUTHOR

Ken Youens-Clark E<lt>E<gt>.

=head1 COPYRIGHT

Copyright (c) 2015 Ken Youens-Clark

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
