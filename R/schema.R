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
  	legal_origin VARCHAR,
    PRIMARY KEY (legal_origin_id)
    )"
  )

  DBI::dbSendQuery(con, "DROP TABLE IF EXISTS cepii_rta_type")

  DBI::dbSendQuery(
    con,
    "CREATE TABLE cepii_rta_type (
  	rta_type_id INTEGER,
  	rta_type_description VARCHAR,
    PRIMARY KEY (rta_type_id)
    )"
  )

  DBI::dbSendQuery(con, "DROP TABLE IF EXISTS cepii_rta_coverage")

  DBI::dbSendQuery(
    con,
    "CREATE TABLE cepii_rta_coverage (
  	rta_coverage_id INTEGER,
    rta_coverage_description VARCHAR,
    PRIMARY KEY (rta_coverage_id)
    )"
  )

  DBI::dbSendQuery(con, "DROP TABLE IF EXISTS cepii_country_information")

  DBI::dbSendQuery(
    con,
    "CREATE TABLE cepii_country_information (
  	iso3 VARCHAR(3),
  	iso3num INTEGER,
    iso3_dynamic VARCHAR(5),
  	country VARCHAR,
  	countrylong VARCHAR,
  	first_year INTEGER,
  	last_year INTEGER,
  	countrygroup_iso3 VARCHAR(3),
  	countrygroup_iso3num INTEGER,
  	PRIMARY KEY (iso3_dynamic)
    )"
  )

  DBI::dbSendQuery(con, "DROP TABLE IF EXISTS cepii_gravity")

  DBI::dbSendQuery(
    con,
    "CREATE TABLE cepii_gravity (
  	year INTEGER,
  	iso3_o VARCHAR(3),
    iso3num_o INTEGER,
    iso3_o_dynamic VARCHAR(5),
    iso3_d VARCHAR(3),
  	iso3num_d INTEGER,
    iso3_d_dynamic VARCHAR(5),
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
  	tradeflow_imf_d DOUBLE,
    FOREIGN KEY (iso3_o_dynamic) REFERENCES cepii_country_information(iso3_dynamic),
    FOREIGN KEY (iso3_d_dynamic) REFERENCES cepii_country_information(iso3_dynamic),
    FOREIGN KEY (legal_old_o) REFERENCES cepii_legal_origin(legal_origin_id),
    FOREIGN KEY (legal_old_d) REFERENCES cepii_legal_origin(legal_origin_id),
    FOREIGN KEY (legal_new_o) REFERENCES cepii_legal_origin(legal_origin_id),
    FOREIGN KEY (legal_new_d) REFERENCES cepii_legal_origin(legal_origin_id),
    FOREIGN KEY (rta_coverage) REFERENCES cepii_rta_coverage(rta_coverage_id),
    FOREIGN KEY (rta_type) REFERENCES cepii_rta_type(rta_type_id)
    )"
  )

  # USITC ----

  DBI::dbSendQuery(con, "DROP TABLE IF EXISTS usitc_country_names")

  DBI::dbSendQuery(
    con,
    "CREATE TABLE usitc_country_names (
  	country_iso3 CHAR(3),
	  country_dynamic_code VARCHAR(5),
  	country_name VARCHAR,
  	PRIMARY KEY (country_dynamic_code)
    )"
  )

  DBI::dbSendQuery(con, "DROP TABLE IF EXISTS usitc_industry_names")

  DBI::dbSendQuery(
    con,
    "CREATE TABLE usitc_industry_names (
  	industry_id INTEGER,
	  industry_descr VARCHAR,
	  PRIMARY KEY (industry_id)
    )"
  )

  DBI::dbSendQuery(con, "DROP TABLE IF EXISTS usitc_sector_names")

  DBI::dbSendQuery(
    con,
    "CREATE TABLE usitc_sector_names (
  	broad_sector_id INTEGER,
	  broad_sector VARCHAR,
	  PRIMARY KEY (broad_sector_id)
    )"
  )

  DBI::dbSendQuery(con, "DROP TABLE IF EXISTS usitc_region_names")

  DBI::dbSendQuery(
    con,
    "CREATE TABLE usitc_region_names (
  	region_id INTEGER,
  	region_name VARCHAR,
  	PRIMARY KEY (region_id)
    )"
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
  	flag_zero CHAR(1),
  	FOREIGN KEY (exporter_dynamic_code) REFERENCES usitc_country_names(country_dynamic_code),
  	FOREIGN KEY (importer_dynamic_code) REFERENCES usitc_country_names(country_dynamic_code),
  	FOREIGN KEY (broad_sector_id) REFERENCES usitc_sector_names(broad_sector_id),
  	FOREIGN KEY (industry_id) REFERENCES usitc_industry_names(industry_id)
  	)"
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
    gdp_wdi_cap_const_d DOUBLE,
    FOREIGN KEY (dynamic_code_o) REFERENCES usitc_country_names(country_dynamic_code),
    FOREIGN KEY (dynamic_code_d) REFERENCES usitc_country_names(country_dynamic_code),
    FOREIGN KEY (region_id_o) REFERENCES usitc_region_names(region_id),
  	FOREIGN KEY (region_id_d) REFERENCES usitc_region_names(region_id)
    )"
  )

  # WTO ----

  DBI::dbSendQuery(con, "DROP TABLE IF EXISTS wto_country_names")

  DBI::dbSendQuery(
    con,
    "CREATE TABLE wto_country_names (
    country_iso3 CHAR(3),
    country_name VARCHAR(255),
    PRIMARY KEY (country_iso3)
    )"
  )

  DBI::dbSendQuery(con, "DROP TABLE IF EXISTS wto_trade")

  DBI::dbSendQuery(
    con,
    "CREATE TABLE wto_trade (
    pair_id INTEGER,
    year INTEGER,
    exporter_iso3 CHAR(3),
    importer_iso3 CHAR(3),
    trade DOUBLE,
    FOREIGN KEY (exporter_iso3) REFERENCES wto_country_names(country_iso3),
    FOREIGN KEY (importer_iso3) REFERENCES wto_country_names(country_iso3)
    )"
  )

  # disconnect ----

  DBI::dbDisconnect(con, shutdown = TRUE)
  gc()
}
