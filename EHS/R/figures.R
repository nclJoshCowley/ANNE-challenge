#' Figures used in Environmental Impact of Housing in England
#'
#' Methods that modularise each figure used in the final report.
#'
#' @param fit_sap12,fit_EPceir12e Linear model objects.
#' @param fit_mlm Multilevel objects.
#'
#' @name figures
NULL


#' @rdname figures
#' @export
fig1_1_sample_sizes_by_region <- function() {
  EHS::EHS %>%
    dplyr::mutate(
      gorEHS = EHS::display_gorEHS(.data$gorEHS),
      YEAR = EHS::display_YEAR(.data$YEAR)
    ) %>%
    EHS::ggplot_counts_by_group(counts = .data$YEAR, group = .data$gorEHS) +
    ggplot2::scale_fill_discrete(
      type = EHS::get_colour_scheme("adobeseqforest")[4:10]
    ) +
    ggplot2::labs(y = NULL, x = NULL, fill = NULL)
}


#' @rdname figures
#' @export
fig1_2_percentage_of_ownership <- function() {
  # Gets data for all plots, define fn to work on filtered data, split by level
  tenure4x_summary <-
    EHS::count_by_group(EHS::EHS, .data$tenure4x, .data$gorEHS, .data$YEAR)

  create_plot <- function(d) {
    d %>%
      dplyr::mutate(gorEHS = EHS::display_gorEHS(.data$gorEHS)) %>%
      ggplot_trend_by_group(.data$prop, .data$gorEHS, nudge_x = 0.3) +
      ggplot2::guides(colour = "none") +
      ggplot2::scale_x_continuous(labels = display_YEAR, expand = c(0, 0, 0.15, 0)) +
      ggplot2::scale_y_continuous(labels = display_percent) +
      ggplot2::scale_color_discrete(type = get_colour_scheme_region()) +
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
  EHS::EHS %>%
    dplyr::count(.data$YEAR, .data$fuelx) %>%
    dplyr::filter(!is.na(.data$fuelx)) %>%
    ggplot_trend_by_group(.data$n, .data$fuelx, nudge_x = 0.2) +
    ggplot2::guides(colour = "none") +
    ggplot2::scale_x_continuous(labels = display_YEAR, expand = c(0, 0, 0.15, 0)) +
    ggplot2::scale_y_continuous(labels = ~ format(.x, big.mark = ",")) +
    ggplot2::labs(y = NULL, x = NULL)
}


#' @rdname figures
#' @export
fig1_4_boiler_trend <- function() {
  EHS::EHS %>%
    dplyr::count(.data$YEAR, .data$boiler) %>%
    dplyr::mutate(
      boiler = .data$boiler %>%
        forcats::fct_explicit_na("No Boiler") %>%
        dplyr::recode_factor(`Condensing-combination` = "Condensing/\nCombination")
    ) %>%
    ggplot_trend_by_group(.data$n, .data$boiler, nudge_x = 0.6) +
    ggplot2::guides(colour = "none") +
    ggplot2::scale_x_continuous(labels = display_YEAR, expand = c(0, 0, 0.15, 0)) +
    ggplot2::scale_y_continuous(labels = ~ format(.x, big.mark = ",")) +
    ggplot2::labs(y = NULL, x = NULL)
}


#' @rdname figures
#' @export
fig1_5_epc_samples <- function() {
  EHS::EHS %>%
    dplyr::count(.data$gorEHS, .data$EPceeb12e) %>%
    ggplot2::ggplot(ggplot2::aes(
      x = .data$n,
      y = rev(.data$gorEHS),
      fill = .data$EPceeb12e
    )) +
    ggplot2::geom_bar(stat = "identity") +
    ggplot2::scale_y_discrete(name = NULL, limits = rev) +
    ggplot2::scale_x_continuous(
      name = "Number of sampled dwellings",
      labels = ~ format(.x, big.mark = ",")
    ) +
    ggplot2::scale_fill_discrete(
      name = "Efficiency",
      type = rlang::set_names(get_colour_scheme("epcbands")[2:7], c("A/B", LETTERS[3:7]))
    ) +
    ggplot2::theme(legend.position = "right")
}


#' @rdname figures
#' @export
fig1_6_sap_histogram <- function() {
  EHS::EHS %>%
    ggplot2::ggplot(ggplot2::aes(
      x = .data$sap12,
      fill = .data$EPceeb12e
    )) +
    ggplot2::geom_histogram(bins = 200, colour = "grey90") +
    ggplot2::expand_limits(x = c(0, 100)) +
    ggplot2::scale_fill_discrete(
      name = NULL,
      type = rlang::set_names(get_colour_scheme("epcbands")[2:7], c("A/B", LETTERS[3:7]))
    ) +
    ggplot2::labs(y = NULL, x = "SAP Rating") +
    ggplot2::theme(legend.position = "right")
}


#' @rdname figures
#' @export
tbl1_1_percentage_of_flats <- function() {
  EHS::EHS %>%
    dplyr::mutate(alltypex = EHS::condense_alltypex(.data$alltypex)) %>%
    EHS::count_by_group(prop = .data$alltypex, .data$gorEHS) %>%
    dplyr::mutate(prop = EHS::display_percent(.data$prop, digits = 2)) %>%
    dplyr::filter(.data$alltypex == "Flat") %>%
    dplyr::select(-.data$alltypex) %>%
    dplyr::arrange(dplyr::desc(.data$prop)) %>%
    kableExtra::kbl(
      col.names = c("Region", "Number of Flats", "Proportion"),
      caption = "Proportion of flats by region",
      booktabs = TRUE
    ) %>%
    kableExtra::kable_styling(latex_options = "HOLD_position") %>%
    kableExtra::footnote("EHS Physical Sample (April 2014 to March 2020)")
}


#' @rdname figures
#' @export
tbl1_2_counts_of_wallinsx <- function() {
  EHS::EHS %>%
    dplyr::count(.data$wallinsz) %>%
    tidyr::separate(
      .data$wallinsz,
      into = c("Type", "Insulated"),
      sep = "\\s(with )*",
      fill = "right"
    ) %>%
    dplyr::mutate(
      Insulated = tidyr::replace_na(.data$Insulated, "unknown"),
      dplyr::across(where(is.numeric), format, big.mark = ","),
    ) %>%
    tidyr::pivot_wider(
      names_from = .data$Insulated,
      values_from = .data$n,
      values_fill = "N/A"
    ) %>%
    kableExtra::kbl(
      col.names = c("Wall Type", "Uninsulated", "Insulated", "Unknown"),
      caption = "Insulation more dominant in 'Cavity' type walls",
      booktabs = TRUE
    ) %>%
    kableExtra::kable_styling(latex_options = "HOLD_position")
}


#' @rdname figures
#' @export
tbl2_1_linear_models <- function(fit_sap12, fit_EPceir12e) {

  joined_tidy_tbls <-
    dplyr::full_join(
      EHS::custom_tidy_tbl(fit_sap12, digits = 1),
      EHS::custom_tidy_tbl(fit_EPceir12e, digits = 1),
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
    rlang::set_names(nm = EHS::display_ehs_cnames(.)) %>%
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


#' @rdname figures
#' @export
fig3_1_population_effects <- function(fit_mlm) {
  fit_mlm %>%
    EHS::tidy_fixef() %>%
    EHS::rename_quantile_colnames() %>%
    ggplot_mlm_estimates_by_year(fill = "grey", alpha = 0.45) +
    # EPC Bands: A/B (81+), C (69-80), D (55-68), E (39-54)
    # ggplot2::geom_hline(
    #   yintercept = c(55, 68),
    #   colour = get_colour_scheme("epcbands")["D"],
    #   size = 2,
    #   alpha = 0.6
    # ) +
    ggplot2::scale_x_continuous(labels = display_YEAR) +
    ggplot2::scale_y_continuous(
      name = NULL,
      limits = c(55, 68),
      breaks = c(55, 60, 65, 68)
    )  +
    ggplot2::labs(
      title = "Population estimates imply increasing efficiency",
      subtitle = "Axis scaled to EPC D: (55 - 68)"
    )
}


#' @rdname figures
#' @export
fig3_2_regional_effects <- function(fit_mlm) {
  fit_mlm %>%
    EHS::tidy_ranef() %>%
    EHS::rename_quantile_colnames() %>%
    ggplot_mlm_estimates_by_year() +
    ggplot2::scale_color_discrete(type = get_colour_scheme_region()) +
    ggplot2::scale_fill_discrete(type = get_colour_scheme_region()) +
    ggplot2::facet_wrap(ggplot2::vars(.data$Region), ncol = 3) +
    ggplot2::expand_limits(y = c(-4, 4)) +
    ggplot2::guides(fill = "none", colour = "none") +
    ggplot2::labs(title = "Region-level estimates not significant", y = NULL)
}


#' @rdname figures
#' @export
tbl3_1_sigma <- function(fit_mlm) {
  tbl <-
    fit_mlm %>%
    summary() %>%
    purrr::pluck("spec_pars") %>%
    tibble::as_tibble(rownames = "Term") %>%
    dplyr::mutate(Term = stringr::str_to_title(.data$Term)) %>%
    dplyr::select(.data$Term, .data$Estimate, tidyselect::ends_with("CI")) %>%
    dplyr::rename_with(~ gsub("u-", "Upper ", .x)) %>%
    dplyr::rename_with(~ gsub("l-", "Lower ", .x))

  tbl %>%
    kableExtra::kbl(
      caption = "Error term summary",
      digits = 2,
      booktabs = TRUE
    ) %>%
    kableExtra::kable_styling(latex_options = "HOLD_position")
}
