#' Display Version(s) of Data
#'
#' These functions convert data for understanding to a more aesthetically
#'   pleasing version for visualisation.
#'
#' @param x vector. Data to be converted.
#' @name display
NULL


#' @describeIn display Line splits long region name, ``Yorkshire and ...`
#' @export
display_gorEHS <- function(x) {
  stopifnot(is.factor(x))

  levels(x) <-
    gsub("Yorkshire and the Humber", "Yorkshire and\nthe Humber", levels(x))

  return(x)
}


#' @describeIn display Assumes financial year so `2018` becomes `2018-19`.
#' @export
display_YEAR <- function(x) sprintf("%s-%s", x, substr(x + 1, 3, 4))


#' @describeIn display Convert numeric (say 0.154) to percentage (15.4%).
#' @export
display_percent <- function(x, ...) {
  args <- utils::modifyList(list(x = 100 * x, digits = 1), rlang::list2(...))
  prefix <- do.call(format, args)
  paste0(prefix, "%")
}


#' Colour Schemes
#'
#' Consistency with colour schemes enforced by defining them here. Returns a
#'   character vector as opposed to do something clever like RColorBrewer.
#'
#' @param name choice. Must be a defined scheme.
#'
#' @section Available Colour Scheme(s):
#'   - `ibm`: IBM Colour Blind safe scheme, nominal, 5 colours,
#'     <https://lospec.com/palette-list/ibm-color-blind-safe>.
#'   - `moor64green` and `moor64blue`. Derived from MOOR64, ordinal, 6 colours,
#'     <https://lospec.com/palette-list/moor64>.
#'
#' @export
get_colour_scheme <- function(name) {
  col_env <- rlang::new_environment(list(
    ibm =
      c("#648fff", "#785ef0", "#dc267f", "#fe6100", "#ffb000"),

    moor64green =
      c("#8dc168", "#65a84f", "#438e3e", "#2d782f", "#12561d", "#0d421c"),

    moor64blue =
      c("#a8ebbf","#78d9c4","#42bdb5","#2e9298","#206f85","#004e78")
  ))

  if (!name %in% names(col_env)) stop("Colour scheme missing - ", name)
  return(get(name, envir = col_env))
}



