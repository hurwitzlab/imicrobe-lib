use utf8;
package IMicrobe::Schema::Result::Reference;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::Reference

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<reference>

=cut

__PACKAGE__->table("reference");

=head1 ACCESSORS

=head2 reference_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 file

  data_type: 'varchar'
  is_nullable: 0
  size: 20

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 revision

  data_type: 'text'
  is_nullable: 1

=head2 length

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 seq_count

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 build_date

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "reference_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "file",
  { data_type => "varchar", is_nullable => 0, size => 20 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "revision",
  { data_type => "text", is_nullable => 1 },
  "length",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "seq_count",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "build_date",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</reference_id>

=back

=cut

__PACKAGE__->set_primary_key("reference_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<file>

=over 4

=item * L</file>

=item * L</name>

=back

=cut

__PACKAGE__->add_unique_constraint("file", ["file", "name"]);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-12-01 15:54:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NCLiOwkLOUldsWhrg062hA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
