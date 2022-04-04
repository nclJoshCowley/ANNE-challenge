#' Custom Tidy.lm Table
#'
#' Bespoke function to create a `kable` from a `lm` object.
#'
#' @param fit `lm` object.
#' @param digits integer. Significant figures to round estimates to.
#'
#' @export
custom_tidy_tbl <- function(fit, digits) {
  tidy_tbl <-
    fit %>%
    broom::tidy(conf.int = TRUE) %>%

    # Combine `estimate`, `conf.low` and `conf.high`
    combine_tidy_estimates(digits = digits) %>%

    # Split `Speciesvirginica` from contrast into `Species` and `virginica`.
    split_tidy_terms(xlevels = fit$xlevels) %>%

    # Deal with appearance of NA(s)
    dplyr::mutate(
      estimate = tidyr::replace_na(.data$estimate, "Reference"),
      term_level = tidyr::replace_na(.data$term_level, ""),
      p.value = gsub("NA", "", format.pval(.data$p.value, digits = 1))
    ) %>%

    # Remove excess columns
    dplyr::select(-.data$term, -.data$std.error, -.data$statistic)

  return(tidy_tbl)

}


#' Split Tidy Terms
#'
#' Split `term` column from `tidy.lm` output for factors. By default, constrasts
#'   make columns names like "Speciesvirginica" where factor name and level are
#'   ambiguous.
#'
#' @param x tibble. Expected to be `tidy.lm` output
#' @param xlevels list. Expected to be the `fit$xlevels` from the same `lm`.
#'
#' @keywords internal
split_tidy_terms <- function(x, xlevels) {
  fct_tbl <-
    xlevels %>%
    purrr::imap_dfr(~ tibble::tibble(fct_nm = .y, fct_lvl = .x)) %>%
    dplyr::mutate(term = paste0(.data$fct_nm, .data$fct_lvl))


  x %>%
    dplyr::full_join(fct_tbl, by = "term") %>%
    dplyr::mutate(
      term_name = ifelse(is.na(.data$fct_nm), NA_character_, .data$fct_nm),
      term_level = ifelse(is.na(.data$fct_nm), .data$term, .data$fct_lvl),
      .after = .data$term
    ) %>%
    dplyr::arrange(
      # Non-factors first
      !is.na(.data$term_name),
      # Then sort by factor name
      .data$term_name,
      # And ensure reference level is highest
      !is.na(.data$estimate)
    ) %>%
    dplyr::select(-.data$fct_nm, -.data$fct_lvl)
}


#' Combine Tidy Estimates
#'
#' Combines the three `estimate`, `conf.low` and `conf.high` columns into a
#'   "`estimate` (`conf.low` to `conf.high`)" column.
#'
#' @param x tibble. Expected to be `tidy.lm` output
#' @inheritParams custom_tidy_tbl
#'
#' @keywords internal
combine_tidy_estimates <- function(x, digits) {
  combine <- function(est, low, high) {
    sprintf(
      "%s (%s to %s)",
      formatC(est, digits = digits, format = "f", flag = "#"),
      formatC(low, digits = digits, format = "f", flag = "#"),
      formatC(high, digits = digits, format = "f", flag = "#")
    )
  }

  x %>%
    dplyr::mutate(
      estimate = ifelse(
        is.na(.data$estimate),
        NA_character_,
        combine(.data$estimate, .data$conf.low, .data$conf.high)
      ),
      .keep = "unused"
    )

}
