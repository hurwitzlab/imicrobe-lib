-- MySQL dump 10.13  Distrib 5.6.24, for Linux (x86_64)
--
-- Host: localhost    Database: imicrobe
-- ------------------------------------------------------
-- Server version	5.6.24

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `assembly`
--

DROP TABLE IF EXISTS `assembly`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assembly` (
  `assembly_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `project_id` int(10) unsigned DEFAULT NULL,
  `assembly_code` varchar(255) DEFAULT NULL,
  `assembly_name` text,
  `organism` varchar(255) DEFAULT NULL,
  `pep_file` varchar(255) DEFAULT NULL,
  `nt_file` varchar(255) DEFAULT NULL,
  `cds_file` varchar(255) DEFAULT NULL,
  `description` text,
  `sample_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`assembly_id`),
  KEY `project_id` (`project_id`),
  KEY `sample_id` (`sample_id`),
  CONSTRAINT `assembly_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `project` (`project_id`) ON DELETE CASCADE,
  CONSTRAINT `assembly_ibfk_2` FOREIGN KEY (`sample_id`) REFERENCES `sample` (`sample_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1069 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `combined_assembly`
--

DROP TABLE IF EXISTS `combined_assembly`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `combined_assembly` (
  `combined_assembly_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `project_id` int(10) unsigned NOT NULL,
  `assembly_name` varchar(255) DEFAULT NULL,
  `phylum` varchar(255) DEFAULT NULL,
  `class` varchar(255) DEFAULT NULL,
  `family` varchar(255) DEFAULT NULL,
  `genus` varchar(255) DEFAULT NULL,
  `species` varchar(255) DEFAULT NULL,
  `strain` varchar(255) DEFAULT NULL,
  `pcr_amp` varchar(255) DEFAULT NULL,
  `annotations_file` varchar(255) DEFAULT NULL,
  `peptides_file` varchar(255) DEFAULT NULL,
  `nucleotides_file` varchar(255) DEFAULT NULL,
  `cds_file` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`combined_assembly_id`),
  UNIQUE KEY `assembly_name` (`assembly_name`),
  KEY `project_id` (`project_id`),
  CONSTRAINT `combined_assembly_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `project` (`project_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=124 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `combined_assembly_to_sample`
--

DROP TABLE IF EXISTS `combined_assembly_to_sample`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `combined_assembly_to_sample` (
  `combined_assembly_to_sample_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `combined_assembly_id` int(10) unsigned NOT NULL,
  `sample_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`combined_assembly_to_sample_id`),
  KEY `combined_assembly_id` (`combined_assembly_id`),
  KEY `sample_id` (`sample_id`),
  CONSTRAINT `combined_assembly_to_sample_ibfk_3` FOREIGN KEY (`combined_assembly_id`) REFERENCES `combined_assembly` (`combined_assembly_id`) ON DELETE CASCADE,
  CONSTRAINT `combined_assembly_to_sample_ibfk_4` FOREIGN KEY (`sample_id`) REFERENCES `sample` (`sample_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=377 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `domain`
--

DROP TABLE IF EXISTS `domain`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `domain` (
  `domain_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `domain_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`domain_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ftp`
--

DROP TABLE IF EXISTS `ftp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ftp` (
  `ftp_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `project_id` int(10) unsigned DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `path` varchar(255) DEFAULT NULL,
  `size` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`ftp_id`),
  KEY `project_id` (`project_id`),
  CONSTRAINT `ftp_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `project` (`project_id`)
) ENGINE=InnoDB AUTO_INCREMENT=26825 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `metadata_type`
--

DROP TABLE IF EXISTS `metadata_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `metadata_type` (
  `metadata_type_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category` varchar(64) NOT NULL DEFAULT '',
  `category_type` varchar(32) DEFAULT NULL,
  `qiime_tag` varchar(128) DEFAULT NULL,
  `mgrast_tag` varchar(128) DEFAULT NULL,
  `tag` varchar(128) NOT NULL DEFAULT '',
  `definition` text,
  `required` tinyint(4) NOT NULL DEFAULT '0',
  `mixs` tinyint(4) NOT NULL DEFAULT '0',
  `type` text,
  `fw_type` text,
  `unit` text,
  PRIMARY KEY (`metadata_type_id`),
  UNIQUE KEY `category` (`category`,`tag`)
) ENGINE=InnoDB AUTO_INCREMENT=434 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ontology`
--

DROP TABLE IF EXISTS `ontology`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ontology` (
  `ontology_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ontology_acc` varchar(125) NOT NULL,
  `label` varchar(125) NOT NULL,
  PRIMARY KEY (`ontology_id`),
  KEY `ontology_acc` (`ontology_acc`)
) ENGINE=InnoDB AUTO_INCREMENT=150 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `project`
--

DROP TABLE IF EXISTS `project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project` (
  `project_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `project_code` varchar(255) DEFAULT NULL,
  `project_name` varchar(255) DEFAULT NULL,
  `pi` varchar(255) DEFAULT NULL,
  `institution` varchar(255) DEFAULT NULL,
  `project_type` varchar(255) DEFAULT NULL,
  `description` text,
  `read_file` varchar(100) DEFAULT NULL,
  `meta_file` varchar(100) DEFAULT NULL,
  `assembly_file` varchar(100) DEFAULT NULL,
  `peptide_file` varchar(100) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `read_pep_file` varchar(100) DEFAULT NULL,
  `nt_file` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`project_id`),
  UNIQUE KEY `project_code` (`project_code`)
) ENGINE=InnoDB AUTO_INCREMENT=130 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `project_page`
--

DROP TABLE IF EXISTS `project_page`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_page` (
  `project_page_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `project_id` int(10) unsigned NOT NULL,
  `title` varchar(255) NOT NULL,
  `contents` text,
  `display_order` int(11) DEFAULT NULL,
  `format` enum('html','markdown') DEFAULT 'html',
  PRIMARY KEY (`project_page_id`),
  UNIQUE KEY `project_id` (`project_id`,`title`),
  KEY `project_id_2` (`project_id`),
  CONSTRAINT `project_page_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `project` (`project_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `project_to_domain`
--

DROP TABLE IF EXISTS `project_to_domain`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_to_domain` (
  `project_to_domain_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `project_id` int(10) unsigned NOT NULL,
  `domain_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`project_to_domain_id`),
  KEY `project_id` (`project_id`),
  KEY `domain_id` (`domain_id`),
  CONSTRAINT `project_to_domain_ibfk_2` FOREIGN KEY (`domain_id`) REFERENCES `domain` (`domain_id`),
  CONSTRAINT `project_to_domain_ibfk_3` FOREIGN KEY (`project_id`) REFERENCES `project` (`project_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=152 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pubchase`
--

DROP TABLE IF EXISTS `pubchase`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pubchase` (
  `pubchase_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `article_id` int(11) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `journal_title` varchar(255) DEFAULT NULL,
  `doi` varchar(255) DEFAULT NULL,
  `authors` text,
  `article_date` date DEFAULT NULL,
  `created_on` date DEFAULT NULL,
  `url` text,
  PRIMARY KEY (`pubchase_id`),
  UNIQUE KEY `article_id` (`article_id`)
) ENGINE=InnoDB AUTO_INCREMENT=429 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pubchase_rec`
--

DROP TABLE IF EXISTS `pubchase_rec`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pubchase_rec` (
  `pubchase_rec_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rec_date` datetime DEFAULT NULL,
  `checksum` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`pubchase_rec_id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `publication`
--

DROP TABLE IF EXISTS `publication`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `publication` (
  `publication_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `project_id` int(10) unsigned DEFAULT NULL,
  `pub_code` varchar(255) DEFAULT NULL,
  `doi` text,
  `author` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `pubmed_id` int(11) DEFAULT NULL,
  `journal` text,
  `pub_date` text,
  PRIMARY KEY (`publication_id`),
  KEY `project_id` (`project_id`),
  CONSTRAINT `publication_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `project` (`project_id`)
) ENGINE=InnoDB AUTO_INCREMENT=134 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `query_log`
--

DROP TABLE IF EXISTS `query_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `query_log` (
  `query_log_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `num_found` int(11) DEFAULT NULL,
  `query` text,
  `params` text,
  `ip` text,
  `user_id` text,
  `time` double DEFAULT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`query_log_id`)
) ENGINE=MyISAM AUTO_INCREMENT=5134 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reference`
--

DROP TABLE IF EXISTS `reference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reference` (
  `reference_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `file` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `revision` text,
  `length` bigint(20) unsigned DEFAULT NULL,
  `seq_count` int(10) unsigned DEFAULT NULL,
  `build_date` text,
  `description` text,
  PRIMARY KEY (`reference_id`),
  UNIQUE KEY `file` (`file`,`name`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample`
--

DROP TABLE IF EXISTS `sample`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sample` (
  `sample_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `project_id` int(10) unsigned DEFAULT NULL,
  `sample_acc` varchar(255) DEFAULT NULL,
  `sample_type` varchar(255) DEFAULT NULL,
  `sample_volume` varchar(255) DEFAULT NULL,
  `volume_unit` varchar(255) DEFAULT NULL,
  `filter_min` varchar(255) DEFAULT NULL,
  `filter_max` varchar(255) DEFAULT NULL,
  `sample_description` varchar(255) DEFAULT NULL,
  `sample_name` varchar(255) DEFAULT NULL,
  `comments` varchar(255) DEFAULT NULL,
  `taxon_id` varchar(255) DEFAULT NULL,
  `collection_start_time` varchar(255) DEFAULT NULL,
  `collection_stop_time` varchar(255) DEFAULT NULL,
  `biomaterial_name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `material_acc` varchar(255) DEFAULT NULL,
  `site_name` varchar(255) DEFAULT NULL,
  `latitude` varchar(255) DEFAULT NULL,
  `longitude` varchar(255) DEFAULT NULL,
  `altitude` varchar(255) DEFAULT NULL,
  `site_depth` varchar(255) DEFAULT NULL,
  `site_description` varchar(255) DEFAULT NULL,
  `country_name` varchar(255) DEFAULT NULL,
  `region` varchar(255) DEFAULT NULL,
  `host_taxon_id` varchar(255) DEFAULT NULL,
  `host_description` varchar(255) DEFAULT NULL,
  `host_organism` varchar(255) DEFAULT NULL,
  `library_acc` varchar(255) DEFAULT NULL,
  `sequencing_method` varchar(255) DEFAULT NULL,
  `dna_type` varchar(255) DEFAULT NULL,
  `num_of_reads` varchar(255) DEFAULT NULL,
  `material_id` varchar(255) DEFAULT NULL,
  `other` varchar(255) DEFAULT NULL,
  `rrna_18s` text,
  `additional_citations` text,
  `ammonium` text,
  `assembly_accession_number` text,
  `axenic` text,
  `chlorophyll` text,
  `clonal` text,
  `co2` text,
  `collection_date` text,
  `collection_time` text,
  `combined_assembly_name` text,
  `country` text,
  `date_of_experiment` text,
  `day_portion_of_day_night_cycle_in_hours` text,
  `depth` text,
  `dissolved_oxygen` text,
  `doc` text,
  `elevation` text,
  `envo_term_for_habitat_primary_term` text,
  `envo_term_for_habitat_secondary_term` text,
  `external_sample_id` text,
  `filter_fraction_maximum` text,
  `filter_fraction_minimum` text,
  `genus` text,
  `growth_medium` text,
  `habitat` text,
  `habitat_description` text,
  `importance` text,
  `investigation_type` text,
  `light` text,
  `list_of_amino_acids_and_concentrations_with_units` text,
  `modifications_to_growth_medium` text,
  `night_portion_of_day_night_cycle_in_hours` text,
  `nitrate` text,
  `other_collection_site_info` text,
  `other_environmental_metadata_available` text,
  `other_experimental_metadata_available` text,
  `ph` text,
  `phosphate` text,
  `poc` text,
  `prelim_ncbi_taxon_id` text,
  `pressure` text,
  `prey_organism_if_applicable` text,
  `primary_citation` text,
  `principle_investigator` text,
  `sample_collection_site` text,
  `sample_material` text,
  `silicate` text,
  `species` text,
  `strain` text,
  `total_fe` text,
  `trace_elements` text,
  `urea` text,
  `volume_filtered` text,
  `reads_file` varchar(200) DEFAULT NULL,
  `annotations_file` varchar(200) DEFAULT NULL,
  `peptides_file` varchar(200) DEFAULT NULL,
  `contigs_file` varchar(200) DEFAULT NULL,
  `cds_file` varchar(200) DEFAULT NULL,
  `pi` text,
  `environmental_salinity` text,
  `environmental_temperature` text,
  `experimental_salinity` text,
  `experimental_temperature` text,
  `class` text,
  `family` text,
  `mmetsp_id` text,
  `phylum` text,
  `pcr_amp` text,
  `rrna_16s` text,
  `torder` text,
  `superkingdom` text,
  `abundance_bacterial_cells_ml` text,
  `abundance_bacterial_cells_ml_h` text,
  `abundance_synechococcus_cells_ml` text,
  `alkalinityalk_mm` text,
  `altitude_m` text,
  `aluminiumal_um` text,
  `ammonianh4_um` text,
  `ammonium_umol_kg` text,
  `antimonysb_um` text,
  `arsenicas_um` text,
  `atmospheric_general_weather` text,
  `atmospheric_pressure_atm` text,
  `atmospheric_wind_speed_m_s` text,
  `bacterial_production_cells_ml_h` text,
  `bariumba_um` text,
  `biofilm_g` text,
  `biomass_concentration_ug_kg` text,
  `biomass_mass_g` text,
  `boronb_um` text,
  `caesiumcs_um` text,
  `calciumca_um` text,
  `carbon_dioxideco2_um` text,
  `carbon_dioxideco2_umol_kg` text,
  `cdom_rfu` text,
  `cfu_cjejuni_cfu` text,
  `charge__mmol` text,
  `charge_mmol` text,
  `chla_mg_1000l` text,
  `chlorinitycl_mm` text,
  `chlorinitycl_um` text,
  `chlorophyll_density_annual_ug_kg` text,
  `chlorophyll_density_annual_ug_l` text,
  `chlorophyll_density_psu` text,
  `chlorophyll_density_sample_month_ug_kg` text,
  `chlorophyll_density_ug_kg` text,
  `chloropigment` text,
  `comment` text,
  `current_land_use` text,
  `dissolved_inorg_cdic_mm` text,
  `dissolved_inorg_cdic_um` text,
  `dissolved_inorganic_carbon_umol_kg` text,
  `dissolved_inorganic_nitrogen_umol_l` text,
  `dissolved_inorganic_phosphate_nmol_kg` text,
  `dissolved_organic_carbon_um` text,
  `dissolved_organic_carbon_umol_kg` text,
  `dissolved_organic_nitrogen_umol_kg` text,
  `dissolved_oxygen_nmol_kg` text,
  `dissolved_oxygen_umol_kg` text,
  `filter_type` text,
  `filter_type_m` text,
  `fluorescence_ug_l` text,
  `fluorinef_um` text,
  `gene_name` text,
  `glucose_mg` text,
  `h2_um` text,
  `habitat_name` text,
  `health_status` text,
  `host_name` text,
  `host_species` text,
  `host_tissue` text,
  `ironfe_um` text,
  `isolation` text,
  `leg` text,
  `leucine_umol_kg` text,
  `light_intensity_umol_m2_s` text,
  `lithiumli_um` text,
  `magnesiummg_um` text,
  `manganesemn_um` text,
  `mean_annual_precipitation_cm` text,
  `methane_um` text,
  `method_of_isolation` text,
  `molybdenummo_um` text,
  `nitratenitrite_nmol_kg` text,
  `nitrateno3_um` text,
  `nitrateno3_umol_l` text,
  `nitrite_umol_l` text,
  `number_of_samples_pooled` text,
  `number_of_stations_sampled` text,
  `nutrients_dmsp_nm` text,
  `nutrients_nh4_microm` text,
  `nutrients_nox_microm` text,
  `nutrients_po3_microm` text,
  `nutrients_po4_microm` text,
  `nutrients_potassium_phosphate_um` text,
  `nutrients_putrescine_c4h12n2_nm` text,
  `nutrients_so4_microm` text,
  `nutrients_sodium_nitrate_um` text,
  `nutrients_spermidine_c7h19n3_nm` text,
  `other_habitat` text,
  `oxygen` text,
  `oxygen_mass_um` text,
  `oxygen_um` text,
  `oxygen_umol_kg` text,
  `particulate_carbon_umol_kg` text,
  `particulate_nigrogen_umol_kg` text,
  `particulate_nitrogen_umol_kg` text,
  `particulate_organic_carbon_umol_kg` text,
  `particulate_phosphate_umol_kg` text,
  `phage_type` text,
  `phosphate_umol_kg` text,
  `phosphate_umol_l` text,
  `plant_cover` text,
  `potassium` text,
  `potassiumk_um` text,
  `pressure_atm` text,
  `rain_fall` text,
  `rubidiumrb_um` text,
  `salinity_ppm` text,
  `salinity_psu` text,
  `sample_depth` text,
  `sample_depth_m` text,
  `sigma_kg_1000l` text,
  `silicah4sio4_um_l` text,
  `silicate_umol_kg` text,
  `siliconsi_um` text,
  `siliconsi_umol_l` text,
  `sodium` text,
  `sodium_um` text,
  `soil_depth_m` text,
  `soil_type` text,
  `strontiumsr_um` text,
  `sulfateso4_mm` text,
  `sulfateso4_um` text,
  `sulfurs2_um` text,
  `temperature` text,
  `temperature_c` text,
  `template_preparation_method` text,
  `theta_its_90` text,
  `time_count` text,
  `time_hour` text,
  `transmission` text,
  `treatment` text,
  `tungstenw_um` text,
  `turbidity_ntu` text,
  `turbidity_umol_kg` text,
  `urea_umol_l` text,
  `vanadiumv_um` text,
  `viral_abundance_viruses_ml` text,
  `viral_production_viruses_ml_h` text,
  `volume_filtered_l` text,
  `volume_l` text,
  `water_depth` text,
  `water_depth_m` text,
  `wave_height_m` text,
  `zinczn_um` text,
  `bact_chl_a_ug_l` text,
  `bchl_cd_ug_l` text,
  `bchl_e_ug_l` text,
  `organism_count` text,
  `sulfide_um` text,
  `total_phosphorus` text,
  `genbank_acc` text,
  `isolation_method` text,
  `fastq_file` varchar(200) DEFAULT NULL,
  `combined_assembly_id` int(10) unsigned DEFAULT NULL,
  `ncbi_acc` varchar(100) DEFAULT NULL,
  `cast_num` varchar(100) DEFAULT NULL,
  `ncbi_sra_experiment` text,
  `ncbi_sra_seq_run` text,
  PRIMARY KEY (`sample_id`),
  UNIQUE KEY `project_id` (`project_id`,`sample_acc`),
  KEY `combined_assembly_id` (`combined_assembly_id`),
  CONSTRAINT `sample_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `project` (`project_id`) ON DELETE CASCADE,
  CONSTRAINT `sample_ibfk_2` FOREIGN KEY (`combined_assembly_id`) REFERENCES `combined_assembly` (`combined_assembly_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2681 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_attr`
--

DROP TABLE IF EXISTS `sample_attr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sample_attr` (
  `sample_attr_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sample_attr_type_id` int(10) unsigned NOT NULL,
  `sample_id` int(10) unsigned NOT NULL,
  `attr_value` varchar(255) NOT NULL,
  PRIMARY KEY (`sample_attr_id`),
  UNIQUE KEY `sample_id` (`sample_id`,`sample_attr_type_id`,`attr_value`),
  KEY `sample_attr_type_id` (`sample_attr_type_id`),
  CONSTRAINT `sample_attr_ibfk_1` FOREIGN KEY (`sample_attr_type_id`) REFERENCES `sample_attr_type` (`sample_attr_type_id`),
  CONSTRAINT `sample_attr_ibfk_2` FOREIGN KEY (`sample_id`) REFERENCES `sample` (`sample_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=282603 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_attr_type`
--

DROP TABLE IF EXISTS `sample_attr_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sample_attr_type` (
  `sample_attr_type_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `url_template` varchar(255) DEFAULT NULL,
  `description` text,
  `category` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`sample_attr_type_id`),
  UNIQUE KEY `type` (`type`),
  KEY `category` (`category`)
) ENGINE=InnoDB AUTO_INCREMENT=709 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_file`
--

DROP TABLE IF EXISTS `sample_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sample_file` (
  `sample_file_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sample_id` int(10) unsigned NOT NULL,
  `sample_file_type_id` int(10) unsigned NOT NULL,
  `file` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`sample_file_id`),
  UNIQUE KEY `sample_id` (`sample_id`,`sample_file_type_id`,`file`),
  KEY `sample_id_2` (`sample_id`),
  KEY `sample_file_type_id` (`sample_file_type_id`),
  CONSTRAINT `sample_file_ibfk_1` FOREIGN KEY (`sample_id`) REFERENCES `sample` (`sample_id`),
  CONSTRAINT `sample_file_ibfk_2` FOREIGN KEY (`sample_file_type_id`) REFERENCES `sample_file_type` (`sample_file_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5319 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_file_type`
--

DROP TABLE IF EXISTS `sample_file_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sample_file_type` (
  `sample_file_type_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(25) NOT NULL,
  PRIMARY KEY (`sample_file_type_id`),
  UNIQUE KEY `type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_to_ontology`
--

DROP TABLE IF EXISTS `sample_to_ontology`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sample_to_ontology` (
  `sample_to_ontology_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sample_id` int(10) unsigned DEFAULT NULL,
  `ontology_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`sample_to_ontology_id`),
  KEY `sample_id` (`sample_id`),
  KEY `ontology_id` (`ontology_id`),
  CONSTRAINT `sample_to_ontology_ibfk_1` FOREIGN KEY (`sample_id`) REFERENCES `sample` (`sample_id`),
  CONSTRAINT `sample_to_ontology_ibfk_2` FOREIGN KEY (`ontology_id`) REFERENCES `ontology` (`ontology_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4479 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `search`
--

DROP TABLE IF EXISTS `search`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `search` (
  `search_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `table_name` varchar(100) DEFAULT NULL,
  `primary_key` int(10) unsigned DEFAULT NULL,
  `search_text` longtext,
  PRIMARY KEY (`search_id`),
  FULLTEXT KEY `search_text` (`search_text`)
) ENGINE=MyISAM AUTO_INCREMENT=86557 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-08-25 11:25:04
