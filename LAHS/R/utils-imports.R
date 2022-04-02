utils::globalVariables(".")


#' Imports
#'
#' Imports from other packages used within this package
#'
#' @name utils-imports
#'
#' @importFrom rlang .data
#' @importFrom rlang %||%
#' @importFrom magrittr %>%
#'
#' @keywords internal
#'
#' @section Links:
#'   - \code{\link[rlang]{tidyeval-data}}, data pronoun.
#'   - \code{\link[rlang]{op-null-default}}, default value for NULL operator.
#'   - \code{\link[magrittr]{pipe}}, magrittr pipe (`%>%`)
#'   - \code{\link[tidyselect]{where}}, tidyselect keyword.
NULL


#' @rdname utils-imports
where <- utils::getFromNamespace("where", "tidyselect")
