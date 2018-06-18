use utf8;
package IMicrobe::Schema::Result::PfamAnnotation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::PfamAnnotation

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<pfam_annotation>

=cut

__PACKAGE__->table("pfam_annotation");

=head1 ACCESSORS

=head2 uproc_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 accession

  data_type: 'varchar'
  is_nullable: 1
  size: 16

=head2 identifier

  data_type: 'varchar'
  is_nullable: 1
  size: 16

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 80

=head2 description

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "uproc_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "accession",
  { data_type => "varchar", is_nullable => 1, size => 16 },
  "identifier",
  { data_type => "varchar", is_nullable => 1, size => 16 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 80 },
  "description",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</uproc_id>

=back

=cut

__PACKAGE__->set_primary_key("uproc_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<accession>

=over 4

=item * L</accession>

=back

=cut

__PACKAGE__->add_unique_constraint("accession", ["accession"]);

=head1 RELATIONS

=head2 uproc_pfam_results

Type: has_many

Related object: L<IMicrobe::Schema::Result::UprocPfamResult>

=cut

__PACKAGE__->has_many(
  "uproc_pfam_results",
  "IMicrobe::Schema::Result::UprocPfamResult",
  { "foreign.uproc_id" => "self.uproc_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2018-02-13 10:10:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:U72p8m4QzrmRXPEW9aFARA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
