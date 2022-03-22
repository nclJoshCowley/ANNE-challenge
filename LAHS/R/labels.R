#' To Label
#'
#' Convert coded data to a human-readable label
#'
#' @param x character. Coded data
#'
#' @name to_label
NULL


#' @describeIn to_label Local Authority types to label.
#' @export
LAD20TYPE_to_label <- function(x) {
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
