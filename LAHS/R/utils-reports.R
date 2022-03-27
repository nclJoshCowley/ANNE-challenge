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

  # ggplot2 theme
  ggplot2::theme_set(ggplot2::theme_minimal(base_size = base_size))

  # Knitr options
  updated_args <- utils::modifyList(default_args, rlang::list2(...))
  do.call(knitr::opts_chunk$set, updated_args)

  # Hooks
  knitr::knit_hooks$set(source = get_knit_hook_source_hide())

  # Using Project directory for filepaths
  knitr::opts_knit$set(root.dir = rprojroot::find_root("DESCRIPTION"))

  return(invisible(NULL))
}


#' Knitr Hook to Hide Source Code
#'
#' Creates a `source` hook to hide source code that could be of interest but
#'   not pertinent to the report.
#'
#' @details This returns a function that should be set using `knit_hook$set()`.
#'   That is, `knitr::knit_hooks$set(source = get_knit_hook_source_hide())`.
#'
#' @export
get_knit_hook_source_hide <- function() {
  original_hook <- knitr::knit_hooks$get("source")

  function(x, options) {
    original_source_output <- original_hook(x, options)
    if (is.null(options$hide)) return(original_source_output)

    sprintf(
      "<details><summary>%s</summary>\n\n%s\n\n</details>",
      options$hide,
      original_source_output
    )
  }
}
