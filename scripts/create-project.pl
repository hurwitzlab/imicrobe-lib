#!/usr/bin/env perl

use common::sense;
use autodie;
use Data::Dump 'dump';
use Getopt::Long;
use IMicrobe::DB;
use Pod::Usage;
use Readonly;

main();

# --------------------------------------------------
sub main {
    my ($help, $man_page);
    GetOptions(
        'help' => \$help,
        'man'  => \$man_page,
    ) or pod2usage(2);

    if ($help || $man_page) {
        pod2usage({
            -exitval => 0,
            -verbose => $man_page ? 2 : 1
        });
    }; 

    my %vals = map {
        print "$_: ";
        chomp(my $answer = <>);
        ($answer) ? ($_, $answer) : ();
    } qw(project_code project_name pi institution project_type description);

    unless (%vals) {
        die "Not enough values to create project.\n";
    }

    my $db = IMicrobe::DB->new;
    my $schema = $db->schema;
    if (my $Project = $schema->resultset('Project')->find_or_create(\%vals)) {
        say "Created project", dump(\%{$Project->get_inflated_columns()});
    }
    else {
        say "There was an error.\n";
    }
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

create-project.pl - creates an iMicrobe project

=head1 SYNOPSIS

  create-project.pl 

Options:

  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

You will be prompted for input values.  A project will be created (or not).

=head1 AUTHOR

Ken Youens-Clark E<lt>kyclark@email.arizona.eduE<gt>.

=head1 COPYRIGHT

Copyright (c) 2015 kyclark

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
