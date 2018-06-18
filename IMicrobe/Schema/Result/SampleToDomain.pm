use utf8;
package IMicrobe::Schema::Result::SampleToDomain;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::SampleToDomain

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<sample_to_domain>

=cut

__PACKAGE__->table("sample_to_domain");

=head1 ACCESSORS

=head2 sample_to_domain_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 sample_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 domain_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "sample_to_domain_id",
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
  "domain_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</sample_to_domain_id>

=back

=cut

__PACKAGE__->set_primary_key("sample_to_domain_id");

=head1 RELATIONS

=head2 domain

Type: belongs_to

Related object: L<IMicrobe::Schema::Result::Domain>

=cut

__PACKAGE__->belongs_to(
  "domain",
  "IMicrobe::Schema::Result::Domain",
  { domain_id => "domain_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
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


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2018-02-13 10:10:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:S1UbYlrZgXwFoM+q+eHMEw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
