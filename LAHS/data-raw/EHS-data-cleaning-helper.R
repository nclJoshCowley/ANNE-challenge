#' Read `general` or `physical` table
#'
#' Reads in the desired variables from the `general` and `physical` files found
#'   in the EHS file structure.
#'
#' @param path filepath to `general` or `physical` data file.
#'
#' @name read_special_tsv
read_special_tsv <- function(path, desired_cols) {
  tsv_raw <-
    path %>%
    readr::read_tsv(show_col_types = FALSE) %>%
    # Deals with gorEHS =/= gorehs issue.
    dplyr::rename_with(~ gsub("gorehs", "gorEHS", .x))

  out <- dplyr::select(tsv_raw, tidyselect::any_of(desired_cols))

  missing_cols <- setdiff(desired_cols, colnames(out))

  if (length(missing_cols) > 0) {
    warning(sprintf(
      "[%s] is missing column(s) %s.",
      basename(path),
      toString(missing_cols)
    ))

    for (mc in missing_cols) out <- tibble::add_column(out, !!mc := NA)
  }

  return(out)
}


#' @rdname read_special_tsv
read_general_tsv <- function(path) {
  desired_cols <-
    c("serialanon", "gorEHS", "tenure4x", "vacantx")

  return(read_special_tsv(path, desired_cols))
}


#' @rdname read_special_tsv
read_physical_tsv <- function(path) {
  desired_cols <-
    c(
      "serialanon", "alltypex", "boiler", "dampalf", "dblglaz4",
      "EPceeb12e", "EPceir12e", "EPceib12e", "fuelx", "loftinsx", "sap12",
      "wallinsz", "watersys"
    )

  return(read_special_tsv(path, desired_cols))
}


#' Label Data Column
#'
#' Replace coded columns with labelled factors by supplying a data frame and
#' chosen column, **then** a lookup table in tribble format.
#'
#' @param data data frame.
#' @param column character. Column to overwrite.
#' @param ... passed to tribble, should create a new data frame with `id` and
#'   `nm` columns.
label_data_column <- function(data, column, ...) {
  lookup <- tibble::tribble(...)

  data[[column]] <-
    factor(data[[column]], levels = lookup$id, labels = lookup$nm)

  return(data)
}
