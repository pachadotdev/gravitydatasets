library(archive)
library(readr)
library(dplyr)
library(tidyr)
library(purrr)
library(RPostgres)

url <- "https://www.usitc.gov/data/gravity/itpd_e/itpd_e_r02.zip"
url2 <- "https://www.usitc.gov/data/gravity/dgd_docs/release_2.1_1948_1999.zip"
url3 <- "https://www.usitc.gov/data/gravity/dgd_docs/release_2.1_2000_2019.zip"

finp <- "finp/"

zip <- gsub(".*/", finp, url)
zip2 <- gsub(".*/", finp, url2)
zip3 <- gsub(".*/", finp, url3)

try(dir.create(finp, recursive = T))

if (!file.exists(zip)) {
  try(download.file(url, zip, method = "wget", quiet = T))
}

if (!file.exists(zip2)) {
  try(download.file(url2, zip2, method = "wget", quiet = T))
}

if (!file.exists(zip3)) {
  try(download.file(url3, zip3, method = "wget", quiet = T))
}

if (!length(list.files(finp, pattern = "csv")) > 1) {
  archive_extract(zip, dir = finp)
  archive_extract(zip2, dir = finp)
  archive_extract(zip3, dir = finp)
}

# Trade ----

trade <- read_csv(paste0(finp, "/ITPD_E_R02.csv"))

country_names <- trade %>%
  select(
    country_iso3 = exporter_iso3,
    country_dynamic_code = exporter_dynamic_code,
    country_name = exporter_name
  ) %>%
  distinct() %>%
  bind_rows(
    trade %>%
      select(
        country_iso3 = importer_iso3,
        country_dynamic_code = importer_dynamic_code,
        country_name = importer_name
      ) %>%
      distinct()
  ) %>%
  distinct() %>%
  arrange(country_iso3)

# keep Cambodia and Western Samoa only

# country_names %>% group_by(country_iso3, country_dynamic_code) %>% count() %>% filter(n > 1) %>% inner_join(country_names)

country_names <- country_names %>%
  filter(!country_name %in% c("Kampuchea", "Samoa"))

trade <- trade %>%
  select(-exporter_name, -importer_name)

industry_names <- trade %>%
  select(industry_id, industry_descr) %>%
  distinct()

sector_names <- trade %>%
  select(broad_sector) %>%
  distinct() %>%
  arrange(broad_sector) %>%
  mutate(broad_sector_id = row_number()) %>%
  select(broad_sector_id, broad_sector)

sector_names_2 <- trade %>%
  select(broad_sector) %>%
  inner_join(sector_names)

trade <- trade %>%
  select(-broad_sector, -industry_descr)

trade <- trade %>%
  bind_cols(sector_names_2) %>%
  select(exporter_iso3:importer_dynamic_code, broad_sector_id, industry_id:flag_zero)

# trade2 <- trade %>%
#   select(year, exporter_dynamic_code, importer_dynamic_code, industry_id) %>%
#   group_by(year) %>%
#   nest()
#
# trade2 <- map_df(
#   trade2 %>% pull(year),
#   function(y) {
#     message(y)
#
#     trade2 %>%
#       filter(year == y) %>%
#       unnest(cols = data) %>%
#       group_by(exporter_dynamic_code, importer_dynamic_code, industry_id) %>%
#       count() %>%
#       filter(n > 1)
#   }
# )
#
# trade2

con <- dbConnect(
  Postgres(),
  user = Sys.getenv("LOCAL_SQL_USR"),
  password = Sys.getenv("LOCAL_SQL_PWD"),
  dbname = "gravitydatasets",
  host = "localhost"
)

DBI::dbSendQuery(con, "DROP TABLE IF EXISTS usitc_country_names")

DBI::dbSendQuery(
  con,
  "CREATE TABLE usitc_country_names (
  	country_iso3 CHAR(3),
	  country_dynamic_code VARCHAR(5),
  	country_name VARCHAR,
  	CONSTRAINT usitc_country_names_PK PRIMARY KEY (country_dynamic_code)
    )"
)

DBI::dbSendQuery(con, "DROP TABLE IF EXISTS usitc_industry_names")

DBI::dbSendQuery(
  con,
  "CREATE TABLE usitc_industry_names (
  	industry_id INTEGER,
	  industry_descr VARCHAR,
	  CONSTRAINT usitc_industry_names_PK PRIMARY KEY (industry_id)
    )"
)

DBI::dbSendQuery(con, "DROP TABLE IF EXISTS usitc_sector_names")

DBI::dbSendQuery(
  con,
  "CREATE TABLE usitc_sector_names (
  	broad_sector_id INTEGER,
	  broad_sector VARCHAR,
	  CONSTRAINT usitc_sector_names_PK PRIMARY KEY (broad_sector_id)
    )"
)

DBI::dbSendQuery(con, "DROP TABLE IF EXISTS usitc_trade")

DBI::dbSendQuery(
  con,
  "CREATE TABLE usitc_trade (
    year INTEGER,
  	exporter_iso3 CHAR(3),
  	exporter_dynamic_code VARCHAR(5),
  	importer_iso3 CHAR(3),
  	importer_dynamic_code VARCHAR(5),
  	broad_sector_id INTEGER,
  	industry_id INTEGER,
  	trade FLOAT,
  	flag_mirror CHAR(1),
  	flag_zero CHAR(1),
    CONSTRAINT usitc_trade_PK PRIMARY KEY (exporter_dynamic_code, importer_dynamic_code, industry_id, year),
  	CONSTRAINT usitc_trade_FK1 FOREIGN KEY (exporter_dynamic_code) REFERENCES usitc_country_names(country_dynamic_code),
  	CONSTRAINT usitc_trade_FK2 FOREIGN KEY (importer_dynamic_code) REFERENCES usitc_country_names(country_dynamic_code),
  	CONSTRAINT usitc_trade_FK3 FOREIGN KEY (broad_sector_id) REFERENCES usitc_sector_names(broad_sector_id),
  	CONSTRAINT usitc_trade_FK4 FOREIGN KEY (industry_id) REFERENCES usitc_industry_names(industry_id)
  	)"
)

dbWriteTable(con, "usitc_country_names", country_names, append = T)
dbWriteTable(con, "usitc_industry_names", industry_names, append = T)
dbWriteTable(con, "usitc_sector_names", sector_names, append = T)

yrs <- min(trade$year):max(trade$year)

N <- 2000000

trade <- trade %>%
  select(year, everything()) %>%
  mutate(p = floor(row_number() / N) + 1) %>%
  group_by(p) %>%
  nest() %>%
  ungroup() %>%
  select(data) %>%
  pull()

map(
  seq_along(trade),
  function(x) {
    message(sprintf("Writing fragment %s of %s", x, length(trade)))
    dbWriteTable(con, "usitc_trade", trade[[x]], append = T)
  }
)

rm(trade, industry_names, sector_names, sector_names_2)
gc()

# Gravity ----

csv_gravity <- list.files(finp, pattern = "release_2\\.1_[0-9][0-9][0-9][0-9]_[0-9][0-9][0-9][0-9]\\.csv", full.names = T)

# yrs <- 1986:2019
# country_names <- read_tsv("fout/usitc_country_names.tsv")

gravity <- map_df(
  rev(csv_gravity),
  function(f) {
    message(f)
    read_csv(f) %>%
      filter(year %in% yrs) %>%
      select(-country_o, -country_d) %>%
      inner_join(
        country_names %>%
          select(country_iso3, country_dynamic_code),
        by = c("iso3_o" = "country_iso3", "dynamic_code_o" = "country_dynamic_code")
      ) %>%
      inner_join(
        country_names %>%
          select(country_iso3, country_dynamic_code),
        by = c("iso3_d" = "country_iso3", "dynamic_code_d" = "country_dynamic_code")
      )
  }
)

region_names <- gravity %>%
  select(region = region_o) %>%
  distinct() %>%
  bind_rows(
    gravity %>%
      select(region = region_d) %>%
      distinct()
  ) %>%
  filter(region != "") %>%
  distinct() %>%
  arrange(region) %>%
  mutate(region_id = row_number()) %>%
  select(region_id, region)

gravity <- gravity %>%
  left_join(
    region_names %>%
      select(region_o = region, region_id_o = region_id)
  ) %>%
  left_join(
    region_names %>%
      select(region_d = region, region_id_d = region_id)
  )

gravity <- gravity %>%
  select(
    year:island_o, region_id_o, landlocked_d:island_d,
    region_id_d, agree_pta_goods:gdp_wdi_cap_const_d
  )

# fix region codes

region_names <- region_names %>%
  mutate(region = gsub("suth_", "south_", region))

region_names <- region_names %>%
  filter(region_id != 15)

region_names <- region_names %>%
  rename(region_name = region)

gravity <- gravity %>%
  mutate(
    region_id_o = ifelse(region_id_o == 15L, 13L, region_id_o),
    region_id_d = ifelse(region_id_d == 15L, 13L, region_id_d)
  )

gravity <- map_df(
  sort(unique(gravity$year)),
  function(y) {
    message(y)

    cols <- colnames(gravity)

    cols_id <- grep("^year$|^iso3_o$|^iso3_d$|^dynamic_code_o$|^dynamic_code_d$", cols, value = T)
    cols_sym <- grep("^year$|_o$|_d$|^colony_of", cols, value = T, invert = T)
    cols_nsym <- setdiff(cols, cols_sym)

    dy_sym <- gravity %>%
      filter(year == y) %>%
      select(all_of(c(cols_id, cols_sym))) %>%
      collect()

    dy_sym <- dy_sym %>%
      bind_rows(
        dy_sym %>%
          select(
            iso3_o = iso3_d, iso3_d = iso3_o,
            dynamic_code_o = dynamic_code_d, dynamic_code_d = dynamic_code_o,
            everything()
          )
      ) %>%
      group_by(year, iso3_o, iso3_d, dynamic_code_o, dynamic_code_d) %>%
      mutate(n = paste0("n", row_number()))

    dy_sym <- dy_sym %>%
      pivot_longer(colony_ever:sanction_imposition_trade) %>%
      pivot_wider(names_from = n, values_from = value) %>%
      mutate(value = pmax(n1, n2, na.rm = T)) %>%
      select(-n1, -n2)

    dy_sym <- dy_sym %>%
      pivot_wider(names_from = name, values_from = value)

    dy_nsym <- gravity %>%
      filter(year == y) %>%
      select(all_of(c(cols_nsym))) %>%
      collect()

    dy_nsym <- dy_nsym %>%
      full_join(
        dy_nsym %>%
          select(
            year,
            iso3_o = iso3_d,
            dynamic_code_o = dynamic_code_d,
            iso3_d = iso3_o,
            dynamic_code_d = dynamic_code_o,
            colony_of_origin_ever = colony_of_destination_ever,
            colony_of_destination_ever = colony_of_origin_ever,
            member_gatt_o = member_gatt_d,
            member_gatt_d = member_gatt_o,
            member_wto_o = member_wto_d,
            member_wto_d = member_wto_o,
            member_eu_o = member_eu_d,
            member_eu_d = member_eu_o,
            lat_o = lat_d,
            lat_d = lat_o,
            lng_o = lng_d,
            lng_d = lng_o,
            landlocked_o = landlocked_d,
            landlocked_d = landlocked_o,
            island_o = island_d,
            island_d = island_o,
            region_id_o = region_id_d,
            region_id_d = region_id_o,
            capital_const_o = capital_const_d,
            capital_const_d = capital_const_o,
            capital_cur_o = capital_cur_d,
            capital_cur_d = capital_cur_o,
            gdp_pwt_const_o = gdp_pwt_const_d,
            gdp_pwt_const_d = gdp_pwt_const_o,
            gdp_pwt_cur_o = gdp_pwt_cur_d,
            gdp_pwt_cur_d = gdp_pwt_cur_o,
            pop_o = pop_d,
            pop_d = pop_o,
            hostility_level_o = hostility_level_d,
            hostility_level_d = hostility_level_o,
            polity_o = polity_d,
            polity_d = polity_o,
            gdp_wdi_cur_o = gdp_wdi_cur_d,
            gdp_wdi_cur_d = gdp_wdi_cur_o,
            gdp_wdi_cap_cur_o = gdp_wdi_cap_cur_d,
            gdp_wdi_cap_cur_d = gdp_wdi_cap_cur_o,
            gdp_wdi_const_o = gdp_wdi_const_d,
            gdp_wdi_const_d = gdp_wdi_const_o,
            gdp_wdi_cap_const_o = gdp_wdi_cap_const_d,
            gdp_wdi_cap_const_d = gdp_wdi_cap_const_o
          ),
        by = c("year", "iso3_o", "iso3_d", "dynamic_code_o", "dynamic_code_d")
      )

    dy_nsym <- dy_nsym %>%
      pivot_longer(colony_of_destination_ever.x:gdp_wdi_cap_const_d.y) %>%
      separate(name, c("name1", "name2"), sep = "\\.")

    dy_nsym <- dy_nsym %>%
      pivot_wider(names_from = name2, values_from = value) %>%
      mutate(value = pmax(x, y, na.rm = T)) %>%
      select(-x, -y)

    dy_nsym <- dy_nsym %>%
      pivot_wider(names_from = name1, values_from = value)

    dy <- dy_sym %>%
      inner_join(dy_nsym) %>%
      select(all_of(cols))

    rm(dy_sym, dy_nsym)

    return(dy)
  }
)

DBI::dbSendQuery(con, "DROP TABLE IF EXISTS usitc_region_names")

DBI::dbSendQuery(
  con,
  "CREATE TABLE usitc_region_names (
  	region_id INTEGER,
  	region_name VARCHAR,
  	CONSTRAINT usitc_region_names_PK PRIMARY KEY (region_id)
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
    distance FLOAT8,
    member_gatt_o INTEGER,
    member_wto_o INTEGER,
    member_eu_o INTEGER,
    member_gatt_d INTEGER,
    member_wto_d INTEGER,
    member_eu_d INTEGER,
    member_gatt_joint INTEGER,
    member_wto_joint INTEGER,
    member_eu_joint INTEGER,
    lat_o FLOAT8,
    lng_o FLOAT8,
    lat_d FLOAT8,
    lng_d FLOAT8,
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
    capital_const_d FLOAT8,
    capital_const_o FLOAT8,
    capital_cur_d FLOAT8,
    capital_cur_o FLOAT8,
    gdp_pwt_const_d FLOAT8,
    gdp_pwt_const_o FLOAT8,
    gdp_pwt_cur_d FLOAT8,
    gdp_pwt_cur_o FLOAT8,
    pop_d FLOAT8,
    pop_o FLOAT8,
    hostility_level_o INTEGER,
    hostility_level_d INTEGER,
    common_language INTEGER,
    polity_o INTEGER,
    polity_d INTEGER,
    sanction_threat INTEGER,
    sanction_threat_trade INTEGER,
    sanction_imposition INTEGER,
    sanction_imposition_trade INTEGER,
    gdp_wdi_cur_o FLOAT8,
    gdp_wdi_cap_cur_o FLOAT8,
    gdp_wdi_const_o FLOAT8,
    gdp_wdi_cap_const_o FLOAT8,
    gdp_wdi_cur_d FLOAT8,
    gdp_wdi_cap_cur_d FLOAT8,
    gdp_wdi_const_d FLOAT8,
    gdp_wdi_cap_const_d FLOAT8,
    CONSTRAINT usitc_gravity_PK PRIMARY KEY (year, dynamic_code_o, dynamic_code_d),
  	CONSTRAINT usitc_gravity_FK1 FOREIGN KEY (dynamic_code_o) REFERENCES usitc_country_names(country_dynamic_code),
  	CONSTRAINT usitc_gravity_FK2 FOREIGN KEY (dynamic_code_d) REFERENCES usitc_country_names(country_dynamic_code),
  	CONSTRAINT usitc_gravity_FK3 FOREIGN KEY (region_id_o) REFERENCES usitc_region_names(region_id),
  	CONSTRAINT usitc_gravity_FK4 FOREIGN KEY (region_id_d) REFERENCES usitc_region_names(region_id)
    )"
)

dbWriteTable(con, "usitc_region_names", region_names, append = T)
dbWriteTable(con, "usitc_gravity", gravity, append = T)

rm(gravity, region_names)

dbDisconnect(con)

gc()
