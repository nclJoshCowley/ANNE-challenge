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


#' Replace Inconsistent Quantile Names
#'
#' Replace `colnames` such as `Q2.5` and `Q97.5` with tidy-like replacements.
#'
#' @param x object with valid `colnames`.
#' @param repl character vector, length 2. Replacement value, lowest first.
#'
#' @export
rename_quantile_colnames <- function(x, repl = c("ci.low", "ci.high")) {
  stopifnot("`x` has NULL colnames" = !is.null(colnames(x)))

  nms <- colnames(x)
  is_ci_nm <- grepl("^Q[0-9\\.]+$", nms)

  if (sum(is_ci_nm) != 2) stop("Matched ", sum(is_ci_nm), " names; expected 2.")

  ci_vals <- as.double(gsub("Q", "", nms[is_ci_nm]))
  nms[is_ci_nm] <- repl[order(ci_vals)]

  colnames(x) <- nms
  return(x)
}
