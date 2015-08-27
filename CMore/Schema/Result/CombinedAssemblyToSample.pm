use utf8;
package CMore::Schema::Result::CombinedAssemblyToSample;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

CMore::Schema::Result::CombinedAssemblyToSample

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<combined_assembly_to_sample>

=cut

__PACKAGE__->table("combined_assembly_to_sample");

=head1 ACCESSORS

=head2 combined_assembly_to_sample_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 combined_assembly_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 sample_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "combined_assembly_to_sample_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "combined_assembly_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "sample_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</combined_assembly_to_sample_id>

=back

=cut

__PACKAGE__->set_primary_key("combined_assembly_to_sample_id");

=head1 RELATIONS

=head2 combined_assembly

Type: belongs_to

Related object: L<CMore::Schema::Result::CombinedAssembly>

=cut

__PACKAGE__->belongs_to(
  "combined_assembly",
  "CMore::Schema::Result::CombinedAssembly",
  { combined_assembly_id => "combined_assembly_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);

=head2 sample

Type: belongs_to

Related object: L<CMore::Schema::Result::Sample>

=cut

__PACKAGE__->belongs_to(
  "sample",
  "CMore::Schema::Result::Sample",
  { sample_id => "sample_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-08-21 17:14:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RjL4lFLEUX/MocwXabDPXg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
