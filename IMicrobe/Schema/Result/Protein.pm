use utf8;
package IMicrobe::Schema::Result::Protein;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::Protein

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<protein>

=cut

__PACKAGE__->table("protein");

=head1 ACCESSORS

=head2 protein_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 protein_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 accession

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 description

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "protein_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "protein_type_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "accession",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "description",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</protein_id>

=back

=cut

__PACKAGE__->set_primary_key("protein_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<accession>

=over 4

=item * L</accession>

=back

=cut

__PACKAGE__->add_unique_constraint("accession", ["accession"]);

=head1 RELATIONS

=head2 protein_type

Type: belongs_to

Related object: L<IMicrobe::Schema::Result::ProteinType>

=cut

__PACKAGE__->belongs_to(
  "protein_type",
  "IMicrobe::Schema::Result::ProteinType",
  { protein_type_id => "protein_type_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);

=head2 sample_to_proteins

Type: has_many

Related object: L<IMicrobe::Schema::Result::SampleToProtein>

=cut

__PACKAGE__->has_many(
  "sample_to_proteins",
  "IMicrobe::Schema::Result::SampleToProtein",
  { "foreign.protein_id" => "self.protein_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2018-02-13 10:10:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:d+S2EiLFJjmgR7O172mfXQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
