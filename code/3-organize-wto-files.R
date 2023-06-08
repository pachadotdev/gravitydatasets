library(archive)
library(haven)
library(dplyr)
library(tidyr)
library(purrr)
library(readr)
library(RPostgres)

finp <- "finp/"

try(dir.create(finp, recursive = T))

url <- "https://www.wto.org/english/res_e/reser_e/structural.gravity.manufacturing.database.Ver1.zip"
zip <- gsub(".*/", finp, url)

if (!file.exists(zip)) {
  download.file(url, zip)
}

if (!file.exists("finp/Structural.gravity.manufacturing.database.Ver1.dta")) {
  archive_extract(url, dir = finp)
}

trade <- read_dta(paste0(finp, "Structural.gravity.manufacturing.database.Ver1.dta")) %>%
  mutate_if(is.character, function(x) ifelse(x == "", NA, x)) %>%
  rename(
    exporter_iso3 = exporter,
    importer_iso3 = importer
  )

con <- dbConnect(
  Postgres(),
  user = Sys.getenv("LOCAL_SQL_USR"),
  password = Sys.getenv("LOCAL_SQL_PWD"),
  dbname = "gravitydatasets",
  host = "localhost"
)

DBI::dbSendQuery(con, "DROP TABLE IF EXISTS wto_country_names")

DBI::dbSendQuery(
  con,
  "CREATE TABLE wto_country_names (
    country_iso3 CHAR(3),
    country_name VARCHAR(255),
    CONSTRAINT wto_country_names_PK PRIMARY KEY (country_iso3)
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
    trade FLOAT8,
    CONSTRAINT wto_trade_FK1 FOREIGN KEY (exporter_iso3) REFERENCES wto_country_names(country_iso3),
    CONSTRAINT wto_trade_FK2 FOREIGN KEY (importer_iso3) REFERENCES wto_country_names(country_iso3)
    )"
)

usitc_country_names <- tbl(con, "usitc_country_names") %>%
  collect() %>%
  select(country_iso3, country_name) %>%
  distinct()

country_names <- trade %>%
  distinct(country_iso3 = exporter_iso3) %>%
  bind_rows(
    trade %>%
      distinct(country_iso3 = importer_iso3)
  ) %>%
  distinct() %>%
  arrange() %>%
  left_join(usitc_country_names)

# See https://wits.worldbank.org/wits/wits/witshelp/content/codes/country_codes.htm
country_names <- country_names %>%
  mutate(
    country_name = case_when(
      country_iso3 == "ROM" ~ "Romania",
      country_iso3 == "TMP" ~ "East Timor",
      country_iso3 == "YDR" ~ "Yemen, Democratic Republic of",
      country_iso3 == "ZAR" ~ "Congo, Democratic Republic of",
      TRUE ~ country_name
    )
  )

# country_names %>%
#     group_by(country_iso3) %>%
#     count() %>%
#     filter(n > 1)

# trade %>%
#     group_by(year, exporter_iso3, importer_iso3) %>%
#     count() %>%
#     filter(n > 1)

# country_names %>%
#     filter(country_iso3 %in% c("DEU", "MMR", "YEM"))

country_names <- country_names %>%
  filter(!country_name %in% c("West Germany", "Yemen, North", "Burma"))

dbWriteTable(con, "wto_country_names", country_names, append = T)

dbWriteTable(con, "wto_trade", trade, append = T)

rm(trade, country_names)

dbDisconnect(con)

gc()
