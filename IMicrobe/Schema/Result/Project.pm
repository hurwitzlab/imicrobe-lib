use utf8;
package IMicrobe::Schema::Result::Project;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::Project

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<project>

=cut

__PACKAGE__->table("project");

=head1 ACCESSORS

=head2 project_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 project_code

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 project_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 pi

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 institution

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 project_type

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 read_file

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 meta_file

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 assembly_file

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 peptide_file

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 email

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 read_pep_file

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 nt_file

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=cut

__PACKAGE__->add_columns(
  "project_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "project_code",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "project_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "pi",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "institution",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "project_type",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "read_file",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "meta_file",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "assembly_file",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "peptide_file",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "email",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "read_pep_file",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "nt_file",
  { data_type => "varchar", is_nullable => 1, size => 100 },
);

=head1 PRIMARY KEY

=over 4

=item * L</project_id>

=back

=cut

__PACKAGE__->set_primary_key("project_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<project_code>

=over 4

=item * L</project_code>

=back

=cut

__PACKAGE__->add_unique_constraint("project_code", ["project_code"]);

=head1 RELATIONS

=head2 assemblies

Type: has_many

Related object: L<IMicrobe::Schema::Result::Assembly>

=cut

__PACKAGE__->has_many(
  "assemblies",
  "IMicrobe::Schema::Result::Assembly",
  { "foreign.project_id" => "self.project_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 combined_assemblies

Type: has_many

Related object: L<IMicrobe::Schema::Result::CombinedAssembly>

=cut

__PACKAGE__->has_many(
  "combined_assemblies",
  "IMicrobe::Schema::Result::CombinedAssembly",
  { "foreign.project_id" => "self.project_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 ftps

Type: has_many

Related object: L<IMicrobe::Schema::Result::Ftp>

=cut

__PACKAGE__->has_many(
  "ftps",
  "IMicrobe::Schema::Result::Ftp",
  { "foreign.project_id" => "self.project_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 project_files

Type: has_many

Related object: L<IMicrobe::Schema::Result::ProjectFile>

=cut

__PACKAGE__->has_many(
  "project_files",
  "IMicrobe::Schema::Result::ProjectFile",
  { "foreign.project_id" => "self.project_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 project_pages

Type: has_many

Related object: L<IMicrobe::Schema::Result::ProjectPage>

=cut

__PACKAGE__->has_many(
  "project_pages",
  "IMicrobe::Schema::Result::ProjectPage",
  { "foreign.project_id" => "self.project_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 project_to_domains

Type: has_many

Related object: L<IMicrobe::Schema::Result::ProjectToDomain>

=cut

__PACKAGE__->has_many(
  "project_to_domains",
  "IMicrobe::Schema::Result::ProjectToDomain",
  { "foreign.project_id" => "self.project_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 publications

Type: has_many

Related object: L<IMicrobe::Schema::Result::Publication>

=cut

__PACKAGE__->has_many(
  "publications",
  "IMicrobe::Schema::Result::Publication",
  { "foreign.project_id" => "self.project_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 samples

Type: has_many

Related object: L<IMicrobe::Schema::Result::Sample>

=cut

__PACKAGE__->has_many(
  "samples",
  "IMicrobe::Schema::Result::Sample",
  { "foreign.project_id" => "self.project_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2016-01-25 11:03:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:sgHwyGomNErdS4cjM6BaoA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
