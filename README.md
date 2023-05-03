# Gravity Datasets

<!-- badges: start -->
<!-- badges: end -->

## About

Aims at gathering in a single place a set of variables adapted that could be useful to researchers or practitioners that use the structural gravity model of trade. We provide trade flows, as well as geographic, cultural, trade facilitation and macroeconomic variables. The tables provided here were reshaped under Cobb's Normal Form, and in some cases contain corrections that we explain in the GitHub repository. The specific sources are the [Gravity database](http://www.cepii.fr/CEPII/en/bdd_modele/bdd_modele_item.asp?id=8) from the Center for Prospective Studies and International Information (CEPII), the [International Trade and Production Database for Estimation (ITPD-E)](https://www.usitc.gov/data/gravity/itpde.htm) and the [Dynamic Gravity Database (DGD)](https://www.usitc.gov/data/gravity/dgd.htm) from the US International Trade Commission (USITC), and the [Structural Gravity Database (SGD)](https://www.wto.org/english/res_e/reser_e/structural_gravity_e.htm) from the World Trade Organization (WTO).

`gravitydatasets` can be installed by running

```
# install.packages("remotes")
remotes::install_github("pachadotdev/gravitydatasets")
```

## Sources

Conte, M., Cotterlaz, P. & Mayer, T. (2021). *The CEPII Gravity Database*. CEPII Working Paper 2022-05.

Borchert, Ingo & Larch, Mario & Shikher, Serge & Yotov, Yoto, 2020. *The International Trade and Production Database for Estimation (ITPD-E)*. School of Economics Working Paper Series 2020-5, LeBow College of Business, Drexel University.

Gurevich, Tamara & Herman, Peter, 2018. *The Dynamic Gravity Dataset: 1948-2016*. USITC Working Paper 2018-02-A.

Larch, Mario & Monteiro, José-Antonio & Piermartini, Roberta & Yotov, Yoto, 2019. *On the Effects of GATT/WTO Membership on Trade: They are Positive and Large After All*. WTO Staff Working Papers ERSD-2019-09, World Trade Organization (WTO), Economic Research and Statistics Division.

## Differences with the original sources.

All the codes to implement the changes are in the `dev/` folder.

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
# Database: postgres  [pacha@localhost:5432/tariff_man]
  iso3_o iso3_d colony_of_origin_ever colony_of_destination_ever colony_ever common_colonizer
  <chr>  <chr>                  <int>                      <int>       <int>            <int>
1 ARG    CHL                        0                          0           0                0
2 ARG    ESP                        0                          1           1                0
3 ARG    PER                        0                          0           0                0

> tbl(con, "usitc_gravity") %>% 
+   filter(iso3_d == "ARG", iso3_o %in% c("CHL", "ESP", "PER"), year == 2015) %>%
+   select(iso3_o, iso3_d, colony_of_origin_ever, colony_of_destination_ever, colony_ever, common_colonizer)
# Source:   SQL [3 x 6]
# Database: postgres  [pacha@localhost:5432/tariff_man]
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
library(gravitydatasets)
library(dplyr)
library(purrr)
library(fixest)

con <- gravitydatasets_connect()

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

gravitydatasets_disconnect()
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
