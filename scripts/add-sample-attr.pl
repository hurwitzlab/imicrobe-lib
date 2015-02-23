#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';
use Data::Dump 'dump';
use Getopt::Long;
use IMicrobe::DB;
use Pod::Usage;
use Readonly;
use Text::RecordParser::Tab;

main(@ARGV);

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

    if (!@ARGV) {
        pod2usage('No input file');
    }

    process(@ARGV);

    say "Done.";
}

# --------------------------------------------------
sub process {
    my @files  = @_;
    my $db     = IMicrobe::DB->new;
    my $schema = $db->schema;

    my $i = 0;
    for my $file (@files) {
        my $p = Text::RecordParser::Tab->new($file);
        say "Processing '$file'";

        REC:
        while (my $rec = $p->fetchrow_hashref) {
            my $sample_id = $rec->{'sample_id'}        or next REC;
            my $attr_type = trim($rec->{'attr_type'})  or next REC;
            my $attr_val  = trim($rec->{'attr_value'}) or next REC;
            my $attr_cat  = trim($rec->{'attr_category'});
            my ($Sample)  = $schema->resultset('Sample')->find($sample_id);

            if (!$Sample) {
                say STDERR "Cannot find sample id '$sample_id'";
                next REC;
            }

            printf "%5d: %s (%s)\n", ++$i, $Sample->sample_name, $Sample->id;

            my ($SampleAttrType) 
                = $schema->resultset('SampleAttrType')->find_or_create({
                    type     => $attr_type,
                    category => $attr_cat,
                });

            if (my $desc = trim($rec->{'attr_description'})) {
                $SampleAttrType->description($desc);
                $SampleAttrType->update;
            }

            if (my $url = trim($rec->{'attr_url'})) {
                $SampleAttrType->url($url);
                $SampleAttrType->update;
            }

            my ($SampleAttr) =
                $schema->resultset('SampleAttr')->find_or_create({
                    sample_id           => $Sample->id,
                    sample_attr_type_id => $SampleAttrType->id,
                    attr_value          => $attr_val
                });
        }
    }
}

# --------------------------------------------------
sub trim {
    my $s = shift // '';
    $s =~ s/^\s*|\s*$//g;
    return $s;
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

add-sample-attr.pl - Add sample_attr/type records

=head1 SYNOPSIS

  add-sample-attr.pl file [file2...]

Options:

  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Accepts a tab-delimited file like so:

    ************ Record 1 ************
        sample_id: 3
       attr_value: PNEC
        attr_type: Longhurst Province
    attr_category: Environment

Creates the appropriate "sample_attr/type" records.

=head1 SEE ALSO

perl.

=head1 AUTHOR

Ken Youens-Clark E<lt>E<gt>.

=head1 COPYRIGHT

Copyright (c) 2015 Ken Youens-Clark

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
