drop table if exists project;
create table project (
    project_id integer unsigned auto_increment primary key,
    project_code varchar(255),
    project_name varchar(255),
    pi varchar(255),
    institution varchar(255),
    project_type varchar(255),
    description text,
    unique(project_code)
) ENGINE=InnoDB;

drop table if exists sample;
create table sample (
    sample_id integer unsigned auto_increment primary key,
    project_id integer unsigned,
    sample_acc varchar(255),
    sample_type varchar(255),
    sample_volume varchar(255),
    volume_unit varchar(255),
    filter_min varchar(255),
    filter_max varchar(255),
    sample_description varchar(255),
    sample_name varchar(255),
    comments varchar(255),
    taxon_id varchar(255),
    collection_start_time varchar(255),
    collection_stop_time varchar(255),
    biomaterial_name varchar(255),
    description varchar(255),
    material_acc varchar(255),
    site_name varchar(255),
    latitude varchar(255),
    longitude varchar(255),
    altitude varchar(255),
    site_depth varchar(255),
    site_description varchar(255),
    country_name varchar(255),
    region varchar(255),
    habitat_name varchar(255),
    host_taxon_id varchar(255),
    host_description varchar(255),
    host_organism varchar(255),
    library_acc varchar(255),
    sequencing_method varchar(255),
    dna_type varchar(255),
    num_of_reads varchar(255),
    material_id varchar(255),
    other varchar(255),
    unique(project_id, sample_acc),
    foreign key (project_id) references project (project_id)
) ENGINE=InnoDB;

drop table if exists pub;
create table pub (
    pub_id integer unsigned auto_increment primary key,
    pub_code varchar(255),
    journal varchar(255),
    author varchar(255),
    title varchar(255)
) ENGINE=InnoDB;

drop table if exists assembly;
create table assembly (
    assembly_id integer unsigned auto_increment primary key,
    project_id integer unsigned,
    assembly_code varchar(255),
    assembly_name text,
    organism varchar(255),
    foreign key (project_id) references project (project_id)
) ENGINE=InnoDB;

drop table if exists search;
create table search (
    search_id integer unsigned auto_increment primary key,
    table_name varchar(100),
    primary_key int unsigned,
    search_text longtext,
    fulltext(search_text)
);
