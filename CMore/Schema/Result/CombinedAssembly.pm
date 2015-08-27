use utf8;
package CMore::Schema::Result::CombinedAssembly;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

CMore::Schema::Result::CombinedAssembly

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<combined_assembly>

=cut

__PACKAGE__->table("combined_assembly");

=head1 ACCESSORS

=head2 combined_assembly_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 project_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 assembly_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 phylum

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 class

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 family

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 genus

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 species

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 strain

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 pcr_amp

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 annotations_file

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 peptides_file

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 nucleotides_file

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 cds_file

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "combined_assembly_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "project_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "assembly_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "phylum",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "class",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "family",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "genus",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "species",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "strain",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "pcr_amp",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "annotations_file",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "peptides_file",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "nucleotides_file",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "cds_file",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</combined_assembly_id>

=back

=cut

__PACKAGE__->set_primary_key("combined_assembly_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<assembly_name>

=over 4

=item * L</assembly_name>

=back

=cut

__PACKAGE__->add_unique_constraint("assembly_name", ["assembly_name"]);

=head1 RELATIONS

=head2 combined_assembly_to_samples

Type: has_many

Related object: L<CMore::Schema::Result::CombinedAssemblyToSample>

=cut

__PACKAGE__->has_many(
  "combined_assembly_to_samples",
  "CMore::Schema::Result::CombinedAssemblyToSample",
  { "foreign.combined_assembly_id" => "self.combined_assembly_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 project

Type: belongs_to

Related object: L<CMore::Schema::Result::Project>

=cut

__PACKAGE__->belongs_to(
  "project",
  "CMore::Schema::Result::Project",
  { project_id => "project_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);

=head2 samples

Type: has_many

Related object: L<CMore::Schema::Result::Sample>

=cut

__PACKAGE__->has_many(
  "samples",
  "CMore::Schema::Result::Sample",
  { "foreign.combined_assembly_id" => "self.combined_assembly_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-08-21 17:14:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:S3bfNlCqYZ5CxFYnM0zuMQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
