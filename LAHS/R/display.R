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
display_YEAR <- function(x) sprintf("%i-%s", x, substr(x + 1, 3, 4))


#' Colour Schemes
#'
#' Consistency with colour schemes enforced by defining them here.
#'
#' @param type choice. Must be a defined scheme.
#'
#' @section Type(s):
#'     - `YEAR`. Data can be 2014-15 to 2019-20
#'
#' @export
get_colour_scheme <- function(type) {
  if (type == "YEAR") {
    # Subject to change (too much green!?)
    return(utils::tail(RColorBrewer::brewer.pal(9, "Greens"), 6))
  }

  stop(type, " not found.")
}
