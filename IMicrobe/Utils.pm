package IMicrobe::Utils;

use Data::Dump 'dump';
use Exporter 'import';
use String::Trim 'trim';

our @EXPORT_OK = qw(add_sample_attr link_project_file link_sample_file);

use IMicrobe::DB;

# --------------------------------------------------
sub _db {
    return IMicrobe::DB->new;
}

# --------------------------------------------------
sub _schema {
    return IMicrobe::DB->new->schema;
}

# --------------------------------------------------
sub link_project_file {
    my %args    = @_;
    my $file    = $args{'file'} or die "No file\n";
    my $schema  = _schema();

    my $Project;
    if (my $project_id = $args{'project_id'}) {
        ($Project) = $schema->resultset('Project')->find($project_id)
                    or die "Bad project_id ($project_id)\n";
    }

    unless ($Project) {
        die "No project\n";
    }

    my $FileType;
    if (my $file_type_id = $args{'project_file_type_id'}) {
        ($FileType) = $schema->resultset('Project')->find($file_type_id)
                    or die "Bad file_type_id ($file_type_id)\n";
    }
    elsif (my $file_type = $args{'project_file_type'}) {
        ($FileType) = $schema->resultset('ProjectFileType')->find_or_create({
            type => $file_type
        }) or die "Can't create type ($file_type)\n";
    }

    unless ($FileType) {
        die "No file type\n";
    }

    my $ProjectFile = $schema->resultset('ProjectFile')->find_or_create({
        project_id           => $Project->id,
        project_file_type_id => $FileType->id,
        file                 => $file,
    });

    return $ProjectFile; 
}

# --------------------------------------------------
sub link_sample_file {
    my %args    = @_;
    my $file    = $args{'file'} or die "No file\n";
    my $schema  = _schema();

    my $Sample;
    if (my $sample_id = $args{'sample_id'}) {
        ($Sample) = $schema->resultset('Sample')->find($sample_id)
                    or die "Bad sample_id ($sample_id)\n";
    }

    unless ($Sample) {
        die "No sample\n";
    }

    my $FileType;
    if (my $file_type_id = $args{'sample_file_type_id'}) {
        ($FileType) = $schema->resultset('Sample')->find($file_type_id)
                    or die "Bad file_type_id ($file_type_id)\n";
    }
    elsif (my $file_type = $args{'sample_file_type'}) {
        ($FileType) = $schema->resultset('SampleFileType')->find_or_create({
            type => $file_type
        }) or die "Can't create type ($file_type)\n";
    }

    unless ($FileType) {
        die "No file type\n";
    }

    my $SampleFile = $schema->resultset('SampleFile')->find_or_create({
        sample_id           => $Sample->id,
        sample_file_type_id => $FileType->id,
        file                => $file,
    });

    return $SampleFile; 
}

# --------------------------------------------------
sub add_sample_attr {
    my $rec    = shift;
    my $schema = _schema();
    my $MAX_ATTR_VALUE_LEN = 255;

    my $sample_rs = $schema->resultset('Sample');
    my $Sample;
    if (my $sample_id = $rec->{'sample_id'}) {
        ($Sample) = $sample_rs->find($sample_id);
    }
    elsif (my $sample_name = $rec->{'sample_name'}) {
        my @Samples = $sample_rs->search({
            sample_name => $sample_name
        });

        if (@Samples == 0) {
            warn "Cannot find sample '$sample_name'\n";
            return;
        }
        elsif (@Samples > 1) {
            warn sprintf "Found %s samples for '%s'\n", 
                scalar(@Samples), $sample_name;
            return;
        }

        $Sample = shift @Samples;
    }

    unless ($Sample) {
        warn "No sample ID/name\n";
        return;
    }

    my $attr_type = trim($rec->{'attr_type'})  or die "No attr_type\n";
    my $attr_val  = trim($rec->{'attr_value'}) or die "No attr_value\n";
    my $unit      = trim($rec->{'unit'});

    if (!$Sample) {
        warn "Cannot find sample\n", dump($rec);
        return;
    }

    my ($SampleAttrType) 
        = $schema->resultset('SampleAttrType')->find_or_create({
            type     => $attr_type,
        });

    if (my $attr_cat = trim($rec->{'attr_category'})) {
        $SampleAttrType->category($attr_cat);
        $SampleAttrType->update;
    }

    if (my $desc = trim($rec->{'attr_description'})) {
        $SampleAttrType->description($desc);
        $SampleAttrType->update;
    }

    if (my $url = trim($rec->{'attr_url'})) {
        $SampleAttrType->url($url);
        $SampleAttrType->update;
    }

    my ($SampleAttr) =
        $schema->resultset('SampleAttr')->find_or_create({
            sample_id           => $Sample->id,
            sample_attr_type_id => $SampleAttrType->id,
            attr_value          => substr($attr_val,0, $MAX_ATTR_VALUE_LEN - 1),
            unit                => $unit,
        });

    return $SampleAttr;
}

1;
