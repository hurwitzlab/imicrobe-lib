#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 4;

use_ok('IMicrobe::Config');

my $conf = new_ok('IMicrobe::Config');

my $db = $conf->get('db');
isa_ok($db, 'HASH', '"db"');

is($db->{'name'}, 'imicrobe');
