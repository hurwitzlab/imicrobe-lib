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
    my %args      = get_args();
    my $main_id   = $args{'main_id'} or pod2usage('No -i id');
    my @other_ids = split /,/, $args{'other_ids'} 
                    or pod2usage('No -o other ids');;

    printf "other (%s) => $main_id\n", join(', ', @other_ids);

    if ($args{'help'} || $args{'man_page'}) {
        pod2usage({
            -exitval => 0,
            -verbose => $args{'man_page'} ? 2 : 1
        });
    }; 

    my $schema = IMicrobe::DB->new->schema;
    my $Inv    = $schema->resultset('Investigator')->find($main_id)
                 or die "Bad id ($main_id)\n";

    for my $id (@other_ids) {
        my $Other = $schema->resultset('Investigator')->find($id)
                    or die "Bad id ($id)\n";

        my @P2I = $schema->resultset('ProjectToInvestigator')->search({
            investigator_id => $Other->id
        });

        for my $P2I (@P2I) {
            printf "Project '%s' (%s) -> %s\n", 
                $P2I->project->project_name, $P2I->project->id, $Inv->id;

            $P2I->investigator_id($Inv->id);
            $P2I->update();
        }

        my @S2I = $schema->resultset('SampleToInvestigator')->search({
            investigator_id => $Other->id
        });

        for my $S2I (@S2I) {
            printf "Sample '%s' (%s) -> %s\n", 
                $S2I->sample->sample_name, $S2I->id, $Inv->id;
            $S2I->investigator_id($Inv->id);
            $S2I->update();
        }
    }

    say "OK";
}

# --------------------------------------------------
sub get_args {
    my %args;
    GetOptions(
        \%args,
        'help',
        'man',
        'main_id|i=i',
        'other_ids|o=s',
    ) or pod2usage(2);

    return %args;
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

merge-investigator.pl - a script

=head1 SYNOPSIS

  merge-investigator.pl -i <main-id> -o <other-ids>

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
