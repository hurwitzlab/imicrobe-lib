#!/usr/bin/env perl

use common::sense;
use autodie;
use Data::Dump 'dump';
use Getopt::Long;
use IMicrobe::DB;
use JSON::XS 'decode_json';
use LWP::Simple 'get';
use Pod::Usage;
use Readonly;

main();

# --------------------------------------------------
sub get_args {
    my %args;

    GetOptions(\%args,
        'id=i',
        'project:i',
        'help',
        'man',
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

    my $pm_id  = $args{'id'} or pod2usage("Missing PubMed ID");
    my $schema = IMicrobe::DB->new->schema;
    my ($Pub)  = $schema->resultset('Publication')->find_or_create({
        pubmed_id => $pm_id
    });

    printf "Publication ID -> %s\n", $Pub->id;

    my $url_tmpl = "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?"
                 . "db=pubmed&id=%s&retmode=json";
    my $url      = sprintf($url_tmpl, $pm_id);
    my $json     = get($url) or die "Nothing from URL ($url)\n";
    my $data     = decode_json($json);
    my $pub_info = $data->{'result'}{$pm_id} 
                   or die "Can't find 'result' in JSON\n";

    my %map = (
        elocationid => "doi",
        title       => "title",
        source      => "journal",
        pubdate     => "pub_date",
        author      => "author",
    );

    $pub_info->{'author'} = join ", ", sort(
        map  { $_->{'name'} } 
        grep { $_->{'authtype'} eq "Author" }
        @{ $pub_info->{'authors'} || [] }
    );

    while (my ($from, $to) = each %map) {
        my $val = $pub_info->{ $from };
        if (defined $val && $val ne "" && $Pub->$to() ne $val) {
            say "    $to -> '$val'";
            $Pub->$to($val);
            $Pub->update;
        }
    }

    if (my $project_id = $args{'project'}) {
        my ($Project) = $schema->resultset('Project')->find($project_id);
        printf "Linking '%s' (%s)\n", $Project->project_name, $Project->id;
        $Pub->project_id($project_id);
        $Pub->update;
    }

    say "Done.";
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

add-publication-from-pubmed.pl - add publications from PubMed IDs

=head1 SYNOPSIS

  add-publication-from-pubmed.pl -i pubmed_id [-p project_id]

Required arguments:

  -i|--id        PubMed ID

Options:

  -p|--project   Project ID
  --help         Show brief help and exit
  --man          Show full documentation

=head1 DESCRIPTION

Download the JSON from PubMed for an ID, add it to the database, optionally
link it to a project.

=head1 SEE ALSO

perl.

=head1 AUTHOR

Ken Youens-Clark E<lt>kyclark@email.arizona.eduE<gt>.

=head1 COPYRIGHT

Copyright (c) 2016 kyclark

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
