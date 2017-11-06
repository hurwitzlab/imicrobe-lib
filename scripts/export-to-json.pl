#!/usr/bin/env perl

use common::sense;
use autodie;
use Getopt::Long;
use IMicrobe::DB;
use Pod::Usage;
use Readonly;
use JSON;

main();

# --------------------------------------------------
sub main {
    my %args = get_args();

    if ($args{'help'} || $args{'man_page'}) {
        pod2usage({
            -exitval => 0,
            -verbose => $args{'man_page'} ? 2 : 1
        });
    }

    my $project_id = $args{'project_id'} or pod2usage('No project_id');
    my $schema     = IMicrobe::DB->new->schema;

    my $Project    = $schema->resultset('Project')->find($project_id)
                     or die "Bad project_id ($project_id)\n";
    my %json       = (project => {$Project->get_inflated_columns});

    for my $P2I ($Project->project_to_investigators) {
        push @{ $json{'investigators'} }, 
            { $P2I->investigator->get_inflated_columns };
    }

    for my $Sample ($Project->samples) {
        push @{ $json{'samples'} }, { 
            $Sample->get_inflated_columns,
            sample_attr => [
                map { {$_->get_inflated_columns} } $Sample->sample_attrs
            ],
        };
    }

    say to_json(\%json); 
}

# --------------------------------------------------
sub get_args {
    my %args;
    GetOptions(
        \%args,
        'help',
        'man',
        'project_id|p:i',
    ) or pod2usage(2);

    return %args;
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

export-to-json.pl - a script

=head1 SYNOPSIS

  export-to-json.pl 

Options:

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
