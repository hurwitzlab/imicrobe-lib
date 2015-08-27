use utf8;
package CMore::Schema::Result::SampleFile;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

CMore::Schema::Result::SampleFile

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<sample_file>

=cut

__PACKAGE__->table("sample_file");

=head1 ACCESSORS

=head2 sample_file_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 sample_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 sample_file_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 file

  data_type: 'varchar'
  is_nullable: 1
  size: 200

=cut

__PACKAGE__->add_columns(
  "sample_file_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "sample_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "sample_file_type_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "file",
  { data_type => "varchar", is_nullable => 1, size => 200 },
);

=head1 PRIMARY KEY

=over 4

=item * L</sample_file_id>

=back

=cut

__PACKAGE__->set_primary_key("sample_file_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<sample_id>

=over 4

=item * L</sample_id>

=item * L</sample_file_type_id>

=item * L</file>

=back

=cut

__PACKAGE__->add_unique_constraint("sample_id", ["sample_id", "sample_file_type_id", "file"]);

=head1 RELATIONS

=head2 sample

Type: belongs_to

Related object: L<CMore::Schema::Result::Sample>

=cut

__PACKAGE__->belongs_to(
  "sample",
  "CMore::Schema::Result::Sample",
  { sample_id => "sample_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 sample_file_type

Type: belongs_to

Related object: L<CMore::Schema::Result::SampleFileType>

=cut

__PACKAGE__->belongs_to(
  "sample_file_type",
  "CMore::Schema::Result::SampleFileType",
  { sample_file_type_id => "sample_file_type_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-08-21 17:14:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Typ03CdP3LiUj4jU785OcQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
