#' ---
#' title: "Multilevel Modelling of Regional EPC"
#' author: "Josh Cowley (Newcastle University). "
#' date: "Compiled at `r format(Sys.time(), '%Y-%m-%d %X %Z')`"
#' output: github_document
#' ---

#' Uses the `brms` package to fit a multilevel model then saves the resultant
#' object in a cache for later analysis.

#+ setup, include = FALSE
library(LAHS)
library(magrittr)
library(rprojroot)
library(xfun)

library(rstan)
library(brms)
options(mc.cores = parallel::detectCores())
rstan::rstan_options(auto_write = TRUE)

#' We will store the cached model fit in the following directory
#+ echo = FALSE, results = "asis"
cache_dir <- file.path(rprojroot::find_root("DESCRIPTION"), "cache")
cat(sprintf("```\n%s\n```", cache_dir))

#' Here, we transform the data to keep only **relevant** variables and to
#' ensure the temporal aspect is coded as a factor.
EHS_subset <-
  dplyr::transmute(
    LAHS::EHS,
    SAP = .data$sap12,
    Year = factor(.data$YEAR),
    Region = .data$gorEHS,
    Type = LAHS::condense_alltypex(.data$alltypex)
  )

#' The formula is given as follows, removing the population and group intercept.
brms_formula <- SAP ~ 0 + Year + (0 + Year | Region)

#' We fit the model using the `brms` package with the options shown and save
#' any results in a `Rds` object for later use and analysis.
fit <-
  xfun::cache_rds(
    brms::brm(
      formula = brms_formula,
      data = EHS_subset,
      chains = 4,
      iter = 5e3,
      warmup = 1e3,
      thin = 1,
      refresh = 20
    ),
    file = "mlm_regional_epc.rds",
    dir = cache_dir
  )
