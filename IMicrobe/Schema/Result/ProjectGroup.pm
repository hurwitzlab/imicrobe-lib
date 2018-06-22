use utf8;
package IMicrobe::Schema::Result::ProjectGroup;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::ProjectGroup

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<project_group>

=cut

__PACKAGE__->table("project_group");

=head1 ACCESSORS

=head2 project_group_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 group_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 url

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 private

  data_type: 'tinyint'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "project_group_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "group_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "url",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "private",
  { data_type => "tinyint", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</project_group_id>

=back

=cut

__PACKAGE__->set_primary_key("project_group_id");

=head1 RELATIONS

=head2 project_group_to_users

Type: has_many

Related object: L<IMicrobe::Schema::Result::ProjectGroupToUser>

=cut

__PACKAGE__->has_many(
  "project_group_to_users",
  "IMicrobe::Schema::Result::ProjectGroupToUser",
  { "foreign.project_group_id" => "self.project_group_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 project_to_project_groups

Type: has_many

Related object: L<IMicrobe::Schema::Result::ProjectToProjectGroup>

=cut

__PACKAGE__->has_many(
  "project_to_project_groups",
  "IMicrobe::Schema::Result::ProjectToProjectGroup",
  { "foreign.project_group_id" => "self.project_group_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2018-06-18 15:43:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:2vgPHXOYjle9xNAJQ6rCGg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
