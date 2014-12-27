use utf8;
package IMicrobe::Schema::Result::QueryLog;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::QueryLog

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<query_log>

=cut

__PACKAGE__->table("query_log");

=head1 ACCESSORS

=head2 query_log_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 num_found

  data_type: 'integer'
  is_nullable: 1

=head2 query

  data_type: 'text'
  is_nullable: 1

=head2 params

  data_type: 'text'
  is_nullable: 1

=head2 ip

  data_type: 'text'
  is_nullable: 1

=head2 user_id

  data_type: 'text'
  is_nullable: 1

=head2 time

  data_type: 'double precision'
  is_nullable: 1

=head2 date

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "query_log_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "num_found",
  { data_type => "integer", is_nullable => 1 },
  "query",
  { data_type => "text", is_nullable => 1 },
  "params",
  { data_type => "text", is_nullable => 1 },
  "ip",
  { data_type => "text", is_nullable => 1 },
  "user_id",
  { data_type => "text", is_nullable => 1 },
  "time",
  { data_type => "double precision", is_nullable => 1 },
  "date",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</query_log_id>

=back

=cut

__PACKAGE__->set_primary_key("query_log_id");


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-12-26 16:37:16
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:J7rRx6knpWUpK/g09pJT9g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
