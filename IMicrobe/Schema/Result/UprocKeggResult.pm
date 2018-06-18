use utf8;
package IMicrobe::Schema::Result::UprocKeggResult;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::UprocKeggResult

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<uproc_kegg_result>

=cut

__PACKAGE__->table("uproc_kegg_result");

=head1 ACCESSORS

=head2 uproc_kegg_result_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 sample_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 kegg_annotation_id

  data_type: 'varchar'
  is_foreign_key: 1
  is_nullable: 0
  size: 16

=head2 read_count

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "uproc_kegg_result_id",
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
  "kegg_annotation_id",
  { data_type => "varchar", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "read_count",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</uproc_kegg_result_id>

=back

=cut

__PACKAGE__->set_primary_key("uproc_kegg_result_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<kegg_annotation_id>

=over 4

=item * L</kegg_annotation_id>

=item * L</sample_id>

=back

=cut

__PACKAGE__->add_unique_constraint("kegg_annotation_id", ["kegg_annotation_id", "sample_id"]);

=head1 RELATIONS

=head2 kegg_annotation

Type: belongs_to

Related object: L<IMicrobe::Schema::Result::KeggAnnotation>

=cut

__PACKAGE__->belongs_to(
  "kegg_annotation",
  "IMicrobe::Schema::Result::KeggAnnotation",
  { kegg_annotation_id => "kegg_annotation_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);

=head2 sample

Type: belongs_to

Related object: L<IMicrobe::Schema::Result::Sample>

=cut

__PACKAGE__->belongs_to(
  "sample",
  "IMicrobe::Schema::Result::Sample",
  { sample_id => "sample_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2018-02-13 10:10:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:CTfVqg/5DCVjS8p5uZj0hQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
