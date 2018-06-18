#!/usr/bin/env perl

use common::sense;
use autodie;
use IO::Prompt 'prompt';
use Getopt::Long;
use IMicrobe::DB;
use MuScope::DB;
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

    my @cruises  = split(/\s*,\s*/, $args{'cruise'}) or die "No cruise(s)\n";
    my $imicrobe = IMicrobe::DB->new->schema;
    my $muscope  = MuScope::DB->new->schema;
    my $Project  = get_project(\%args, $imicrobe);

    printf "IMICROBE PROJECT %s (%s)\n", $Project->project_name, $Project->id;

    for my $cruise (@cruises) {
        process($imicrobe, $muscope, $Project, $cruise);
        last;
    }

    say "Done";
}

# --------------------------------------------------
sub get_args {
    my %args;
    GetOptions(
        \%args,
        'cruise|c=s',
        'project_id|p=i',
        'help',
        'man',
    ) or pod2usage(2);

    return %args;
}

# --------------------------------------------------
sub get_project {
    my ($args, $imicrobe) = @_;
    my $project_id = $args->{'project_id'} or do {
        my $name = prompt "iMicrobe Project Name: ";
        my $code = prompt "iMicrobe Project Code: ";
        my ($Project) = $imicrobe->resultset('Project')->find_or_create({
            project_name => $name,
            project_code => $code,
        });
    };

    my ($Project) = $imicrobe->resultset('Project')->find($project_id)
        or die "Bad project id ($project_id)\n";

    return $Project;
}

# --------------------------------------------------
sub process {
    my ($imicrobe, $muscope, $Project, $cruise) = @_;

    my $Cruise;
    if ($cruise =~ /^\d+$/) {
        ($Cruise) = $muscope->resultset('Cruise')->find($cruise)
    }
    else {
        ($Cruise) = $muscope->resultset('Cruise')->search({
            cruise_name => $cruise
        });
    }

    die "Bad cruise ($cruise)\n" unless $Cruise;
    printf "CRUISE: %s (%s)\n", $Cruise->cruise_name, $Cruise->cruise_id;

    my %sample_fields_to_attr = (
        station_number   => '',
        cast_number      => '',
        latitude_start   => 'latitude',
        longitude_start  => 'longitude',
        depth            => '',
        collection_start => 'collection_start_time',
    );

    my $i = 0;
    for my $MSample ($Cruise->samples) {
        my $ISample     = $imicrobe->resultset('Sample')->find_or_create({
            project_id  => $Project->id,
            sample_acc  => join('-', 
                           $Project->project_code, $MSample->sample_name),
            sample_name => $MSample->sample_name,
        });

        printf "%3d: %s => %s\n", ++$i, $MSample->sample_name, $ISample->id;

        my ($seq_type) = 
            map  { $_->value }
            grep { $_->sample_attr_type->type eq 'sequence_type' } 
            $MSample->sample_attrs;

        if ($seq_type) {
            $ISample->sample_type($seq_type);
            $ISample->update;
        }

        for my $S2I ($MSample->sample_to_investigators) {
            my $investigator_name = join(' ',
                $S2I->investigator->first_name,
                $S2I->investigator->last_name
            );

            my $IInv = $imicrobe->resultset('Investigator')->find_or_create({
                investigator_name => $investigator_name
            });

            my $ISampleToInv = 
            $imicrobe->resultset('SampleToInvestigator')->find_or_create({
                sample_id       => $ISample->id,
                investigator_id => $IInv->id
            });
        }

        for my $MAttr ($MSample->sample_attrs) {
            next if lc($MAttr->value) == 'unknown';

            my $MType = $MAttr->sample_attr_type;

            my $IAttrType = 
            $imicrobe->resultset('SampleAttrType')->find_or_create({
                type => $MType->type
            });

            unless ($IAttrType->category) {
                $IAttrType->category('miscellaneous');
                $IAttrType->update;
            }

            if (my $desc = $MType->description) {
                $IAttrType->description($desc);
                $IAttrType->update;
            }

            my $IAttr = $imicrobe->resultset('SampleAttr')->find_or_create({
                sample_attr_type_id => $IAttrType->id,
                sample_id           => $ISample->id,
                attr_value          => $MAttr->value,
            });

            
            if (my $unit = $MType->unit) {
                $IAttr->unit($unit);
                $IAttr->update;
            }
            
            printf "  Attr %s => %s\n", $IAttrType->type, $IAttr->attr_value;
        }

        for my $fld (keys %sample_fields_to_attr) {
            my $val = $MSample->$fld or next;
            my $imicrobe_sample_type = $sample_fields_to_attr{$fld} || $fld;
            say "  Attr $fld => $imicrobe_sample_type '$val'";
            my $IAttrType = 
                $imicrobe->resultset('SampleAttrType')->find_or_create({
                    type => $imicrobe_sample_type
                });

            my $IAttr = $imicrobe->resultset('SampleAttr')->find_or_create({
                sample_attr_type_id => $IAttrType->id,
                sample_id           => $ISample->id,
                attr_value          => $val,
            });

            if ($fld eq 'depth') {
                $IAttr->unit('m');
                $IAttr->update;
            }
        }

#        for my $File ($MSample->sample_files) {
#            my $type = $File->sample_file_type->type;
#            printf "  File %s (%s)\n", $File->file, $type;
#
#            my $FType = 
#            $imicrobe->resultset('SampleFileType')->find_or_create({
#                type => $File->sample_file_type->type
#            });
#
#            my $IAttr = $imicrobe->resultset('SampleAttr')->find_or_create({
#                sample_attr_type_id => $IAttrType->id,
#                sample_id           => $ISample->id,
#                attr_value          => $val,
#            });
#        }
    }
}

# --------------------------------------------------
sub create_sample_attr {
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

import-from-muscope.pl - import cruises from muScope

=head1 SYNOPSIS

  import-from-muscope.pl -c 1,2,3

  import-from-muscope.pl -c HOT224 -p 2

Options:

  --cruise|-c      Comma-separated cruise ids/names
  --project_id|-p  iMicrobe project id (optional)
  --help           Show brief help and exit
  --man            Show full documentation

=head1 DESCRIPTION

Import cruise data from muScope.

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
