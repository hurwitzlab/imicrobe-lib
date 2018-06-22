use utf8;
package IMicrobe::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::User

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<user>

=cut

__PACKAGE__->table("user");

=head1 ACCESSORS

=head2 user_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 user_name

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 first_name

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 last_name

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 date

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=head2 orcid

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=cut

__PACKAGE__->add_columns(
  "user_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "user_name",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "first_name",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "last_name",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "date",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
  "orcid",
  { data_type => "varchar", is_nullable => 1, size => 30 },
);

=head1 PRIMARY KEY

=over 4

=item * L</user_id>

=back

=cut

__PACKAGE__->set_primary_key("user_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<user_name>

=over 4

=item * L</user_name>

=back

=cut

__PACKAGE__->add_unique_constraint("user_name", ["user_name"]);

=head1 RELATIONS

=head2 app_runs

Type: has_many

Related object: L<IMicrobe::Schema::Result::AppRun>

=cut

__PACKAGE__->has_many(
  "app_runs",
  "IMicrobe::Schema::Result::AppRun",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 logins

Type: has_many

Related object: L<IMicrobe::Schema::Result::Login>

=cut

__PACKAGE__->has_many(
  "logins",
  "IMicrobe::Schema::Result::Login",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 project_group_to_users

Type: has_many

Related object: L<IMicrobe::Schema::Result::ProjectGroupToUser>

=cut

__PACKAGE__->has_many(
  "project_group_to_users",
  "IMicrobe::Schema::Result::ProjectGroupToUser",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 project_to_users

Type: has_many

Related object: L<IMicrobe::Schema::Result::ProjectToUser>

=cut

__PACKAGE__->has_many(
  "project_to_users",
  "IMicrobe::Schema::Result::ProjectToUser",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2018-06-18 15:43:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:6lDZwH+onOuFucC5AGXUWg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
