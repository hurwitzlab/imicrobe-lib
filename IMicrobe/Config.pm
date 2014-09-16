package IMicrobe::Config;

use namespace::autoclean;
use Carp qw( croak );
use File::Basename qw( dirname );
use File::Spec::Functions;
use Moose::Util::TypeConstraints;
use Moose;
use YAML qw( LoadFile );

subtype 'ExistingFile'
    => as 'Str' 
    => where   { -f $_ && -r _ && -s _ }
    => message { 'File must exist and be non-empty' } 
;

has default_filename => (
    is      => 'ro',
    default => '/usr/local/imicrobe/lib/conf/imicrobe.yaml',
);

has config     => (
    is         => 'ro',
    isa        => 'HashRef',
    lazy_build => 1,
);

has filename   => (
    is         => 'rw',
    isa        => 'ExistingFile',
    lazy_build => 1,
    trigger    => sub { 
        my $self = shift;
        $self->clear_config(@_);
    },
);

#
# Allow for calling "->new( $filename )" 
#
around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;

    if ( @_ == 1 && !ref $_[0] ) {
        return $class->$orig( filename => $_[0] );
    }
    else {
        return $class->$orig(@_);
    }
};

# ----------------------------------------------------------------
sub _build_filename {
    my $self = shift;

    $self->clear_config;

    return $_[0] || $ENV{'IMICROBE_CONF'} || $self->default_filename;
}

# ----------------------------------------------------------------
sub _build_config {
    my $self = shift;
    my $file = $self->filename   or croak('No filename');
    my $conf = LoadFile( $file ) or croak("Error reading config file: '$file'");

    if ( my $also_load = $conf->{'also_load'} ) {
        my $cur_dir = dirname( $file );

        chomp $also_load;

        for my $also ( split( /\s*,\s*/, $also_load ) ) {
            if ( $also !~ m{^/} ) {
                $also = catfile( $cur_dir, $also );
            }

            if ( -e $also ) {
                my $other = LoadFile( $also );
                for my $key ( keys %$other ) {
                    $conf->{ $key } = $other->{ $key };
                }
            }
            else {
                warn "Can't load other config file: $also\n";
            }
        }
    }

    #
    # Add in Ensembl as modules, set their db info
    #
    my $ens_conf    = $conf->{'ensembl'}           || {};
    my $reg_file    = $ens_conf->{'registry_file'} || '';
    my $install_dir = $ens_conf->{'install_dir'}   || '';
    my $aliases     = $ens_conf->{'alias'}         || {};

    if ( $reg_file && $install_dir && -e $reg_file && -d $install_dir ) {
        my %inc = map { $_, 1 } @INC;
        for my $dir ( qw{
            conf
            ensembl-compara/modules
            ensembl-draw/modules
            ensembl-external/modules
            ensembl-variation/modules
            ensembl/modules
            modules
        } ) {
            my $path = catdir( $install_dir, $dir );

            if ( !$inc{ $path } ) {
                push @INC, $path;
            }
        }

        my $reg_class = 'Bio::EnsEMBL::Registry';

        if ( load_class( $reg_class ) ) {
            $reg_class->load_all( $reg_file );

            DB:
            for my $db ( @{ $reg_class->get_all_DBAdaptors() } ) {
                my $dbc = $db->dbc;

                next DB if $dbc->host =~ /^ensembl/i;

                my $db_name = $dbc->dbname;
                my $species = '';

                if ( 
                    $db_name =~ /^([\w_]+)(?:_fpc)?_(core|variation|funcgen)_/ 
                ) {
                    my $group = $2 eq 'core' ? 'ensembl' : $2;
                    $species = join '_', $group, $1;
                }
                else {
                    next DB;
                }

                $conf->{'database'}{ $species } = {
                    name     => $dbc->dbname,
                    user     => $dbc->username,
                    password => $dbc->password,
                    host     => $dbc->host,
                };

                push @{ $conf->{'modules'} }, $species;
            }
        }
        else {
            warn "Cannot load $reg_class\n";
        }

        @{ $conf->{'modules'} } = sort @{ $conf->{'modules'} };
    }
    
    return $conf;
}

# ----------------------------------------------------------------
sub get {
    my $self   = shift;
    my $config = $self->config;
    
    if ( my $section_name = shift ) {
        if ( defined $config->{ $section_name } ) {
            if ( my $value = $config->{ $section_name } ) {
                # If we want an array AND our value is an array or a hash, 
                # dereference it and hand it back
                if ( wantarray && ref $value eq 'ARRAY' ) {
                    return @$value;
                } 
                elsif ( wantarray && ref $value eq 'HASH' ) {
                    return %$value;
                }
                # otherwise (don't want an array, or don't know what it is), 
                # just return as is
                else {
                    return $value;
                }
            }
            else {
                return wantarray ? () : '';
            }
        }
        else {
            croak(sprintf("No config section named '%s' in '%s'",
                $section_name, $self->filename
            ));
        }
    }
    else {
        return $config;
    }
}

__PACKAGE__->meta->make_immutable;

1;

__END__

# ----------------------------------------------------------------

=pod

=head1 NAME

IMicrobe::Config - Read local configuration information

=head1 SYNOPSIS

  use IMicrobe::Conf;

  my $config  = IMicrobe::Conf->new;
  my $db_info = $config->get('db');

=head1 DESCRIPTION

Certain configuration items are specific to the machine they are 
deployed on, and should, therefore, be available locally to the apps 
that need them without any code changing.  With this module, only the
one location of the configuration file needs to be changed, and then
all the calling modules can read the correct info.  

This module relies on Config::General, so perldoc that module for more
information on how the configuration options can be set.  It is hoped
that module-specific information (e.g., for QTL, mutants, etc.) will
be wrapped in specific tags (e.g., "<qtl>...</qtl>") to logically
group like elements.

=head1 METHODS

=head2 new

Constructor for object.  Takes an optional "filename" argument of the 
path to the configuration file.

  my $config = Gramene::Conf->new( filename => '/path/to/config.conf' );

Or:

  my $config = Gramene::Conf->new('/path/to/config.conf');

=head2 filename

Gets or sets the complete path to the configuration file.  If a file is
already opened, then the handle on it will be closed and a new one
opened on the new file.

  $config->filename('/path/to/config.conf');

=head2 get

Returns one or all options from the config file.

  my $foo = $config->get('foo');
  
=head2 config

Returns the full config hashref.

  my $conf_hashref = $config->config;

=head1 AUTHOR

Ken Youens-Clark E<lt>kclark@cshl.orgE<gt>.

=head1 COPYRIGHT

Copyright (c) 2012 Cold Spring Harbor Laboratory

This library is free software;  you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
