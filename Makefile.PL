BEGIN { $DB::single = 1; };

use inc::Module::Install;

name           'IMicrobe-Lib';
abstract       'General purpose code for iMicrobe';
author         'Ken Youens-Clark <kyclark@gmail.com>';
version        '0.01';
license        'GPL';

requires 'DBD::mysql';
requires 'DBI'                      => '1.630';
requires 'DBIx::Class';
requires 'DBIx::Class::Schema';
requires 'DBIx::Class::Schema::Loader';
requires 'JSON::XS';
requires 'MongoDB';
requires 'Moose'                    => '2.1005';
requires 'MooseX::MarkAsMethods';
requires 'MooseX::NonMoose';
requires 'namespace::autoclean';
requires 'Readonly';
requires 'String::Trim';
requires 'Template'                 => '2.25';
requires 'Template::Plugin::Comma'  => '0.04';
requires 'Text::Markdown';
requires 'YAML';
requires 'HTTP::Request';
requires 'LWP';
requires 'LWP::Protocol::https';

test_requires 'Test::More'          => '0.98';
test_requires 'Test::Exception'     => '';

WriteAll;
