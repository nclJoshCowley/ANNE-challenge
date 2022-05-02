#' Tidy Fixed and Random Effect Estimates
#'
#' Wrappers around population estimate getter'\code{\link[brms]{fixef.brmsfit}}
#' and group-level estimate getter \code{\link[brms]{ranef.brmsfit}}) that
#' tidies the data and decodes `<chr>Year2019` to `<int>2019`.
#'
#' @section Warning:
#'   Only use this method on `mlm-regional-epc` due to assumptions made.
#'
#' @param x `brms` fit.
#' @param ... passed to corresponding `brms` method.
#'
#' @name tidy-brms-ef
#' @export


#' @rdname tidy-brms-ef
#' @export
tidy_fixef <- function(x, ...) {
  brms::fixef(x, ...) %>%
    tibble::as_tibble(rownames = "Year") %>%
    dplyr::mutate(Year = as.integer(gsub("^Year", "", .data$Year)))
}


#' @rdname tidy-brms-ef
#' @export
tidy_ranef <- function(x, ...) {
  ranef_array <- purrr::pluck(brms::ranef(x, ...), "Region")

  ranef_tidy <-
    as.data.frame.table(ranef_array) %>%
    tibble::as_tibble() %>%
    rlang::set_names(c("Region", "summary_stat", "Year", "Value")) %>%
    tidyr::pivot_wider(
      names_from = .data$summary_stat,
      values_from = .data$Value
    ) %>%
    dplyr::mutate(Year = as.integer(gsub("^Year", "", .data$Year)))

  return(ranef_tidy)
}
