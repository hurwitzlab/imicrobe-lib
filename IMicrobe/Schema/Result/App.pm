use utf8;
package IMicrobe::Schema::Result::App;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::App

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<app>

=cut

__PACKAGE__->table("app");

=head1 ACCESSORS

=head2 app_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 app_name

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 is_active

  data_type: 'tinyint'
  default_value: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "app_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "app_name",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "is_active",
  { data_type => "tinyint", default_value => 1, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</app_id>

=back

=cut

__PACKAGE__->set_primary_key("app_id");

=head1 RELATIONS

=head2 app_runs

Type: has_many

Related object: L<IMicrobe::Schema::Result::AppRun>

=cut

__PACKAGE__->has_many(
  "app_runs",
  "IMicrobe::Schema::Result::AppRun",
  { "foreign.app_id" => "self.app_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2017-05-03 10:02:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:R3unwyvQrp1mEKa+PIp48A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
