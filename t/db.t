#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 3;

use_ok('IMicrobe::DB');

my $db = new_ok('IMicrobe::DB');
my $dbh = $db->dbh;

isa_ok($dbh, 'DBI::db', "dbh");
