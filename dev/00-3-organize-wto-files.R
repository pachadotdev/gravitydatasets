library(archive)
library(haven)
library(dplyr)
library(tidyr)
library(purrr)
library(readr)

finp <- "dev/finp/"
fout <- "dev/fout/"

try(dir.create(finp, recursive = T))
try(dir.create(fout, recursive = T))

url <- "https://www.wto.org/english/res_e/reser_e/structural.gravity.manufacturing.database.Ver1.zip"
zip <- gsub(".*/", finp, url)

if (!file.exists(zip)) {
  download.file(url, zip)
}

if (!file.exists("dev/finp/Structural.gravity.manufacturing.database.Ver1.dta")) {
  archive_extract(url, dir = finp)
}

trade <- read_dta(paste0(finp, "Structural.gravity.manufacturing.database.Ver1.dta")) %>%
  mutate_if(is.character, function(x) ifelse(x == "", NA, x)) %>%
  rename(
    exporter_iso3 = exporter,
    importer_iso3 = importer
  )

usitc_country_names <- read_tsv("dev/fout/usitc_country_names.tsv") %>%
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

write_tsv(country_names, paste0(fout, "wto_country_names.tsv"), na = "")

N <- 2000000

trade <- trade %>%
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
    write_tsv(trade[[x]], sprintf("dev/fout/wto_trade_part%s.tsv", ifelse(nchar(x) == 1, paste0("0", x), x)), na = "")
  }
)

rm(trade, country_names)
gc()
