use utf8;
package IMicrobe::Schema::Result::SampleFileType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::SampleFileType

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<sample_file_type>

=cut

__PACKAGE__->table("sample_file_type");

=head1 ACCESSORS

=head2 sample_file_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 type

  data_type: 'varchar'
  is_nullable: 0
  size: 25

=cut

__PACKAGE__->add_columns(
  "sample_file_type_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "type",
  { data_type => "varchar", is_nullable => 0, size => 25 },
);

=head1 PRIMARY KEY

=over 4

=item * L</sample_file_type_id>

=back

=cut

__PACKAGE__->set_primary_key("sample_file_type_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<type>

=over 4

=item * L</type>

=back

=cut

__PACKAGE__->add_unique_constraint("type", ["type"]);

=head1 RELATIONS

=head2 sample_files

Type: has_many

Related object: L<IMicrobe::Schema::Result::SampleFile>

=cut

__PACKAGE__->has_many(
  "sample_files",
  "IMicrobe::Schema::Result::SampleFile",
  { "foreign.sample_file_type_id" => "self.sample_file_type_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-03-04 13:32:16
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YjsJaJRq2jVk4fbPzyn7aQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
