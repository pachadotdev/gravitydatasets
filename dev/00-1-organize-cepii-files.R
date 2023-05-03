library(archive)
library(readr)
library(purrr)
library(haven)
library(janitor)
library(dplyr)
library(tidyr)
library(stringr)

try(dir.create("dev/finp", recursive = T))
try(dir.create("dev/fout", recursive = T))

# download ----

# contains inconsistency (rta type = 8 when the index is 1,...,7)
# url_data <- "http://www.cepii.fr/DATA_DOWNLOAD/gravity/legacy/202102/Gravity_dta_V202102.zip"

url_data <- "http://www.cepii.fr/DATA_DOWNLOAD/gravity/data/Gravity_dta_V202211.zip"

url_docs <- "http://www.cepii.fr/DATA_DOWNLOAD/gravity/legacy/202102/Gravity_documentation.pdf"

zip_data <- gsub(".*/", "dev/finp/", url_data)
pdf_docs <- gsub(".*/", "dev/finp/", url_docs)

map2(
  c(url_data, url_docs),
  c(zip_data, pdf_docs),
  function(x, y) {
    if (!file.exists(y)) {
      try(
        download.file(x, y)
      )
    }
  }
)

finp <- list.files("dev/finp", pattern = "V202211\\.dta", full.names = T)

if (length(finp) == 0L) {
  archive_extract(zip_data, dir = "dev/finp")
}

# tidy ----

finp <- list.files("dev/finp", pattern = "V202211\\.dta", full.names = T)

countries <- read_stata(finp[1]) %>%
  clean_names() %>%
  # mutate(iso3 = tolower(iso3)) %>%
  mutate_if(is.character, function(x) ifelse(x == "", NA, x))

# to create primary key later, this will remove Malaysia+Singapore
countries <- countries %>%
  filter(!is.na(iso3))

# countries %>%
#   group_by(iso3) %>%
#   count() %>%
#   filter(n > 1)

# countries <- countries %>%
#   mutate(
#     iso3_dynamic = case_when(
#       iso3 == "ANT" & iso3num == 532L ~ "ANT.X", # Netherlands Antilles + Aruba up to 1986
#       iso3 == "DEU" & iso3num == 280L ~ "DEU.X", # West Germany up to 1990
#       iso3 == "ETH" & iso3num == 230L ~ "ETF", # Ethiopia + Eritrea up to 1993
#       iso3 == "IDN" & country == "Indonesia + Timor-Leste" ~ "IDN.X", # up to 2002
#       iso3 == "PAK" & country == "Pakistan + Bangladesh" ~ "PAK.X", # up to 1971
#       iso3 == "SDN" & iso3num == 736L ~ "SDN.X", # Sudan + South Sudan before 2011
#       iso3 == "VNM" & country == "South Vietnam" ~ "VNM.X", # Vietnam up to 1976
#       iso3 == "YEM" & country == "North Yemen" ~ "YEM.X", # Yemen up to 1990
#       TRUE ~ iso3
#     )
#   )

# countries <- countries %>%
#   select(iso3, iso3num, iso3_dynamic, everything())

# unique(nchar(countries$iso3))

gravity <- read_stata(finp[2]) %>%
  clean_names() %>%
  # mutate(
  #   iso3_o = tolower(iso3_o),
  #   iso3_d = tolower(iso3_d)
  # ) %>%
  mutate_if(is.character, function(x) ifelse(x == "", NA, x))

unique(nchar(gravity$iso3_o))
unique(nchar(gravity$iso3_d))

# descriptions -----

attr(countries[[1]], "label") <- "ISO3 alphabetic"

countries_desc <- tibble(
  variable = colnames(countries),
  description = map_chr(
    seq_along(colnames(countries)),
    function(x) {
      y <- attr(countries[[x]], "label")
      if (is.null(y)) y <- NA
      return(y)
    }
  )
)

attr(gravity[[2]], "label") <- "Origin ISO3 alphabetic"
attr(gravity[[3]], "label") <- "Destination ISO3 alphabetic"
attr(gravity[[34]], "label") <- "Common colonizer"

gravity_desc <- tibble(
  variable = colnames(gravity),
  description = map_chr(
    seq_along(colnames(gravity)),
    function(x) {
      y <- attr(gravity[[x]], "label")
      if (is.null(y)) y <- NA
      return(y)
    }
  )
)

knitr::kable(countries_desc)

knitr::kable(gravity_desc)

legal <- tibble(
  legal_origin_id = 1L:5L,
  legal_origin = c("French (FR)", "German (GE)", "Scandinavian (SC)", "Socialist (SO)", "English (UK)")
)

unique(gravity$legal_old_o)
unique(gravity$legal_old_d)

gravity <- gravity %>%
  mutate(
    legal_old_o = case_when(
      legal_old_o == 1 ~ "French (FR)",
      legal_old_o == 2 ~ "Socialist (SO)",
      legal_old_o == 3 ~ "English (UK)",
      legal_old_o == 4 ~ "German (GE)",
      legal_old_o == 5 ~ "Scandinavian (SC)",
      TRUE ~ NA_character_
    ),
    legal_old_d = case_when(
      legal_old_d == 1 ~ "French (FR)",
      legal_old_d == 2 ~ "Socialist (SO)",
      legal_old_d == 3 ~ "English (UK)",
      legal_old_d == 4 ~ "German (GE)",
      legal_old_d == 5 ~ "Scandinavian (SC)",
      TRUE ~ NA_character_
    )
  )

unique(gravity$legal_new_o)
unique(gravity$legal_new_d)

gravity <- gravity %>%
  mutate(
    legal_new_o = case_when(
      legal_new_o == 1 ~ "French (FR)",
      legal_new_o == 2 ~ "English (UK)",
      legal_new_o == 3 ~ "German (GE)",
      legal_new_o == 4 ~ "Scandinavian (SC)",
      legal_new_o == 5 ~ "Socialist (SO)",
      TRUE ~ NA_character_
    ),
    legal_new_d = case_when(
      legal_new_d == 1 ~ "French (FR)",
      legal_new_d == 2 ~ "English (UK)",
      legal_new_d == 3 ~ "German (GE)",
      legal_new_d == 4 ~ "Scandinavian (SC)",
      legal_new_d == 5 ~ "Socialist (SO)",
      TRUE ~ NA_character_
    )
  )

cols <- colnames(gravity)

gc()

# by parts or it crashes

gravity <- gravity %>%
  left_join(legal %>% rename(legal_old_o = legal_origin), by = "legal_old_o") %>%
  select(-legal_old_o) %>%
  rename(legal_old_o = legal_origin_id)

gravity <- gravity %>%
  left_join(legal %>% rename(legal_old_d = legal_origin), by = "legal_old_d") %>%
  select(-legal_old_d) %>%
  rename(legal_old_d = legal_origin_id)

gravity <- gravity %>%
  left_join(legal %>% rename(legal_new_o = legal_origin), by = "legal_new_o") %>%
  select(-legal_new_o) %>%
  rename(legal_new_o = legal_origin_id)

gravity <- gravity %>%
  left_join(legal %>% rename(legal_new_d = legal_origin), by = "legal_new_d") %>%
  select(-legal_new_d) %>%
  rename(legal_new_d = legal_origin_id)

gravity <- gravity %>%
  select(all_of(cols))

attr(gravity[["rta_coverage"]], "labels")

rta_coverage <- tibble(
  rta_coverage_id = as.integer(attr(gravity[["rta_coverage"]], "labels")),
  rta_coverage_description = names(attr(gravity[["rta_coverage"]], "labels"))
)

rta_type <- tibble(
  rta_type_id = as.integer(attr(gravity[["rta_type"]], "labels")),
  rta_type_description = names(attr(gravity[["rta_type"]], "labels"))
) %>%
  mutate(
    rta_type_description = str_replace_all(rta_type_description, "CU", "Customs Union (CU)"),
    rta_type_description = str_replace_all(rta_type_description, "EIA", "Economic Integration Agreement (EIA)"),
    rta_type_description = str_replace_all(rta_type_description, "FTA", "Free Trade Agreement (FTA)"),
    rta_type_description = str_replace_all(rta_type_description, "PSA", "Partial Scope Agreement (PSA)")
  )

pop_source <- tibble(
  pop_source_id = as.integer(attr(gravity[["pop_source_o"]], "labels")),
  pop_source_description = names(attr(gravity[["pop_source_o"]], "labels"))
)

pop_source <- pop_source %>%
  mutate(
    pop_source_description = case_when(
      pop_source_description == "WDI" ~ "World Development Indicators (WDI)",
      pop_source_description == "Maddison" ~ "Angus Maddison's Statistics on World Population",
      pop_source_description == "Taiwan Govt" ~ "Taiwan's National Statistical Agency"
    )
  )

gdp_source <- tibble(
  gdp_source_id = as.integer(attr(gravity[["gdp_source_o"]], "labels")),
  gdp_source_description = names(attr(gravity[["gdp_source_o"]], "labels"))
)

gdp_source <- gdp_source %>%
  mutate(
    gdp_source_description = case_when(
      gdp_source_description == "WDI" ~ "World Development Indicators (WDI)",
      gdp_source_description == "Barbieri" ~ "Barbieri, K. (2005). The liberal illusion: Does trade promote peace? (U. of Michigan Press)",
      gdp_source_description == "Taiwan Govt" ~ "Taiwan's National Statistical Agency"
    )
  )

# main_city_source <- tibble(
#   main_city_source_id = as.integer(attr(gravity[["main_city_source_o"]], "labels")),
#   main_city_source_description = names(attr(gravity[["main_city_source_o"]], "labels"))
# )

main_city_source <- gravity %>%
  select(main_city_source_o) %>%
  distinct() %>%
  drop_na() %>%
  mutate(main_city_source_id = row_number()) %>%
  rename(main_city_source_description = main_city_source_o) %>%
  select(main_city_source_id, main_city_source_description)

# gravity %>%
#   select(main_city_source_d) %>%
#   distinct() %>%
#   drop_na()

main_city_source <- main_city_source %>%
  mutate(
    main_city_source_description = case_when(
      main_city_source_description == "WB_Area" ~ "World Bank (WB) Surface Area Dataset (internal distance)",
      main_city_source_description == "UN_WUP_Capitals" ~ "United Nations (UN) World Urbanization Prospects (WUP) Dataset (capital to capital distance)",
      main_city_source_description == "UN_WUP_Largest" ~ "United Nations (UN) World Urbanization Prospects (WUP) Dataset (cities with over 300,000 inhabitants)",
      main_city_source_description == "Wikipedia_Area" ~ "Wikipedia (internal distance)"
    )
  )

gravity <- gravity %>%
  mutate(
    main_city_source_o = case_when(
      main_city_source_o == "WB_Area" ~ 1L,
      main_city_source_o == "UN_WUP_Capitals" ~ 2L,
      main_city_source_o == "UN_WUP_Largest" ~ 3L,
      main_city_source_o == "Wikipedia_Area" ~ 4L
    ),
    main_city_source_d = case_when(
      main_city_source_d == "WB_Area" ~ 1L,
      main_city_source_d == "UN_WUP_Capitals" ~ 2L,
      main_city_source_d == "UN_WUP_Largest" ~ 3L,
      main_city_source_d == "Wikipedia_Area" ~ 4L
    )
  ) %>%
  mutate(
    main_city_source_o = as.integer(main_city_source_o),
    main_city_source_d = as.integer(main_city_source_d)
  )

# gravity <- gravity %>%
#   mutate(
#     iso3_o_dynamic = case_when(
#       iso3_o == "ANT" & iso3num_o == 532L ~ "ANT.X",
#       iso3_o == "DEU" & iso3num_o == 280L ~ "DEU.X",
#       iso3_o == "ETH" & iso3num_o == 230L ~ "ETF",
#       iso3_o == "IDN" & year <= 2002L ~ "IDN.X",
#       iso3_o == "PAK" & year <= 1971L ~ "PAK.X",
#       iso3_o == "SDN" & iso3num_o == 736L ~ "SDN.X",
#       iso3_o == "VNM" & year <= 1976L ~ "VNM.X", # Vietnam up to 1976
#       iso3_o == "YEM" & year <= 1990L ~ "YEM.X",
#       TRUE ~ iso3_o
#     ),
#     iso3_d_dynamic = case_when(
#       iso3_d == "ANT" & iso3num_d == 532L ~ "ANT.X",
#       iso3_d == "DEU" & iso3num_d == 280L ~ "DEU.X",
#       iso3_d == "ETH" & iso3num_d == 230L ~ "ETF",
#       iso3_d == "IDN" & year <= 2002L ~ "IDN.X",
#       iso3_d == "PAK" & year <= 1971L ~ "PAK.X",
#       iso3_d == "SDN" & iso3num_d == 736L ~ "SDN.X",
#       iso3_d == "VNM" & year <= 1976L ~ "VNM.X", # Vietnam up to 1976
#       iso3_d == "YEM" & year <= 1990L ~ "YEM.X",
#       TRUE ~ iso3_d
#     )
#   ) %>%
#   select(year, iso3_o, iso3num_o, iso3_o_dynamic, iso3_d, iso3num_d, iso3_d_dynamic, everything())

# countries %>%
#   filter(iso3 == "DEU")

# gravity %>%
#   filter(iso3_o_dynamic %in% c("ANT", "ANT.X")) %>%
#   print(n = 60)

# gravity %>%
#   filter(iso3_o_dynamic %in% c("DEU", "DEU.X")) %>%
#   print(n = 100)

# gravity %>%
#   filter(iso3_o_dynamic %in% c("ETH", "ETF")) %>%
#   print(n = 100)

# gravity %>%
#   filter(iso3_o_dynamic %in% c("IDN", "IDN.X")) %>%
#   print(n = 100)

# gravity %>%
#   filter(iso3_o_dynamic %in% c("PAK", "PAK.X")) %>%
#   print(n = 100)

# gravity %>%
#   filter(iso3_o_dynamic %in% c("SDN", "SDN.X")) %>%
#   print(n = 100)

# we need to fix the rta_type = 8, it has no labels and doesn't allow to create a foreign key

# gravity %>%
#   distinct(rta_type) %>%
#   arrange()

# gravity %>%
#   filter(rta == 0) %>%
#   select(year, iso3_o, iso3_d, rta, rta_type)

# gravity %>%
#   filter(rta_type == 8) %>%
#   select(year, iso3_o, iso3_d, rta, rta_type)

# gravity %>%
#   filter(rta_type == 8) %>%
#   select(iso3_o, iso3_d, rta, rta_type) %>%
#   distinct() %>%
#   print(n = 30)

# not required in the current version
# gravity <- gravity %>%
#   mutate(
#     rta_type = case_when(
#       rta_type == 8 ~ NA_integer_,
#       TRUE ~ rta_type
#     )
#   )

# export ----

# we do not really need to replace NAs with 0s

# fix_0s <- gravity_desc %>%
#   filter(grepl("1", description)) %>%
#   select(variable) %>%
#   pull()

# fix_0s <- fix_0s[!fix_0s %in% c("gdp_ppp_pwt_d", "col_dep_end_year",
#                                 "gdp_ppp_pwt_o", "manuf_tradeflow_baci",
#                                 "tradeflow_baci", "tradeflow_imf_d",
#                                 "tradeflow_comtrade_d", "tradeflow_imf_o",
#                                 "tradeflow_comtrade_o")]

# gravity_0s <- gravity %>%
#   select(fix_0s)

# col_names <- colnames(gravity)

# gravity <- gravity %>%
#   select(col_names[!col_names %in% fix_0s]) %>%
#   bind_cols(
#     gravity_0s %>%
#       mutate_if(is.numeric, function(x) as.integer(ifelse(is.na(x), 0L, x)))
#   )

# gravity <- gravity %>%
#   select(all_of(col_names))

write_tsv(countries, "dev/fout/cepii_country_information.tsv", na = "")
write_tsv(legal, "dev/fout/cepii_legal_origin.tsv", na = "")
write_tsv(rta_coverage, "dev/fout/cepii_rta_coverage.tsv", na = "")
write_tsv(rta_type, "dev/fout/cepii_rta_type.tsv", na = "")
write_tsv(pop_source, "dev/fout/cepii_pop_source.tsv", na = "")
write_tsv(gdp_source, "dev/fout/cepii_gdp_source.tsv", na = "")
write_tsv(main_city_source, "dev/fout/cepii_main_city_source.tsv", na = "")

N <- 2000000

gravity <- gravity %>%
  mutate(p = floor(row_number() / N) + 1) %>% 
  group_by(p) %>% 
  nest() %>% 
  ungroup() %>% 
  select(data) %>% 
  pull()

map(
  seq_along(gravity),
  function(x) {
    message(sprintf("Writing fragment %s of %s", x, length(gravity)))
    write_tsv(gravity[[x]], sprintf("dev/fout/cepii_gravity_part%s.tsv", ifelse(nchar(x) == 1, paste0("0", x), x)), na = "")
  }
)

rm(gravity, countries, legal, rta_coverage, rta_type)
gc()
