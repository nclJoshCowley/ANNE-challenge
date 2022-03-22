#' Common Report Setup
#'
#' Sets up sensible defaults for a `ggplot2` theme and knitr options.
#'
#' @param ... extra arguments passed to `knitr::opts_chunk$set` and overwrites
#'   any defaults.
#' @param base_size integer. Default font size for `ggplot` objects.
#'
#' @export
common_report_setup <- function(..., base_size = 16) {
  ggplot2::theme_set(ggplot2::theme_minimal(base_size = base_size))

  default_args <-
    list(
      # Figure(s)
      fig.width = 12,
      fig.asp = 0.7,
      fig.align = "center",
      out.width = "100%",
      # Execution
      echo = FALSE,
      message = FALSE,
      cache = FALSE
    )

  updated_args <- utils::modifyList(default_args, rlang::list2(...))
  do.call(knitr::opts_chunk$set, updated_args)

  return(invisible(NULL))
}
