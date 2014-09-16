package IMicrobe::DB;

use IMicrobe::Config;
use DBI;
use Moose;

has dbh => (
    is         => 'rw',
    isa        => 'DBI::db',
    lazy_build => 1,
);

# ----------------------------------------------------------------
sub _build_dbh {
    my $self        = shift;
    my $config      = IMicrobe::Config->new;
    my $db_info     = $config->get('db');
    my $db_name     = $db_info->{'name'}     || 'imicrobe';
    my $driver      = $db_info->{'driver'}   || 'mysql';
    my $user        = $db_info->{'user'}     || 'imicrobe';
    my $host        = $db_info->{'host'}     || 'localhost';
    my $password    = $db_info->{'password'} || '';
    my $dsn         = sprintf("dbi:%s:db=%s;host=%s", $driver, $db_name, $host);

    my $dbh;
    eval {
        $dbh = DBI->connect($dsn, $user, $password, { RaiseError => 1 });
    };

    if ( my $err = $@ ) {
        die "Error: $err";
    }
    else {
        return $dbh;
    }
}

1;
