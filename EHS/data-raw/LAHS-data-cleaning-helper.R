#' Parse LA Type
#'
#' Convert local authority types to label to a human-readable label.
#'
#' @param x character. Coded data such as `E06` to `E09`.
parse_la_type <- function(x) {
  out <-
    factor(
      x,
      levels = paste0("E0", 6:9),
      labels = c(
        "Unitary authority",
        "Lower tier district authority",
        "Metropolitan local authority",
        "London borough"
      )
    )

  if (anyNA(out)) warning("Invalid types: ", toString(x[is.na(out)]))

  return(out)
}


#' Parse Renewable Technologies Coding
#'
#' In LAHS data, the renewable technology types are coded as integers (0-63),
#'   that when converted to binary will denote 6 binary variables.
#'
#' @param x integer vector. Vector of values from column f2daa.
#'
#' @return data frame with `length(x)` rows and 6 named columns.
parse_rt_types <- function(x) {
  stopifnot(is.numeric(x))

  if (anyNA(x)) stop("Missing values: ", toString(which(is.na(x))))

  is_invalid <- (x >= 64 | x < 0)
  if (any(is_invalid)) stop("Invalid values: ", toString(x[is_invalid]))

  rt_names <-
    c(
      "RT_PVPANELS",
      "RT_SOLARTHERMAL",
      "RT_HEATPUMP",
      "RT_BIOMASS",
      "RT_TURBINE",
      "RT_OTHER"
    )

  purrr::map_dfr(x, function(.x) {
    # Get the 6 Least-Significant-Bits as TRUE / FALSE
    vec <- as.logical(intToBits(.x)[1:6])
    structure(as.list(vec), .Names = rt_names)
  })
}
