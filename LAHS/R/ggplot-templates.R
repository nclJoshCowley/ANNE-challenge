#' Show Counts by Group (ggplot template)
#'
#' Create a barchart showing counts of 1 factor, grouped by another.
#'
#' @param data tibble.
#' @param counts unquoted expression. Sub-level of grouping, mapped to `fill`.
#' @param group unquoted expression. Top-level of grouping, mapped to `x`.
#' @param ... extra arguments passed to \code{\link[ggplot2]{geom_bar}}.
#'
#' @export
ggplot_counts_by_group <- function(data, counts, group, ...) {
  cn <- rlang::enexpr(counts)
  gp <- rlang::enexpr(group)

  data %>%
    dplyr::count(!!gp, !!cn) %>%
    ggplot2::ggplot(ggplot2::aes(
      x = !!gp,
      y = .data$n,
      fill = factor(!!cn)
    )) +
    ggplot2::geom_bar(position = "dodge", stat = "identity", ...)
}
