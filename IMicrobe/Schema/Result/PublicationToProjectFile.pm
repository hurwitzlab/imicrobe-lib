use utf8;
package IMicrobe::Schema::Result::PublicationToProjectFile;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::PublicationToProjectFile

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<publication_to_project_file>

=cut

__PACKAGE__->table("publication_to_project_file");

=head1 ACCESSORS

=head2 publication_to_project_file_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 publication_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 project_file_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "publication_to_project_file_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "publication_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "project_file_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</publication_to_project_file_id>

=back

=cut

__PACKAGE__->set_primary_key("publication_to_project_file_id");

=head1 RELATIONS

=head2 project_file

Type: belongs_to

Related object: L<IMicrobe::Schema::Result::ProjectFile>

=cut

__PACKAGE__->belongs_to(
  "project_file",
  "IMicrobe::Schema::Result::ProjectFile",
  { project_file_id => "project_file_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);

=head2 publication

Type: belongs_to

Related object: L<IMicrobe::Schema::Result::Publication>

=cut

__PACKAGE__->belongs_to(
  "publication",
  "IMicrobe::Schema::Result::Publication",
  { publication_id => "publication_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2018-02-13 10:10:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:iINfprpgIXoUQvh8N0z5GQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
