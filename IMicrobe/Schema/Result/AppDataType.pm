use utf8;
package IMicrobe::Schema::Result::AppDataType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::AppDataType

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<app_data_type>

=cut

__PACKAGE__->table("app_data_type");

=head1 ACCESSORS

=head2 app_data_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 alias

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "app_data_type_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "alias",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</app_data_type_id>

=back

=cut

__PACKAGE__->set_primary_key("app_data_type_id");

=head1 RELATIONS

=head2 app_to_app_data_types

Type: has_many

Related object: L<IMicrobe::Schema::Result::AppToAppDataType>

=cut

__PACKAGE__->has_many(
  "app_to_app_data_types",
  "IMicrobe::Schema::Result::AppToAppDataType",
  { "foreign.app_data_type_id" => "self.app_data_type_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2017-10-19 15:41:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:2y4LeILxZfAo76B+CoaOIw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
