use utf8;
package IMicrobe::Schema::Result::SampleUproc;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::SampleUproc

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<sample_uproc>

=cut

__PACKAGE__->table("sample_uproc");

=head1 ACCESSORS

=head2 sample_uproc_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 sample_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 uproc_id

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 count

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "sample_uproc_id",
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
  "uproc_id",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "count",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</sample_uproc_id>

=back

=cut

__PACKAGE__->set_primary_key("sample_uproc_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<sample_id_2>

=over 4

=item * L</sample_id>

=item * L</uproc_id>

=back

=cut

__PACKAGE__->add_unique_constraint("sample_id_2", ["sample_id", "uproc_id"]);

=head1 RELATIONS

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


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2017-10-19 15:41:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:DhsaW3ch/eH1Mne4ZZOq8w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
