#!/usr/bin/env perl

use common::sense;
use autodie;
use Data::Dump 'dump';
use Getopt::Long;
use IMicrobe::DB;
use JSON;
use Perl6::Slurp 'slurp';
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

    my $db_name = $args{'db'} or pod2usage('No db');
    my $schema  = IMicrobe::DB->new(name => $db_name)->schema;
    my $json    = shift(@ARGV) or pod2usage('No JSON');
    my $data    = decode_json(slurp($json));

    printf "#projects = %s\n", dump($schema->resultset('Project')->count);

    # PROJECT
    my $project_rs = $schema->resultset('Project');
    my $project_pk = join '', $project_rs->result_source->primary_columns;
    my $project_hash = $data->{'project'};
    delete $project_hash->{$project_pk}; 
    my $Project = $schema->resultset('Project')->find_or_create($project_hash);
    say dump({$Project->get_inflated_columns});
    my $project_id = $Project->id;

    investigators($schema, $data, $Project);
    samples($schema, $data, $Project);

    say "OK";
}

# --------------------------------------------------
sub investigators {
    my ($schema, $hash, $Project) = @_;
    return unless defined $hash->{'investigators'}
                  && ref $hash->{'investigators'} eq 'ARRAY';

    my $rs = $schema->resultset('Investigator');
    my $pk = join '', $rs->result_source->primary_columns;
    for my $inv ( @{ $hash->{'investigators'} }) {
        delete $inv->{ $pk };
        my $Inv = $schema->resultset('Investigator')->find_or_create($inv);
        $schema->resultset('ProjectToInvestigator')->find_or_create({
            project_id => $Project->id,
            investigator_id => $Inv->id
        });
    }
}

# --------------------------------------------------
sub samples {
    my ($schema, $hash, $Project) = @_;
    return unless defined $hash->{'samples'}
                  && ref $hash->{'samples'} eq 'ARRAY';

    my $rs = $schema->resultset('Sample');
    my $pk = join '', $rs->result_source->primary_columns;
    for my $sample ( @{ $hash->{'samples'} }) {
        my @attr = @{ $sample->{'sample_attr'} || [] };
        delete $sample->{'sample_attr'};
        delete $sample->{ $pk };
        $sample->{'project_id'} = $Project->id;

        my $Sample = $schema->resultset('Sample')->find_or_create($sample);
        $schema->resultset('SampleToInvestigator')->find_or_create({
            sample_id => $Sample->id,
            investigator_id => 1,
        });

        for my $attr (@attr) {
            $attr->{'sample_id'} = $Sample->id;
            my $Attr = $schema->resultset('SampleAttr')->find_or_create($attr);
        }
    }
}

# --------------------------------------------------
sub get_args {
    my %args;
    GetOptions(
        \%args,
        'help',
        'man',
        'db|d=s',
    ) or pod2usage(2);

    return %args;
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

import-from-json.pl - a script

=head1 SYNOPSIS

  import-from-json.pl 

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
