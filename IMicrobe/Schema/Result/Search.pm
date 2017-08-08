use utf8;
package IMicrobe::Schema::Result::Search;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::Search

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<search>

=cut

__PACKAGE__->table("search");

=head1 ACCESSORS

=head2 search_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 table_name

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 primary_key

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 object_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 search_text

  data_type: 'longtext'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "search_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "table_name",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "primary_key",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "object_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "search_text",
  { data_type => "longtext", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</search_id>

=back

=cut

__PACKAGE__->set_primary_key("search_id");


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2017-08-08 09:40:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:aWwCwlXlKzRspqwB6f1A2w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
