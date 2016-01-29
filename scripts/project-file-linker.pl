#!/usr/bin/env perl

use strict;
use feature 'say';
use autodie;
use Data::Dump 'dump';
use IMicrobe::DB;
use IO::Prompt 'prompt';
use File::Basename 'fileparse';
use File::Spec::Functions 'catfile';
use String::Trim 'trim';

my $irods_dir    = shift or die "No irods dir\n";
my ($project_id) = $irods_dir =~ m{/projects/(\d+)}
                   or die "Cannot get project id from '$irods_dir'\n";
my $schema       = IMicrobe::DB->new->schema;
my $Project      = $schema->resultset('Project')->find($project_id)
                   or die "Bad project_id ($project_id)\n";
my $irods        = `ils $irods_dir` 
                   or die "Nothing good from '$irods_dir'\n";;
my $data         = parse_irods($irods);
my @contents     = @{ $data->{$irods_dir} || [] } 
                   or die "Nothing in $irods_dir\n";
my %file_type    = (
    '<<DO_NOT_LINK>>' => 0,
    (map { $_->type, $_->id } $schema->resultset('ProjectFileType')->all)
);

for my $file (@contents) {
    next if $file =~ /^C-\s+/; # not a regular file
    my $path = catfile($irods_dir, $file);

    my ($PF) = $schema->resultset('ProjectFile')->search({
        project_id => $Project->id,
        file       => $path,
    });

    if ($PF) {
        my $ft_id = prompt(
            sprintf("%s is currently '%s'. New type?\n", 
                $file, $PF->project_file_type->type
            ),
            -menu => \%file_type
        );

        if ($ft_id > 0 && $ft_id != $PF->project_file_type_id) {
            $PF->project_file_type_id($ft_id);
            $PF->update;
        }
    }
    else {
        my $ft_id = prompt("$file type? ", -menu => \%file_type);
        if ($ft_id > 0) {
            $schema->resultset('ProjectFile')->find_or_create({
                project_id           => $Project->id,
                project_file_type_id => $ft_id,
                file                 => $path,
            });
        }
    }
}

say "Done.";

# --------------------------------------------------
sub parse_irods {
    my $text = shift or die 'No irods input';
    my $cur_dir;
    my %contents;

    for my $line (split(/\n/, $text)) {
        chomp($line);
        if ($line =~ m{^(/.+):$}) {
            $cur_dir = $1;
        }
        elsif ($cur_dir) {
            push @{ $contents{ $cur_dir } }, trim($line);
        }
    }

    return \%contents;
}
