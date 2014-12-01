use utf8;
package IMicrobe::Schema::Result::Pubchase;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::Pubchase

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<pubchase>

=cut

__PACKAGE__->table("pubchase");

=head1 ACCESSORS

=head2 pubchase_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 article_id

  data_type: 'integer'
  is_nullable: 1

=head2 title

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 journal_title

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 doi

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 authors

  data_type: 'text'
  is_nullable: 1

=head2 article_date

  data_type: 'date'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 created_on

  data_type: 'date'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 url

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "pubchase_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "article_id",
  { data_type => "integer", is_nullable => 1 },
  "title",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "journal_title",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "doi",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "authors",
  { data_type => "text", is_nullable => 1 },
  "article_date",
  { data_type => "date", datetime_undef_if_invalid => 1, is_nullable => 1 },
  "created_on",
  { data_type => "date", datetime_undef_if_invalid => 1, is_nullable => 1 },
  "url",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</pubchase_id>

=back

=cut

__PACKAGE__->set_primary_key("pubchase_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<article_id>

=over 4

=item * L</article_id>

=back

=cut

__PACKAGE__->add_unique_constraint("article_id", ["article_id"]);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-12-01 15:54:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:gMb2yyOoW1LczqKbz5VYCg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
