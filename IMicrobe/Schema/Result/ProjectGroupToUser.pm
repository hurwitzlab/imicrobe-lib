use utf8;
package IMicrobe::Schema::Result::ProjectGroupToUser;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::ProjectGroupToUser

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<project_group_to_user>

=cut

__PACKAGE__->table("project_group_to_user");

=head1 ACCESSORS

=head2 project_group_to_user_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 project_group_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 permission

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "project_group_to_user_id",
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
  "user_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "permission",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</project_group_to_user_id>

=back

=cut

__PACKAGE__->set_primary_key("project_group_to_user_id");

=head1 RELATIONS

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

=head2 user

Type: belongs_to

Related object: L<IMicrobe::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "IMicrobe::Schema::Result::User",
  { user_id => "user_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2018-06-18 15:43:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:H5wlxdD9lI11x1muKodr7w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
