#' Show Counts by Group
#'
#' Create a bar chart showing counts of 1 factor, grouped by another.
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


#' Show Trend of Time by Group
#'
#' Time series plot with 1 line of distinct colour per group.
#'
#' @param data tibble.
#' @param yvalue unquoted expression. Column to plot on the y-axis.
#' @param group unquoted expression. Grouping column to colour lines.
#' @param nudge_x numeric. Value to move labels.
#' @param expand_x numeric. Expansion of x scale to improve label visibility.
#'
#' @export
ggplot_trend_by_group <- function(data, yvalue, group, nudge_x = 0, expand_x) {
  yv <- rlang::enexpr(yvalue)
  gp <- rlang::enexpr(group)

  # Only want labels at end of trend line
  data_with_labels <-
    data %>%
    dplyr::mutate(
      label = dplyr::case_when(
        .data$YEAR == max(.data$YEAR) ~ as.character(!!gp),
        TRUE ~ NA_character_
      )
    )

  p <-
    data_with_labels %>%
    ggplot2::ggplot(ggplot2::aes(x = .data$YEAR, y = !!yv, col = !!gp)) +
    ggplot2::geom_line(size = 1.5, alpha = 0.8) +
    ggplot2::geom_point(size = 2.5, alpha = 0.8) +
    ggrepel::geom_text_repel(
      ggplot2::aes(label = .data$label),
      nudge_x = nudge_x,
      na.rm = TRUE
    )

  if (missing(expand_x)) return(p)

  p + ggplot2::scale_x_continuous(expand = c(0, 0, expand_x, 0))
}


#' Show Multilevel Estimates by Year
#'
#' Given a table of estimates will plot the estimates as a time series with
#'   shaded region showing previously chosen credible interval.
#'
#' @param tidy_tbl tibble. Output from \code{\link{tidy_fixef}} or
#'   \code{\link{tidy_ranef}}.
#' @param ...,alpha extra arguments passed to \code{\link[ggplot2]{geom_ribbon}}.
#'
#' @export
ggplot_mlm_estimates_by_year <- function(tidy_tbl, alpha = 0.2, ...) {
  has_region <- "Region" %in% colnames(tidy_tbl)

  tidy_tbl %>%
    ggplot2::ggplot(ggplot2::aes(
      x = .data$Year,
      y = .data$Estimate,
      fill = if (has_region) .data$Region else NULL
    )) +
    ggplot2::geom_ribbon(
      ggplot2::aes(ymin = .data$ci.low, ymax = .data$ci.high),
      alpha = alpha,
      ...
    ) +
    ggplot2::geom_point(ggplot2::aes(
      colour = if (has_region) .data$Region else NULL
    )) +
    ggplot2::geom_line(ggplot2::aes(
      colour = if (has_region) .data$Region else NULL
    ))
}
