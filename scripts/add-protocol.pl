#!/usr/bin/env perl

use common::sense;
use autodie;
use Data::Dump 'dump';
use Getopt::Long;
use IMicrobe::DB;
use IO::Prompt 'prompt';
use LWP::Simple 'get';
use JSON::XS 'decode_json';
use Pod::Usage;
use Readonly;

Readonly my $PROTOCOLS_URL_JSON => 
    'https://www.protocols.io/api/v2/get_protocol?uri=';
Readonly my $PROTOCOLS_URL_VIEW => 
    'https://www.protocols.io/api/v2/get_protocol?uri=';

main();

# --------------------------------------------------
sub get_args {
    my %args;

    GetOptions(\%args,
        'project_id:i',
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

    my $schema     = IMicrobe::DB->new->schema;
    my $project_id = $args{'project_id'}   || prompt('Project ID: ');

    unless ($project_id =~ /^\d+$/) {
        die "Project ID must be an integer.\n";
    }
    my $Project = $schema->resultset('Project')->find($project_id)
                  or die "Bad project id ($project_id)\n";

    printf "Project: %s\n", $Project->project_name;

    my $url = $args{'url'}  || prompt('URL: ');
    unless ($url =~ /\S+/) {
        die "URL is required.\n";
    }

    my $get_url    = $PROTOCOLS_URL_JSON . $url;
    my $prot_json  = get($get_url) or die "Cannot get '$get_url'\n";
    my $prot_data  = decode_json($prot_json) or die "Bad JSON ($prot_json)\n";
    my $res_code   = $prot_data->{'status_code'} || 0;

    if ($res_code != 0) {
        my $msg = $prot_data->{'error_message'} or "Unknown error";
        die join "\n", "Status: $res_code", "Error: $msg";
    }
    
    my $protocol      = shift @{ $prot_data->{'protocol'} || [] }
                        or die "Cannot find protocol in ", dump($prot_data);
    my $protocol_name = $protocol->{'protocol_name'}
                        or die "Cannot find protocol in ", dump($protocol);
    printf "Protocol: %s\n", $protocol_name;

    my ($Protocol) = $schema->resultset('Protocol')->find_or_create({
        protocol_name => $protocol_name,
    }) or die "Failed to create protocol.\n";

    my $url = $PROTOCOLS_URL_VIEW . $url;
    if ($Protocol->url ne $url) {
        $Protocol->url($url);
        $Protocol->update;
    }

    my ($P2P) = $schema->resultset('ProjectToProtocol')->find_or_create({
        project_id  => $Project->id,
        protocol_id => $Protocol->id,
    });

    say "Done.";
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

add-protocol.pl - add a protocol to a project

=head1 SYNOPSIS

  add-protocol.pl -p 94 \
    -u 'Modeling-ecological-drivers-in-marine-viral-commun-efgbbjw'

Required arguments:

  -p|--project_id  Project id
  -u|--url         Protocol URL

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
