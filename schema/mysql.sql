-- MySQL dump 10.13  Distrib 5.1.73, for redhat-linux-gnu (x86_64)
--
-- Host: localhost    Database: imicrobe
-- ------------------------------------------------------
-- Server version	5.1.73

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
  PRIMARY KEY (`assembly_id`),
  KEY `project_id` (`project_id`),
  CONSTRAINT `assembly_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `project` (`project_id`)
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
  KEY `project_id` (`project_id`),
  CONSTRAINT `combined_assembly_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `project` (`project_id`)
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
  CONSTRAINT `combined_assembly_to_sample_ibfk_1` FOREIGN KEY (`combined_assembly_id`) REFERENCES `combined_assembly` (`combined_assembly_id`),
  CONSTRAINT `combined_assembly_to_sample_ibfk_2` FOREIGN KEY (`sample_id`) REFERENCES `sample` (`sample_id`)
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
  PRIMARY KEY (`project_id`),
  UNIQUE KEY `project_code` (`project_code`)
) ENGINE=InnoDB AUTO_INCREMENT=129 DEFAULT CHARSET=utf8;
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
  CONSTRAINT `project_to_domain_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `project` (`project_id`),
  CONSTRAINT `project_to_domain_ibfk_2` FOREIGN KEY (`domain_id`) REFERENCES `domain` (`domain_id`)
) ENGINE=InnoDB AUTO_INCREMENT=150 DEFAULT CHARSET=latin1;
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
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=latin1;
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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `publication`
--

DROP TABLE IF EXISTS `publication`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `publication` (
  `publication_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pub_code` varchar(255) DEFAULT NULL,
  `doi` text,
  `author` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `pubmed_id` int(11) DEFAULT NULL,
  `journal` text,
  `pub_date` text,
  PRIMARY KEY (`publication_id`)
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=utf8;
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
  `habitat_name` varchar(255) DEFAULT NULL,
  `host_taxon_id` varchar(255) DEFAULT NULL,
  `host_description` varchar(255) DEFAULT NULL,
  `host_organism` varchar(255) DEFAULT NULL,
  `library_acc` varchar(255) DEFAULT NULL,
  `sequencing_method` varchar(255) DEFAULT NULL,
  `dna_type` varchar(255) DEFAULT NULL,
  `num_of_reads` varchar(255) DEFAULT NULL,
  `material_id` varchar(255) DEFAULT NULL,
  `other` varchar(255) DEFAULT NULL,
  `18s_rrna` text,
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
  `ncgr_sample_id` text,
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
  `salinity` text,
  `sample_accession_number` text,
  `sample_collection_site` text,
  `sample_material` text,
  `silicate` text,
  `species` text,
  `strain` text,
  `temperature` text,
  `total_fe` text,
  `trace_elements` text,
  `urea` text,
  `volume_filtered` text,
  PRIMARY KEY (`sample_id`),
  UNIQUE KEY `project_id` (`project_id`,`sample_acc`),
  CONSTRAINT `sample_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `project` (`project_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2468 DEFAULT CHARSET=utf8;
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
) ENGINE=MyISAM AUTO_INCREMENT=38125 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-11-14 16:27:19
