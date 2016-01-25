use utf8;
package IMicrobe::Schema::Result::Ontology;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::Ontology

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<ontology>

=cut

__PACKAGE__->table("ontology");

=head1 ACCESSORS

=head2 ontology_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 ontology_acc

  data_type: 'varchar'
  is_nullable: 0
  size: 125

=head2 label

  data_type: 'varchar'
  is_nullable: 0
  size: 125

=head2 ontology_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "ontology_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "ontology_acc",
  { data_type => "varchar", is_nullable => 0, size => 125 },
  "label",
  { data_type => "varchar", is_nullable => 0, size => 125 },
  "ontology_type_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</ontology_id>

=back

=cut

__PACKAGE__->set_primary_key("ontology_id");

=head1 RELATIONS

=head2 ontology_type

Type: belongs_to

Related object: L<IMicrobe::Schema::Result::OntologyType>

=cut

__PACKAGE__->belongs_to(
  "ontology_type",
  "IMicrobe::Schema::Result::OntologyType",
  { ontology_type_id => "ontology_type_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);

=head2 sample_to_ontologies

Type: has_many

Related object: L<IMicrobe::Schema::Result::SampleToOntology>

=cut

__PACKAGE__->has_many(
  "sample_to_ontologies",
  "IMicrobe::Schema::Result::SampleToOntology",
  { "foreign.ontology_id" => "self.ontology_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2016-01-12 12:46:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3bGDHQUGVwU1KAmKnseNVg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
