use utf8;
package IMicrobe::Schema::Result::Sample;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IMicrobe::Schema::Result::Sample

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<sample>

=cut

__PACKAGE__->table("sample");

=head1 ACCESSORS

=head2 sample_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 project_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 sample_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 sample_type

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 sample_volume

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 volume_unit

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 filter_min

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 filter_max

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 sample_description

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 sample_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 comments

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 taxon_id

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 collection_start_time

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 collection_stop_time

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 biomaterial_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 description

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 material_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 site_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 latitude

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 longitude

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 altitude

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 site_depth

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 site_description

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 country_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 region

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 host_taxon_id

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 host_description

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 host_organism

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 library_acc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 sequencing_method

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 dna_type

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 num_of_reads

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 material_id

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 other

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 rrna_18s

  data_type: 'text'
  is_nullable: 1

=head2 additional_citations

  data_type: 'text'
  is_nullable: 1

=head2 ammonium

  data_type: 'text'
  is_nullable: 1

=head2 assembly_accession_number

  data_type: 'text'
  is_nullable: 1

=head2 axenic

  data_type: 'text'
  is_nullable: 1

=head2 chlorophyll

  data_type: 'text'
  is_nullable: 1

=head2 clonal

  data_type: 'text'
  is_nullable: 1

=head2 co2

  data_type: 'text'
  is_nullable: 1

=head2 collection_date

  data_type: 'text'
  is_nullable: 1

=head2 collection_time

  data_type: 'text'
  is_nullable: 1

=head2 combined_assembly_name

  data_type: 'text'
  is_nullable: 1

=head2 country

  data_type: 'text'
  is_nullable: 1

=head2 date_of_experiment

  data_type: 'text'
  is_nullable: 1

=head2 day_portion_of_day_night_cycle_in_hours

  data_type: 'text'
  is_nullable: 1

=head2 depth

  data_type: 'text'
  is_nullable: 1

=head2 dissolved_oxygen

  data_type: 'text'
  is_nullable: 1

=head2 doc

  data_type: 'text'
  is_nullable: 1

=head2 elevation

  data_type: 'text'
  is_nullable: 1

=head2 envo_term_for_habitat_primary_term

  data_type: 'text'
  is_nullable: 1

=head2 envo_term_for_habitat_secondary_term

  data_type: 'text'
  is_nullable: 1

=head2 external_sample_id

  data_type: 'text'
  is_nullable: 1

=head2 filter_fraction_maximum

  data_type: 'text'
  is_nullable: 1

=head2 filter_fraction_minimum

  data_type: 'text'
  is_nullable: 1

=head2 genus

  data_type: 'text'
  is_nullable: 1

=head2 growth_medium

  data_type: 'text'
  is_nullable: 1

=head2 habitat

  data_type: 'text'
  is_nullable: 1

=head2 habitat_description

  data_type: 'text'
  is_nullable: 1

=head2 importance

  data_type: 'text'
  is_nullable: 1

=head2 investigation_type

  data_type: 'text'
  is_nullable: 1

=head2 light

  data_type: 'text'
  is_nullable: 1

=head2 list_of_amino_acids_and_concentrations_with_units

  data_type: 'text'
  is_nullable: 1

=head2 modifications_to_growth_medium

  data_type: 'text'
  is_nullable: 1

=head2 night_portion_of_day_night_cycle_in_hours

  data_type: 'text'
  is_nullable: 1

=head2 nitrate

  data_type: 'text'
  is_nullable: 1

=head2 other_collection_site_info

  data_type: 'text'
  is_nullable: 1

=head2 other_environmental_metadata_available

  data_type: 'text'
  is_nullable: 1

=head2 other_experimental_metadata_available

  data_type: 'text'
  is_nullable: 1

=head2 ph

  data_type: 'text'
  is_nullable: 1

=head2 phosphate

  data_type: 'text'
  is_nullable: 1

=head2 poc

  data_type: 'text'
  is_nullable: 1

=head2 prelim_ncbi_taxon_id

  data_type: 'text'
  is_nullable: 1

=head2 pressure

  data_type: 'text'
  is_nullable: 1

=head2 prey_organism_if_applicable

  data_type: 'text'
  is_nullable: 1

=head2 primary_citation

  data_type: 'text'
  is_nullable: 1

=head2 principle_investigator

  data_type: 'text'
  is_nullable: 1

=head2 sample_collection_site

  data_type: 'text'
  is_nullable: 1

=head2 sample_material

  data_type: 'text'
  is_nullable: 1

=head2 silicate

  data_type: 'text'
  is_nullable: 1

=head2 species

  data_type: 'text'
  is_nullable: 1

=head2 strain

  data_type: 'text'
  is_nullable: 1

=head2 total_fe

  data_type: 'text'
  is_nullable: 1

=head2 trace_elements

  data_type: 'text'
  is_nullable: 1

=head2 urea

  data_type: 'text'
  is_nullable: 1

=head2 volume_filtered

  data_type: 'text'
  is_nullable: 1

=head2 reads_file

  data_type: 'varchar'
  is_nullable: 1
  size: 200

=head2 annotations_file

  data_type: 'varchar'
  is_nullable: 1
  size: 200

=head2 peptides_file

  data_type: 'varchar'
  is_nullable: 1
  size: 200

=head2 contigs_file

  data_type: 'varchar'
  is_nullable: 1
  size: 200

=head2 cds_file

  data_type: 'varchar'
  is_nullable: 1
  size: 200

=head2 pi

  data_type: 'text'
  is_nullable: 1

=head2 environmental_salinity

  data_type: 'text'
  is_nullable: 1

=head2 environmental_temperature

  data_type: 'text'
  is_nullable: 1

=head2 experimental_salinity

  data_type: 'text'
  is_nullable: 1

=head2 experimental_temperature

  data_type: 'text'
  is_nullable: 1

=head2 class

  data_type: 'text'
  is_nullable: 1

=head2 family

  data_type: 'text'
  is_nullable: 1

=head2 mmetsp_id

  data_type: 'text'
  is_nullable: 1

=head2 phylum

  data_type: 'text'
  is_nullable: 1

=head2 pcr_amp

  data_type: 'text'
  is_nullable: 1

=head2 rrna_16s

  data_type: 'text'
  is_nullable: 1

=head2 torder

  data_type: 'text'
  is_nullable: 1

=head2 superkingdom

  data_type: 'text'
  is_nullable: 1

=head2 abundance_bacterial_cells_ml

  data_type: 'text'
  is_nullable: 1

=head2 abundance_bacterial_cells_ml_h

  data_type: 'text'
  is_nullable: 1

=head2 abundance_synechococcus_cells_ml

  data_type: 'text'
  is_nullable: 1

=head2 alkalinityalk_mm

  data_type: 'text'
  is_nullable: 1

=head2 altitude_m

  data_type: 'text'
  is_nullable: 1

=head2 aluminiumal_um

  data_type: 'text'
  is_nullable: 1

=head2 ammonianh4_um

  data_type: 'text'
  is_nullable: 1

=head2 ammonium_umol_kg

  data_type: 'text'
  is_nullable: 1

=head2 antimonysb_um

  data_type: 'text'
  is_nullable: 1

=head2 arsenicas_um

  data_type: 'text'
  is_nullable: 1

=head2 atmospheric_general_weather

  data_type: 'text'
  is_nullable: 1

=head2 atmospheric_pressure_atm

  data_type: 'text'
  is_nullable: 1

=head2 atmospheric_wind_speed_m_s

  data_type: 'text'
  is_nullable: 1

=head2 bacterial_production_cells_ml_h

  data_type: 'text'
  is_nullable: 1

=head2 bariumba_um

  data_type: 'text'
  is_nullable: 1

=head2 biofilm_g

  data_type: 'text'
  is_nullable: 1

=head2 biomass_concentration_ug_kg

  data_type: 'text'
  is_nullable: 1

=head2 biomass_mass_g

  data_type: 'text'
  is_nullable: 1

=head2 boronb_um

  data_type: 'text'
  is_nullable: 1

=head2 caesiumcs_um

  data_type: 'text'
  is_nullable: 1

=head2 calciumca_um

  data_type: 'text'
  is_nullable: 1

=head2 carbon_dioxideco2_um

  data_type: 'text'
  is_nullable: 1

=head2 carbon_dioxideco2_umol_kg

  data_type: 'text'
  is_nullable: 1

=head2 cdom_rfu

  data_type: 'text'
  is_nullable: 1

=head2 cfu_cjejuni_cfu

  data_type: 'text'
  is_nullable: 1

=head2 charge__mmol

  data_type: 'text'
  is_nullable: 1

=head2 charge_mmol

  data_type: 'text'
  is_nullable: 1

=head2 chla_mg_1000l

  data_type: 'text'
  is_nullable: 1

=head2 chlorinitycl_mm

  data_type: 'text'
  is_nullable: 1

=head2 chlorinitycl_um

  data_type: 'text'
  is_nullable: 1

=head2 chlorophyll_density_annual_ug_kg

  data_type: 'text'
  is_nullable: 1

=head2 chlorophyll_density_annual_ug_l

  data_type: 'text'
  is_nullable: 1

=head2 chlorophyll_density_psu

  data_type: 'text'
  is_nullable: 1

=head2 chlorophyll_density_sample_month_ug_kg

  data_type: 'text'
  is_nullable: 1

=head2 chlorophyll_density_ug_kg

  data_type: 'text'
  is_nullable: 1

=head2 chloropigment

  data_type: 'text'
  is_nullable: 1

=head2 comment

  data_type: 'text'
  is_nullable: 1

=head2 current_land_use

  data_type: 'text'
  is_nullable: 1

=head2 dissolved_inorg_cdic_mm

  data_type: 'text'
  is_nullable: 1

=head2 dissolved_inorg_cdic_um

  data_type: 'text'
  is_nullable: 1

=head2 dissolved_inorganic_carbon_umol_kg

  data_type: 'text'
  is_nullable: 1

=head2 dissolved_inorganic_nitrogen_umol_l

  data_type: 'text'
  is_nullable: 1

=head2 dissolved_inorganic_phosphate_nmol_kg

  data_type: 'text'
  is_nullable: 1

=head2 dissolved_organic_carbon_um

  data_type: 'text'
  is_nullable: 1

=head2 dissolved_organic_carbon_umol_kg

  data_type: 'text'
  is_nullable: 1

=head2 dissolved_organic_nitrogen_umol_kg

  data_type: 'text'
  is_nullable: 1

=head2 dissolved_oxygen_nmol_kg

  data_type: 'text'
  is_nullable: 1

=head2 dissolved_oxygen_umol_kg

  data_type: 'text'
  is_nullable: 1

=head2 filter_type

  data_type: 'text'
  is_nullable: 1

=head2 filter_type_m

  data_type: 'text'
  is_nullable: 1

=head2 fluorescence_ug_l

  data_type: 'text'
  is_nullable: 1

=head2 fluorinef_um

  data_type: 'text'
  is_nullable: 1

=head2 gene_name

  data_type: 'text'
  is_nullable: 1

=head2 glucose_mg

  data_type: 'text'
  is_nullable: 1

=head2 h2_um

  data_type: 'text'
  is_nullable: 1

=head2 habitat_name

  data_type: 'text'
  is_nullable: 1

=head2 health_status

  data_type: 'text'
  is_nullable: 1

=head2 host_name

  data_type: 'text'
  is_nullable: 1

=head2 host_species

  data_type: 'text'
  is_nullable: 1

=head2 host_tissue

  data_type: 'text'
  is_nullable: 1

=head2 ironfe_um

  data_type: 'text'
  is_nullable: 1

=head2 isolation

  data_type: 'text'
  is_nullable: 1

=head2 leg

  data_type: 'text'
  is_nullable: 1

=head2 leucine_umol_kg

  data_type: 'text'
  is_nullable: 1

=head2 light_intensity_umol_m2_s

  data_type: 'text'
  is_nullable: 1

=head2 lithiumli_um

  data_type: 'text'
  is_nullable: 1

=head2 magnesiummg_um

  data_type: 'text'
  is_nullable: 1

=head2 manganesemn_um

  data_type: 'text'
  is_nullable: 1

=head2 mean_annual_precipitation_cm

  data_type: 'text'
  is_nullable: 1

=head2 methane_um

  data_type: 'text'
  is_nullable: 1

=head2 method_of_isolation

  data_type: 'text'
  is_nullable: 1

=head2 molybdenummo_um

  data_type: 'text'
  is_nullable: 1

=head2 nitratenitrite_nmol_kg

  data_type: 'text'
  is_nullable: 1

=head2 nitrateno3_um

  data_type: 'text'
  is_nullable: 1

=head2 nitrateno3_umol_l

  data_type: 'text'
  is_nullable: 1

=head2 nitrite_umol_l

  data_type: 'text'
  is_nullable: 1

=head2 number_of_samples_pooled

  data_type: 'text'
  is_nullable: 1

=head2 number_of_stations_sampled

  data_type: 'text'
  is_nullable: 1

=head2 nutrients_dmsp_nm

  data_type: 'text'
  is_nullable: 1

=head2 nutrients_nh4_microm

  data_type: 'text'
  is_nullable: 1

=head2 nutrients_nox_microm

  data_type: 'text'
  is_nullable: 1

=head2 nutrients_po3_microm

  data_type: 'text'
  is_nullable: 1

=head2 nutrients_po4_microm

  data_type: 'text'
  is_nullable: 1

=head2 nutrients_potassium_phosphate_um

  data_type: 'text'
  is_nullable: 1

=head2 nutrients_putrescine_c4h12n2_nm

  data_type: 'text'
  is_nullable: 1

=head2 nutrients_so4_microm

  data_type: 'text'
  is_nullable: 1

=head2 nutrients_sodium_nitrate_um

  data_type: 'text'
  is_nullable: 1

=head2 nutrients_spermidine_c7h19n3_nm

  data_type: 'text'
  is_nullable: 1

=head2 other_habitat

  data_type: 'text'
  is_nullable: 1

=head2 oxygen

  data_type: 'text'
  is_nullable: 1

=head2 oxygen_mass_um

  data_type: 'text'
  is_nullable: 1

=head2 oxygen_um

  data_type: 'text'
  is_nullable: 1

=head2 oxygen_umol_kg

  data_type: 'text'
  is_nullable: 1

=head2 particulate_carbon_umol_kg

  data_type: 'text'
  is_nullable: 1

=head2 particulate_nigrogen_umol_kg

  data_type: 'text'
  is_nullable: 1

=head2 particulate_nitrogen_umol_kg

  data_type: 'text'
  is_nullable: 1

=head2 particulate_organic_carbon_umol_kg

  data_type: 'text'
  is_nullable: 1

=head2 particulate_phosphate_umol_kg

  data_type: 'text'
  is_nullable: 1

=head2 phage_type

  data_type: 'text'
  is_nullable: 1

=head2 phosphate_umol_kg

  data_type: 'text'
  is_nullable: 1

=head2 phosphate_umol_l

  data_type: 'text'
  is_nullable: 1

=head2 plant_cover

  data_type: 'text'
  is_nullable: 1

=head2 potassium

  data_type: 'text'
  is_nullable: 1

=head2 potassiumk_um

  data_type: 'text'
  is_nullable: 1

=head2 pressure_atm

  data_type: 'text'
  is_nullable: 1

=head2 rain_fall

  data_type: 'text'
  is_nullable: 1

=head2 rubidiumrb_um

  data_type: 'text'
  is_nullable: 1

=head2 salinity_ppm

  data_type: 'text'
  is_nullable: 1

=head2 salinity_psu

  data_type: 'text'
  is_nullable: 1

=head2 sample_depth

  data_type: 'text'
  is_nullable: 1

=head2 sample_depth_m

  data_type: 'text'
  is_nullable: 1

=head2 sigma_kg_1000l

  data_type: 'text'
  is_nullable: 1

=head2 silicah4sio4_um_l

  data_type: 'text'
  is_nullable: 1

=head2 silicate_umol_kg

  data_type: 'text'
  is_nullable: 1

=head2 siliconsi_um

  data_type: 'text'
  is_nullable: 1

=head2 siliconsi_umol_l

  data_type: 'text'
  is_nullable: 1

=head2 sodium

  data_type: 'text'
  is_nullable: 1

=head2 sodium_um

  data_type: 'text'
  is_nullable: 1

=head2 soil_depth_m

  data_type: 'text'
  is_nullable: 1

=head2 soil_type

  data_type: 'text'
  is_nullable: 1

=head2 strontiumsr_um

  data_type: 'text'
  is_nullable: 1

=head2 sulfateso4_mm

  data_type: 'text'
  is_nullable: 1

=head2 sulfateso4_um

  data_type: 'text'
  is_nullable: 1

=head2 sulfurs2_um

  data_type: 'text'
  is_nullable: 1

=head2 temperature

  data_type: 'text'
  is_nullable: 1

=head2 temperature_c

  data_type: 'text'
  is_nullable: 1

=head2 template_preparation_method

  data_type: 'text'
  is_nullable: 1

=head2 theta_its_90

  data_type: 'text'
  is_nullable: 1

=head2 time_count

  data_type: 'text'
  is_nullable: 1

=head2 time_hour

  data_type: 'text'
  is_nullable: 1

=head2 transmission

  data_type: 'text'
  is_nullable: 1

=head2 treatment

  data_type: 'text'
  is_nullable: 1

=head2 tungstenw_um

  data_type: 'text'
  is_nullable: 1

=head2 turbidity_ntu

  data_type: 'text'
  is_nullable: 1

=head2 turbidity_umol_kg

  data_type: 'text'
  is_nullable: 1

=head2 urea_umol_l

  data_type: 'text'
  is_nullable: 1

=head2 vanadiumv_um

  data_type: 'text'
  is_nullable: 1

=head2 viral_abundance_viruses_ml

  data_type: 'text'
  is_nullable: 1

=head2 viral_production_viruses_ml_h

  data_type: 'text'
  is_nullable: 1

=head2 volume_filtered_l

  data_type: 'text'
  is_nullable: 1

=head2 volume_l

  data_type: 'text'
  is_nullable: 1

=head2 water_depth

  data_type: 'text'
  is_nullable: 1

=head2 water_depth_m

  data_type: 'text'
  is_nullable: 1

=head2 wave_height_m

  data_type: 'text'
  is_nullable: 1

=head2 zinczn_um

  data_type: 'text'
  is_nullable: 1

=head2 bact_chl_a_ug_l

  data_type: 'text'
  is_nullable: 1

=head2 bchl_cd_ug_l

  data_type: 'text'
  is_nullable: 1

=head2 bchl_e_ug_l

  data_type: 'text'
  is_nullable: 1

=head2 organism_count

  data_type: 'text'
  is_nullable: 1

=head2 sulfide_um

  data_type: 'text'
  is_nullable: 1

=head2 total_phosphorus

  data_type: 'text'
  is_nullable: 1

=head2 genbank_acc

  data_type: 'text'
  is_nullable: 1

=head2 isolation_method

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "sample_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "project_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "sample_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "sample_type",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "sample_volume",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "volume_unit",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "filter_min",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "filter_max",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "sample_description",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "sample_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "comments",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "taxon_id",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "collection_start_time",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "collection_stop_time",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "biomaterial_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "description",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "material_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "site_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "latitude",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "longitude",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "altitude",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "site_depth",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "site_description",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "country_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "region",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "host_taxon_id",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "host_description",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "host_organism",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "library_acc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "sequencing_method",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "dna_type",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "num_of_reads",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "material_id",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "other",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "rrna_18s",
  { data_type => "text", is_nullable => 1 },
  "additional_citations",
  { data_type => "text", is_nullable => 1 },
  "ammonium",
  { data_type => "text", is_nullable => 1 },
  "assembly_accession_number",
  { data_type => "text", is_nullable => 1 },
  "axenic",
  { data_type => "text", is_nullable => 1 },
  "chlorophyll",
  { data_type => "text", is_nullable => 1 },
  "clonal",
  { data_type => "text", is_nullable => 1 },
  "co2",
  { data_type => "text", is_nullable => 1 },
  "collection_date",
  { data_type => "text", is_nullable => 1 },
  "collection_time",
  { data_type => "text", is_nullable => 1 },
  "combined_assembly_name",
  { data_type => "text", is_nullable => 1 },
  "country",
  { data_type => "text", is_nullable => 1 },
  "date_of_experiment",
  { data_type => "text", is_nullable => 1 },
  "day_portion_of_day_night_cycle_in_hours",
  { data_type => "text", is_nullable => 1 },
  "depth",
  { data_type => "text", is_nullable => 1 },
  "dissolved_oxygen",
  { data_type => "text", is_nullable => 1 },
  "doc",
  { data_type => "text", is_nullable => 1 },
  "elevation",
  { data_type => "text", is_nullable => 1 },
  "envo_term_for_habitat_primary_term",
  { data_type => "text", is_nullable => 1 },
  "envo_term_for_habitat_secondary_term",
  { data_type => "text", is_nullable => 1 },
  "external_sample_id",
  { data_type => "text", is_nullable => 1 },
  "filter_fraction_maximum",
  { data_type => "text", is_nullable => 1 },
  "filter_fraction_minimum",
  { data_type => "text", is_nullable => 1 },
  "genus",
  { data_type => "text", is_nullable => 1 },
  "growth_medium",
  { data_type => "text", is_nullable => 1 },
  "habitat",
  { data_type => "text", is_nullable => 1 },
  "habitat_description",
  { data_type => "text", is_nullable => 1 },
  "importance",
  { data_type => "text", is_nullable => 1 },
  "investigation_type",
  { data_type => "text", is_nullable => 1 },
  "light",
  { data_type => "text", is_nullable => 1 },
  "list_of_amino_acids_and_concentrations_with_units",
  { data_type => "text", is_nullable => 1 },
  "modifications_to_growth_medium",
  { data_type => "text", is_nullable => 1 },
  "night_portion_of_day_night_cycle_in_hours",
  { data_type => "text", is_nullable => 1 },
  "nitrate",
  { data_type => "text", is_nullable => 1 },
  "other_collection_site_info",
  { data_type => "text", is_nullable => 1 },
  "other_environmental_metadata_available",
  { data_type => "text", is_nullable => 1 },
  "other_experimental_metadata_available",
  { data_type => "text", is_nullable => 1 },
  "ph",
  { data_type => "text", is_nullable => 1 },
  "phosphate",
  { data_type => "text", is_nullable => 1 },
  "poc",
  { data_type => "text", is_nullable => 1 },
  "prelim_ncbi_taxon_id",
  { data_type => "text", is_nullable => 1 },
  "pressure",
  { data_type => "text", is_nullable => 1 },
  "prey_organism_if_applicable",
  { data_type => "text", is_nullable => 1 },
  "primary_citation",
  { data_type => "text", is_nullable => 1 },
  "principle_investigator",
  { data_type => "text", is_nullable => 1 },
  "sample_collection_site",
  { data_type => "text", is_nullable => 1 },
  "sample_material",
  { data_type => "text", is_nullable => 1 },
  "silicate",
  { data_type => "text", is_nullable => 1 },
  "species",
  { data_type => "text", is_nullable => 1 },
  "strain",
  { data_type => "text", is_nullable => 1 },
  "total_fe",
  { data_type => "text", is_nullable => 1 },
  "trace_elements",
  { data_type => "text", is_nullable => 1 },
  "urea",
  { data_type => "text", is_nullable => 1 },
  "volume_filtered",
  { data_type => "text", is_nullable => 1 },
  "reads_file",
  { data_type => "varchar", is_nullable => 1, size => 200 },
  "annotations_file",
  { data_type => "varchar", is_nullable => 1, size => 200 },
  "peptides_file",
  { data_type => "varchar", is_nullable => 1, size => 200 },
  "contigs_file",
  { data_type => "varchar", is_nullable => 1, size => 200 },
  "cds_file",
  { data_type => "varchar", is_nullable => 1, size => 200 },
  "pi",
  { data_type => "text", is_nullable => 1 },
  "environmental_salinity",
  { data_type => "text", is_nullable => 1 },
  "environmental_temperature",
  { data_type => "text", is_nullable => 1 },
  "experimental_salinity",
  { data_type => "text", is_nullable => 1 },
  "experimental_temperature",
  { data_type => "text", is_nullable => 1 },
  "class",
  { data_type => "text", is_nullable => 1 },
  "family",
  { data_type => "text", is_nullable => 1 },
  "mmetsp_id",
  { data_type => "text", is_nullable => 1 },
  "phylum",
  { data_type => "text", is_nullable => 1 },
  "pcr_amp",
  { data_type => "text", is_nullable => 1 },
  "rrna_16s",
  { data_type => "text", is_nullable => 1 },
  "torder",
  { data_type => "text", is_nullable => 1 },
  "superkingdom",
  { data_type => "text", is_nullable => 1 },
  "abundance_bacterial_cells_ml",
  { data_type => "text", is_nullable => 1 },
  "abundance_bacterial_cells_ml_h",
  { data_type => "text", is_nullable => 1 },
  "abundance_synechococcus_cells_ml",
  { data_type => "text", is_nullable => 1 },
  "alkalinityalk_mm",
  { data_type => "text", is_nullable => 1 },
  "altitude_m",
  { data_type => "text", is_nullable => 1 },
  "aluminiumal_um",
  { data_type => "text", is_nullable => 1 },
  "ammonianh4_um",
  { data_type => "text", is_nullable => 1 },
  "ammonium_umol_kg",
  { data_type => "text", is_nullable => 1 },
  "antimonysb_um",
  { data_type => "text", is_nullable => 1 },
  "arsenicas_um",
  { data_type => "text", is_nullable => 1 },
  "atmospheric_general_weather",
  { data_type => "text", is_nullable => 1 },
  "atmospheric_pressure_atm",
  { data_type => "text", is_nullable => 1 },
  "atmospheric_wind_speed_m_s",
  { data_type => "text", is_nullable => 1 },
  "bacterial_production_cells_ml_h",
  { data_type => "text", is_nullable => 1 },
  "bariumba_um",
  { data_type => "text", is_nullable => 1 },
  "biofilm_g",
  { data_type => "text", is_nullable => 1 },
  "biomass_concentration_ug_kg",
  { data_type => "text", is_nullable => 1 },
  "biomass_mass_g",
  { data_type => "text", is_nullable => 1 },
  "boronb_um",
  { data_type => "text", is_nullable => 1 },
  "caesiumcs_um",
  { data_type => "text", is_nullable => 1 },
  "calciumca_um",
  { data_type => "text", is_nullable => 1 },
  "carbon_dioxideco2_um",
  { data_type => "text", is_nullable => 1 },
  "carbon_dioxideco2_umol_kg",
  { data_type => "text", is_nullable => 1 },
  "cdom_rfu",
  { data_type => "text", is_nullable => 1 },
  "cfu_cjejuni_cfu",
  { data_type => "text", is_nullable => 1 },
  "charge__mmol",
  { data_type => "text", is_nullable => 1 },
  "charge_mmol",
  { data_type => "text", is_nullable => 1 },
  "chla_mg_1000l",
  { data_type => "text", is_nullable => 1 },
  "chlorinitycl_mm",
  { data_type => "text", is_nullable => 1 },
  "chlorinitycl_um",
  { data_type => "text", is_nullable => 1 },
  "chlorophyll_density_annual_ug_kg",
  { data_type => "text", is_nullable => 1 },
  "chlorophyll_density_annual_ug_l",
  { data_type => "text", is_nullable => 1 },
  "chlorophyll_density_psu",
  { data_type => "text", is_nullable => 1 },
  "chlorophyll_density_sample_month_ug_kg",
  { data_type => "text", is_nullable => 1 },
  "chlorophyll_density_ug_kg",
  { data_type => "text", is_nullable => 1 },
  "chloropigment",
  { data_type => "text", is_nullable => 1 },
  "comment",
  { data_type => "text", is_nullable => 1 },
  "current_land_use",
  { data_type => "text", is_nullable => 1 },
  "dissolved_inorg_cdic_mm",
  { data_type => "text", is_nullable => 1 },
  "dissolved_inorg_cdic_um",
  { data_type => "text", is_nullable => 1 },
  "dissolved_inorganic_carbon_umol_kg",
  { data_type => "text", is_nullable => 1 },
  "dissolved_inorganic_nitrogen_umol_l",
  { data_type => "text", is_nullable => 1 },
  "dissolved_inorganic_phosphate_nmol_kg",
  { data_type => "text", is_nullable => 1 },
  "dissolved_organic_carbon_um",
  { data_type => "text", is_nullable => 1 },
  "dissolved_organic_carbon_umol_kg",
  { data_type => "text", is_nullable => 1 },
  "dissolved_organic_nitrogen_umol_kg",
  { data_type => "text", is_nullable => 1 },
  "dissolved_oxygen_nmol_kg",
  { data_type => "text", is_nullable => 1 },
  "dissolved_oxygen_umol_kg",
  { data_type => "text", is_nullable => 1 },
  "filter_type",
  { data_type => "text", is_nullable => 1 },
  "filter_type_m",
  { data_type => "text", is_nullable => 1 },
  "fluorescence_ug_l",
  { data_type => "text", is_nullable => 1 },
  "fluorinef_um",
  { data_type => "text", is_nullable => 1 },
  "gene_name",
  { data_type => "text", is_nullable => 1 },
  "glucose_mg",
  { data_type => "text", is_nullable => 1 },
  "h2_um",
  { data_type => "text", is_nullable => 1 },
  "habitat_name",
  { data_type => "text", is_nullable => 1 },
  "health_status",
  { data_type => "text", is_nullable => 1 },
  "host_name",
  { data_type => "text", is_nullable => 1 },
  "host_species",
  { data_type => "text", is_nullable => 1 },
  "host_tissue",
  { data_type => "text", is_nullable => 1 },
  "ironfe_um",
  { data_type => "text", is_nullable => 1 },
  "isolation",
  { data_type => "text", is_nullable => 1 },
  "leg",
  { data_type => "text", is_nullable => 1 },
  "leucine_umol_kg",
  { data_type => "text", is_nullable => 1 },
  "light_intensity_umol_m2_s",
  { data_type => "text", is_nullable => 1 },
  "lithiumli_um",
  { data_type => "text", is_nullable => 1 },
  "magnesiummg_um",
  { data_type => "text", is_nullable => 1 },
  "manganesemn_um",
  { data_type => "text", is_nullable => 1 },
  "mean_annual_precipitation_cm",
  { data_type => "text", is_nullable => 1 },
  "methane_um",
  { data_type => "text", is_nullable => 1 },
  "method_of_isolation",
  { data_type => "text", is_nullable => 1 },
  "molybdenummo_um",
  { data_type => "text", is_nullable => 1 },
  "nitratenitrite_nmol_kg",
  { data_type => "text", is_nullable => 1 },
  "nitrateno3_um",
  { data_type => "text", is_nullable => 1 },
  "nitrateno3_umol_l",
  { data_type => "text", is_nullable => 1 },
  "nitrite_umol_l",
  { data_type => "text", is_nullable => 1 },
  "number_of_samples_pooled",
  { data_type => "text", is_nullable => 1 },
  "number_of_stations_sampled",
  { data_type => "text", is_nullable => 1 },
  "nutrients_dmsp_nm",
  { data_type => "text", is_nullable => 1 },
  "nutrients_nh4_microm",
  { data_type => "text", is_nullable => 1 },
  "nutrients_nox_microm",
  { data_type => "text", is_nullable => 1 },
  "nutrients_po3_microm",
  { data_type => "text", is_nullable => 1 },
  "nutrients_po4_microm",
  { data_type => "text", is_nullable => 1 },
  "nutrients_potassium_phosphate_um",
  { data_type => "text", is_nullable => 1 },
  "nutrients_putrescine_c4h12n2_nm",
  { data_type => "text", is_nullable => 1 },
  "nutrients_so4_microm",
  { data_type => "text", is_nullable => 1 },
  "nutrients_sodium_nitrate_um",
  { data_type => "text", is_nullable => 1 },
  "nutrients_spermidine_c7h19n3_nm",
  { data_type => "text", is_nullable => 1 },
  "other_habitat",
  { data_type => "text", is_nullable => 1 },
  "oxygen",
  { data_type => "text", is_nullable => 1 },
  "oxygen_mass_um",
  { data_type => "text", is_nullable => 1 },
  "oxygen_um",
  { data_type => "text", is_nullable => 1 },
  "oxygen_umol_kg",
  { data_type => "text", is_nullable => 1 },
  "particulate_carbon_umol_kg",
  { data_type => "text", is_nullable => 1 },
  "particulate_nigrogen_umol_kg",
  { data_type => "text", is_nullable => 1 },
  "particulate_nitrogen_umol_kg",
  { data_type => "text", is_nullable => 1 },
  "particulate_organic_carbon_umol_kg",
  { data_type => "text", is_nullable => 1 },
  "particulate_phosphate_umol_kg",
  { data_type => "text", is_nullable => 1 },
  "phage_type",
  { data_type => "text", is_nullable => 1 },
  "phosphate_umol_kg",
  { data_type => "text", is_nullable => 1 },
  "phosphate_umol_l",
  { data_type => "text", is_nullable => 1 },
  "plant_cover",
  { data_type => "text", is_nullable => 1 },
  "potassium",
  { data_type => "text", is_nullable => 1 },
  "potassiumk_um",
  { data_type => "text", is_nullable => 1 },
  "pressure_atm",
  { data_type => "text", is_nullable => 1 },
  "rain_fall",
  { data_type => "text", is_nullable => 1 },
  "rubidiumrb_um",
  { data_type => "text", is_nullable => 1 },
  "salinity_ppm",
  { data_type => "text", is_nullable => 1 },
  "salinity_psu",
  { data_type => "text", is_nullable => 1 },
  "sample_depth",
  { data_type => "text", is_nullable => 1 },
  "sample_depth_m",
  { data_type => "text", is_nullable => 1 },
  "sigma_kg_1000l",
  { data_type => "text", is_nullable => 1 },
  "silicah4sio4_um_l",
  { data_type => "text", is_nullable => 1 },
  "silicate_umol_kg",
  { data_type => "text", is_nullable => 1 },
  "siliconsi_um",
  { data_type => "text", is_nullable => 1 },
  "siliconsi_umol_l",
  { data_type => "text", is_nullable => 1 },
  "sodium",
  { data_type => "text", is_nullable => 1 },
  "sodium_um",
  { data_type => "text", is_nullable => 1 },
  "soil_depth_m",
  { data_type => "text", is_nullable => 1 },
  "soil_type",
  { data_type => "text", is_nullable => 1 },
  "strontiumsr_um",
  { data_type => "text", is_nullable => 1 },
  "sulfateso4_mm",
  { data_type => "text", is_nullable => 1 },
  "sulfateso4_um",
  { data_type => "text", is_nullable => 1 },
  "sulfurs2_um",
  { data_type => "text", is_nullable => 1 },
  "temperature",
  { data_type => "text", is_nullable => 1 },
  "temperature_c",
  { data_type => "text", is_nullable => 1 },
  "template_preparation_method",
  { data_type => "text", is_nullable => 1 },
  "theta_its_90",
  { data_type => "text", is_nullable => 1 },
  "time_count",
  { data_type => "text", is_nullable => 1 },
  "time_hour",
  { data_type => "text", is_nullable => 1 },
  "transmission",
  { data_type => "text", is_nullable => 1 },
  "treatment",
  { data_type => "text", is_nullable => 1 },
  "tungstenw_um",
  { data_type => "text", is_nullable => 1 },
  "turbidity_ntu",
  { data_type => "text", is_nullable => 1 },
  "turbidity_umol_kg",
  { data_type => "text", is_nullable => 1 },
  "urea_umol_l",
  { data_type => "text", is_nullable => 1 },
  "vanadiumv_um",
  { data_type => "text", is_nullable => 1 },
  "viral_abundance_viruses_ml",
  { data_type => "text", is_nullable => 1 },
  "viral_production_viruses_ml_h",
  { data_type => "text", is_nullable => 1 },
  "volume_filtered_l",
  { data_type => "text", is_nullable => 1 },
  "volume_l",
  { data_type => "text", is_nullable => 1 },
  "water_depth",
  { data_type => "text", is_nullable => 1 },
  "water_depth_m",
  { data_type => "text", is_nullable => 1 },
  "wave_height_m",
  { data_type => "text", is_nullable => 1 },
  "zinczn_um",
  { data_type => "text", is_nullable => 1 },
  "bact_chl_a_ug_l",
  { data_type => "text", is_nullable => 1 },
  "bchl_cd_ug_l",
  { data_type => "text", is_nullable => 1 },
  "bchl_e_ug_l",
  { data_type => "text", is_nullable => 1 },
  "organism_count",
  { data_type => "text", is_nullable => 1 },
  "sulfide_um",
  { data_type => "text", is_nullable => 1 },
  "total_phosphorus",
  { data_type => "text", is_nullable => 1 },
  "genbank_acc",
  { data_type => "text", is_nullable => 1 },
  "isolation_method",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</sample_id>

=back

=cut

__PACKAGE__->set_primary_key("sample_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<project_id>

=over 4

=item * L</project_id>

=item * L</sample_acc>

=back

=cut

__PACKAGE__->add_unique_constraint("project_id", ["project_id", "sample_acc"]);

=head1 RELATIONS

=head2 combined_assembly_to_samples

Type: has_many

Related object: L<IMicrobe::Schema::Result::CombinedAssemblyToSample>

=cut

__PACKAGE__->has_many(
  "combined_assembly_to_samples",
  "IMicrobe::Schema::Result::CombinedAssemblyToSample",
  { "foreign.sample_id" => "self.sample_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 project

Type: belongs_to

Related object: L<IMicrobe::Schema::Result::Project>

=cut

__PACKAGE__->belongs_to(
  "project",
  "IMicrobe::Schema::Result::Project",
  { project_id => "project_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);

=head2 sample_attrs

Type: has_many

Related object: L<IMicrobe::Schema::Result::SampleAttr>

=cut

__PACKAGE__->has_many(
  "sample_attrs",
  "IMicrobe::Schema::Result::SampleAttr",
  { "foreign.sample_id" => "self.sample_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-12-01 15:54:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:2NJ6pgQuZqL+Vsvh6PTMoA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
