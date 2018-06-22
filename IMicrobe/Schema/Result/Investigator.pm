use utf8;
package IMicrobe::Schema::Result::Investigator;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::Investigator

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<investigator>

=cut

__PACKAGE__->table("investigator");

=head1 ACCESSORS

=head2 investigator_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 investigator_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 institution

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 url

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 orcid

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 50

=cut

__PACKAGE__->add_columns(
  "investigator_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "investigator_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "institution",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "url",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "orcid",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 50 },
);

=head1 PRIMARY KEY

=over 4

=item * L</investigator_id>

=back

=cut

__PACKAGE__->set_primary_key("investigator_id");

=head1 RELATIONS

=head2 project_to_investigators

Type: has_many

Related object: L<IMicrobe::Schema::Result::ProjectToInvestigator>

=cut

__PACKAGE__->has_many(
  "project_to_investigators",
  "IMicrobe::Schema::Result::ProjectToInvestigator",
  { "foreign.investigator_id" => "self.investigator_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 sample_to_investigators

Type: has_many

Related object: L<IMicrobe::Schema::Result::SampleToInvestigator>

=cut

__PACKAGE__->has_many(
  "sample_to_investigators",
  "IMicrobe::Schema::Result::SampleToInvestigator",
  { "foreign.investigator_id" => "self.investigator_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2018-06-18 15:43:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NR48iHUkl8VXSOuohx6wQg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
