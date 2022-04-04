---
title: "English Housing Survey - Data Cleaning Script"
author: "Josh Cowley"
date: "April 04, 2022"
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




```r
source(file.path("data-raw", "EHS-data-cleaning-helper.R"))
```

The purpose of this report is to convey all processes used and any decisions
made when the data was cleaned.

Note that the raw data is not stored on this git repository in line with the 
End User Licence agreement set out by the UK Data Archive (UKDA), more 
information is available in the README(s) located in "data-raw/source/EHS".

# Obtaining Raw Data

We are interested in the following studies that cover the EHS from 2014/15 to 
2018/19. Older historical data is available with minor structural differences.

## Alternating Studies

The data is collated on a 2-year rolling period.  

For example, study 8186 that holds data for 2014/15 and 2015/16 which overlaps 
study 8350 that holds data for 2015/16 and 2016/17.

Hence, we only extract alternating studies as per instruction of the EHS.


```r
study_ids <- 
  c(
    8186,     # 2014-15 AND 2015-16
    #8350,    # 2015-16 AND 2016-17
    8494,     # 2016-17 AND 2017-18
    #8670,    # 2017-18 AND 2018-19
    8923      # 2018-19 AND 2019-20
  )
```

These studies are from [Series 200010][s200010], GN 33422 and are downloaded in
`tab` format (tab delimited data).

[s200010]:
  https://beta.ukdataservice.ac.uk/datacatalogue/series/series?id=200010

Hence the main directories containing data (once unzipped) are given by:


```r
study_dirs <-
  file.path(
    "data-raw",
    "source",
    "EHS",
    sprintf("UKDA-%i-tab", study_ids),
    "tab"
  )
```

## Filepaths

The following lists the directories of each `general` data sheet (general 
information) and each `physical` data sheet (physical inspection data).

See [`README_EHS_VARS.md`](source/EHS/README_EHS_VARS.md) for more information.


```r
general_paths <- 
  purrr::map_chr(study_dirs, list.files, "^general", full.names = TRUE)

physical_paths <- 
  purrr::map_chr(study_dirs, list.files, "^physical", full.names = TRUE)
```

## Missing Columns

The following helper highlights any expected columns that are missing over a 
whole dataset.


```r
general_data <- 
  purrr::map_dfr(general_paths, read_general_tsv, .id = "source") %>%
  dplyr::mutate(source = factor(.data$source, labels = general_paths))


physical_data <- 
  purrr::map_dfr(physical_paths, read_physical_tsv, .id = "source") %>%
  dplyr::mutate(source = factor(.data$source, labels = physical_paths))
```

No warnings means all columns were found in all data.

## Verification

The EHS releases the following sample sizes to be used as verification for 
datasets gathered.

<details><summary>Reveal table source code</summary>

```r
ehs_verification <- 
  tibble::tribble(
    ~EHS, ~Dwellings, ~Households,
    "EHS2008    ", 16150, 15523,
    "EHS2009    ", 16150, 15512,
    "EHS2010    ", 16670, 16047,
    "EHS2011    ", 14951, 14386,
    "EHS2012    ", 12763, 12269,
    "EHS2013    ", 12498, 12008,
    "EHS2014    ", 12297, 11851,
    "EHS2015 (*)", 12351, 11955,
    "EHS2016    ", 12292, 11924,
    "EHS2017 (*)", 12320, 11963,
    "EHS2018    ", 12562, 12203,
    "EHS2019 (*)", 12300, 11974
  )

ehs_verification %>%
  kableExtra::kbl() %>%
  kableExtra::kable_styling() %>%
  kableExtra::footnote(symbol = "Datasets used in this project")
```



</details><table class="table" style="margin-left: auto; margin-right: auto;border-bottom: 0;">
 <thead>
  <tr>
   <th style="text-align:left;"> EHS </th>
   <th style="text-align:right;"> Dwellings </th>
   <th style="text-align:right;"> Households </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> EHS2008 </td>
   <td style="text-align:right;"> 16150 </td>
   <td style="text-align:right;"> 15523 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> EHS2009 </td>
   <td style="text-align:right;"> 16150 </td>
   <td style="text-align:right;"> 15512 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> EHS2010 </td>
   <td style="text-align:right;"> 16670 </td>
   <td style="text-align:right;"> 16047 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> EHS2011 </td>
   <td style="text-align:right;"> 14951 </td>
   <td style="text-align:right;"> 14386 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> EHS2012 </td>
   <td style="text-align:right;"> 12763 </td>
   <td style="text-align:right;"> 12269 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> EHS2013 </td>
   <td style="text-align:right;"> 12498 </td>
   <td style="text-align:right;"> 12008 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> EHS2014 </td>
   <td style="text-align:right;"> 12297 </td>
   <td style="text-align:right;"> 11851 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> EHS2015 (*) </td>
   <td style="text-align:right;"> 12351 </td>
   <td style="text-align:right;"> 11955 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> EHS2016 </td>
   <td style="text-align:right;"> 12292 </td>
   <td style="text-align:right;"> 11924 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> EHS2017 (*) </td>
   <td style="text-align:right;"> 12320 </td>
   <td style="text-align:right;"> 11963 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> EHS2018 </td>
   <td style="text-align:right;"> 12562 </td>
   <td style="text-align:right;"> 12203 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> EHS2019 (*) </td>
   <td style="text-align:right;"> 12300 </td>
   <td style="text-align:right;"> 11974 </td>
  </tr>
</tbody>
<tfoot><tr><td style="padding: 0; " colspan="100%">
<sup>*</sup> Datasets used in this project</td></tr></tfoot>
</table>

Which can be compared to our data.

<details><summary>Reveal table source code</summary>

```r
dplyr::count(general_data, .data$source) %>%
  kableExtra::kbl(col.names = c("Source", "Rows found")) %>%
  kableExtra::kable_styling()
```



</details><table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> Source </th>
   <th style="text-align:right;"> Rows found </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> data-raw/source/EHS/UKDA-8186-tab/tab/general_14plus15_eul.tab </td>
   <td style="text-align:right;"> 12351 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> data-raw/source/EHS/UKDA-8494-tab/tab/general16_17_eul.tab </td>
   <td style="text-align:right;"> 12320 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> data-raw/source/EHS/UKDA-8923-tab/tab/general_18plus19_eul.tab </td>
   <td style="text-align:right;"> 12300 </td>
  </tr>
</tbody>
</table>

The source of the data is removed after this verification as we can recover the 
year the data was reported using the serial numbers.


```r
general_data <- 
  dplyr::mutate(
    general_data,
    source = NULL,
    YEAR = 2000 + as.integer(substr(.data$serialanon, 1, 2)),
    .before = 1
  )

physical_data <- 
  dplyr::mutate(
    physical_data,
    source = NULL,
    YEAR = 2000 + as.integer(substr(.data$serialanon, 1, 2)),
    .before = 1
  )
```

# General

All coded variables are converted to factors for easier data visualisation.


```r
general_data <- 
  
  general_data %>%
  
  label_data_column(
    column = "gorEHS",
    ~id, ~nm,
    1, "North East",
    2, "North West",
    4, "Yorkshire and the Humber",
    5, "East Midlands",
    6, "West Midlands",
    7, "East",
    8, "London",
    9, "South East",
    10, "South West"
  ) %>%
  
  label_data_column(
    column = "tenure4x",
    ~id, ~nm,
    1, "Owner occupied",
    2, "Private rented",
    3, "Local authority",
    4, "Housing association"
  ) %>%

  label_data_column(
    column = "vacantx",
    ~id, ~nm,
    1, "Occupied",
    2, "Vacant"
  )
```

# Physical

We do the same relabelling for `physical` except for `dampalf` which we assign 
to be a binary variable.


```r
physical_data <- 
  
  physical_data %>%
  
  label_data_column(
    column = "alltypex",
    ~id, ~nm,
    -8, "NA",
    1, "Purpose built flat, high rise",
    2, "Purpose built flat, low rise",
    3, "Converted flat",
    4, "Bungalow : all ages",
    5, "Detached house : pre 1919",
    6, "Detached house : post 1919",
    7, "Semi detached & terraced : pre 1919",
    8, "Semi detached & terraced : 1919-1944",
    9, "Semi detached & terraced : 1945-1964",
    1, "Semi detached & terraced : 1965 onwards") %>%
  
  label_data_column(
    column = "boiler",
    ~id, ~nm,
    -9, "NA",
    1, "Standard boiler (floor or wall)",
    2, "Back boiler (to fire or stove)",
    3, "Combination boiler",
    4, "Condensing boiler",
    5, "Condensing-combination boiler"
  ) %>%
  
  label_data_column(
    column = "dampalf",
    ~id, ~nm,
    0, "Not present",
    1, "Damp present"
  ) %>%
  
  label_data_column(
    column = "dblglaz4",
    ~id, ~nm,
    -8, "NA",
    1, "No double glazing",
    2, "Less than half",
    3, "More than half",
    4, "Entire house"
  ) %>%
  
  label_data_column(
    column = "EPceeb12e",
    ~id, ~nm,
    2, "A/B",
    3, "C",
    4, "D",
    5, "E",
    6, "F",
    7, "G",
  ) %>%
  
  label_data_column(
    column = "EPceib12e",
    ~id, ~nm,
    2, "A/B",
    3, "C",
    4, "D",
    5, "E",
    6, "F",
    7, "G",
  ) %>%
  
  label_data_column(
    column = "fuelx",
    ~id, ~nm,
    -8, "NA",
    1, "Gas fired system",
    2, "Oil fired system",
    3, "Solid fuel fired system",
    4, "Electrical system"
  ) %>%
  
  label_data_column(
    column = "loftins6",
    ~id, ~nm,
    -9, "NA",
    1, "None",
    2, "Less than 50mm",
    3, "50 up to 99mm",
    4, "100 up to 149mm",
    5, "150 up to 199mm",
    6, "200mm or more"
  ) %>%

  label_data_column(
    column = "wallinsz",
    ~id, ~nm,
    1, "Cavity with insulation",
    2, "Cavity uninsulated",
    3, "Solid with insulation",
    4, "Solid uninsulated",
    5, "Other"
  ) %>%
  
  label_data_column(
    column = "watersys",
    ~id, ~nm,
    1, "With central heating",
    2, "Dedicated boiler",
    3, "Electric immersion heater",
    4, "Instantaneous",
    5, "Other"
  )
```

We then make sure any NA values are explicitly missing.


```r
physical_data <-
  dplyr::mutate(physical_data, dplyr::across(.fns = ~ dplyr::na_if(.x, "NA")))
```

# Access to these Data



One can access this data by downloading the data from UKDA, compiling this 
report and building the LAHS package, then, import the dataset.


```r
data("EHS", package = "LAHS")
```
