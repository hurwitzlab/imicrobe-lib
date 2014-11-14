#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use IMicrobe::DB;
use Template;
use File::Spec::Functions;

my $db = IMicrobe::DB->new->dbh;

my $projects = $db->selectall_arrayref(
    'select * from project', { Columns => {} }
);

my $i;
for my $project (@$projects) {
    printf "%5d: %s\n", ++$i, $project->{'project_code'};

    my $desc = $project->{'description'} or next;
    $desc =~ s/^\s+|\s+$//g;
    $desc =~ s/Click to enlarge.?//g;
    $db->do(
        'update project set description=? where project_id=?',
        {},
        ($desc, $project->{'project_id'})
    );
}

say "Done."
