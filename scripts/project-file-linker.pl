#!/usr/bin/env perl

use common::sense;
use autodie;
use Getopt::Long;
use IMicrobe::DB;
use Pod::Usage;
use Readonly;
use Text::RecordParser::Tab;

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

    my $project_id = $args{'project_id'} or pod2usage('Missing --project_id');
    my $file       = $args{'file'}       or pod2usage('Missing --file');
    my $p          = Text::RecordParser::Tab->new($file);
    my $schema     = IMicrobe::DB->new->schema;
    my $Project    = $schema->resultset('Project')->find($project_id)
                     or die "Bad project_id ($project_id)\n";

    my $i = 0;
    while (my $rec = $p->fetchrow_hashref) {
        my $file   = $rec->{'file'} or next;
        my $type   = $rec->{'type'} or next;
        my ($Type) = $schema->resultset('ProjectFileType')->find_or_create({
            type   => $type
        });

        printf "%3d: %s -> %s\n", ++$i, $file, $type;

        my ($ProjectFile) = $schema->resultset('ProjectFile')->find_or_create({
            project_file_type_id => $Type->id,
            project_id           => $Project->id,
            file                 => $file,
        });
    }

    say "Done, processed $i.\n";
}

# --------------------------------------------------
sub get_args {
    my %args;
    GetOptions(
        \%args,
        'project_id|p=i',
        'file|f=s',
        'help',
        'man',
    ) or pod2usage(2);

    return %args;
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

project-file-linker.pl - a script

=head1 SYNOPSIS

  project-file-linker.pl 

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
