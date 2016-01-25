use utf8;
package IMicrobe::Schema::Result::ProjectFileType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::ProjectFileType

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<project_file_type>

=cut

__PACKAGE__->table("project_file_type");

=head1 ACCESSORS

=head2 project_file_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 type

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "project_file_type_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "type",
  { data_type => "varchar", is_nullable => 0, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</project_file_type_id>

=back

=cut

__PACKAGE__->set_primary_key("project_file_type_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<type>

=over 4

=item * L</type>

=back

=cut

__PACKAGE__->add_unique_constraint("type", ["type"]);

=head1 RELATIONS

=head2 project_files

Type: has_many

Related object: L<IMicrobe::Schema::Result::ProjectFile>

=cut

__PACKAGE__->has_many(
  "project_files",
  "IMicrobe::Schema::Result::ProjectFile",
  { "foreign.project_file_type_id" => "self.project_file_type_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2016-01-25 11:03:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:WSeqmNf0ZHWKhOkiyl4m3Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
