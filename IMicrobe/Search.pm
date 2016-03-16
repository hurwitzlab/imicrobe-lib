package IMicrobe::Search;

use Exporter qw(import);

our @EXPORT_OK = qw(search);

use IMicrobe::DB;

sub search {
    my %args  = ref $_[0] eq 'HASH' ? %{ $_ } : @_;
    my $query = $args{'query'} or return;
    my $dbh   = IMicrobe::DB->new->dbh;

    my (@results, %types);
    my $sql = sprintf(
        q[
            select *
            from   search
            where  match (search_text) against (%s in boolean mode)
        ],
        $dbh->quote($query)
    );

    if (my $type = $args{'type'}) {
        $sql .= sprintf(" and table_name=%s", $dbh->quote($type));
    }

    my $data = $dbh->selectall_arrayref($sql, { Columns => {} });

    for my $r (@$data) {
        $types{ $r->{'table_name'} }++;

        my $sql = sprintf('select * from %s where %s=?',
            $r->{'table_name'}, $r->{'table_name'} . '_id'
        );

        my $sth = $dbh->prepare($sql);
        $sth->execute($r->{'primary_key'});
        $r->{'object'} = $sth->fetchrow_hashref();
        $r->{'url'}    = join '/',
            '', $r->{'table_name'}, 'view', $r->{'primary_key'};

        push @results, $r;
    }

    return {
        results   => \@results,
        types     => \%types,
        num_found => scalar(@results),
    };
}

1;
