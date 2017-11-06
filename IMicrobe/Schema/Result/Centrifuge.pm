use utf8;
package IMicrobe::Schema::Result::Centrifuge;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::Centrifuge

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<centrifuge>

=cut

__PACKAGE__->table("centrifuge");

=head1 ACCESSORS

=head2 centrifuge_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 tax_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "centrifuge_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "tax_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</centrifuge_id>

=back

=cut

__PACKAGE__->set_primary_key("centrifuge_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<name>

=over 4

=item * L</name>

=back

=cut

__PACKAGE__->add_unique_constraint("name", ["name"]);

=head2 C<tax_id>

=over 4

=item * L</tax_id>

=back

=cut

__PACKAGE__->add_unique_constraint("tax_id", ["tax_id"]);

=head1 RELATIONS

=head2 sample_to_centrifuges

Type: has_many

Related object: L<IMicrobe::Schema::Result::SampleToCentrifuge>

=cut

__PACKAGE__->has_many(
  "sample_to_centrifuges",
  "IMicrobe::Schema::Result::SampleToCentrifuge",
  { "foreign.centrifuge_id" => "self.centrifuge_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2017-11-01 16:25:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4eeDq2bfjvuiSAhaYgMO8Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
