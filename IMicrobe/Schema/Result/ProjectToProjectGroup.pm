use utf8;
package IMicrobe::Schema::Result::ProjectToProjectGroup;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::ProjectToProjectGroup

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<project_to_project_group>

=cut

__PACKAGE__->table("project_to_project_group");

=head1 ACCESSORS

=head2 project_to_project_group_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 project_group_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 project_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "project_to_project_group_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "project_group_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "project_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</project_to_project_group_id>

=back

=cut

__PACKAGE__->set_primary_key("project_to_project_group_id");

=head1 RELATIONS

=head2 project

Type: belongs_to

Related object: L<IMicrobe::Schema::Result::Project>

=cut

__PACKAGE__->belongs_to(
  "project",
  "IMicrobe::Schema::Result::Project",
  { project_id => "project_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);

=head2 project_group

Type: belongs_to

Related object: L<IMicrobe::Schema::Result::ProjectGroup>

=cut

__PACKAGE__->belongs_to(
  "project_group",
  "IMicrobe::Schema::Result::ProjectGroup",
  { project_group_id => "project_group_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2016-03-15 10:29:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:oMo35NRa6CW9AMxOfYrHMg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
