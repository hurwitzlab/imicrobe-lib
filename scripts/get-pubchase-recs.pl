#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';
use Digest::MD5 'md5_hex';
use Getopt::Long;
use JSON::XS qw'decode_json encode_json';
use IMicrobe::DB;
use Pod::Usage;
use Readonly;
use WWW::Mechanize;

Readonly my $URL => 'https://www.pubchase.com/api/v1/recommendations?' .
    'email=imicrobe@imicrobe.us&key=e9026c0697dbc49d76680af5a825f0c9';

my ( $help, $man_page );
GetOptions(
    'help' => \$help,
    'man'  => \$man_page,
) or pod2usage(2);

if ( $help || $man_page ) {
    pod2usage({
        -exitval => 0,
        -verbose => $man_page ? 2 : 1
    });
}; 

main();

# ----------------------------------------------------
sub main {
    my $www = WWW::Mechanize->new;
    my $res = $www->get($URL);

    if ($res->is_success) {
        my $content = $res->decoded_content;
        my $md5     = md5_hex($content);
        my $db      = IMicrobe::DB->new->dbh;

        my ($last_checksum) = $db->selectrow_array(q'
            select   checksum
            from     pubchase_rec
            order by rec_date desc
            limit 1
        ') || '';

        if ($last_checksum eq $md5) {
            say STDERR "Nothing new under the sun.";
            return;
        }

        my $json  = decode_json($content);
        my $added = add_articles($db, @{ $json->{'recommendations'} });

        if ($added) {
            say STDERR "Added $added articles.";
            $db->do(
                q[
                    insert 
                    into   pubchase_rec (rec_date, checksum)
                    values (now(), ?)
                ],
                {},
                $md5
            );
        }
        else {
            say STDERR "Error adding articles.";
        }
    }

    say "Done.";
}

# ----------------------------------------------------
sub add_articles {
    my ($db, @articles) = @_;
   
    my $n = 0;
    for my $article (@articles) {
        $db->do(
            q[
                insert 
                into   pubchase (article_id, title, journal_title,
                       doi, list_of_authors, article_date, url, created_on)
                values (?, ?, ?, ?, ?, ?, ?, now())
            ],
            {},
            ( 
                $article->{'article_id'}, 
                $article->{'title'}, 
                $article->{'journal_title'}, 
                $article->{'ELocationID'}, 
                join(', ', @{$article->{'list_of_authors'}}), 
                $article->{'article_date'}, 
                $article->{'url'}
            )
        );

        $n++;
    }

    return $n;
}

__END__

# ----------------------------------------------------

=pod

=head1 NAME

get-pubchase-recs.pl - a script

=head1 SYNOPSIS

  get-pubchase-recs.pl 

Options:

  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Describe what the script does, what input it expects, what output it
creates, etc.

=head1 SEE ALSO

perl.

=head1 AUTHOR

Ken Youens-Clark E<lt>kyclark@cshl.eduE<gt>.

=head1 COPYRIGHT

Copyright (c) 2014 Ken Youens-Clark

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
