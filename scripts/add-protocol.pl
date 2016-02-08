#!/usr/bin/env perl

use common::sense;
use autodie;
use Data::Dump 'dump';
use Getopt::Long;
use IMicrobe::DB;
use IO::Prompt 'prompt';
use Pod::Usage;
use Readonly;

main();

# --------------------------------------------------
sub get_args {
    my %args;

    GetOptions(\%args,
        'id:i',
        'name:s',
        'url:s',
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
    }

    my $project_id    = $args{'id'}   || prompt('Project ID: ');
    my $protocol_name = $args{'name'} || prompt('Protocol name: ');
    my $url           = $args{'url'}  || prompt('URL: ');

    my $schema     = IMicrobe::DB->new->schema;
    my $Project    = $schema->resultset('Project')->find($project_id)
                     or die "Bad project id ($project_id)\n";
    my ($Protocol) = $schema->resultset('Protocol')->find_or_create({
        protocol_name => $protocol_name,
    }) or die "Failed to create protocol.\n";

    if ($url && $Protocol->url ne $url) {
        $Protocol->url($url);
        $Protocol->update;
    }

    my ($P2P) = $schema->resultset('ProjectToProtocol')->find_or_create({
        project_id  => $Project->id,
        protocol_id => $Protocol->id,
    });

    printf "Linked project '%s' (%s)\nto protocol '%s' (%s)\n",
        $Project->project_name,
        $Project->id,
        $Protocol->protocol_name,
        $Protocol->id,
    ;
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

add-protocol.pl - add a protocol to a project

=head1 SYNOPSIS

  add-protocol.pl -i 94 -n 'Modeling ecological drivers in marine viral communities using comparative metagenomics and network analyses' -u 'https://www.protocols.io/view/Modeling-ecological-drivers-in-marine-viral-commun-efgbbjw'

Required arguments:

  -i|--id    Project id
  -n|--name  Protocol name
  -u|--url   Protocol URL

Options:

  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Finds an existing project by ID, creates the protcol if needed, links 
the two.

=head1 SEE ALSO

protocols.io.

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
