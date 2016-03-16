use utf8;
package IMicrobe::Schema::Result::Publication;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::Publication

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<publication>

=cut

__PACKAGE__->table("publication");

=head1 ACCESSORS

=head2 publication_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 project_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 pub_code

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 doi

  data_type: 'text'
  is_nullable: 1

=head2 author

  data_type: 'text'
  is_nullable: 1

=head2 title

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 pubmed_id

  data_type: 'integer'
  is_nullable: 1

=head2 journal

  data_type: 'text'
  is_nullable: 1

=head2 pub_date

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "publication_id",
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
  "pub_code",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "doi",
  { data_type => "text", is_nullable => 1 },
  "author",
  { data_type => "text", is_nullable => 1 },
  "title",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "pubmed_id",
  { data_type => "integer", is_nullable => 1 },
  "journal",
  { data_type => "text", is_nullable => 1 },
  "pub_date",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</publication_id>

=back

=cut

__PACKAGE__->set_primary_key("publication_id");

=head1 RELATIONS

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
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2016-02-08 10:53:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:HCrHwmWuAaatFUTcGXGkBw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
