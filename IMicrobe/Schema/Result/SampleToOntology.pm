use utf8;
package IMicrobe::Schema::Result::SampleToOntology;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::SampleToOntology

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<sample_to_ontology>

=cut

__PACKAGE__->table("sample_to_ontology");

=head1 ACCESSORS

=head2 sample_to_ontology_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 sample_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 ontology_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "sample_to_ontology_id",
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
    is_nullable => 1,
  },
  "ontology_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</sample_to_ontology_id>

=back

=cut

__PACKAGE__->set_primary_key("sample_to_ontology_id");

=head1 RELATIONS

=head2 ontology

Type: belongs_to

Related object: L<IMicrobe::Schema::Result::Ontology>

=cut

__PACKAGE__->belongs_to(
  "ontology",
  "IMicrobe::Schema::Result::Ontology",
  { ontology_id => "ontology_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);

=head2 sample

Type: belongs_to

Related object: L<IMicrobe::Schema::Result::Sample>

=cut

__PACKAGE__->belongs_to(
  "sample",
  "IMicrobe::Schema::Result::Sample",
  { sample_id => "sample_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-02-16 13:55:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:bSmjJKDYXCgNDbofAgdhmA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
