#' Figures used in Environmental Impact of Housing in England
#'
#' Methods that modularise each figure used in the final report.
#'
#' @name figures
NULL


#' @rdname figures
#' @export
fig1_1_sample_sizes_by_region <- function() {
  LAHS::EHS %>%
    dplyr::mutate(
      gorEHS = LAHS::display_gorEHS(.data$gorEHS),
      YEAR = LAHS::display_YEAR(.data$YEAR)
    ) %>%
    LAHS::ggplot_counts_by_group(counts = .data$YEAR, group = .data$gorEHS) +
    ggplot2::scale_fill_discrete(type = LAHS::get_colour_scheme("moor64green")) +
    ggplot2::labs(y = NULL, x = NULL, fill = NULL)
}


#' @rdname figures
#' @export
fig1_2_percentage_of_ownership <- function() {
  # Gets data for all plots, define fn to work on filtered data, split by level
  tenure4x_summary <-
    LAHS::count_by_group(LAHS::EHS, .data$tenure4x, .data$gorEHS, .data$YEAR)

  create_plot <- function(d) {
    d %>%
      dplyr::mutate(gorEHS = LAHS::display_gorEHS(.data$gorEHS)) %>%
      ggplot_trend_by_group(.data$prop, .data$gorEHS, nudge_x = 0.3) +
      ggplot2::guides(colour = "none") +
      ggplot2::scale_x_continuous(labels = display_YEAR, expand = c(0, 0, 0.15, 0)) +
      ggplot2::scale_y_continuous(labels = display_percent) +
      ggplot2::labs(y = NULL, x = NULL)
  }

  tenure4x_summary %>%
    dplyr::group_by(.data$tenure4x) %>%
    dplyr::group_split() %>%
    rlang::set_names(purrr::map_chr(., ~ unique(as.character(.x$tenure4x)))) %>%
    purrr::map(create_plot)
}


#' @rdname figures
#' @export
fig1_3_fuelx_trend <- function() {
  LAHS::EHS %>%
    dplyr::count(.data$YEAR, .data$fuelx) %>%
    dplyr::filter(!is.na(.data$fuelx)) %>%
    ggplot_trend_by_group(.data$n, .data$fuelx, nudge_x = 0.2) +
    ggplot2::guides(colour = "none") +
    ggplot2::scale_x_continuous(labels = display_YEAR, expand = c(0, 0, 0.15, 0)) +
    ggplot2::scale_y_continuous(labels = ~ paste0(.x / 1000, "K")) +
    ggplot2::labs(y = NULL, x = NULL)
}


#' @rdname figures
#' @export
tbl1_1_percentage_of_flats <- function() {
  LAHS::EHS %>%
    dplyr::mutate(alltypex = LAHS::condense_alltypex(.data$alltypex)) %>%
    LAHS::count_by_group(prop = .data$alltypex, .data$gorEHS) %>%
    dplyr::mutate(prop = LAHS::display_percent(.data$prop, digits = 2)) %>%
    dplyr::filter(.data$alltypex == "Flat") %>%
    dplyr::select(-.data$alltypex) %>%
    dplyr::arrange(dplyr::desc(.data$prop)) %>%
    kableExtra::kbl(
      col.names = c("Region", "Number of Flats", "Proportion"),
      caption = "Proportion of Flats",
      booktabs = TRUE
    ) %>%
    kableExtra::kable_styling() %>%
    kableExtra::footnote("EHS Physical Sample (April 2014 to March 2020)")
}


#' @rdname figures
#' @param fit_sap12,fit_EPceir12e Linear model objects, fit in RMD.
#' @export
tbl1_2_linear_models <- function(fit_sap12, fit_EPceir12e) {

  joined_tidy_tbls <-
    dplyr::full_join(
      LAHS::custom_tidy_tbl(fit_sap12, digits = 1),
      LAHS::custom_tidy_tbl(fit_EPceir12e, digits = 1),
      by = c("term_name", "term_level")
    )

  out <-
    joined_tidy_tbls %>%
    dplyr::select(-.data$term_name) %>%
    kableExtra::kbl(
      col.names = c("Term", rep(c("Estimate (95% CI)", "P Value"), 2)),
      caption = "Linear Regression Results",
      booktabs = TRUE
    ) %>%
    kableExtra::kable_styling() %>%
    kableExtra::add_header_above(
      c(" ", "Efficiency Rating" = 2, "Impact Rating" = 2)
    )

  # Want one row heading for each factor fitted
  groupings <-
    unique(stats::na.omit(joined_tidy_tbls$term_name)) %>%
    rlang::set_names(nm = LAHS::display_ehs_cnames(.)) %>%
    purrr::map(~ range(which(joined_tidy_tbls$term_name == .x)))

  for (gi in seq_along(groupings)) {
    out <-
      kableExtra::pack_rows(
        out,
        group_label = names(groupings)[gi],
        start_row = groupings[[gi]][1],
        end_row = groupings[[gi]][2]
      )
  }

  return(out)
}
