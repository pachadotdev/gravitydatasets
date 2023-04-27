#' Create SQL schema
#' @noRd
create_schema <- function() {
  con <- gravitydatasets_connect()

  # CEPII ----

  DBI::dbSendQuery(con, "DROP TABLE IF EXISTS cepii_legal_origin")

  DBI::dbSendQuery(
    con,
    "CREATE TABLE cepii_legal_origin (
  	legal_origin_id INTEGER,
  	legal_origin VARCHAR)"
  )

  DBI::dbSendQuery(con, "DROP TABLE IF EXISTS cepii_rta_type")

  DBI::dbSendQuery(
    con,
    "CREATE TABLE cepii_rta_type (
  	rta_type_id INTEGER,
  	rta_type_description VARCHAR)"
  )

  DBI::dbSendQuery(con, "DROP TABLE IF EXISTS cepii_rta_coverage")

  DBI::dbSendQuery(
    con,
    "CREATE TABLE cepii_rta_coverage (
  	rta_coverage_id INTEGER,
    rta_coverage_description VARCHAR)"
  )

  DBI::dbSendQuery(con, "DROP TABLE IF EXISTS cepii_country_names")

  DBI::dbSendQuery(
    con,
    "CREATE TABLE cepii_country_names (
  	iso3 VARCHAR(3),
  	iso3num INTEGER,
  	country VARCHAR,
  	countrylong VARCHAR,
  	first_year INTEGER,
  	last_year INTEGER,
  	countrygroup_iso3 VARCHAR(3),
  	countrygroup_iso3num INTEGER)"
  )

  DBI::dbSendQuery(con, "DROP TABLE IF EXISTS cepii_gravity")

  DBI::dbSendQuery(
    con,
    "CREATE TABLE cepii_gravity (
  	year DOUBLE,
  	iso3_o VARCHAR(3),
  	iso3_d VARCHAR(3),
  	iso3num_o INTEGER,
  	iso3num_d INTEGER,
  	country_exists_o INTEGER,
  	country_exists_d INTEGER,
  	gmt_offset_2020_o INTEGER,
  	gmt_offset_2020_d INTEGER,
  	contig INTEGER,
  	dist DOUBLE,
  	distw DOUBLE,
  	distcap DOUBLE,
  	distwces DOUBLE,
  	dist_source INTEGER,
  	comlang_off INTEGER,
  	comlang_ethno INTEGER,
  	comcol INTEGER,
  	comrelig DOUBLE,
  	col45 INTEGER,
  	legal_old_o INTEGER,
  	legal_old_d INTEGER,
  	legal_new_o INTEGER,
  	legal_new_d INTEGER,
  	comleg_pretrans INTEGER,
  	comleg_posttrans INTEGER,
  	transition_legalchange INTEGER,
  	heg_o INTEGER,
  	heg_d INTEGER,
  	col_dep_ever INTEGER,
  	col_dep INTEGER,
  	col_dep_end_year INTEGER,
  	col_dep_end_conflict INTEGER,
  	empire VARCHAR(3),
  	sibling_ever INTEGER,
  	sibling INTEGER,
  	sever_year INTEGER,
  	sib_conflict INTEGER,
  	pop_o DOUBLE,
  	pop_d DOUBLE,
  	gdp_o DOUBLE,
  	gdp_d DOUBLE,
  	gdpcap_o DOUBLE,
  	gdpcap_d DOUBLE,
  	pop_source_o DOUBLE,
  	pop_source_d DOUBLE,
  	gdp_source_o DOUBLE,
  	gdp_source_d DOUBLE,
  	gdp_ppp_o DOUBLE,
  	gdp_ppp_d DOUBLE,
  	gdpcap_ppp_o DOUBLE,
  	gdpcap_ppp_d DOUBLE,
  	pop_pwt_o DOUBLE,
  	pop_pwt_d DOUBLE,
  	gdp_ppp_pwt_o DOUBLE,
  	gdp_ppp_pwt_d DOUBLE,
  	gatt_o INTEGER,
  	gatt_d INTEGER,
  	wto_o INTEGER,
  	wto_d INTEGER,
  	eu_o INTEGER,
  	eu_d INTEGER,
  	rta INTEGER,
  	rta_coverage INTEGER,
  	rta_type INTEGER,
  	entry_cost_o DOUBLE,
  	entry_cost_d DOUBLE,
  	entry_proc_o INTEGER,
  	entry_proc_d INTEGER,
  	entry_time_o INTEGER,
  	entry_time_d INTEGER,
  	entry_tp_o INTEGER,
  	entry_tp_d INTEGER,
  	tradeflow_comtrade_o DOUBLE,
  	tradeflow_comtrade_d DOUBLE,
  	tradeflow_baci DOUBLE,
  	manuf_tradeflow_baci DOUBLE,
  	tradeflow_imf_o DOUBLE,
  	tradeflow_imf_d DOUBLE)"
  )

  # add primary keys

  # DBI::dbSendQuery(
  #   con,
  #   "ALTER TABLE cepii_gravity ADD PRIMARY KEY (year, iso3_o, iso3_d)"
  # )

  # add foreign keys

  # DBI::dbSendQuery(
  #   con,
  #   "ALTER TABLE cepii_gravity ADD FOREIGN KEY (iso3_o) REFERENCES cepii_countries(iso3)"
  # )

  # DBI::dbSendQuery(
  #   con,
  #   "ALTER TABLE cepii_gravity ADD FOREIGN KEY (iso3_d) REFERENCES cepii_countries(iso3)"
  # )

  # DBI::dbSendQuery(
  #   con,
  #   "ALTER TABLE cepii_gravity ADD FOREIGN KEY (legal_old_o) REFERENCES cepii_legal_origin(legal_origin_id)"
  # )

  # DBI::dbSendQuery(
  #   con,
  #   "ALTER TABLE cepii_gravity ADD FOREIGN KEY (legal_old_d) REFERENCES cepii_legal_origin(legal_origin_id)"
  # )

  # DBI::dbSendQuery(
  #   con,
  #   "ALTER TABLE cepii_gravity ADD FOREIGN KEY (legal_new_o) REFERENCES cepii_legal_origin(legal_origin_id)"
  # )

  # DBI::dbSendQuery(
  #   con,
  #   "ALTER TABLE cepii_gravity ADD FOREIGN KEY (legal_new_d) REFERENCES cepii_legal_origin(legal_origin_id)"
  # )

  # DBI::dbSendQuery(
  #   con,
  #   "ALTER TABLE cepii_gravity ADD FOREIGN KEY (rta_coverage) REFERENCES cepii_rta_coverage(rta_coverage_id)"
  # )

  # DBI::dbSendQuery(
  #   con,
  #   "ALTER TABLE cepii_gravity ADD FOREIGN KEY (rta_type) REFERENCES cepii_rta_type(rta_type_id)"
  # )

  # USITC ----

  DBI::dbSendQuery(con, "DROP TABLE IF EXISTS usitc_country_names")

  DBI::dbSendQuery(
    con,
    "CREATE TABLE usitc_country_names (
  	country_iso3 CHAR(3),
	  country_dynamic_code VARCHAR(5),
  	country_name VARCHAR)"
  )

  DBI::dbSendQuery(con, "DROP TABLE IF EXISTS usitc_industry_names")

  DBI::dbSendQuery(
    con,
    "CREATE TABLE usitc_industry_names (
  	industry_id INTEGER,
	  industry_descr VARCHAR)"
  )

  DBI::dbSendQuery(con, "DROP TABLE IF EXISTS usitc_sector_names")

  DBI::dbSendQuery(
    con,
    "CREATE TABLE usitc_sector_names (
  	broad_sector_id INTEGER,
	  broad_sector VARCHAR)"
  )

  DBI::dbSendQuery(con, "DROP TABLE IF EXISTS usitc_trade")

  DBI::dbSendQuery(
    con,
    "CREATE TABLE usitc_trade (
  	exporter_iso3 CHAR(3),
  	exporter_dynamic_code VARCHAR(5),
  	importer_iso3 CHAR(3),
  	importer_dynamic_code VARCHAR(5),
  	broad_sector_id INTEGER,
  	industry_id INTEGER,
  	year INTEGER,
  	trade FLOAT,
  	flag_mirror CHAR(1),
  	flag_zero CHAR(1))"
  )

  DBI::dbSendQuery(con, "DROP TABLE IF EXISTS usitc_region_names")

  DBI::dbSendQuery(
    con,
    "CREATE TABLE usitc_region_names (
  	region_id INTEGER,
  	region_name VARCHAR)"
  )

  DBI::dbSendQuery(con, "DROP TABLE IF EXISTS usitc_gravity")

  DBI::dbSendQuery(
    con,
    "CREATE TABLE usitc_gravity (
    year INTEGER,
    iso3_o CHAR(3),
    dynamic_code_o VARCHAR(5),
    iso3_d CHAR(3),
    dynamic_code_d VARCHAR(5),
    colony_of_destination_ever INTEGER,
    colony_of_origin_ever INTEGER,
    colony_ever INTEGER,
    common_colonizer INTEGER,
    common_legal_origin INTEGER,
    contiguity INTEGER,
    distance DOUBLE,
    member_gatt_o INTEGER,
    member_wto_o INTEGER,
    member_eu_o INTEGER,
    member_gatt_d INTEGER,
    member_wto_d INTEGER,
    member_eu_d INTEGER,
    member_gatt_joint INTEGER,
    member_wto_joint INTEGER,
    member_eu_joint INTEGER,
    lat_o DOUBLE,
    lng_o DOUBLE,
    lat_d DOUBLE,
    lng_d DOUBLE,
    landlocked_o INTEGER,
    island_o INTEGER,
    region_id_o INTEGER,
    landlocked_d INTEGER,
    island_d INTEGER,
    region_id_d INTEGER,
    agree_pta_goods INTEGER,
    agree_pta_services INTEGER,
    agree_fta INTEGER,
    agree_eia INTEGER,
    agree_cu INTEGER,
    agree_psa INTEGER,
    agree_fta_eia INTEGER,
    agree_cu_eia INTEGER,
    agree_pta INTEGER,
    capital_const_d DOUBLE,
    capital_const_o DOUBLE,
    capital_cur_d DOUBLE,
    capital_cur_o DOUBLE,
    gdp_pwt_const_d DOUBLE,
    gdp_pwt_const_o DOUBLE,
    gdp_pwt_cur_d DOUBLE,
    gdp_pwt_cur_o DOUBLE,
    pop_d DOUBLE,
    pop_o DOUBLE,
    hostility_level_o INTEGER,
    hostility_level_d INTEGER,
    common_language INTEGER,
    polity_o INTEGER,
    polity_d INTEGER,
    sanction_threat INTEGER,
    sanction_threat_trade INTEGER,
    sanction_imposition INTEGER,
    sanction_imposition_trade INTEGER,
    gdp_wdi_cur_o DOUBLE,
    gdp_wdi_cap_cur_o DOUBLE,
    gdp_wdi_const_o DOUBLE,
    gdp_wdi_cap_const_o DOUBLE,
    gdp_wdi_cur_d DOUBLE,
    gdp_wdi_cap_cur_d DOUBLE,
    gdp_wdi_const_d DOUBLE,
    gdp_wdi_cap_const_d DOUBLE)"
  )

  # add primary keys

  # DBI::dbSendQuery(
  #   con,
  #   "ALTER TABLE usitc_trade ADD PRIMARY KEY (exporter_iso3, importer_iso3, broad_sector_id, industry_id, year)"
  # )

  # DBI::dbSendQuery(
  #   con,
  #   "ALTER TABLE usitc_gravity ADD PRIMARY KEY (year, iso3_o, iso3_d)"
  # )

  # add foreign keys

  # DBI::dbSendQuery(
  #   con,
  #   "ALTER TABLE usitc_gravity ADD FOREIGN KEY (iso3_o) REFERENCES usitc_country_names(country_iso3)"
  # )

  # DBI::dbSendQuery(
  #   con,
  #   "ALTER TABLE usitc_gravity ADD FOREIGN KEY (iso3_d) REFERENCES usitc_country_names(country_iso3)"
  # )

  # DBI::dbSendQuery(
  #   con,
  #   "ALTER TABLE usitc_gravity ADD FOREIGN KEY (dynamic_code_o) REFERENCES usitc_country_names(country_dynamic_code)"
  # )

  # DBI::dbSendQuery(
  #   con,
  #   "ALTER TABLE usitc_gravity ADD FOREIGN KEY (dynamic_code_d) REFERENCES usitc_country_names(country_dynamic_code)"
  # )

  # DBI::dbSendQuery(
  #   con,
  #   "ALTER TABLE usitc_gravity ADD FOREIGN KEY (region_id_o) REFERENCES usitc_region_names(region_id)"
  # )

  # DBI::dbSendQuery(
  #   con,
  #   "ALTER TABLE usitc_gravity ADD FOREIGN KEY (region_id_d) REFERENCES usitc_region_names(region_id)"
  # )

  # DBI::dbSendQuery(
  #   con,
  #   "ALTER TABLE usitc_trade ADD FOREIGN KEY (exporter_iso3) REFERENCES usitc_country_names(country_iso3)"
  # )

  # DBI::dbSendQuery(
  #   con,
  #   "ALTER TABLE usitc_trade ADD FOREIGN KEY (importer_iso3) REFERENCES usitc_country_names(country_iso3)"
  # )

  # DBI::dbSendQuery(
  #   con,
  #   "ALTER TABLE usitc_trade ADD FOREIGN KEY (exporter_dynamic_code) REFERENCES usitc_country_names(country_dynamic_code)"
  # )

  # DBI::dbSendQuery(
  #   con,
  #   "ALTER TABLE usitc_trade ADD FOREIGN KEY (importer_dynamic_code) REFERENCES usitc_country_names(country_dynamic_code)"
  # )

  # DBI::dbSendQuery(
  #   con,
  #   "ALTER TABLE usitc_trade ADD FOREIGN KEY (broad_sector_id) REFERENCES usitc_sector_names(broad_sector_id)"
  # )

  # WTO ----

  DBI::dbSendQuery(con, "DROP TABLE IF EXISTS wto_trade")

  DBI::dbSendQuery(
    con,
    "CREATE TABLE wto_trade (
    pair_id INTEGER,
    year INTEGER,
    exporter_iso3 CHAR(3),
    importer_iso3 CHAR(3),
    trade DOUBLE)"
  )

  DBI::dbSendQuery(con, "DROP TABLE IF EXISTS wto_country_names")

  DBI::dbSendQuery(
    con,
    "CREATE TABLE wto_country_names (
    country_iso3 CHAR(3),
    country_name VARCHAR(255))"
  )

  # disconnect ----

  DBI::dbDisconnect(con, shutdown = TRUE)
  gc()
}
