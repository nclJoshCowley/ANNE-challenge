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
