#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use IMicrobe::DB;
use Template;
use File::Spec::Functions;
use Text::RecordParser::Tab;

my $file = shift or die 'No file';

main($file);

sub main {
    my $file = shift;
    my $p    = Text::RecordParser::Tab->new($file);
    my $db   = IMicrobe::DB->new->dbh;
    my $i    = 0;

    while (my $rec = $p->fetchrow_hashref) {
        for my $domain (split(/\s*,\s*/, $rec->{'DOL'})) {
            my $domain_id = get_domain_id($db, $domain);

            printf "%5d: %s (%s) => %s\n", 
                ++$i, 
                $domain, 
                $domain_id, 
                $rec->{'project_id'};

            $db->do(
                q[
                    replace into project_to_domain 
                    (project_id, domain_id) values (?,?)
                ],
                {},
                ($rec->{'project_id'}, $domain_id)
            );
        }
    }

    say "Done."
}

sub get_domain_id {
    my ($db, $domain) = @_;
    my $domain_id = $db->selectrow_array(
        'select domain_id from domain where domain_name=?', {}, $domain
    );

    if (!$domain_id) {
        $db->do(
            'insert into domain (domain_name) values (?)', {}, $domain
        );

        $domain_id = $db->selectrow_array(
            'select domain_id from domain where domain_name=?', {}, $domain
        );
    }

    return $domain_id;
}
