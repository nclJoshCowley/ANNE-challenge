#' Summarise Proportions by Group
#'
#' Get counts and proportions of a factor by group level specified in `...`
#'
#' @param data tibble.
#' @param prop unquoted expression. Column to count.
#' @param ... passed to \code{\link[dplyr]{group_by}}. Columns to group by such
#'   that the sum of `prop` over each of these groups will be 1.
#'
#' @examples \dontrun{
#'   count_by_group(mtcars, prop = gear, cyl, carb)
#' }
#'
#' @export
count_by_group <- function(data, prop, ...) {
  pr <- rlang::enexpr(prop)

  data %>%
    dplyr::count(..., !!pr) %>%
    dplyr::group_by(...) %>%
    dplyr::mutate(prop = .data$n / sum(.data$n)) %>%
    dplyr::ungroup()
}
