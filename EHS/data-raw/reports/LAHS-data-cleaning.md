---
title: "Local Authority Housing Statistics - Data Cleaning Script"
author: "Josh Cowley"
date: "May 02, 2022"
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
source(file.path("data-raw", "LAHS-data-cleaning-helper.R"))
```

The purpose of this report is to convey all processes used and any decisions
made when the data was cleaned.
The source of this data (CSV) can be found at
<https://www.gov.uk/government/statistical-data-sets/local-authority-housing-statistics-open-data>.

Currently, we are interested in a subset of these data and as such will 
populate a new data frame as we clean the data.


```r
lahs_path <-
  file.path("data-raw", "source", "LAHS_201112_to_202021_open_data_02_2022.csv")

lahs_csv <- utils::read.csv(lahs_path)

LAHS <- tibble::tibble(.rows = nrow(lahs_csv))
```

# Local Authority Information

## Unique Identifiers

We use the local authority code and name at the time of data collection,
ignoring the codes and names using the 2020 geography


```r
LAHS$LA_CODE <- lahs_csv$LA_CODE
LAHS$LA_NAME <- lahs_csv$LA_NAME
```

There are 332 unique local authorities.
Most have 10 data points, one for each year, but this is not always the case.
The following visualisation summarises the LA(s) that have fewer than 10 
observations.

<details><summary>Reveal ggplot2 code.</summary>

```r
LAHS %>%
  dplyr::count(.data$LA_NAME) %>%
  dplyr::filter(.data$n != 10) %>%
  ggplot2::ggplot(ggplot2::aes(
    y = forcats::fct_rev(factor(.data$LA_NAME)),
    xmax = .data$n,
  )) +
  ggplot2::geom_linerange(xmin = 0) +
  ggplot2::scale_x_continuous(breaks = 1:10, limits = c(1, 10)) +
  ggplot2::labs(y = NULL, x = "Number of Datum")
```



</details><img src="LAHS-data-cleaning_files/figure-html/plot-la-code-name-issues-1.png" width="100%" style="display: block; margin: auto;" />

In a later Section (Data Subsetting) we mark for removal any LA with less than 
5 data points shown above.

## Classification

We are also interested in the categorical information that is held in the first 
three characters of the local authority code and in its own column.

For example, Darlington is coded "E06000005"; the "E06" implies that this LA
is a unitary authority. We convert each code to a corresponding label.


```r
LAHS$LA_TYPE <- parse_la_type(lahs_csv$LAD20TYPE)
```

We can see the respective sample sizes of such divisions here.

<details><summary>Reveal table generating code.</summary>

```r
dplyr::count(LAHS, .data$LA_TYPE) %>%
  kableExtra::kbl(col.names = c("Local Authority Type", "N"), align = "lr") %>%
  kableExtra::kable_styling()
```



</details><table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> Local Authority Type </th>
   <th style="text-align:right;"> N </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Unitary authority </td>
   <td style="text-align:right;"> 609 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Lower tier district authority </td>
   <td style="text-align:right;"> 1940 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Metropolitan local authority </td>
   <td style="text-align:right;"> 360 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> London borough </td>
   <td style="text-align:right;"> 330 </td>
  </tr>
</tbody>
</table>

A further classification can be made on the region each LA exists in.


```r
LAHS$LA_REGION <- lahs_csv$RGN20NM
```

With a similar table also made.

<details><summary>Reveal table generating code.</summary>

```r
dplyr::count(LAHS, .data$LA_REGION) %>%
  kableExtra::kbl(col.names = c("English Region", "N"), align = "lr") %>%
  kableExtra::kable_styling()
```



</details><table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> English Region </th>
   <th style="text-align:right;"> N </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> East Midlands </td>
   <td style="text-align:right;"> 400 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> East of England </td>
   <td style="text-align:right;"> 466 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> London </td>
   <td style="text-align:right;"> 330 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> North East </td>
   <td style="text-align:right;"> 120 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> North West </td>
   <td style="text-align:right;"> 390 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> South East </td>
   <td style="text-align:right;"> 667 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> South West </td>
   <td style="text-align:right;"> 356 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> West Midlands </td>
   <td style="text-align:right;"> 300 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Yorkshire and The Humber </td>
   <td style="text-align:right;"> 210 </td>
  </tr>
</tbody>
</table>

# Temporal Information

The raw data spans a decade and lists the years in plain text, that is, 
"2011-12", "2012-13" to "2020-21".
To convert this to numerical information we obtain the data as year start 
information so a value of $20$ denotes the duration from tax year start, 2020,
to tax year end, 2021.


```r
LAHS$YEAR <- 
  lahs_csv$Year %>%
  regmatches(regexpr("^20[0-9]{2}", .)) %>%
  as.integer()
```

# Section A: Dwelling Stock

Section A, as described in the LAHS guidance document informs about the number
and value of dwellings within the LA.

## Ownership

Questions a.1.a) and a.1.b) relate to any publicly owned property within a LA,
whereas a.2.i.a) relates to all stock owned by the corresponding LA with option
to dig deeper into how many are "Social Rent" against "Affordable Rent".


```r
LAHS$STOCK_PUBLIC_LA <- lahs_csv$a1a
LAHS$STOCK_PUBLIC_OTHER <- lahs_csv$a1b
LAHS$STOCK <- lahs_csv$a2ia
```

Now, we see many of the data points concern local auhthorities that own no
dwelling stock and thus will be unusable.

<details><summary>Reveal table generating code.</summary>

```r
local({
  raw_stock_table <- 
    LAHS %>%
    dplyr::count(g = ceiling(.data$STOCK / 1e4)) %>%
    dplyr::mutate(
      lower = prettyNum(1e4 * (g - 1) + 1, big.mark = ","),
      upper = prettyNum(1e4 * g, big.mark = ","),
      stock_tb = paste(.data$lower, .data$upper, sep = " - "),
      .before = 1, .keep = "unused"
    )
  
  raw_stock_table$stock_tb[1] <- "No dwellings owned"
  
  raw_stock_table %>%
    dplyr::select(.data$stock_tb, .data$n) %>%
    kableExtra::kbl(col.names = c("Owned Stock", "N"), align = "lr") %>%
    kableExtra::kable_styling()
})
```



</details><table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> Owned Stock </th>
   <th style="text-align:right;"> N </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> No dwellings owned </td>
   <td style="text-align:right;"> 1520 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1 - 10,000 </td>
   <td style="text-align:right;"> 1162 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 10,001 - 20,000 </td>
   <td style="text-align:right;"> 346 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 20,001 - 30,000 </td>
   <td style="text-align:right;"> 170 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 30,001 - 40,000 </td>
   <td style="text-align:right;"> 16 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 40,001 - 50,000 </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 50,001 - 60,000 </td>
   <td style="text-align:right;"> 11 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 60,001 - 70,000 </td>
   <td style="text-align:right;"> 9 </td>
  </tr>
</tbody>
</table>

## Value

The value of all dwellings in a LA is reported in the millions of pounds and
accurate to 3 decimal places.


```r
LAHS$STOCK_VALUE <- lahs_csv$a3a
```

# Section F: Condition of Dwelling Stock

Section F, as described in the LAHS guidance document, is where we focus for the
environmental impact.
Each question is label is also shown in the headings to help matching with any
official documentation

## EPC

Question F.1.a) is concerned with the *average* rating of all properties.
The LA is instructed to calculate the mean of the SAP (Standard Assessment 
Procedure) for each dwelling and report the EPC band of this result.

We note that in the CSV, some values are missing (coded as "") and need to be 
converted to explicit missing data and some (1) values are miscoded in
lowercase.


```r
LAHS$EPC <- 
  lahs_csv$f1a %>%
  dplyr::na_if("") %>%
  stringr::str_to_upper()
```

<details><summary>Reveal table generating code.</summary>

```r
dplyr::count(LAHS, .data$EPC) %>%
  kableExtra::kbl(col.names = c("EPC Average", "N"), align = "lr") %>%
  kableExtra::kable_styling()
```



</details><table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> EPC Average </th>
   <th style="text-align:right;"> N </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 117 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B </td>
   <td style="text-align:right;"> 16 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> C </td>
   <td style="text-align:right;"> 958 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> D </td>
   <td style="text-align:right;"> 691 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> E </td>
   <td style="text-align:right;"> 21 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> F </td>
   <td style="text-align:right;"> 7 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> G </td>
   <td style="text-align:right;"> 11 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;"> 1418 </td>
  </tr>
</tbody>
</table>

## Boiler Replacement

Raw quantity of boilers replaced, regardless of energy efficiency rating of the 
boiler.


```r
LAHS$NEW_BOILERS <- lahs_csv$f2ba
```

## Insulation

We are given a total of insulation installed by question f.2.c.a) with more 
granular details given by sub-questions.


```r
LAHS$INSULATION <- lahs_csv$f2ca

LAHS$INSULATION_SOLID <- lahs_csv$f2caa
LAHS$INSULATION_CAVITY <- lahs_csv$f2cba
LAHS$INSULATION_LOFT <- lahs_csv$f2cca
LAHS$INSULATION_FLOOR <- lahs_csv$f2cda
```

## Renewables

Question f.2.d.a) allows local authorities to report the number of dwellings 
that have had renewable technologies installed.


```r
LAHS$RT_TOTAL <- lahs_csv$f2da
```

The sub-part of this question codes the renewable types in the following way,
for each of the following that have been installed, add the corresponding value
to a total.

- 1 = photovoltaic panels
- 2 = solar thermal
- 4 = heat pumps (air, ground or water)
- 8 = biomass boilers
- 16 = wind turbines
- 32 = other

Thus the value of f.2.d.a.a) uniquely determines 6 binary variables that can be
recovered by converting to binary.
For example, 42 (10 10 01 in  binary) implies the installation of other, 
biomass boilers and photovoltaic panels.

Note the presence of missing values are assumed to be 0.


```r
LAHS <- 
  dplyr::bind_cols(
    LAHS,
    parse_rt_types(
      tidyr::replace_na(lahs_csv$f2daa, replace = 0)
    )
  )
```

# Data Subsetting

Peeking the data shows that many observations equate to a null value, that is,
they own no stock at the corresponding year. Other data quality issues persist
but are not mentioned here.

Hence, we mark the following for removal

<details><summary>LA(s) with <5 data points</summary>

```r
incomplete_la <-
  local({
    tbl <- table(LAHS$LA_NAME)
    names(tbl)[tbl < 5]
  })
```



</details>

<details><summary>LA(s) reporting no stock over the last decade.</summary>

```r
no_stock_la <- 
  LAHS %>%
  dplyr::group_by(.data$LA_NAME) %>%
  dplyr::summarise(STOCK_MAX = max(.data$STOCK)) %>%
  dplyr::filter(.data$STOCK_MAX == 0) %>%
  dplyr::pull(.data$LA_NAME)
```



</details>

<details><summary>LA(s) with no reported EPC ratings over the last decade.</summary>

```r
no_epc_la <-
  LAHS %>%
  dplyr::group_by(.data$LA_NAME) %>%
  dplyr::summarise(N_EPC = sum(!is.na(.data$EPC))) %>%
  dplyr::filter(.data$N_EPC == 0) %>%
  dplyr::pull(.data$LA_NAME)
```



</details>

&nbsp;

And then split our data into a full version and a shorter version where the 
above LA(s) have been removed.


```r
la_removals <- unique(c(incomplete_la, no_stock_la, no_epc_la))

LAHS_FULL <- LAHS

LAHS <- dplyr::filter(LAHS, !(.data$LA_NAME %in% la_removals))
```

# Access to these Data



One can access this data by installing this package and importing the dataset.


```r
data("LAHS", package = "EHS")
```
