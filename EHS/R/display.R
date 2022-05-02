#' Display Version(s) of Data
#'
#' These functions convert data for understanding to a more aesthetically
#'   pleasing version for visualisation.
#'
#' @param x vector. Data to be converted.
#' @name display
NULL


#' @describeIn display Human-friendly column names for EHS data.
#' @export
display_ehs_cnames <- function(x) {
  dplyr::recode(
    x,
    YEAR = "Year",
    serialanon = "ID",
    gorEHS = "Region",
    tenure4x = "Tenure",
    vacantx = "Vacant",
    alltypex = "Type",
    boiler = "Boiler",
    dampalf = "Dampness",
    dblglaz4 = "Double Glazing",
    EPceeb12e = "EPC Band",
    EPceir12e = "Environmental Impact Rating",
    EPceib12e = "Environmental Impact Band",
    fuelx = "Space Heating",
    loftins6 = "Loft Insulation",
    sap12 = "SAP Rating",
    wallinsz = "Wall Insulation",
    watersys = "Water Heating"
  )
}


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
#' @param ... extra arguments in `display_percent` passed to `format`.
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
#'   - `ibm`: IBM Colour Blind safe scheme, nominal, 5 colours.
#'     <https://lospec.com/palette-list/ibm-color-blind-safe>.
#'   - `moor64green` and `moor64blue`. Derived from MOOR64, ordinal, 6 colours.
#'     <https://lospec.com/palette-list/moor64>.
#'   - `adobeseqforest` Adobe Sequential Forest, ordinal, 16 colours.
#'     <https://spectrum.adobe.com/page/color-for-data-visualization>
#'   - `adobe12` Adobe Categorical, 12 colours.
#'     <https://spectrum.adobe.com/page/color-for-data-visualization>
#'   - `epcbands`. EPC Band colours (named), ordinal, 7 colours (A-G).
#'     <https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/5996/2116821.pdf>
#'
#' @export
get_colour_scheme <- function(name) {
  col_env <- rlang::new_environment(list(
    ibm =
      c("#648fff", "#785ef0", "#dc267f", "#fe6100", "#ffb000"),

    moor64green =
      c("#8dc168", "#65a84f", "#438e3e", "#2d782f", "#12561d", "#0d421c"),

    moor64blue =
      c("#a8ebbf","#78d9c4","#42bdb5","#2e9298","#206f85","#004e78"),

    adobeseqforest =
      c(
        "#FFFFE0", "#E2F5BD", "#C5EA99", "#A6DF73",
        "#8FD16C", "#79C365", "#62B55E", "#4CA658",
        "#3B9752", "#31884F", "#28794C", "#1E6A48",
        "#155B45", "#0E4D41", "#073F3E", "#00313A"
      ),

    adobe12 =
      c(
        "#00C0C7", "#5144D3", "#E8871A", "#DA3490",
        "#9089FA", "#47E26F", "#2780EB", "#6F38B1",
        "#DFBF03", "#CB6F10", "#268D6C", "#9BEC54"
      ),

    epcbands =
      c(
        A = "#007F3D", B = "#2C9F29", C = "#9DCB3C",
        D = "#F2E200", # Original was "#FFF200", vue changed from 100 to 95.
        E = "#F7AF1D", `F` = "#ED6823", G = "#E31D23"
      )
  ))

  if (!name %in% names(col_env)) stop("Colour scheme missing - ", name)
  return(get(name, envir = col_env))
}

#' @describeIn get_colour_scheme Wrapper to be used for region colouring (n=9).
#' @export
get_colour_scheme_region <- function() {
  c(get_colour_scheme("adobe12")[c(1:6, 9)], "black", "grey50")
}
