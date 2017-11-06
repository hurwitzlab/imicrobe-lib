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

    my %bad = (Â => '', \xa0 => ' ');

    my $schema = IMicrobe::DB->new->schema;
    for my $Sample ($schema->resultset('Sample')->search) {
        say $Sample->sample_name;
        for my $fld (qw[sample_name sample_description]) {
            my $val = $Sample->$fld or next;
            while (my ($pattern, $replace) = each %bad) {
                if ($val =~ s/$pattern/$replace/g) {
                    say $Sample->sample_name, ": $fld ($val)";
#                    $Sample->$fld($val);
#                    $Sample->update;
                }
            }
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
    ) or pod2usage(2);

    return %args;
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

fix-unicode.pl - a script

=head1 SYNOPSIS

  fix-unicode.pl 

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

Copyright (c) 2017 kyclark

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
