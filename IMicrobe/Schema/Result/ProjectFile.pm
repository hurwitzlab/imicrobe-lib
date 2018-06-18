use utf8;
package IMicrobe::Schema::Result::ProjectFile;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::ProjectFile

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<project_file>

=cut

__PACKAGE__->table("project_file");

=head1 ACCESSORS

=head2 project_file_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 project_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 project_file_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 file

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 description

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "project_file_id",
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
    is_nullable => 0,
  },
  "project_file_type_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "file",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "description",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</project_file_id>

=back

=cut

__PACKAGE__->set_primary_key("project_file_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<project_id>

=over 4

=item * L</project_id>

=item * L</project_file_type_id>

=item * L</file>

=back

=cut

__PACKAGE__->add_unique_constraint("project_id", ["project_id", "project_file_type_id", "file"]);

=head1 RELATIONS

=head2 project

Type: belongs_to

Related object: L<IMicrobe::Schema::Result::Project>

=cut

__PACKAGE__->belongs_to(
  "project",
  "IMicrobe::Schema::Result::Project",
  { project_id => "project_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 project_file_type

Type: belongs_to

Related object: L<IMicrobe::Schema::Result::ProjectFileType>

=cut

__PACKAGE__->belongs_to(
  "project_file_type",
  "IMicrobe::Schema::Result::ProjectFileType",
  { project_file_type_id => "project_file_type_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 publication_to_project_files

Type: has_many

Related object: L<IMicrobe::Schema::Result::PublicationToProjectFile>

=cut

__PACKAGE__->has_many(
  "publication_to_project_files",
  "IMicrobe::Schema::Result::PublicationToProjectFile",
  { "foreign.project_file_id" => "self.project_file_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2018-02-13 10:10:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:yvaHJ71wtEznUOJr7dkOfA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
