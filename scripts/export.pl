#!/usr/bin/env perl

use common::sense;
use autodie;
use Data::Dump 'dump';
use DBI;
use IMicrobe::DB;
use File::Spec::Functions;
use Getopt::Long;
use Pod::Usage;
use Readonly;

Readonly my @BASE_TABLES => qw(
    domain
    metadata_type
    ontology
    pubchase
    pubchase_rec
    sample_attr_type
    sample_attr_type_alias
    sample_file_type
);

main();

# --------------------------------------------------
sub get_args {
    my %args;

    GetOptions(\%args,
        'help',
        'man',
        'project_id:i',
        'db=s',
    ) or pod2usage(2);

    return %args;
}

# --------------------------------------------------
sub main {
    my %args = get_args;

    if ($args{'help'} || $args{'man_page'}) {
        pod2usage({
            -exitval => 0,
            -verbose => $args{'man_page'} ? 2 : 1
        });
    }; 

    unless ($args{'db'}) {
        pod2usage("No 'db' arg");
    }

    my $to_db  = $args{'db'};
    my $to_dbh = DBI->connect("dbi:mysql:$to_db", 'kyclark', 'L1ttlecrobes.',
                 { RaiseError => 1 });
    my $mdb    = IMicrobe::DB->new;
    my $schema = $mdb->schema;

    say "Transferring to db '$to_db'";

    for my $tbl (@BASE_TABLES) {
        my $rs_name       = join('', map { ucfirst($_) } split(/_/, $tbl));
        my $result_set    = $schema->resultset($rs_name);
        my $result_source = $result_set->result_source;
        my ($pk_name)     = $result_source->primary_columns;
        my @flds          = grep { !/$pk_name/ } $result_source->columns;

        say "Processing '$rs_name' ($pk_name) = ", join(', ', @flds);

        my $insert_sql = sprintf("insert into %s (%s) values (%s)",
            $tbl,
            join(', ', ($pk_name, @flds)),
            join(', ', map { "?" } ($pk_name, @flds)),
        );

        my $update_sql = sprintf("update %s set %s where %s=?",
            $tbl,
            join(', ', map { "$_=?" } @flds),
            $pk_name
        );

        my $i = 0;
        for my $Rec ($result_set->search) {
            my $id   = $Rec->id;
            my @vals = map { $Rec->$_() } @flds;

            my $report = sub { 
                my ($action) = @_;
                printf "%-70s\r", sprintf("%5d: %s (%s)", ++$i, $id, $action);
            };

            if (db_exists($to_dbh, $tbl, $pk_name, $id)) {
                $report->("update");
                $to_dbh->do($update_sql, {}, (@vals, $id));
            }
            else {
                $report->("insert");
                $to_dbh->do($insert_sql, {}, ($id, @vals));
            }
        }
        print "\n";
    }

    export_projects($schema, $to_dbh, $args{'project_id'});

    say "Done.";
}

# --------------------------------------------------
sub db_exists {
    my ($dbh, $tbl, $pk_name, $id) = @_;

    return $dbh->selectrow_array(
        "select count(*) from $tbl where $pk_name=?", {}, $id
    );
}

# --------------------------------------------------
sub export_projects {
    my ($schema, $to_dbh, $project_ids) = @_;
    my @ids = split(/\s*,\s*/, $project_ids) or return;

    for my $project_id (@ids) {
        my $Project = $schema->resultset('Project')->find($project_id)
                      or die "Failed to find project id '$project_id'\n";
        copy_record($Project, $to_dbh);
    }
}

# --------------------------------------------------
sub copy_record {
    my $Rec          = shift or return;
    my $to_dbh       = shift or die 'No "to_dbh"';
    my $parent_class = shift || '';
    my $tbl          = $Rec->table;
    my ($pk_name)    = $Rec->primary_columns;
    my @flds         = grep { !/$pk_name/ } $Rec->columns;
    my $id           = $Rec->id;
    my @vals         = map { $Rec->$_() } @flds;

    say "Processing '$tbl' ($id)";

    my $insert_sql = sprintf("insert into %s (%s) values (%s)",
        $tbl,
        join(', ', ($pk_name, @flds)),
        join(', ', map { "?" } ($pk_name, @flds)),
    );

    my $update_sql = sprintf("update %s set %s where %s=?",
        $tbl,
        join(', ', map { "$_=?" } @flds),
        $pk_name
    );

    if (db_exists($to_dbh, $tbl, $pk_name, $id)) {
        $to_dbh->do($update_sql, {}, (@vals, $id));
    }
    else {
        $to_dbh->do($insert_sql, {}, ($id, @vals));
    }

    for my $relationship_name ($Rec->relationships) {
        my $rel_info = $Rec->relationship_info($relationship_name);

        next if $rel_info->{'class'} eq $parent_class;

        for my $Related ($Rec->$relationship_name()) {
            copy_record($Related, $to_dbh, $Rec->result_class);
        }
    }
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

export.pl - export iMicrobe data to another db

=head1 SYNOPSIS

  export.pl -d cmore -p 129

Required Arguments:

  -d       Target DB name (e.g., "cmore")

Options:

  -p       Project id(s) to export (default all)
  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Will insert/update data in the target db using primary keys from 
"imicrobe" db.

=head1 AUTHOR

Ken Youens-Clark E<lt>kyclark@email.arizona.eduE<gt>.

=head1 COPYRIGHT

Copyright (c) 2015 kyclark

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
