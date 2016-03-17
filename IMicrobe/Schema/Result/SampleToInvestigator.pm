use utf8;
package IMicrobe::Schema::Result::SampleToInvestigator;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::SampleToInvestigator

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<sample_to_investigator>

=cut

__PACKAGE__->table("sample_to_investigator");

=head1 ACCESSORS

=head2 sample_to_investigator_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 sample_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 investigator_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "sample_to_investigator_id",
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
  "investigator_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</sample_to_investigator_id>

=back

=cut

__PACKAGE__->set_primary_key("sample_to_investigator_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<sample_id>

=over 4

=item * L</sample_id>

=item * L</investigator_id>

=back

=cut

__PACKAGE__->add_unique_constraint("sample_id", ["sample_id", "investigator_id"]);

=head1 RELATIONS

=head2 investigator

Type: belongs_to

Related object: L<IMicrobe::Schema::Result::Investigator>

=cut

__PACKAGE__->belongs_to(
  "investigator",
  "IMicrobe::Schema::Result::Investigator",
  { investigator_id => "investigator_id" },
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


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2016-03-17 12:36:42
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:BYLcSxVTWARZZ4FSsmwKDA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
