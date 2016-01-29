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
    sample       => [qw(sample_acc sample_name sample_type sample_description
                    comments)],
    combined_assembly => [qw( 
        assembly_name phylum class family genus species strain
    )],
);

Readonly my %MONGO_SQL => {
    sample => [
        q'select "specimen__sample_id" as name, sample_id as value
          from   sample
          where  sample_id=?
        ',
        q'select "specimen__project_id" as name, project_id as value
          from   sample
          where  sample_id=?
        ',
        q'select "specimen__project_name" as name, p.project_name as value
          from   sample s, project p
          where  s.sample_id=?
          and    s.project_id=p.project_id
        ',
        q'select "specimen__is_metagenome" as name, 
                 sample_type like "metagenome" as value
          from   sample
          where  sample_id=?
        ',
        q'select "specimen__domain_of_life" as name, d.domain_name as value
          from   sample s, project p, project_to_domain p2d, domain d
          where  s.sample_id=?
          and    s.project_id=p.project_id
          and    p.project_id=p2d.project_id
          and    p2d.domain_id=d.domain_id
        ',
        q'select "ontology__ontology_acc" as name, o.ontology_acc as value
          from   ontology o, sample_to_ontology s2o
          where  s2o.sample_id=?
          and    s2o.ontology_id=o.ontology_id
        ',
        q'select "ontology__ontology_label" as name, o.label as value
          from   ontology o, sample_to_ontology s2o
          where  s2o.sample_id=?
          and    s2o.ontology_id=o.ontology_id
        ',
        q'select "publication__pubmed_id" as name, pubmed_id as value
          from   publication p, sample s, project pr
          where  s.sample_id=?
          and    s.project_id=pr.project_id
          and    pr.project_id=p.project_id
        ',
        q'select "publication__title" as name, 
                 concat_ws(" ", p.title, p.author) as value
          from   publication p, sample s, project pr
          where  s.sample_id=?
          and    s.project_id=pr.project_id
          and    pr.project_id=p.project_id
        ',
        q'select concat_ws("__", t.category, t.type) as name, 
                 a.attr_value as value
          from   sample_attr a, sample_attr_type t
          where  a.sample_attr_type_id=t.sample_attr_type_id
          and    a.sample_id=?
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
    my @tables     = @_;
    my $db         = IMicrobe::DB->new;
    my $mongo_conf = IMicrobe::Config->new->get('mongo');
    my $dbh        = $db->dbh;
    my $mongo      = $db->mongo;
    my $db_name    = $mongo_conf->{'dbname'};
    my $host       = $mongo_conf->{'host'};
    my $coll_name  = 'sampleKeys';
    my $mdb        = $mongo->get_database($db_name);
    $mdb->drop($coll_name);

    for my $table (@tables) {
        my $coll = $mdb->get_collection($table);
        $coll->drop();

        my @flds    = @{ $INDEX_FLDS{$table} } or next;
        my $pk_name = $table . '_id'; 
        unshift @flds, $pk_name;

        my @records = @{$dbh->selectall_arrayref(
            sprintf('select %s from %s', join(', ', @flds), $table), 
            { Columns => {} }
        )};

        printf "Processing %s from table '%s.'\n", scalar(@records), $table;

        $dbh->do('delete from search where table_name=?', {}, $table);

        my @mongo_sql = @{ $MONGO_SQL{ $table } || [] };

        my $i;
        for my $rec (@records) {
            my $pk  = $rec->{ $pk_name } or next;
            my $raw = join(' ', map { trim($rec->{$_} // '') } 
                      grep { $_ ne $pk } @flds);

            my @tmp;
            for my $w (split(/\s+/, $raw)) {
                push @tmp, $w;
                if ($w =~ /_/) {
                    $w =~ s/_/ /g;
                    push @tmp, $w;
                }
            }

            my $text = join(' ', @tmp);

            $rec->{'primary_key'} = $pk;

            printf "%-78s\r", ++$i;

            my %mongo_rec;
            if ($table eq 'sample') {
                for my $sql (@mongo_sql) {
                    my $data =
                      $dbh->selectall_arrayref($sql, { Columns => {} }, $pk);

                    for my $rec (@$data) {
                        my $key = normalize($rec->{'name'}) or next;
                        my $val = trim($rec->{'value'})     or next;
                        if ($mongo_rec{ $key }) {
                            $mongo_rec{ $key } .= " $val";
                        }
                        else {
                            $mongo_rec{ $key } = $val;
                        }
                    }
                }

                $mongo_rec{'text'} = join(' ', 
                    grep { ! /^-?\d+(\.\d+)?$/ }
                    map  { split(/\s+/, $_) }
                    values %mongo_rec
                );

                $coll->insert(\%mongo_rec);
            }

            $dbh->do(
                q[
                    insert
                    into   search (table_name, primary_key, search_text)
                    values (?, ?, ?)
                ],
                {},
                ($table, $pk, join(' ', $text, $mongo_rec{'text'} // ''))
            );
        }
        print "\n";
    }

    say "Updating Mongo keys";

    `/usr/bin/mongo $host/$db_name --quiet --eval "var collection = 'sample', outputFormat='json'" /usr/local/imicrobe/variety/variety.js | mongoimport --host $host --db $db_name --collection $coll_name --jsonArray`;

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
    $ret    =~ s/_parameter//;
    $ret    =~ s/[^\w:_]//g;
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
