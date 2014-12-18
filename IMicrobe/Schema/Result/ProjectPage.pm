use utf8;
package IMicrobe::Schema::Result::ProjectPage;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::ProjectPage

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<project_page>

=cut

__PACKAGE__->table("project_page");

=head1 ACCESSORS

=head2 project_page_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 project_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 title

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 contents

  data_type: 'text'
  is_nullable: 1

=head2 display_order

  data_type: 'integer'
  is_nullable: 1

=head2 format

  data_type: 'enum'
  default_value: 'html'
  extra: {list => ["html","markdown"]}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "project_page_id",
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
  "title",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "contents",
  { data_type => "text", is_nullable => 1 },
  "display_order",
  { data_type => "integer", is_nullable => 1 },
  "format",
  {
    data_type => "enum",
    default_value => "html",
    extra => { list => ["html", "markdown"] },
    is_nullable => 1,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</project_page_id>

=back

=cut

__PACKAGE__->set_primary_key("project_page_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<project_id>

=over 4

=item * L</project_id>

=item * L</title>

=back

=cut

__PACKAGE__->add_unique_constraint("project_id", ["project_id", "title"]);

=head1 RELATIONS

=head2 project

Type: belongs_to

Related object: L<IMicrobe::Schema::Result::Project>

=cut

__PACKAGE__->belongs_to(
  "project",
  "IMicrobe::Schema::Result::Project",
  { project_id => "project_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-12-18 16:00:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5RSgFGTlMn7MHWwwGdXHKA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
