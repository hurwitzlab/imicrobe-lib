use utf8;
package IMicrobe::Schema::Result::AppResult;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::AppResult

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<app_result>

=cut

__PACKAGE__->table("app_result");

=head1 ACCESSORS

=head2 app_result_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 app_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 app_data_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 path

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "app_result_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "app_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "app_data_type_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "path",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</app_result_id>

=back

=cut

__PACKAGE__->set_primary_key("app_result_id");


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2018-02-13 10:10:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Fz5uzfu6lGb/qzkWtS9TRQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
