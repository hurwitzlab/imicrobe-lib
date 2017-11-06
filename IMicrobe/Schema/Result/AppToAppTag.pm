use utf8;
package IMicrobe::Schema::Result::AppToAppTag;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::AppToAppTag

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<app_to_app_tag>

=cut

__PACKAGE__->table("app_to_app_tag");

=head1 ACCESSORS

=head2 app_to_app_tag_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 app_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 app_tag_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "app_to_app_tag_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "app_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "app_tag_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</app_to_app_tag_id>

=back

=cut

__PACKAGE__->set_primary_key("app_to_app_tag_id");

=head1 RELATIONS

=head2 app

Type: belongs_to

Related object: L<IMicrobe::Schema::Result::App>

=cut

__PACKAGE__->belongs_to(
  "app",
  "IMicrobe::Schema::Result::App",
  { app_id => "app_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 app_tag

Type: belongs_to

Related object: L<IMicrobe::Schema::Result::AppTag>

=cut

__PACKAGE__->belongs_to(
  "app_tag",
  "IMicrobe::Schema::Result::AppTag",
  { app_tag_id => "app_tag_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2017-10-19 15:41:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pXvG+aJ37yR57Newc5qb3g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
