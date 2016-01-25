#!/usr/bin/env perl

use common::sense;
use autodie;
use Data::Dump 'dump';
use Getopt::Long;
use IMicrobe::DB;
use Pod::Usage;
use Readonly;
use Text::RecordParser::Tab;

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

    my $db = IMicrobe::DB->new;
    my $schema = $db->schema;

    if (my $file = shift @ARGV) {
        import_file($schema, $file);
    }
    else {
        my %vals = map {
            print "$_: ";
            chomp(my $answer = <>);
            ($answer) ? ($_, $answer) : ();
        } qw(project_code project_name pi institution project_type description);

        unless (%vals) {
            die "Not enough values to create project.\n";
        }

        if (
            my $Project = $schema->resultset('Project')->find_or_create(\%vals)
        ) {
            printf "Created project (%s)\n", $Project->id;
        }
        else {
            say "There was an error.\n";
        }
    }
}

# --------------------------------------------------
sub import_file {
    my ($schema, $file) = @_;

    my $p = Text::RecordParser::Tab->new($file);

    while (my $rec = $p->fetchrow_hashref) {
        my $Project = $schema->resultset('Project')->find_or_create({
            project_code => get_val($rec, qw[code bioproject]),
            project_name => get_val($rec, qw[project_name name]),
        });

        if ($Project) {
            printf "Created project '%s' (%s)\n", 
                $Project->project_name, $Project->id;

            for my $fld (
                'pi pi_name',
                'institution institute center_name',
                'project_type investigation_type',
                'description desc',
            ) {
                #'library_name',
                my ($fld_name, @aliases) = split(/\s+/, $fld);

                if (my $val = get_val($rec, $fld_name, @aliases)) {
                    say "  $fld_name => '$val'";
                    $Project->$fld_name($val);
                }
            }

            $Project->update();
        }
        else {
            say "Failed to create project for ", dump($rec);
        }
        last;
    }
}

# --------------------------------------------------
sub get_val {
    my ($hash, @keys) = @_;
    my $val = '';
    for my $key (@keys) {
        if (defined $hash->{$key}) {
            $val = $hash->{$key};
            last;
        }
    }
    return $val;
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
