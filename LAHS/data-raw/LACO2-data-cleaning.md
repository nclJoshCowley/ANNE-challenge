---
title: "Local Authority CO2 Emissions - Data Cleaning Script"
author: "Josh Cowley"
date: "March 29, 2022"
output:
  html_document:
    number_sections: true
    toc: true
    toc_depth: 2
    toc_float:
      collapsed: false
    keep_md: true
params:
  use_data: TRUE
---



The purpose of this report is to convey all processes used and any decisions
made when the data was cleaned.
The source of this data (CSV) can be found at
<https://data.gov.uk/dataset/723c243d-2f1a-4d27-8b61-cdb93e5b10ff/uk-local-authority-and-regional-carbon-dioxide-emissions-national-statistics-2005-to-2019>.


```r
laco2_path <-
  file.path("data-raw", "source", "2005-19_Local_Authority_CO2_emissions.csv")
```

# Selection

For these data, we initially remove superfluous columns by defining the 
following specification.


```r
laco2_raw <- 
  laco2_path %>%
  readr::read_csv(
    col_select = -tidyselect::all_of(
      c("Country", "Country Code", "Region Code", "Second Tier Authority")
    ),
    show_col_types = FALSE
  )
```

-  Country = col_skip(),
-  `Country Code` = col_skip(),
-  Region = col_character(),
-  `Region Code` = col_skip(),
-  `Second Tier Authority` = col_skip(),
-  `Local Authority` = col_character(),
-  `Local Authority Code` = col_character(),
-  `Calendar Year` = col_double(),
-  `LA CO2 Sector` = col_character(),
-  `LA CO2 Sub-sector` = col_character(),
-  `Territorial emissions (kt CO2)` = col_double(),
-  `Emissions within the scope of influence of LAs (kt CO2)` = col_double(),
-  `Mid-year Population (thousands)` = col_double(),
-  `Area (km2)` = col_double()

# Renaming

Then, we rename the columns to make joining with `LAHS` easier and to improve conciseness


```r
LACO2 <- 
  laco2_raw %>%
  dplyr::rename(
    LA_CODE = `Local Authority Code`,
    LA_NAME = `Local Authority`,
    LA_REGION = Region,
    YEAR = `Calendar Year`,
    CO2_SECTOR = `LA CO2 Sector`,
    CO2_SUBSECTOR = `LA CO2 Sub-sector`,
    CO2_EMISSIONS = `Territorial emissions (kt CO2)`,
    CO2_LA_EMISSIONS = `Emissions within the scope of influence of LAs (kt CO2)`,
    LA_POPULATION = `Mid-year Population (thousands)`,
    LA_AREA = `Area (km2)`
  )
```

# Removal

We see some of the data has no region and is logged under the local authority 
name "Unallocated electricity NI", "Unallocated consumption" and "Large elec 
users (high voltage lines) unknown location" which we remove from the data.


```r
LACO2 <- dplyr::filter(LACO2, !is.na(.data$LA_REGION))
```

# Access to these Data



One can access this data by installing this package and importing the dataset.


```r
data("LAHS", package = "LAHS")
```
