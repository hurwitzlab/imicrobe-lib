#!/usr/bin/env perl

use common::sense;
use autodie;
use Cwd 'cwd';
use Getopt::Long;
use File::Spec::Functions 'catfile';
use File::Basename 'dirname';
use File::Path 'make_path';
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

    my $out_file = $args{'out_file'} 
                || catfile(cwd(), 'imicrobe-blast-annots.txt');
    my $schema   = IMicrobe::DB->new->schema;
    my $out_dir  = dirname($out_file);

    unless (-d $out_dir) {
        make_path($out_dir);
    }

    my @SampleAttrType = 
        grep { $_->type !~ /^(comments|order)$/ }
        $schema->resultset('SampleAttrType')->search();

    open my $out_fh, '>', $out_file;
    say $out_fh join "\t", 
        qw[
            sample_id
            project_name
            ontologies
        ], 
        # add "_" to beginning to fix fields for SQLite
        map  { s/[\s-]+/_/g; s/^\W+//g; s/^(\d+)/_\1/; lc $_ }
        map  { $_->type } 
        @SampleAttrType  
    ;

    my $i = 0;
    for my $Sample ($schema->resultset('Sample')->search) {
        printf "%d: %s (%s)\n", ++$i, $Sample->sample_name, $Sample->id;
        my @ontologies;
        for my $S2O ($Sample->sample_to_ontologies) {
            push @ontologies, sprintf("%s%s",
                $S2O->ontology->ontology_acc,
                $S2O->ontology->label 
                    ? sprintf(" (%s)", $S2O->ontology->label)
                    : ''
            );
        }

        my @attrs;
        for my $Type (@SampleAttrType) {
            my ($Attr) = $schema->resultset('SampleAttr')->search({
                sample_id           => $Sample->id,
                sample_attr_type_id => $Type->id,
            });

            my $val = '';
            if ($Attr) {
                $val = sprintf("%s%s", $Attr->attr_value, 
                    $Attr->unit ? ' ' . $Attr->unit : ''
                );
            }
            push @attrs, $val;
        }

        say $out_fh join "\t", 
            $Sample->id,
            map { s/\t/ /g; $_ }
            $Sample->project->project_name,
            join(',', @ontologies),
            @attrs,
        ;
    }

    say "Done, exported $i samples to '$out_file.'";
}

# --------------------------------------------------
sub get_args {
    my %args;
    GetOptions(
        \%args,
        'out_file|o=s',
        'help',
        'man',
    ) or pod2usage(2);

    return %args;
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

export-blast-annots.pl - a script

=head1 SYNOPSIS

  export-blast-annots.pl 

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
