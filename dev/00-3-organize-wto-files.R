library(archive)
library(haven)
library(dplyr)
library(readr)

finp <- "dev/finp/"
fout <- "dev/fout/"

url <- "https://www.wto.org/english/res_e/reser_e/structural.gravity.manufacturing.database.Ver1.zip"
zip <- gsub(".*/", finp, url)

if (!file.exists(zip)) {
    download.file(url, zip)
    archive_extract(url, dir = finp)
}

trade <- read_dta(paste0(finp, "Structural.gravity.manufacturing.database.Ver1.dta")) %>%
    mutate_if(is.character, function(x) ifelse(x == "", NA, x)) %>%
    rename(
        exporter_iso3 = exporter,
        importer_iso3 = importer
    )

country_names <- trade %>%
    distinct(country_iso3 = exporter_iso3) %>%
    bind_rows(
        trade %>%
            distinct(country_iso3 = importer_iso3)
    ) %>%
    distinct() %>%
    arrange() %>%
    left_join(
        read_tsv(paste0(fout, "usitc_country_names.tsv")) %>%
            select(country_iso3, country_name) %>%
            distinct()
    )

country_names %>%
    filter(is.na(country_name))

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

write_tsv(trade, paste0(fout, "wto_trade.tsv"), na = "")
write_tsv(country_names, paste0(fout, "wto_country_names.tsv"), na = "")
