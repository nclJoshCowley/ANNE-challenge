Multilevel Modelling of Regional EPC
================
Josh Cowley (Newcastle University).
Compiled at 2022-04-05 22:30:24 BST

Uses the `brms` package to fit a multilevel model then saves the
resultant object in a cache for later analysis.

We will store the cached model fit in the following directory

    C:/Users/Joshc/Git/ANNE-challenge/LAHS/cache

Here, we transform the data to keep only **relevant** variables and to
ensure the temporal aspect is coded as a factor.

``` r
EHS_subset <-
  dplyr::transmute(
    EHS::EHS,
    SAP = .data$sap12,
    Year = factor(.data$YEAR),
    Region = .data$gorEHS,
    Type = EHS::condense_alltypex(.data$alltypex)
  )
```

The formula is given as follows, removing the population and group
intercept.

``` r
brms_formula <- SAP ~ 0 + Year + (0 + Year | Region)
```

We fit the model using the `brms` package with the options shown and
save any results in a `Rds` object for later use and analysis.

``` r
fit <-
  xfun::cache_rds(
    brms::brm(
      formula = brms_formula,
      data = EHS_subset,
      chains  = 2,
      iter    = 2e3,
      warmup  = 1e3,
      thin    = 1,
      refresh = 20
    ),
    file = "mlm_regional_epc.rds",
    dir = paste0(cache_dir, "/")
  )
```
