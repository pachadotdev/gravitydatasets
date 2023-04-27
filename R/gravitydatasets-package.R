#' @keywords internal
"_PACKAGE"

#' @keywords internal
"_PACKAGE"

#' @title CEPII Country-Level Information
#' @name cepii_country_names
#' @docType data
#' @author CEPII, adapted from the World Bank and other sources
#' @format A data frame with 257 rows and 8 columns:
#' |variable             |description                         |
#' |:--------------------|:-----------------------------------|
#' |iso3                 |ISO3 alphabetic                     |
#' |iso3num              |ISO3 numeric                        |
#' |country              |Country name                        |
#' |countrylong          |Country official name               |
#' |first_year           |First year of territorial existence |
#' |last_year            |Last year of territorial existence  |
#' |countrygroup_iso3    |Country group (ISO3 alphabetic)     |
#' |countrygroup_iso3num |Country group (ISO3 numeric)        |
#' @description Countries is the dataset that includes static country-level
#'  variables, allowing for a full identification of each country included in
#'  Gravity and, if relevant, for a tracking of its territorial changes (splits
#'  and merges). Some of the variables provided in Countries are also included
#'  in the main Gravity dataset.
#'  Countries includes one observation for each territorial configuration,
#'  mapping the full set of territorial changes that are accounted for in
#'  Gravity. For example, Countries includes one observation for West Germany,
#'  one for East Germany and one for the unified Germany. Similarly, it includes
#'  one observation for Sudan before the split of South Sudan, one observation
#'  for South Sudan, and one observation for Sudan after the split of South
#'  Sudan.
#' @details There are differences with respect to the original Stata version.
#'  ISO3 alphabetic codes of length zero were converted to NAs and the
#'  attributes (i.e., column descriptions), when missing, were added after
#'  reading the original documentation.
#'  The universe of Countries (and of the Gravity dataset) is based on
#'  CEPII's GeoDist dataset (Mayer and Zignago 2011). This dataset is augmented
#'  with some countries and territories that either appear in the World Bank's
#'  World Integrated Trade Solution (WITS) or that are necessary to construct
#'  the full chain of territorial changes that have led to the creation of
#'  countries appearing in the GeoDist dataset. In addition, some names are
#'  updated, as well as ISO3 alphabetic numeric codes, by comparing the GeoDist
#'  dataset with the WITS dataset and with the official source for ISO country
#'  codes. Countries' official names also come from the WITS dataset, augmented
#'  by Wikipedia for countries or territories that are not present in the WITS
#'  dataset but that appear in GeoDist.
#'  Countries (and the Gravity dataset) carefully tracks territorial changes,
#'  i.e. the country's previous membership (in case of a split) and the
#'  country's new membership (in case of a unification of two territories). We
#'  only take into account the modifications that occurred over the time span
#'  of the database, i.e 1948-2019. This is done using the CIA World Factbook
#'  and Wikipedia.
#' @keywords data
NULL

#' @title CEPII Gravity
#' @name cepii_gravity
#' @docType data
#' @author CEPII, adapted from the World Bank and other sources
#' @format A data frame with 4,428,288 rows and 79 columns for the period
#' 1948-2019:
#' |variable               |description                                                                      |
#' |:----------------------|:--------------------------------------------------------------------------------|
#' |year                   |Year                                                                             |
#' |iso3_o                 |Origin ISO3 alphabetic                                                           |
#' |iso3_d                 |Destination ISO3 alphabetic                                                      |
#' |iso3num_o              |Origin ISO3 numeric                                                              |
#' |iso3num_d              |Destination ISO3 numeric                                                         |
#' |country_exists_o       |1 = Origin country exists                                                        |
#' |country_exists_d       |1 = Destination country exists                                                   |
#' |gmt_offset_2020_o      |Origin GMT offset (hours)                                                        |
#' |gmt_offset_2020_d      |Destination GMT offset (hours)                                                   |
#' |contig                 |1 = Contiguity                                                                   |
#' |dist                   |Distance between most populated cities, in km                                    |
#' |distw                  |Population-weighted distance between most populated cities, in km                |
#' |distcap                |Distance between capitals, in km                                                 |
#' |distwces               |Population-weighted distance between most populated cities, in km, using CES for |
#' |dist_source            |1 = Distance taken directly from CEPII's GeoDist; 0 = Based on close country     |
#' |comlang_off            |1 = Common official or primary language                                          |
#' |comlang_ethno          |1 = Language is spoken by at least 9% of the population                          |
#' |comcol                 |1 = Common colonizer post 1945                                                   |
#' |comrelig               |Common religion index                                                            |
#' |col45                  |1 = Pair in colonial relationship post 1945                                      |
#' |legal_old_o            |Origin legal system before transition                                            |
#' |legal_old_d            |Destination legal system before transition                                       |
#' |legal_new_o            |Origin legal system after transition                                             |
#' |legal_new_d            |Destination legal system after transition                                        |
#' |comleg_pretrans        |1 = Common legal origins before transition                                       |
#' |comleg_posttrans       |1 = Common legal origins after transition                                        |
#' |transition_legalchange |1 = Common legal origin changed since transition                                 |
#' |heg_o                  |1 = Origin is current or former hegemon of destination                           |
#' |heg_d                  |1 = Destination is current or former hegemon of origin                           |
#' |col_dep_ever           |1 = Pair ever in colonial or dependency relationship                             |
#' |col_dep                |1 = Pair currently in colonial or dependency relationship                        |
#' |col_dep_end_year       |Independence date, if col_dep = 1                                                |
#' |col_dep_end_conflict   |1 = Independence involved conflict, if col_dep_ever = 1                          |
#' |empire                 |Hegemon if sibling = 1 and year < sever_year                                     |
#' |sibling_ever           |1 = Pair ever in sibling relationship                                            |
#' |sibling                |1 = Pair currently in sibling relationship                                       |
#' |sever_year             |Severance year for pairs if sibling == 1                                         |
#' |sib_conflict           |1 = Pair ever in sibling relationship and conflict with hegemon                  |
#' |pop_o                  |Origin Population, total in thousands                                            |
#' |pop_d                  |Destination Population, total in thousands                                       |
#' |gdp_o                  |Origin GDP (current thousands US$)                                               |
#' |gdp_d                  |Destination GDP (current thousands US$)                                          |
#' |gdpcap_o               |Origin GDP per cap (current thousands US$)                                       |
#' |gdpcap_d               |Destination GDP per cap (current thousands US$)                                  |
#' |pop_source_o           |Origin Population source                                                         |
#' |pop_source_d           |Destination Population source                                                    |
#' |gdp_source_o           |Origin GDP source                                                                |
#' |gdp_source_d           |Destination GDP source                                                           |
#' |gdp_ppp_o              |Origin GDP, PPP (current thousands international $)                              |
#' |gdp_ppp_d              |Destination GDP, PPP (current thousands international $)                         |
#' |gdpcap_ppp_o           |Origin GDP per cap, PPP (current thousands international $)                      |
#' |gdpcap_ppp_d           |Destination GDP per cap, PPP (current thousands international $)                 |
#' |pop_pwt_o              |Origin Population, total in thousands (PWT)                                      |
#' |pop_pwt_d              |Destination Population, total in thousands (PWT)                                 |
#' |gdp_ppp_pwt_o          |Origin GDP, current PPP (2011 thousands US$) (PWT)                               |
#' |gdp_ppp_pwt_d          |Destination GDP, current PPP (2011 thousands US$) (PWT)                          |
#' |gatt_o                 |Origin GATT membership                                                           |
#' |gatt_d                 |Destination GATT membership                                                      |
#' |wto_o                  |Origin WTO membership                                                            |
#' |wto_d                  |Destination WTO membership                                                       |
#' |eu_o                   |1 = Origin is a EU member                                                        |
#' |eu_d                   |1 = Destination is a EU member                                                   |
#' |rta                    |1 = RTA (source: WTO)                                                            |
#' |rta_coverage           |Coverage of RTA (source: WTO)                                                    |
#' |rta_type               |Type of RTA (source: WTO)                                                        |
#' |entry_cost_o           |Origin Cost of business start-up procedures (% of GNI per capita)                |
#' |entry_cost_d           |Destination Cost of business start-up procedures (% of GNI per capita)           |
#' |entry_proc_o           |Origin Start-up procedures to register a business (number)                       |
#' |entry_proc_d           |Destination Start-up procedures to register a business (number)                  |
#' |entry_time_o           |Origin Time required to start a business (days)                                  |
#' |entry_time_d           |Destination Time required to start a business (days)                             |
#' |entry_tp_o             |Origin Days + procedures to start a business                                     |
#' |entry_tp_d             |Destination Days + procedures to start a business                                |
#' |tradeflow_comtrade_o   |Trade flows as reported by the origin, 1000 Current USD (source: UNSD)           |
#' |tradeflow_comtrade_d   |Trade flows as reported by the destination, 1000 Current USD (source: UNSD)      |
#' |tradeflow_baci         |Trade flow, 1000 USD (source: BACI)                                              |
#' |manuf_tradeflow_baci   |Trade flow of manufactured goods, 1000 USD (source: BACI)                        |
#' |tradeflow_imf_o        |Trade flows as reported by the origin, 1000 Current USD (source: IMF)            |
#' |tradeflow_imf_d        |Trade flows as reported by the destination, 1000 Current USD (source: IMF)       |
#' @description In Gravity, each observation is uniquely identified by the
#'  combination of the country_id of the origin country, the country_id of the
#'  destination country and the year. Gravity is “squared”, meaning that each
#'  country pair appears every year, even if one of the countries actually does
#'  not exist. However, based on the territorial changes tracked in the
#'  Countries dataset, we set to missing all variables for country pairs in
#'  which at least one of the countries does not exist in a given year.
#'  Furthermore, we provide two dummy variables indicating whether the origin
#'  and the destination countries exist. These dummies allow users wishing drop
#'  non-existing country pairs from the dataset to do so easily. Users looking
#'  for a more detailed account of country existence should turn to the
#'  Countries dataset.
#'  A few caveats on the identification of countries through country_id must be
#'  noted. Firstly, when countries merge, it is the new country or territorial
#'  configuration that exists during transition year but not the old country or
#'  territorial configuration. As an example DEU.1 (West Germany) has 1989 as
#'  last year, not 1990, while DEU.2 (the unified Germany) has 1990 as first
#'  year. This is consistent with the construction of underlying variables that
#'  varies over time, such as GDP, population, trade. Secondly, since the
#'  dataset is square in terms of country_id, there exist cases in which two
#'  configurations of the same alphabetic ISO3 code appear bilaterally, e.g.
#'  DEU.1 and DEU.2. While DEU.1 and DEU.2 never existed simultaneously, we
#'  still keep these null observations to ensure that the final dataset is
#'  square.
#' @details The details are the same as for the Countries dataset.
#' @keywords data
NULL

#' @title USITC Trade at Sector-Level
#' @name usitc_trade
#' @docType data
#' @author USITC, adapted from UN COMTRADE and other sources
#' @format A data frame with 72,534,869 rows and 10 columns for the period
#' 1986-2020:
#' |Variable name         |Variable description                                                                                                |
#' |:---------------------|:-------------------------------------------------------------------------------------------------------------------|
#' |exporter_iso3         |ISO 3-letter alpha code of the exporter                                                                             |
#' |exporter_dynamic_code |DGD's dynamic code of the exporter                                                                                  |
#' |exporter_name         |Name of the exporter                                                                                                |
#' |importer_iso3         |ISO 3-letter alpha code of the importer                                                                             |
#' |importer_dynamic_code |DGD's dynamic code of the importer                                                                                  |
#' |importer_name         |Name of the importer                                                                                                |
#' |year                  |Year                                                                                                                |
#' |industry_id           |ITPD industry code                                                                                                  |
#' |industry_descr        |ITPD industry description                                                                                           |
#' |broad_sector          |Broad sector                                                                                                        |
#' |trade                 |Trade flows in million of current US dollars                                                                        |
#' |flag_mirror           |Flag indicator, 1 if trade mirror value is used                                                                     |
#' |flag_zero             |Flag indicator: `p` if positive trade, `r` if the raw data contained zero and `u`` missing (unknown, assigned zero) |
#' @description The data goes back to 1986 for Agriculture, and to 1988 for Mining & Energy and Manufacturing. Due to administrative data limitations, the data for Services is not available before to the year 2000.
#' @details There are differences with respect to the original CSV file. This version provides a more compact representation of the data, with the following changes:
#' \itemize{
#' \item{The `exporter_name` and `importer_name` columns are provided in the `country_names` table as `country_name` and can be joined by using the `_iso3` and `_dynamic` columns.}
#' \item{The `industry_descr` column is provided in the industry names table.}
#' \item{The `broad_sector` column is provided in the sector names table and `broad_sector_id` was created for this version of the table.}
#' }
#' @keywords data
NULL

#' @title USITC Gravity: Macroeconomic, geographic and institutional variables table.
#' @name usitc_gravity
#' @docType data
#' @author USITC, adapted from WTO, UN COMTRADE, National Geographic and other sources, with corrections made for the package
#' @format A data frame with 1,940,681 rows and 67 columns for the period 1986-2020:
#' |Variable name              |Variable description                                                                                 |
#' |:--------------------------|:----------------------------------------------------------------------------------------------------|
#' |year                       |Year of observation                                                                                  |
#' |iso3_o                     |3-digit ISO code of origin country                                                                   |
#' |dynamic_code_o             |Year appropriate 3-digit code of origin country                                                      |
#' |iso3_d                     |3-digit ISO code of destination country                                                              |
#' |dynamic_code_d             |Year appropriate 3-digit code of destination country                                                 |
#' |colony_of_destination_ever |Origin country was ever a colony of the destination country                                          |
#' |colony_of_origin_ever      |Destination country was ever a colony of the origin country                                          |
#' |colony_ever                |Country pair has been in a colonial relationship                                                     |
#' |common_colonizer           |Country pair has been colonized by a common colonizer                                                |
#' |common_legal_origin        |Country pair shares common legal origin                                                              |
#' |contiguity                 |Country pair shares a common border                                                                  |
#' |distance                   |Population weighted distance between country pair                                                    |
#' |member_gatt_o              |Origin country is a General Agreement on Tariffs and Trade member                                    |
#' |member_wto_o               |Origin country is a World Trade Organization member                                                  |
#' |member_eu_o                |Origin country is a European Union member                                                            |
#' |member_gatt_d              |Destination country is a General Agreement on Tariffs and Trade member                               |
#' |member_wto_d               |Destination country is a World Trade Organization member                                             |
#' |member_eu_d                |Destination country is a European Union member                                                       |
#' |member_gatt_joint          |Country pair are both members of the General Agreement on Tariffs and Trade                          |
#' |member_wto_joint           |Country pair are both members of the World Trade Organization                                        |
#' |member_eu_joint            |Country pair are both members of the European Union                                                  |
#' |lat_o                      |Latitude coordinate of origin country                                                                |
#' |lng_o                      |Longitude coordinate of origin country                                                               |
#' |lat_d                      |Latitude coordinate of destination country                                                           |
#' |lng_d                      |Longitude coordinate of destination country                                                          |
#' |landlocked_o               |Origin country is landlocked                                                                         |
#' |island_o                   |Origin country is an island                                                                          |
#' |region_id_o                |Geographic region of origin country                                                                  |
#' |landlocked_d               |Destination country is landlocked                                                                    |
#' |island_d                   |Destination country is an island                                                                     |
#' |region_id_d                |Geographic region of destination country                                                             |
#' |agree_pta_goods            |Country pair is in at least one active preferential trade agreement covering goods                   |
#' |agree_pta_services         |Country pair is in at least one active preferential trade agreement covering services                |
#' |agree_fta                  |Country pair is in at least one free trade agreement                                                 |
#' |agree_eia                  |Country pair is in at least one economic integration agreement                                       |
#' |agree_cu                   |Country pair is in at least one customs union                                                        |
#' |agree_psa                  |Country pair is in at least one partial scope agreement                                              |
#' |agree_fta_eia              |Country pair is in at least one free trade agreement and at least one economic integration agreement |
#' |agree_cu_eia               |Country pair is in at least one customs union and at least one economic integration agreement        |
#' |agree_pta                  |Country pair is in at least one active preferential trade agreement covering goods                   |
#' |capital_const_d            |Capital stock at constant prices of destination country                                              |
#' |capital_const_o            |Capital stock at constant prices of origin country                                                   |
#' |capital_cur_d              |Capital stock at current PPP of destination country                                                  |
#' |capital_cur_o              |Capital stock at current PPP of origin country                                                       |
#' |gdp_pwt_const_d            |Real, inflation-adjusted, PPP-adjusted GDP of destination country (PWT)                              |
#' |gdp_pwt_const_o            |Real, inflation-adjusted, PPP-adjusted GDP of origin country (PWT)                                   |
#' |gdp_pwt_cur_d              |Real, current, PPP-adjusted GDP of destination country (PWT)                                         |
#' |gdp_pwt_cur_o              |Real, current, PPP-adjusted GDP of origin country (PWT)                                              |
#' |pop_d                      |Population of destination country                                                                    |
#' |pop_o                      |Population of origin country                                                                         |
#' |hostility_level_o          |Level of the origin/destination country’s hostility toward the destination country                   |
#' |hostility_level_d          |Level of the origin/destination country’s hostility toward the origin country                        |
#' |common_language            |Residents of country pair speak at least one common language                                         |
#' |polity_o                   |Polity (political stability) score of origin country                                                 |
#' |polity_d                   |Polity (political stability) score of destination country                                            |
#' |sanction_threat            |There exists a threat of sanction between one country in a record towards the other                  |
#' |sanction_threat_trade      |There exists a threat of trade sanction between one country in a record towards the other            |
#' |sanction_imposition        |There exists a sanction between one country in a record towards the other                            |
#' |sanction_imposition_trade  |There exists a trade sanction between one country in a record towards the other                      |
#' |gdp_wdi_cur_o              |Nominal GDP of origin country (WDI)                                                                  |
#' |gdp_wdi_cap_cur_o          |Nominal GDP per capita of origin country (WDI)                                                       |
#' |gdp_wdi_const_o            |Real, current, PPP-adjusted GDP of origin country (PWT)                                              |
#' |gdp_wdi_cap_const_o        |Real GDP per capita of origin country (WDI)                                                          |
#' |gdp_wdi_cur_d              |Nominal GDP of destination country (WDI)                                                             |
#' |gdp_wdi_cap_cur_d          |Nominal GDP per capita of destination country (WDI)                                                  |
#' |gdp_wdi_const_d            |Real, current, PPP-adjusted GDP of destination country (PWT)                                         |
#' |gdp_wdi_cap_const_d        |Real GDP per capita of destination country (WDI)                                                     |
#' @description The data goes back to 1986 and is suited to join with the `trade` table.
#' @details There are differences with respect to the original CSV files. This version provides a more compact representation of the data, with the following changes:
#' \itemize{
#' \item{Starts in 1986 instead of 1948.}
#' \item{Is limited to ISO codes contained in the `trade` table.}
#' \item{The `region_origin` and `region_destination` columns are provided in the `region names` table as `region_name` and can be joined by using the `region_id_` columns.}
#' }
#' @keywords data
NULL

#' @title USITC-Derived Country Names
#' @name usitc_country_names
#' @docType data
#' @author Own creation, adapted from the original DGD
#' @format A data frame with 267 rows and 3 columns:
#' |Variable name         |Variable description                      |
#' |:---------------------|:-----------------------------------------|
#' |country_iso3          |ISO 3-letter alpha code of the country    |
#' |country_dynamic_code  |DGD's dynamic country code of the country |
#' |country_name          |Name of the country                       |
#' @keywords data
NULL

#' @title USITC-Derived Industry Names
#' @name usitc_industry_names
#' @docType data
#' @author Own creation, adapted from the original ITPD-E
#' @format A data frame with 170 rows and 2 columns:
#' |Variable name         |Variable description      |
#' |:---------------------|:-------------------------|
#' |industry_id           |ITPD industry code        |
#' |industry_descr        |ITPD industry description |
#' @keywords data
NULL

#' USTIC-Derived Sector Names
#' @name usitc_sector_names
#' @docType data
#' @author Own creation, adapted from the original ITPD-E
#' @format A data frame with 4 rows and 2 columns:
#' |Variable name         |Variable description |
#' |:---------------------|:--------------------|
#' |broad_sector_id       |Broad sector code    |
#' |broad_sector          |Broad sector         |
#' @keywords data
NULL

#' @title USITC-Derived Region Names
#' @name usitc_region_names
#' @docType data
#' @author Own creation, adapted from the original DGD
#' @format A data frame with 15 rows and 2 columns:
#' |Variable name         |Variable description |
#' |:---------------------|:--------------------|
#' |region_id             |Region code          |
#' |region                |Region name          |
#' @keywords data
NULL

#' @title WTO Country Names
#' @name wto_country_names
#' @docType data
#' @author Own creation, adapted from the original SGD
#' @format A data frame with 232 rows and 3 columns:
#' |variable             |description                         |
#' |:--------------------|:-----------------------------------|
#' |country_iso3         |Country ISO3 alphabetic             |
#' |country_name         |Country name                        |

#' @title WTO Trade
#' @name wto_trade
#' @docType data
#' @author WTO
#' @format A data frame with 972,692 rows and 5 columns for the period
#' 1980-2016:
#' |variable             |description                         |
#' |:--------------------|:-----------------------------------|
#' |pair_id              |Exporter-Importer index             |
#' |year                 |Year of observation                 |
#' |exporter_iso3        |Exporter ISO3 alphabetic            |
#' |importer_iso3        |Importer ISO3 alphabetic            |
#' |trade                |Trade flows in current US dollars   |
