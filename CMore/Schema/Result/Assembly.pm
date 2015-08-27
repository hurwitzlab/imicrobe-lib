use utf8;
package CMore::Schema::Result::Assembly;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

CMore::Schema::Result::Assembly

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<assembly>

=cut

__PACKAGE__->table("assembly");

=head1 ACCESSORS

=head2 assembly_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 project_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 assembly_code

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 assembly_name

  data_type: 'text'
  is_nullable: 1

=head2 organism

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 pep_file

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 nt_file

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 cds_file

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 sample_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "assembly_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "project_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "assembly_code",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "assembly_name",
  { data_type => "text", is_nullable => 1 },
  "organism",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "pep_file",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "nt_file",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "cds_file",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "sample_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</assembly_id>

=back

=cut

__PACKAGE__->set_primary_key("assembly_id");

=head1 RELATIONS

=head2 project

Type: belongs_to

Related object: L<CMore::Schema::Result::Project>

=cut

__PACKAGE__->belongs_to(
  "project",
  "CMore::Schema::Result::Project",
  { project_id => "project_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "RESTRICT",
  },
);

=head2 sample

Type: belongs_to

Related object: L<CMore::Schema::Result::Sample>

=cut

__PACKAGE__->belongs_to(
  "sample",
  "CMore::Schema::Result::Sample",
  { sample_id => "sample_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-08-21 17:14:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:gBghP1GtXPxGG0V4r9QPtw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
