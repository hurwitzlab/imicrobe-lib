#!/usr/bin/env perl

use common::sense;
use autodie;
use Data::Dump 'dump';
use Getopt::Long;
use IMicrobe::DB;
use Pod::Usage;
use Readonly;
use Text::RecordParser;

main();

# --------------------------------------------------
sub get_args {
    my %args = (
        file => 'sample_metadata_fields.csv',
    );

    GetOptions(\%args,
        'file=s',
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

    unless ($args{'file'}) {
        pod2usage('No input file');
    }

    my $db     = IMicrobe::DB->new;
    my $schema = $db->schema;
    my $p      = Text::RecordParser->new($args{'file'});
    my $i      = 0;

    while (my $rec = $p->fetchrow_hashref) {
        #say dump($rec);
        my $proper_name = $rec->{'imicrobe'} or next;
        printf "%5d: %s\n", ++$i, $proper_name;
        my $SampleAttrType = $schema->resultset('SampleAttrType')->find_or_create({
            type => $proper_name
        });

        if (my $category = $rec->{'category'}) {
            if ($SampleAttrType->category ne $category) {
                printf "     %s => %s\n", 
                    $SampleAttrType->category || 'NA', $category;
                $SampleAttrType->category($category);
                $SampleAttrType->update;
            }
        }

        for my $fld (
            qw[mixs_term alternate_name camera bco_dmo_short_name hot_name]
        ) {
            if (my $alias = $rec->{ $fld }) {
                printf "     Alias => %s\n", $alias;
                $schema->resultset('SampleAttrTypeAlias')->find_or_create({
                    sample_attr_type_id => $SampleAttrType->id,
                    alias               => $alias,
                });
            }
        }
        #last;
    }

    say "Done.";
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

import-metadata-fields.pl - a script

=head1 SYNOPSIS

  import-metadata-fields.pl 

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

Copyright (c) 2015 kyclark

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
