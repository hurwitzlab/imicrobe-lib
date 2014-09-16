DROP TABLE IF EXISTS assembly;
CREATE TABLE assembly (
  assembly_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  project_id int(10) unsigned DEFAULT NULL,
  assembly_code varchar(255) DEFAULT NULL,
  assembly_name text,
  organism varchar(255) DEFAULT NULL,
  PRIMARY KEY (assembly_id),
  KEY project_id (project_id),
  CONSTRAINT assembly_ibfk_1 FOREIGN KEY (project_id) REFERENCES project (project_id)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS project;
CREATE TABLE project (
  project_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  project_code varchar(255) DEFAULT NULL,
  project_name varchar(255) DEFAULT NULL,
  pi varchar(255) DEFAULT NULL,
  institution varchar(255) DEFAULT NULL,
  project_type varchar(255) DEFAULT NULL,
  description text,
  PRIMARY KEY (project_id),
  UNIQUE KEY project_code (project_code)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS publication;
CREATE TABLE publication (
  publication_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  pub_code varchar(255) DEFAULT NULL,
  doi text,
  author varchar(255) DEFAULT NULL,
  title varchar(255) DEFAULT NULL,
  pubmed_id int(11) DEFAULT NULL,
  journal text,
  pub_date text,
  PRIMARY KEY (publication_id)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS sample;
CREATE TABLE sample (
  sample_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  project_id int(10) unsigned DEFAULT NULL,
  sample_acc varchar(255) DEFAULT NULL,
  sample_type varchar(255) DEFAULT NULL,
  sample_volume varchar(255) DEFAULT NULL,
  volume_unit varchar(255) DEFAULT NULL,
  filter_min varchar(255) DEFAULT NULL,
  filter_max varchar(255) DEFAULT NULL,
  sample_description varchar(255) DEFAULT NULL,
  sample_name varchar(255) DEFAULT NULL,
  comments varchar(255) DEFAULT NULL,
  taxon_id varchar(255) DEFAULT NULL,
  collection_start_time varchar(255) DEFAULT NULL,
  collection_stop_time varchar(255) DEFAULT NULL,
  biomaterial_name varchar(255) DEFAULT NULL,
  description varchar(255) DEFAULT NULL,
  material_acc varchar(255) DEFAULT NULL,
  site_name varchar(255) DEFAULT NULL,
  latitude varchar(255) DEFAULT NULL,
  longitude varchar(255) DEFAULT NULL,
  altitude varchar(255) DEFAULT NULL,
  site_depth varchar(255) DEFAULT NULL,
  site_description varchar(255) DEFAULT NULL,
  country_name varchar(255) DEFAULT NULL,
  region varchar(255) DEFAULT NULL,
  habitat_name varchar(255) DEFAULT NULL,
  host_taxon_id varchar(255) DEFAULT NULL,
  host_description varchar(255) DEFAULT NULL,
  host_organism varchar(255) DEFAULT NULL,
  library_acc varchar(255) DEFAULT NULL,
  sequencing_method varchar(255) DEFAULT NULL,
  dna_type varchar(255) DEFAULT NULL,
  num_of_reads varchar(255) DEFAULT NULL,
  material_id varchar(255) DEFAULT NULL,
  other varchar(255) DEFAULT NULL,
  PRIMARY KEY (sample_id),
  UNIQUE KEY project_id (project_id,sample_acc),
  CONSTRAINT sample_ibfk_1 FOREIGN KEY (project_id) REFERENCES project (project_id)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS search;
CREATE TABLE search (
  search_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  table_name varchar(100) DEFAULT NULL,
  primary_key int(10) unsigned DEFAULT NULL,
  search_text longtext,
  PRIMARY KEY (search_id),
  FULLTEXT KEY search_text (search_text)
) ENGINE=MyISAM AUTO_INCREMENT=10277 DEFAULT CHARSET=utf8;


