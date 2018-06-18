use utf8;
package IMicrobe::Schema::Result::KeggAnnotation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::KeggAnnotation

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<kegg_annotation>

=cut

__PACKAGE__->table("kegg_annotation");

=head1 ACCESSORS

=head2 kegg_annotation_id

  data_type: 'varchar'
  is_nullable: 0
  size: 16

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 80

=head2 definition

  data_type: 'text'
  is_nullable: 1

=head2 pathway

  data_type: 'text'
  is_nullable: 1

=head2 module

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "kegg_annotation_id",
  { data_type => "varchar", is_nullable => 0, size => 16 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 80 },
  "definition",
  { data_type => "text", is_nullable => 1 },
  "pathway",
  { data_type => "text", is_nullable => 1 },
  "module",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</kegg_annotation_id>

=back

=cut

__PACKAGE__->set_primary_key("kegg_annotation_id");

=head1 RELATIONS

=head2 uproc_kegg_results

Type: has_many

Related object: L<IMicrobe::Schema::Result::UprocKeggResult>

=cut

__PACKAGE__->has_many(
  "uproc_kegg_results",
  "IMicrobe::Schema::Result::UprocKeggResult",
  { "foreign.kegg_annotation_id" => "self.kegg_annotation_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2018-02-13 10:10:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:gqLEekKx30gsBvR03TbmYw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
