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

my $tmpl = join('', <DATA>);
my $t    = Template->new;
my $dir  = "./projects";
my $i    = 0;

for my $project (@$projects) {
    # printf "* [[%s]]\n", $project->{'project_name'};
    my $out = '';
    $t->process(\$tmpl, $project, \$out) or die $t->error;

    my $fname = lc $project->{'project_name'} . '.txt';
    $fname =~ s/[^a-zA-Z0-9\s]//g;
    $fname =~ s/\s+/_/g;
    my $file = catfile($dir, $fname);

    printf "%s: %s\n", ++$i, $fname;

    open my $fh, '>', $file;
    print $fh $out;
    close $fh;
}

say "Done."

__DATA__
{| class="wikitable"
|-
! PI
! Institution
! Project Code
! Project Type
|-
| [% pi %]
| [% institution %]
| [% project_code %]
| [% project_type %]
|}

= Description =

[% description.trim %]

[[Category:Projects]]
