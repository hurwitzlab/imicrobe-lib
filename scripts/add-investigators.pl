#!/usr/bin/env perl

use common::sense;
use autodie;
use Getopt::Long;
use IMicrobe::DB;
use Pod::Usage;
use Readonly;

main();

# --------------------------------------------------
sub main {
    my %args = get_args();

    if ($args{'help'} || $args{'man_page'}) {
        pod2usage({
            -exitval => 0,
            -verbose => $args{'man_page'} ? 2 : 1
        });
    }; 

    my @investigators = @ARGV or pod2usage('Missing investigators');
    my $project_id = $args{'project_id'} or pod2usage('Missing --project_id');
    my $schema     = IMicrobe::DB->new(name => $args{'db'})->schema;
    my $Project    = $schema->resultset('Project')->find($project_id)
                     or die "Bad project_id ($project_id)\n";

    my $i;
    for my $inv (@investigators) {
        my ($Inv) = $schema->resultset('Investigator')->find_or_create({
            investigator_name => $inv
        });

        printf "%3d: %s (%s)\n", ++$i, $Inv->investigator_name, $Inv->id;

        my ($P2I) 
        = $schema->resultset('ProjectToInvestigator')->find_or_create({
            investigator_id => $Inv->id,
            project_id      => $Project->id,
        });
    }

    say "OK";
}

# --------------------------------------------------
sub get_args {
    my %args = (db => 'imicrobe');
    GetOptions(
        \%args,
        'db:s',
        'project_id:i',
        'help',
        'man',
    ) or pod2usage(2);

    return %args;
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

add-investigators.pl - a script

=head1 SYNOPSIS

  add-investigators.pl -p 1 'Edward Delong'

Options:

  -p       Project ID
  -d       imicrobe/muscope
  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Describe what the script does, what input it expects, what output it
creates, etc.

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
