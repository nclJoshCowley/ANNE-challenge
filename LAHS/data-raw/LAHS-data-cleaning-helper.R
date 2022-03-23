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

