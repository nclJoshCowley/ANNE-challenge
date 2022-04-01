#' Visualisations
#'
#' Methods that take few arguments yet modularise each visualisation to be used
#'   in the final report.
#'
#' @name vis_final
NULL

#' @rdname vis_final
#' @export
vis_sample_sizes_by_region <- function() {
  LAHS::EHS %>%
    dplyr::count(.data$gorEHS, .data$YEAR) %>%
    dplyr::mutate(
      gorEHS = LAHS::display_gorEHS(.data$gorEHS),
      YEAR = LAHS::display_YEAR(.data$YEAR)
    ) %>%
    ggplot2::ggplot(ggplot2::aes(
      x = .data$gorEHS,
      y = .data$n,
      fill = factor(.data$YEAR)
    )) +
    ggplot2::geom_bar(position = "dodge", stat = "identity") +
    ggplot2::scale_fill_discrete(type = LAHS::get_colour_scheme("YEAR")) +
    ggplot2::labs(y = NULL, x = NULL, fill = NULL)
}
