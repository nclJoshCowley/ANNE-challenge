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
