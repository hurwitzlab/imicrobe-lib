#!/usr/bin/env perl

use common::sense;
use autodie;
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
);

Readonly my %OPTIONAL_TABLES => (
    reference => [],
    project   => [qw(
        assembly
        combined_assembly
        combined_assembly_to_sample
        ftp
        project_page
        project_to_domain
        publication
        sample
        sample_attr
        sample_file
        sample_file_type
        sample_to_ontology
    )],
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
    my $to_dbh = DBI->connect("dbi:mysql:$to_db", 'kyclark', 'g0p3rl!',
                 { RaiseError => 1 });
    my $mdb    = IMicrobe::DB->new;
    my $schema = $mdb->schema;

    say "Transferring to db '$to_db'";

#    for my $tbl (@BASE_TABLES) {
#        my $rs_name       = join('', map { ucfirst($_) } split(/_/, $tbl));
#        my $result_set    = $schema->resultset($rs_name);
#        my $result_source = $result_set->result_source;
#        my ($pk_name)     = $result_source->primary_columns;
#        my @flds          = grep { !/$pk_name/ } $result_source->columns;
#
#        say "Processing '$rs_name' ($pk_name) = ", join(', ', @flds);
#
#        my $insert_sql = sprintf("insert into %s (%s) values (%s)",
#            $tbl,
#            join(', ', ($pk_name, @flds)),
#            join(', ', map { "?" } ($pk_name, @flds)),
#        );
#
#        my $update_sql = sprintf("update %s set %s where %s=?",
#            $tbl,
#            join(', ', map { "$_=?" } @flds),
#            $pk_name
#        );
#
#        my $i = 0;
#        for my $Rec ($result_set->search) {
#            my $id   = $Rec->id;
#            my @vals = map { $Rec->$_() } @flds;
#
#            my $report = sub { 
#                my ($action) = @_;
#                printf "%5d: %s (%s)\n", ++$i, $id, $action;
#            };
#
#            if (db_exists($to_dbh, $tbl, $pk_name, $id)) {
#                $report->("update");
#                $to_dbh->do($update_sql, {}, (@vals, $id));
#            }
#            else {
#                $report->("insert");
#                $to_dbh->do($insert_sql, {}, ($id, @vals));
#            }
#        }
#    }

    export_projects($schema, $to_dbh, $args{'project_ids'});

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
sub export_project {
    my ($schema, $to_dbh, $project_ids) = @_;
    my @ids = split(/\s*,\s*/, $project_ids) or return;
    say "project_ids = ", join(', ', @ids);

    for my $project_id (@ids) {
        my $Project = $schema->resultset('Project')->find($project_id)
                      or die "Failed to find project id '$project_id'\n";
        copy_record($Project, $to_dbh);
    }
}

# --------------------------------------------------
sub copy_record {
    my ($Rec, $to_db) = @_;
    my $result_set    = $Rec->resultset;
    my $result_source = $result_set->result_source;
    my ($pk_name)     = $result_source->primary_columns;
    my @flds          = grep { !/$pk_name/ } $result_source->columns;

#    say "Processing '$rame' ($pk_name) = ", join(', ', @flds);

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
            printf "%5d: %s (%s)\n", ++$i, $id, $action;
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
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

export.pl - a script

=head1 SYNOPSIS

  export.pl 

Required Arguments:

  -d       DB to export to

Options:

  -p       Project id(s) to export (default all)
  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Describe what the script does, what input it expects, what output it
creates, etc.

=head1 SEE ALSO

perl.

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
