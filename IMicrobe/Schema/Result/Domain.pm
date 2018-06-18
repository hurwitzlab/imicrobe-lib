use utf8;
package IMicrobe::Schema::Result::Domain;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::Domain

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<domain>

=cut

__PACKAGE__->table("domain");

=head1 ACCESSORS

=head2 domain_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 domain_name

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=cut

__PACKAGE__->add_columns(
  "domain_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "domain_name",
  { data_type => "varchar", is_nullable => 1, size => 50 },
);

=head1 PRIMARY KEY

=over 4

=item * L</domain_id>

=back

=cut

__PACKAGE__->set_primary_key("domain_id");

=head1 RELATIONS

=head2 project_to_domains

Type: has_many

Related object: L<IMicrobe::Schema::Result::ProjectToDomain>

=cut

__PACKAGE__->has_many(
  "project_to_domains",
  "IMicrobe::Schema::Result::ProjectToDomain",
  { "foreign.domain_id" => "self.domain_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 sample_to_domains

Type: has_many

Related object: L<IMicrobe::Schema::Result::SampleToDomain>

=cut

__PACKAGE__->has_many(
  "sample_to_domains",
  "IMicrobe::Schema::Result::SampleToDomain",
  { "foreign.domain_id" => "self.domain_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2018-02-13 10:10:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:EQK2OUBUeZ1vXeYRUkcL9w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
