use utf8;
package IMicrobe::Schema::Result::SampleAttrTypeAlias;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::SampleAttrTypeAlias

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<sample_attr_type_alias>

=cut

__PACKAGE__->table("sample_attr_type_alias");

=head1 ACCESSORS

=head2 sample_attr_type_alias_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 sample_attr_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 alias

  data_type: 'varchar'
  is_nullable: 0
  size: 200

=cut

__PACKAGE__->add_columns(
  "sample_attr_type_alias_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "sample_attr_type_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "alias",
  { data_type => "varchar", is_nullable => 0, size => 200 },
);

=head1 PRIMARY KEY

=over 4

=item * L</sample_attr_type_alias_id>

=back

=cut

__PACKAGE__->set_primary_key("sample_attr_type_alias_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<sample_attr_type_id>

=over 4

=item * L</sample_attr_type_id>

=item * L</alias>

=back

=cut

__PACKAGE__->add_unique_constraint("sample_attr_type_id", ["sample_attr_type_id", "alias"]);

=head1 RELATIONS

=head2 sample_attr_type

Type: belongs_to

Related object: L<IMicrobe::Schema::Result::SampleAttrType>

=cut

__PACKAGE__->belongs_to(
  "sample_attr_type",
  "IMicrobe::Schema::Result::SampleAttrType",
  { sample_attr_type_id => "sample_attr_type_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2018-06-25 16:10:16
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XwstV9oqZGspseJoxy6EUw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
