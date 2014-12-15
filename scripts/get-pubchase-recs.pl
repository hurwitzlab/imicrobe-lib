#!/opt/perl-5.20.1/bin/perl

use strict;
use warnings;
use autodie;
use feature 'say';
use Class::Load 'load_class';
use Digest::MD5 'md5_hex';
use Getopt::Long;
use JSON::XS qw'decode_json encode_json';
use Pod::Usage;
use Perl6::Slurp 'slurp';
use Readonly;
use WWW::Mechanize;

Readonly my $URL => 'https://www.pubchase.com/api/v1/recommendations?key=';
Readonly my $KEY_FILE => '/usr/local/hurwitzlab/configs/pubchase/api-key.';

main();

# ----------------------------------------------------
sub main {
    my $site = 'imicrobe';
    my ($help, $man_page);
    GetOptions(
        's|site:s' => \$site,
        'help'     => \$help,
        'man'      => \$man_page,
    ) or pod2usage(2);

    if ($help || $man_page) {
        pod2usage({
            -exitval => 0,
            -verbose => $man_page ? 2 : 1
        });
    }; 

    my $config_file = $KEY_FILE . $site;
    my $api_key     = '';
    if (-e $config_file) {
        chomp($api_key = slurp($config_file));
    }
    else {
        die "Unknown site ($site), no API key file.\n";
    }

    my $db_class = $site eq 'imicrobe' ? 'IMicrobe::DB' : 'IVirus::DB';
    my $db;
    if (load_class($db_class)) {
        $db = $db_class->new->dbh;
    }

    my $www = WWW::Mechanize->new;
    my $res = $www->get($URL . $api_key);

    if ($res->is_success) {
        my $content = $res->decoded_content;
        my $md5     = md5_hex($content);

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

        my $json = decode_json($content);
        my @recs = @{ $json->{'recommendations'} };

        if (!@recs) {
            say STDERR "There are no recommendations.";
            return;
        }

        my $added = add_articles($db, @recs);
        if (defined $added) {
            printf STDERR "Added %s article%s to %s.\n", 
                $added, 
                $added == 1 ? '' : 's', 
                $site;
        }
        else {
            say STDERR "Error adding articles.";
        }

        if ($added > 0) {
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
    }

    say "Done.";
}

# ----------------------------------------------------
sub add_articles {
    my ($db, @articles) = @_;
   
    my $n = 0;
    for my $article (@articles) {
        (my $title = $article->{'title'}) =~ s/\.$//; 

        my $exists = $db->selectrow_array(
            'select count(*) from pubchase where article_id=?', {},
            $article->{'article_id'}
        );

        if (!$exists) {
            $db->do(
                q[
                    insert 
                    into   pubchase (article_id, title, journal_title,
                           doi, authors, article_date, url, created_on)
                    values (?, ?, ?, ?, ?, ?, ?, now())
                ],
                {},
                ( 
                    $article->{'article_id'}, 
                    $title,
                    $article->{'journal_title'}, 
                    $article->{'ELocationID'}, 
                    join(', ', 
                        map { join(' ', $_->{'last_name'}, $_->{'initials'}) }
                        @{$article->{'authors'}}
                    ), 
                    $article->{'article_date'}, 
                    $article->{'url'}
                )
            );

            $n++;
        }
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

  -s|--site  Either "imicrobe" (default) or "ivirus"
  --help     Show brief help and exit
  --man      Show full documentation

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
