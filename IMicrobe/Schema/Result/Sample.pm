use utf8;
package IMicrobe::Schema::Result::Sample;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::Sample

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<sample>

=cut

__PACKAGE__->table("sample");

=head1 ACCESSORS

=head2 sample_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 project_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 combined_assembly_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 sample_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 sample_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 sample_type

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 sample_description

  data_type: 'text'
  is_nullable: 1

=head2 comments

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 taxon_id

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 latitude

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 longitude

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "sample_id",
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
    is_nullable => 1,
  },
  "combined_assembly_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "sample_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "sample_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "sample_type",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "sample_description",
  { data_type => "text", is_nullable => 1 },
  "comments",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "taxon_id",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "latitude",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "longitude",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</sample_id>

=back

=cut

__PACKAGE__->set_primary_key("sample_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<project_id>

=over 4

=item * L</project_id>

=item * L</sample_acc>

=back

=cut

__PACKAGE__->add_unique_constraint("project_id", ["project_id", "sample_acc"]);

=head1 RELATIONS

=head2 assemblies

Type: has_many

Related object: L<IMicrobe::Schema::Result::Assembly>

=cut

__PACKAGE__->has_many(
  "assemblies",
  "IMicrobe::Schema::Result::Assembly",
  { "foreign.sample_id" => "self.sample_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 combined_assembly

Type: belongs_to

Related object: L<IMicrobe::Schema::Result::CombinedAssembly>

=cut

__PACKAGE__->belongs_to(
  "combined_assembly",
  "IMicrobe::Schema::Result::CombinedAssembly",
  { combined_assembly_id => "combined_assembly_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);

=head2 combined_assembly_to_samples

Type: has_many

Related object: L<IMicrobe::Schema::Result::CombinedAssemblyToSample>

=cut

__PACKAGE__->has_many(
  "combined_assembly_to_samples",
  "IMicrobe::Schema::Result::CombinedAssemblyToSample",
  { "foreign.sample_id" => "self.sample_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 project

Type: belongs_to

Related object: L<IMicrobe::Schema::Result::Project>

=cut

__PACKAGE__->belongs_to(
  "project",
  "IMicrobe::Schema::Result::Project",
  { project_id => "project_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "RESTRICT",
  },
);

=head2 sample_attrs

Type: has_many

Related object: L<IMicrobe::Schema::Result::SampleAttr>

=cut

__PACKAGE__->has_many(
  "sample_attrs",
  "IMicrobe::Schema::Result::SampleAttr",
  { "foreign.sample_id" => "self.sample_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 sample_files

Type: has_many

Related object: L<IMicrobe::Schema::Result::SampleFile>

=cut

__PACKAGE__->has_many(
  "sample_files",
  "IMicrobe::Schema::Result::SampleFile",
  { "foreign.sample_id" => "self.sample_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 sample_to_ontologies

Type: has_many

Related object: L<IMicrobe::Schema::Result::SampleToOntology>

=cut

__PACKAGE__->has_many(
  "sample_to_ontologies",
  "IMicrobe::Schema::Result::SampleToOntology",
  { "foreign.sample_id" => "self.sample_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2016-03-15 10:29:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3U7dRyjsg2QZ4Ss0408YUQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
