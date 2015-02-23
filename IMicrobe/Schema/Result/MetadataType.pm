use utf8;
package IMicrobe::Schema::Result::MetadataType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::MetadataType

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<metadata_type>

=cut

__PACKAGE__->table("metadata_type");

=head1 ACCESSORS

=head2 metadata_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 category

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 64

=head2 category_type

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 qiime_tag

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 mgrast_tag

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 tag

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 128

=head2 definition

  data_type: 'text'
  is_nullable: 1

=head2 required

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 0

=head2 mixs

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 0

=head2 type

  data_type: 'text'
  is_nullable: 1

=head2 fw_type

  data_type: 'text'
  is_nullable: 1

=head2 unit

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "metadata_type_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "category",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 64 },
  "category_type",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "qiime_tag",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "mgrast_tag",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "tag",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 128 },
  "definition",
  { data_type => "text", is_nullable => 1 },
  "required",
  { data_type => "tinyint", default_value => 0, is_nullable => 0 },
  "mixs",
  { data_type => "tinyint", default_value => 0, is_nullable => 0 },
  "type",
  { data_type => "text", is_nullable => 1 },
  "fw_type",
  { data_type => "text", is_nullable => 1 },
  "unit",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</metadata_type_id>

=back

=cut

__PACKAGE__->set_primary_key("metadata_type_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<category>

=over 4

=item * L</category>

=item * L</tag>

=back

=cut

__PACKAGE__->add_unique_constraint("category", ["category", "tag"]);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-01-14 10:36:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:JlrhhT2+jSv/q9AZnsGqGg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
