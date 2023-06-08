# Gravity Datasets

## Contents

- [About](https://github.com/pachadotdev/gravitydatasets#about)
- [Acknowledgements](https://github.com/pachadotdev/gravitydatasets#acknowledgments)
- [Motivation](https://github.com/pachadotdev/gravitydatasets#motivation)
- [Sources](https://github.com/pachadotdev/gravitydatasets#sources)
- [Tables](https://github.com/pachadotdev/gravitydatasets#tables)
- [Differences with the original sources](https://github.com/pachadotdev/gravitydatasets#differences-with-the-original-sources)
- [Usage](https://github.com/pachadotdev/gravitydatasets#usage)
- [Installing the database locally](https://github.com/pachadotdev/gravitydatasets#installing-the-database-locally)
- [Additional configurations](https://github.com/pachadotdev/gravitydatasets#additional-configurations)
- [Contributing](https://github.com/pachadotdev/gravitydatasets#contributing)
- [Collaborating](https://github.com/pachadotdev/gravitydatasets#collaborating)
- [License](https://github.com/pachadotdev/gravitydatasets#license)

## About

This repository aims at gathering in a single place a set of adapted variables that could be useful to researchers or practitioners that use the structural gravity model of trade. I provide trade flows, as well as geographic, cultural, trade facilitation and macroeconomic variables.

The tables provided here were reshaped under Cobb's Normal Form, and in some cases contain corrections that I explain below. The specific sources are the [Gravity database](http://www.cepii.fr/CEPII/en/bdd_modele/bdd_modele_item.asp?id=8) from the Center for Prospective Studies and International Information (CEPII), the [International Trade and Production Database for Estimation (ITPD-E)](https://www.usitc.gov/data/gravity/itpde.htm) and the [Dynamic Gravity Database (DGD)](https://www.usitc.gov/data/gravity/dgd.htm) from the US International Trade Commission (USITC), and the [Structural Gravity Database (SGD)](https://www.wto.org/english/res_e/reser_e/structural_gravity_e.htm) from the World Trade Organization (WTO).

This is a sub-product, and perhaps the biggest contribution I made during my MA thesis, "NAFTA is the Worst Trade Deal in the History of Trade Deals, Maybe Ever". Of course, that title took inspiration from a US president. I used the gravity model of trade to simulate the effects of NAFTA on the Canadian, American and Mexican economy (ordered from north to south) at sectoral level (i.e., Agriculture, Mining and Energy, and Manufacturing). I needed to correct some inconsistencies in the data, and I thought that it would be useful to share the results with the community.

## Acknowledgments

My MA thesis supervisor, [Dr. Victor Falkenheim](https://politics.utoronto.ca/faculty/profile/32/), was highly supportive and understood that, in order to conduct a reasonable General Equilibrium simulation of NAFTA effects by sectors, I had to care about the internal data consistency. I really thank him for his wise advice and support.

I also had indirect but valuable inputs from [Dr. Mark Manger](https://munkschool.utoronto.ca/person/mark-manger) and [Dr. Leonardo Baccini](https://www.mcgill.ca/politicalscience/leonardo-baccini) when discussing the distributional consequences of free trade. Even when they didn't tell me to use SQL or fight with the data or Cobb's third formal norm, their emails demanded the need to reshape my datasets to be able to answer some questions coming from their end, such as "when a few industries concentrate trade gains and others experience losses in a positive overall result scenario, does the distribution of gains introduces a political justification to oppose trade at the expense of economic efficiency?"

## Motivation

The motivation to explore this topic follows from the observed change in US Republicans’ speech. Some
clear examples can be obtained from what Republican presidents have said about trade in different decades:

> “We should beware of the demagogues who are ready to declare a trade war against our friends —
weakening our economy, our national security, and the entire free world— all while cynically
waving the American flag.” Ronald Reagan, 40th president of the USA.

> “. . . .I am a Tariff Man. When people or countries come in to raid the great wealth of our
Nation, I want them to pay for the privilege of doing so. It will always be the best way to
max out our economic power. We are right now taking in $billions in Tariffs. MAKE AMERICA RICH AGAIN” Donald J. Trump, 45th president of the USA. (https://twitter.com/realdonaldtrump/status/1069970500535902208)

## Sources

Conte, M., Cotterlaz, P. & Mayer, T. (2021). *The CEPII Gravity Database*. CEPII Working Paper 2022-05.

Borchert, Ingo & Larch, Mario & Shikher, Serge & Yotov, Yoto, 2020. *The International Trade and Production Database for Estimation (ITPD-E)*. School of Economics Working Paper Series 2020-5, LeBow College of Business, Drexel University.

Gurevich, Tamara & Herman, Peter, 2018. *The Dynamic Gravity Dataset: 1948-2016*. USITC Working Paper 2018-02-A.

Larch, Mario & Monteiro, José-Antonio & Piermartini, Roberta & Yotov, Yoto, 2019. *On the Effects of GATT/WTO Membership on Trade: They are Positive and Large After All*. WTO Staff Working Papers ERSD-2019-09, World Trade Organization (WTO), Economic Research and Statistics Division.

## Tables

### CEPII Country-Level Information

Name: `cepii_country_information`

Source: CEPII, adapted from the World Bank and other sources

Format: A table with 257 rows and 8 columns

|variable             |description                                                                                                   |
|:--------------------|:-------------------------------------------------------------------------------------------------------------|
|country_id           |Combines a country's ISO3 code with a number identifying potential territorial transformations of the country |
|iso3                 |ISO3 alphabetic                                                                                               |
|iso3num              |ISO3 numeric                                                                                                  |
|country              |Country name                                                                                                  |
|countrylong          |Country official name                                                                                         |
|first_year           |First year of territorial existence                                                                           |
|last_year            |Last year of territorial existence                                                                            |
|countrygroup_iso3    |Country group (ISO3 alphabetic)                                                                               |
|countrygroup_iso3num |Country group (ISO3 numeric)                                                                                  |
|iso2                 |ISO2 alphabetic                                                                                               |
|heg_iso3_2020        |Hegemon (ISO3 alphabetic) if country is a dependency in 2020                                                                                                       |
|heg_iso3num_2020     |Hegemon (ISO3 numeric) if country is a dependency in 2020                        |

Description: Allows for a full identification of each country included in the
 gravity dataset and, if relevant, for a tracking of its territorial changes
 (splits and merges).  Includes one observation for each territorial
 configuration, mapping the full set of territorial changes that are
 accounted for in gravity. For example, this dataset includes one observation
 for West Germany, one for East Germany and one for the unified Germany.

Details: There are differences with respect to the original Stata version.
 ISO3 alphabetic codes of length zero were converted to NAs and the
 attributes (i.e., column descriptions), when missing, were added after
 reading the original documentation. The dynamic codes were added to the
 dataset and follow from USITC's DGD codes.

### CEPII Population Source

Name: `cepii_population_source`

Source: CEPII

Format: A table with 3 rows and 2 columns

|variable               |description                                                             |
|:----------------------|:-----------------------------|
|pop_source_id          |Population source ID          |
|pop_source_description |Population source description |

### CEPII GDP Source

Name: `cepii_gdp_source`

Source: CEPII

Format: A table with 3 rows and 2 columns

|variable               |description            |
|:----------------------|:----------------------|
|gdp_source_id          |GDP source ID          |
|gdp_source_description |GDP source description |

### CEPII Gravity

Name: `cepii_gravity`

Source: CEPII, adapted from the World Bank and other sources

Format A table with 4,428,288 rows and 79 columns for the period
1948-2019:
|variable               |description                                                                                 |
|:----------------------|:-------------------------------------------------------------------------------------------|
|year                   |Year                                                                                        |
|country_id_o           |Origin country ID                                                                           |
|country_id_d           |Destination country ID                                                                      |
|iso3_o                 |Origin ISO3 alphabetic                                                                      |
|iso3_d                 |Destination ISO3 alphabetic                                                                 |
|iso3num_o              |Origin ISO3 numeric                                                                         |
|iso3num_d              |Destination ISO3 numeric                                                                    |
|country_exists_o       |1 = Origin country exists                                                                   |
|country_exists_d       |1 = Destination country exists                                                              |
|gmt_offset_2020_o      |Origin GMT offset (hours)                                                                   |
|gmt_offset_2020_d      |Destination GMT offset (hours)                                                              |
|distw_harmonic         |Population-weighted distance between most populated cities (harmonic mean)                  |
|distw_arithmetic       |Population-weighted distance between most populated cities (arithmetic mean)                |
|distw_harmonic_jh      |Population-weighted distance between most populated cities (harmonic mean) by Julian Hinz   |
|distw_arithmetic_jh    |Population-weighted distance between most populated cities (arithmetic mean) by Julian Hinz |
|dist                   |Distance between most populated cities, in km                                               |
|main_city_source_o     |Source of origin's most populated city                                                      |
|main_city_source_d     |Source of destination's most populated city                                                 |
|distcap                |Distance between capitals, in km                                                            |
|contig                 |1 = Contiguity                                                                              |
|diplo_disagreement     |UN diplomatic disagreement score                                                            |
|scaled_sci_2021        |Social connectedness index in 2021                                                          |
|comlang_off            |1 = Common official or primary language                                                     |
|comlang_ethno          |1 = Language is spoken by at least 9% of the population                                     |
|comcol                 |1 = Common colonizer post 1945                                                              |
|col45                  |1 = Pair in colonial relationship post 1945                                                 |
|legal_old_o            |Origin legal system before transition                                                       |
|legal_old_d            |Destination legal system before transition                                                  |
|legal_new_o            |Origin legal system after transition                                                        |
|legal_new_d            |Destination legal system after transition                                                   |
|comleg_pretrans        |1 = Common legal origins before transition                                                  |
|comleg_posttrans       |1 = Common legal origins after transition                                                   |
|transition_legalchange |1 = Common legal origin changed since transition                                            |
|comrelig               |Common religion index                                                                       |
|heg_o                  |1 = Origin is current or former hegemon of destination                                      |
|heg_d                  |1 = Destination is current or former hegemon of origin                                      |
|col_dep_ever           |1 = Pair ever in colonial or dependency relationship                                        |
|col_dep                |1 = Pair currently in colonial or dependency relationship                                   |
|col_dep_end_year       |Independence date, if col_dep = 1                                                           |
|col_dep_end_conflict   |1 = Independence involved conflict, if col_dep_ever = 1                                     |
|empire                 |Hegemon if sibling = 1 and year < sever_year                                                |
|sibling_ever           |1 = Pair ever in sibling relationship                                                       |  
|sibling                |1 = Pair currently in sibling relationship                                                  |
|sever_year             |Severance year for pairs if sibling == 1                                                    |
|sib_conflict           |1 = Pair ever in sibling relationship and conflict with hegemon                             |
|pop_o                  |Origin Population, total in thousands                                                       |
|pop_d                  |Destination Population, total in thousands                                                  |
|gdp_o                  |Origin GDP (current thousands US$)                                                          |
|gdp_d                  |Destination GDP (current thousands US$)                                                     |
|gdpcap_o               |Origin GDP per cap (current thousands US$)                                                  |
|gdpcap_d               |Destination GDP per cap (current thousands US$)                                             | 
|pop_source_o           |Origin Population source                                                                    |
|pop_source_d           |Destination Population source                                                               |
|gdp_source_o           |Origin GDP source                                                                           |
|gdp_source_d           |Destination GDP source                                                                      |
|gdp_ppp_o              |Origin GDP, PPP (current thousands international $)                                         |
|gdp_ppp_d              |Destination GDP, PPP (current thousands international $)                                    |
|gdpcap_ppp_o           |Origin GDP per cap, PPP (current thousands international $)                                 |
|gdpcap_ppp_d           |Destination GDP per cap, PPP (current thousands international $)                            |
|pop_pwt_o              |Origin Population, total in thousands (PWT)                                                 |
|pop_pwt_d              |Destination Population, total in thousands (PWT)                                            |
|gdp_ppp_pwt_o          |Origin GDP, current PPP (2011 thousands US$) (PWT)                                          |
|gdp_ppp_pwt_d          |Destination GDP, current PPP (2011 thousands US$) (PWT)                                     |
|gatt_o                 |Origin GATT membership                                                                      |
|gatt_d                 |Destination GATT membership                                                                 |
|wto_o                  |Origin WTO membership                                                                       |
|wto_d                  |Destination WTO membership                                                                  |
|eu_o                   |1 = Origin is a EU member                                                                   |
|eu_d                   |1 = Destination is a EU member                                                              |
|fta_wto                |1 = The country pair is engaged in a regional trade agreement (source: WTO, supplemented by T. Mayer) |
|fta_wto_raw            |1 = The country pair is engaged in a regional trade agreement (source: WTO)                 |
|rta_coverage           |Coverage of RTA (source: WTO)                                                               |
|rta_type               |Type of RTA (source: WTO)                                                                   |
|entry_cost_o           |Origin Cost of business start-up procedures (% of GNI per capita)                           |
|entry_cost_d           |Destination Cost of business start-up procedures (% of GNI per capita)                      |
|entry_proc_o           |Origin Start-up procedures to register a business (number)                                  |
|entry_proc_d           |Destination Start-up procedures to register a business (number)                             |
|entry_time_o           |Origin Time required to start a business (days)                                             |
|entry_time_d           |Destination Time required to start a business (days)                                        |
|entry_tp_o             |Origin Days + procedures to start a business                                                |
|entry_tp_d             |Destination Days + procedures to start a business                                           |
|tradeflow_comtrade_o   |Trade flows as reported by the origin, 1000 Current USD (source: UNSD)                      |
|tradeflow_comtrade_d   |Trade flows as reported by the destination, 1000 Current USD (source: UNSD)                 |
|tradeflow_baci         |Trade flow, 1000 USD (source: BACI)                                                         |
|manuf_tradeflow_baci   |Trade flow of manufactured goods, 1000 USD (source: BACI)                                   |
|tradeflow_imf_o        |Trade flows as reported by the origin, 1000 Current USD (source: IMF)                       |
|tradeflow_imf_d        |Trade flows as reported by the destination, 1000 Current USD (source: IMF)                  |

Description: Each observation is uniquely identified by the
 combination of the ISO-3 code of the origin country, the ISO-3 code of the
 destination country and the year. Country pair appears every year, even if
 one of the countries actually does not exist. However, based on the
 territorial changes tracked in the countries dataset, we set to missing all
 variables for country pairs in which at least one of the countries does not
 exist in a given year. Furthermore, we provide two dummy variables
 indicating whether the origin and the destination countries exist. These
 dummies allow users wishing drop non-existing country pairs from the
 dataset.
 A few caveats on the identification of countries through country_id must be
 noted. Firstly, when countries merge, it is the new country or territorial
 configuration that exists during transition year but not the old country or
 territorial configuration. As an example DEU.1 (West Germany) has 1989 as
 last year, not 1990, while DEU.2 (the unified Germany) has 1990 as first
 year. This is consistent with the construction of underlying variables that
 varies over time, such as GDP, population, trade. Secondly, since the
 dataset is square in terms of country_id, there exist cases in which two
 configurations of the same alphabetic ISO3 code appear bilaterally, e.g.
 DEU.1 and DEU.2. While DEU.1 and DEU.2 never existed simultaneously, we
 still keep these null observations to ensure that the final dataset is
 square.

Details: The details are the same as for the countries dataset.

### USITC Sector-Level Trade

Name: `usitc_trade`

Source: USITC, adapted from UN COMTRADE and other sources

Format: A table with 72,534,869 rows and 10 columns for the period 1986-2020

|Variable name         |Variable description                                                                                                |
|:---------------------|:-------------------------------------------------------------------------------------------------------------------|
|exporter_iso3         |ISO 3-letter alpha code of the exporter                                                                             |
|exporter_dynamic_code |DGD's dynamic code of the exporter                                                                                  |
|exporter_name         |Name of the exporter                                                                                                |
|importer_iso3         |ISO 3-letter alpha code of the importer                                                                             |
|importer_dynamic_code |DGD's dynamic code of the importer                                                                                  |
|importer_name         |Name of the importer                                                                                                |
|year                  |Year                                                                                                                |
|industry_id           |ITPD industry code                                                                                                  |
|industry_descr        |ITPD industry description                                                                                           |
|broad_sector          |Broad sector                                                                                                        |
|trade                 |Trade flows in million of current US dollars                                                                        |
|flag_mirror           |Flag indicator, 1 if trade mirror value is used                                                                     |
|flag_zero             |Flag indicator: `p` if positive trade, `r` if the raw data contained zero and `u`` missing (unknown, assigned zero) |

Description: The data goes back to 1986 for Agriculture, and to 1988 for Mining & Energy and Manufacturing. Due to administrative data limitations, the data for Services is not available before to the year 2000.
@details There are differences with respect to the original CSV file. This version provides a more compact representation of the data, with the following changes:

* The `exporter_name` and `importer_name` columns are provided in the `country_names` table as `country_name` and can be joined by using the `_iso3` and `_dynamic` columns.
* The `industry_descr` column is provided in the industry names table.
* The `broad_sector` column is provided in the sector names table and `broad_sector_id` was created for this version of the table.

### USITC Gravity Variables

Name: `usitc_gravity`

Source: USITC, adapted from WTO, UN COMTRADE, National Geographic and other sources, with corrections made for the release

Format: A table with 1,940,681 rows and 67 columns for the period 1986-2020

|Variable name              |Variable description                                                                                 |
|:--------------------------|:----------------------------------------------------------------------------------------------------|
|year                       |Year of observation                                                                                  |
|iso3_o                     |3-digit ISO code of origin country                                                                   |
|dynamic_code_o             |Year appropriate 3-digit code of origin country                                                      |
|iso3_d                     |3-digit ISO code of destination country                                                              |
|dynamic_code_d             |Year appropriate 3-digit code of destination country                                                 |
|colony_of_destination_ever |Origin country was ever a colony of the destination country                                          |
|colony_of_origin_ever      |Destination country was ever a colony of the origin country                                          |
|colony_ever                |Country pair has been in a colonial relationship                                                     |
|common_colonizer           |Country pair has been colonized by a common colonizer                                                |
|common_legal_origin        |Country pair shares common legal origin                                                              |
|contiguity                 |Country pair shares a common border                                                                  |
|distance                   |Population weighted distance between country pair                                                    |
|member_gatt_o              |Origin country is a General Agreement on Tariffs and Trade member                                    |
|member_wto_o               |Origin country is a World Trade Organization member                                                  |
|member_eu_o                |Origin country is a European Union member                                                            |
|member_gatt_d              |Destination country is a General Agreement on Tariffs and Trade member                               |
|member_wto_d               |Destination country is a World Trade Organization member                                             |
|member_eu_d                |Destination country is a European Union member                                                       |
|member_gatt_joint          |Country pair are both members of the General Agreement on Tariffs and Trade                          |
|member_wto_joint           |Country pair are both members of the World Trade Organization                                        |
|member_eu_joint            |Country pair are both members of the European Union                                                  |
|lat_o                      |Latitude coordinate of origin country                                                                |
|lng_o                      |Longitude coordinate of origin country                                                               |
|lat_d                      |Latitude coordinate of destination country                                                           |
|lng_d                      |Longitude coordinate of destination country                                                          |
|landlocked_o               |Origin country is landlocked                                                                         |
|island_o                   |Origin country is an island                                                                          |
|region_id_o                |Geographic region of origin country                                                                  |
|landlocked_d               |Destination country is landlocked                                                                    |
|island_d                   |Destination country is an island                                                                     |
|region_id_d                |Geographic region of destination country                                                             |
|agree_pta_goods            |Country pair is in at least one active preferential trade agreement covering goods                   |
|agree_pta_services         |Country pair is in at least one active preferential trade agreement covering services                |
|agree_fta                  |Country pair is in at least one free trade agreement                                                 |
|agree_eia                  |Country pair is in at least one economic integration agreement                                       |
|agree_cu                   |Country pair is in at least one customs union                                                        |
|agree_psa                  |Country pair is in at least one partial scope agreement                                              |
|agree_fta_eia              |Country pair is in at least one free trade agreement and at least one economic integration agreement |
|agree_cu_eia               |Country pair is in at least one customs union and at least one economic integration agreement        |
|agree_pta                  |Country pair is in at least one active preferential trade agreement covering goods                   |
|capital_const_d            |Capital stock at constant prices of destination country                                              |
|capital_const_o            |Capital stock at constant prices of origin country                                                   |
|capital_cur_d              |Capital stock at current PPP of destination country                                                  |
|capital_cur_o              |Capital stock at current PPP of origin country                                                       |
|gdp_pwt_const_d            |Real, inflation-adjusted, PPP-adjusted GDP of destination country (PWT)                              |
|gdp_pwt_const_o            |Real, inflation-adjusted, PPP-adjusted GDP of origin country (PWT)                                   |
|gdp_pwt_cur_d              |Real, current, PPP-adjusted GDP of destination country (PWT)                                         |
|gdp_pwt_cur_o              |Real, current, PPP-adjusted GDP of origin country (PWT)                                              |
|pop_d                      |Population of destination country                                                                    |
|pop_o                      |Population of origin country                                                                         |
|hostility_level_o          |Level of the origin/destination country’s hostility toward the destination country                   |
|hostility_level_d          |Level of the origin/destination country’s hostility toward the origin country                        |
|common_language            |Residents of country pair speak at least one common language                                         |
|polity_o                   |Polity (political stability) score of origin country                                                 |
|polity_d                   |Polity (political stability) score of destination country                                            |
|sanction_threat            |There exists a threat of sanction between one country in a record towards the other                  |
|sanction_threat_trade      |There exists a threat of trade sanction between one country in a record towards the other            |
|sanction_imposition        |There exists a sanction between one country in a record towards the other                            |
|sanction_imposition_trade  |There exists a trade sanction between one country in a record towards the other                      |
|gdp_wdi_cur_o              |Nominal GDP of origin country (WDI)                                                                  |
|gdp_wdi_cap_cur_o          |Nominal GDP per capita of origin country (WDI)                                                       |
|gdp_wdi_const_o            |Real, current, PPP-adjusted GDP of origin country (PWT)                                              |
|gdp_wdi_cap_const_o        |Real GDP per capita of origin country (WDI)                                                          |
|gdp_wdi_cur_d              |Nominal GDP of destination country (WDI)                                                             |
|gdp_wdi_cap_cur_d          |Nominal GDP per capita of destination country (WDI)                                                  |
|gdp_wdi_const_d            |Real, current, PPP-adjusted GDP of destination country (PWT)                                         |
|gdp_wdi_cap_const_d        |Real GDP per capita of destination country (WDI)                                                     |

Description: The data goes back to 1986 and is suited to join with the `trade` table.

Details: There are differences with respect to the original CSV files. This version provides a more compact representation of the data, with the following changes:

* Starts in 1986 instead of 1948.
* Is limited to ISO codes contained in the `trade` table.
* The `region_origin` and `region_destination` columns are provided in the `region names` table as `region_name` and can be joined by using the `region_id_` columns.

### USITC-Derived Country Names

Name: `usitc_country_names`

Source: Own creation, adapted from the original DGD

Format: A table with 267 rows and 3 columns

|Variable name         |Variable description                      |
|:---------------------|:-----------------------------------------|
|country_iso3          |ISO 3-letter alpha code of the country    |
|country_dynamic_code  |DGD's dynamic country code of the country |
|country_name          |Name of the country                       |

### USITC-Derived Industry Names

Name: `usitc_industry_names`

Source: Own creation, adapted from the original ITPD-E

Format: A table with 170 rows and 2 columns

|Variable name         |Variable description      |
|:---------------------|:-------------------------|
|industry_id           |ITPD industry code        |
|industry_descr        |ITPD industry description |

### USTIC-Derived Sector Names

Name: `usitc_sector_names`

Source: Own creation, adapted from the original ITPD-E

Format: A table with 4 rows and 2 columns

|Variable name         |Variable description |
|:---------------------|:--------------------|
|broad_sector_id       |Broad sector code    |
|broad_sector          |Broad sector         |

### USITC-Derived Region Names

Name usitc_region_names

Source Own creation, adapted from the original DGD

Format: A table with 15 rows and 2 columns

|Variable name         |Variable description |
|:---------------------|:--------------------|
|region_id             |Region code          |
|region                |Region name          |

### WTO Country Names

Name wto_country_names

Source: Own creation, adapted from the original SGD

Format: A table with 232 rows and 2 columns

|variable             |description                         |
|:--------------------|:-----------------------------------|
|country_iso3         |Country ISO3 alphabetic             |
|country_name         |Country name                        |

### WTO Trade

Name: `wto_trade`

Source: WTO

Format: A table with 972,692 rows and 5 columns for the period 1980-2016

|variable             |description                         |
|:--------------------|:-----------------------------------|
|pair_id              |Exporter-Importer index             |
|year                 |Year of observation                 |
|exporter_iso3        |Exporter ISO3 alphabetic            |
|importer_iso3        |Importer ISO3 alphabetic            |
|trade                |Trade flows in current US dollars   |

## Differences with the original sources.

All the codes to implement the changes are in the `code/` folder.

### CEPII

The key differences are:

* Fixes inconsistent indexing in the legal origins columns in the `cepii_gravity` table to match with the `cepii_legal_origin` table correctly.
* Includes explanations for the abbreviations (i.e., Customs Union (CU) instead of just CU for the RTA types)
* Removes Malaysia+Singapore in the country information table because it has no ISO-3 code and there is no trade or gravity information for it.
* Includes a dynamic ISO-3 code to be able to create primary keys, this is similar to the USITC dataset buw we added the code ANT.X for the Netherland Antilles + Aruba up to 1986.

Some changes that applied to Gravity V202102 but not to V202211 because those were corrected upstream:

* The RTA types equal to 8 were replaced by NAs, because those do not provide a description, are not aligned with the WTO classification, and do not allow to create a foreign key.

### USITC

The key differences are:

* Fixes duplicated ISO3 code + Dynamic code for Cambodia and West Samoa in the `usitc_country_names` table
* Fixes duplicated label "south_east_asia" vs "suth_east_asia" in the `usitc_region_names` table
* Fixes inconsistencies in the `usitc_gravity` table

The last point deserves an example. See the differences in the `common_colonizer` variable for Argentina-Chile-Peru and Spain. This variable should be the same, for example, for ARG-CHL or CHL-ARG, but it's not in the original dataset.

```
> tbl(con, "usitc_gravity") %>% 
+   filter(iso3_o == "ARG", iso3_d %in% c("CHL", "ESP", "PER"), year == 2015) %>%
+   select(iso3_o, iso3_d, colony_of_origin_ever, colony_of_destination_ever, colony_ever, common_colonizer)
# Source:   SQL [3 x 6]
# Database: postgres  [pacha@localhost:5432/gravitydatasets]
  iso3_o iso3_d colony_of_origin_ever colony_of_destination_ever colony_ever common_colonizer
  <chr>  <chr>                  <int>                      <int>       <int>            <int>
1 ARG    CHL                        0                          0           0                0
2 ARG    ESP                        0                          1           1                0
3 ARG    PER                        0                          0           0                0

> tbl(con, "usitc_gravity") %>% 
+   filter(iso3_d == "ARG", iso3_o %in% c("CHL", "ESP", "PER"), year == 2015) %>%
+   select(iso3_o, iso3_d, colony_of_origin_ever, colony_of_destination_ever, colony_ever, common_colonizer)
# Source:   SQL [3 x 6]
# Database: postgres  [pacha@localhost:5432/gravitydatasets]
  iso3_o iso3_d colony_of_origin_ever colony_of_destination_ever colony_ever common_colonizer
  <chr>  <chr>                  <int>                      <int>       <int>            <int>
1 CHL    ARG                        0                          0           0                1
2 ESP    ARG                        1                          0           1                0
3 PER    ARG                        0                          0           0                1
```

I corrected this by using the gravity table itself in two ways:

* By binding rows on a pairwise basis for all symmetrical variables (i.e., `common_colonizer`) and obtained the maximum for each pair.
* By obtaining a full join on a pairwise basis for all non-symmetrical variables (i.e., `colony_of_origin_ever`) and obtained the maximum for each pair.

To check this I ran some queries to verify, for example, that the populations for CHL-ESP are around `c(20,40)` and not `c(40,40)` (i.e., Spain doubles the population of Chile), and that for the same pair `colony_of_origin_ever = 0` but for ESP-CHL `colony_of_origin_ever = 1`.

### WTO

No modification besides adding the full country names in a separate table from trade.

## Usage

Estimating the gravity model of trade with exporter/importer time fixed effects for 4 sectors:

```r
# install_github("r-dbi/RPostgres") # optional: use the cpp11-based version

library(RPostgres)
library(dplyr)
library(purrr)
library(fixest)

con <- dbConnect(
  Postgres(),
  user = Sys.getenv("LOCAL_SQL_USR"),
  password = Sys.getenv("LOCAL_SQL_PWD"),
  dbname = "gravitydatasets",
  host = "localhost"
)

# run one model per sector
models <- map(
  tbl(con, "usitc_sector_names") %>% pull(broad_sector_id),
  function(s) {
    message(s)
    
    yrs <- seq(2005, 2015, by = 5)
    
    d <- tbl(con, "usitc_trade") %>% 
      filter(year %in% yrs, broad_sector_id == s) %>% 
      group_by(year, exporter_iso3, importer_iso3, broad_sector_id) %>% 
      summarise(trade = sum(trade, na.rm = T)) %>% 
      inner_join(
        tbl(con, "usitc_gravity") %>% 
          filter(year %in% yrs) %>% 
          select(iso3_o, iso3_d, contiguity, common_language, colony_ever, distance),
        by = c("exporter_iso3" = "iso3_o", "importer_iso3" = "iso3_d")
      ) %>% 
      collect()
    
    d <- d %>% 
      mutate(
        etfe = paste(exporter_iso3, year, sep = "_"),
        itfe = paste(importer_iso3, year, sep = "_")
      )
    
    feglm(trade ~ contiguity + common_language + colony_ever + 
            log(distance) | etfe + itfe,
          family = quasipoisson(),
          data = d)
  }
)

dbDisconnect(con)
```

```r
print(models)

[[1]]
GLM estimation, family = quasipoisson, Dep. Var.: trade
Observations: 243,259 
Fixed-effects: etfe: 666,  itfe: 685
Standard-errors: Clustered (etfe) 
                 Estimate Std. Error   t value   Pr(>|t|)    
contiguity      -1.100653   0.095092 -11.57462  < 2.2e-16 ***
common_language  0.909522   0.093396   9.73833  < 2.2e-16 ***
colony_ever     -0.580546   0.123115  -4.71548 2.9394e-06 ***
log(distance)   -2.290567   0.049593 -46.18709  < 2.2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
                                           
  Squared Cor.: 0.995063                   

[[2]]
GLM estimation, family = quasipoisson, Dep. Var.: trade
Observations: 392,413 
Fixed-effects: etfe: 699,  itfe: 699
Standard-errors: Clustered (etfe) 
                 Estimate Std. Error   t value   Pr(>|t|)    
contiguity      -0.607763   0.066653  -9.11825  < 2.2e-16 ***
common_language  1.017510   0.122499   8.30624 5.1286e-16 ***
colony_ever     -0.349214   0.095491  -3.65703 2.7435e-04 ***
log(distance)   -1.232183   0.079635 -15.47282  < 2.2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
                                           
  Squared Cor.: 0.993544                   

[[3]]
GLM estimation, family = quasipoisson, Dep. Var.: trade
Observations: 183,063 
Fixed-effects: etfe: 658,  itfe: 682
Standard-errors: Clustered (etfe) 
                 Estimate Std. Error   t value  Pr(>|t|)    
contiguity      -1.288772   0.104207 -12.36742 < 2.2e-16 ***
common_language  1.346403   0.132482  10.16290 < 2.2e-16 ***
colony_ever     -0.288555   0.222484  -1.29697    0.1951    
log(distance)   -2.298211   0.074100 -31.01505 < 2.2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
                                           
  Squared Cor.: 0.992104                   

[[4]]
GLM estimation, family = quasipoisson, Dep. Var.: trade
Observations: 46,359 
Fixed-effects: etfe: 578,  itfe: 579
Standard-errors: Clustered (etfe) 
                 Estimate Std. Error    t value  Pr(>|t|)    
contiguity      -2.671951   0.183679 -14.546876 < 2.2e-16 ***
common_language  1.612855   0.127482  12.651606 < 2.2e-16 ***
colony_ever      0.139054   0.170712   0.814552   0.41566    
log(distance)   -2.267021   0.081151 -27.935858 < 2.2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
                                           
  Squared Cor.: 0.998325
```

## Installing the database locally

You need PostgreSQL. An excellent guide is provided by [DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-install-postgresql-on-ubuntu-22-04-quickstart).

Download the [current version](https://github.com/pachadotdev/gravitydatasets/releases/download/v0.4/gravitydatasets.sql), and then from the command line create a SQL database and restore the downloaded dump.

```bash
createdb gravitydatasets
pg_restore gravitydatasets.sql -d gravitydatasets
```

## Additional configurations

In order to maximize PostgreSQL performance, I obtained this configuration from pgtune.leopard.in.ua:

```sql
# DB Version: 14
# OS Type: linux
# DB Type: desktop
# Total Memory (RAM): 16 GB
# CPUs num: 8
# Connections num: 20
# Data Storage: ssd

ALTER SYSTEM SET
 max_connections = '20';
ALTER SYSTEM SET
 shared_buffers = '1GB';
ALTER SYSTEM SET
 effective_cache_size = '4GB';
ALTER SYSTEM SET
 maintenance_work_mem = '1GB';
ALTER SYSTEM SET
 checkpoint_completion_target = '0.9';
ALTER SYSTEM SET
 wal_buffers = '16MB';
ALTER SYSTEM SET
 default_statistics_target = '100';
ALTER SYSTEM SET
 random_page_cost = '1.1';
ALTER SYSTEM SET
 effective_io_concurrency = '200';
ALTER SYSTEM SET
 work_mem = '10922kB';
ALTER SYSTEM SET
 min_wal_size = '100MB';
ALTER SYSTEM SET
 max_wal_size = '2GB';
ALTER SYSTEM SET
 max_worker_processes = '8';
ALTER SYSTEM SET
 max_parallel_workers_per_gather = '4';
ALTER SYSTEM SET
 max_parallel_workers = '8';
ALTER SYSTEM SET
 max_parallel_maintenance_workers = '4';
```

This must be inserted by using the `postgres` user (i.e., `sudo -i -u postgres && psql`).

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

This is run as an independent project, if this was useful for you, please consider [sponsoring](https://github.com/sponsors/pachadotdev) or [donating](https://buymeacoffee.com/pacha).

## Collaborating

I am really interested in the gravity model of trade. If you are working on this topic, please reach out to me, I would love to collaborate.

## License

[CC-BY-NC-SA-4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/)
