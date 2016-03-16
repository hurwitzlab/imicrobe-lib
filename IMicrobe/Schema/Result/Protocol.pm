use utf8;
package IMicrobe::Schema::Result::Protocol;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::Protocol

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<protocol>

=cut

__PACKAGE__->table("protocol");

=head1 ACCESSORS

=head2 protocol_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 protocol_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 url

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "protocol_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "protocol_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "url",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</protocol_id>

=back

=cut

__PACKAGE__->set_primary_key("protocol_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<protocol_name>

=over 4

=item * L</protocol_name>

=back

=cut

__PACKAGE__->add_unique_constraint("protocol_name", ["protocol_name"]);

=head1 RELATIONS

=head2 project_to_protocols

Type: has_many

Related object: L<IMicrobe::Schema::Result::ProjectToProtocol>

=cut

__PACKAGE__->has_many(
  "project_to_protocols",
  "IMicrobe::Schema::Result::ProjectToProtocol",
  { "foreign.protocol_id" => "self.protocol_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2016-02-08 10:53:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:M88EnzOtJBtmpa+QvpH9cA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
