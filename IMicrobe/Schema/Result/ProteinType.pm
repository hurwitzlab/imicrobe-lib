use utf8;
package IMicrobe::Schema::Result::ProteinType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::ProteinType

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<protein_type>

=cut

__PACKAGE__->table("protein_type");

=head1 ACCESSORS

=head2 protein_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 type

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=cut

__PACKAGE__->add_columns(
  "protein_type_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "type",
  { data_type => "varchar", is_nullable => 1, size => 100 },
);

=head1 PRIMARY KEY

=over 4

=item * L</protein_type_id>

=back

=cut

__PACKAGE__->set_primary_key("protein_type_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<type>

=over 4

=item * L</type>

=back

=cut

__PACKAGE__->add_unique_constraint("type", ["type"]);

=head1 RELATIONS

=head2 proteins

Type: has_many

Related object: L<IMicrobe::Schema::Result::Protein>

=cut

__PACKAGE__->has_many(
  "proteins",
  "IMicrobe::Schema::Result::Protein",
  { "foreign.protein_type_id" => "self.protein_type_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2018-02-13 10:10:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RHKZgAh1I/SLP9+g9L2+fw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
