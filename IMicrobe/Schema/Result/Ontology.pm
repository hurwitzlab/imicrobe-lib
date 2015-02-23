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
);

=head1 PRIMARY KEY

=over 4

=item * L</ontology_id>

=back

=cut

__PACKAGE__->set_primary_key("ontology_id");

=head1 RELATIONS

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


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-02-16 13:55:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:bz6FK58GxUAdI8MhBdAo4g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
