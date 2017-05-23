package IMicrobe::DB;

use IMicrobe::Config;
use IMicrobe::Schema;
use DBI;
use Moose;
use MongoDB;
use Data::Dump 'dump';

has config     => (
    is         => 'rw',
    isa        => 'IMicrobe::Config',
    lazy_build => 1,
);

has dbd => (
    is         => 'rw',
    isa        => 'Str',
    default    => 'mysql',
    predicate  => 'has_dbd',
);

has dbh => (
    is         => 'rw',
    isa        => 'DBI::db',
    lazy_build => 1,
);

has dsn => (
    is         => 'rw',
    isa        => 'Str',
    lazy_build => 1,
);

has db_options => (
    is         => 'rw',
    isa        => 'HashRef',
    default    => sub { { RaiseError => 1, mysql_enable_utf8 => 1 } },
);

has host => (
    is         => 'rw',
    isa        => 'Str',
    default    => 'localhost',
);

has mongo => (
    is         => 'rw',
    #isa        => 'MongoDB::Client',
    lazy_build => 1,
);

has name => (
    is         => 'rw',
    isa        => 'Str',
    default    => 'imicrobe',
    predicate  => 'has_name',
);

has password   => (
    is         => 'rw',
    isa        => 'Str',
    lazy_build => 1,
);

has schema => (
    is         => 'ro',
    isa        => 'DBIx::Class::Schema',
    lazy_build => 1,
);

has user => (
    is         => 'rw',
    isa        => 'Str',
    default    => 'imicrobe',
    predicate  => 'has_user',
);

# ----------------------------------------------------------------
sub BUILD {
    my $self    = shift;
    my $opts    = shift || {};
    my $config  = $opts->{'config'} || $self->config;
    my $db_conf = $config->get('db');

    if (my $user = $opts->{'user'} || $db_conf->{'user'}) {
        $self->user($user);
    }

    if (my $password = $opts->{'password'} || $db_conf->{'password'}) {
        $self->password($password);
    }

    if (my $name = $opts->{'name'} || $db_conf->{'name'}) {
        $self->name($name);
    }

    if (my $host = $opts->{'host'} || $db_conf->{'host'}) {
        $self->host($host);
    }

    if (!$self->has_dsn) {
        my $host = $self->host || 'localhost';
        my $name = $self->name;

        $self->dsn(
            sprintf( "dbi:%s:%s",
                $self->dbd,
                $host ? "database=$name;host=$host" : $name
            )
        );
    }
}

# ----------------------------------------------------------------
sub _build_config {
    return IMicrobe::Config->new;
}

# ----------------------------------------------------------------
sub _build_dbh {
    my $self = shift;
    my $dbh;

    eval {
        $dbh = DBI->connect_cached(
            $self->dsn, 
            $self->user, 
            $self->password, 
            $self->db_options
        );
    };

    if ( my $err = $@ ) {
        die "Error: $err";
    }
    else {
        return $dbh;
    }
}

# ----------------------------------------------------------------
sub _build_mongo {
    my $self       = shift;
    my $config     = $self->config;
    my $mongo_conf = $config->get('mongo');
    my $mongo      = MongoDB::MongoClient->new(
        host => $mongo_conf->{'host'} || 'localhost', 
        port => $mongo_conf->{'port'} || 27017
    );

    return $mongo;
}

# ----------------------------------------------------------------
sub _build_schema {
    my $self = shift;

    return IMicrobe::Schema->connect( sub { $self->dbh } );
}

1;
