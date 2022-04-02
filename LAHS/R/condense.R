#' Condense Levels
#'
#' Data, potentially already grouped, can be split into fewer groups with
#'   these methods.
#'
#' @param x vector. Data to be converted.
#' @name condense
NULL


#' @describeIn condense Convert dwelling type from type/age to just type.
#' @export
condense_alltypex <- function(x) {
  forcats::fct_collapse(
    x,
    Flat = c(
      "Purpose built flat, high rise",
      "Purpose built flat, low rise",
      "Converted flat"
    ),
    House = c(
      "Detached house : pre 1919",
      "Detached house : post 1919",
      "Semi detached & terraced : pre 1919",
      "Semi detached & terraced : 1919-1944",
      "Semi detached & terraced : 1945-1964",
      "Semi detached & terraced : 1965 onwards"
    ),
    Bungalow = "Bungalow : all ages",
    Unknown = "NA"
  )
}
