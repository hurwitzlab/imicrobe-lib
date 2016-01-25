use utf8;
package IMicrobe::Schema::Result::OntologyType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::OntologyType

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<ontology_type>

=cut

__PACKAGE__->table("ontology_type");

=head1 ACCESSORS

=head2 ontology_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 type

  data_type: 'varchar'
  is_nullable: 1
  size: 256

=head2 url_template

  data_type: 'varchar'
  is_nullable: 1
  size: 256

=cut

__PACKAGE__->add_columns(
  "ontology_type_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "type",
  { data_type => "varchar", is_nullable => 1, size => 256 },
  "url_template",
  { data_type => "varchar", is_nullable => 1, size => 256 },
);

=head1 PRIMARY KEY

=over 4

=item * L</ontology_type_id>

=back

=cut

__PACKAGE__->set_primary_key("ontology_type_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<type>

=over 4

=item * L</type>

=back

=cut

__PACKAGE__->add_unique_constraint("type", ["type"]);

=head1 RELATIONS

=head2 ontologies

Type: has_many

Related object: L<IMicrobe::Schema::Result::Ontology>

=cut

__PACKAGE__->has_many(
  "ontologies",
  "IMicrobe::Schema::Result::Ontology",
  { "foreign.ontology_type_id" => "self.ontology_type_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2016-01-12 12:46:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:BKvmtshxtSS/Gc+kGOTAew


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
