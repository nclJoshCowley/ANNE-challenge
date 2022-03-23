#' Subset of Local Authority Housing Statistics
#'
#' We focus on the subset of the data that could be relevant from an
#'   environmental perspective.
#'
#' @format A data frame with 3239 rows and ? variables:
#' \describe{
#'   \item{LA_CODE}{Local authority code at the time the data was collected.}
#'   \item{LA_NAME}{Local Authority name at the time the data was collected.}
#'   \item{LA_TYPE}{Current local authority type (April 2020).}
#'   \item{LA_REGION}{English Region name.}
#'   \item{YEAR}{The starting year of the financial reporting year.}
#'   \item{STOCK_PUBLIC_LA}{Number of dwellings owned by **any** LA.}
#'   \item{STOCK_PUBLIC_OTHER}{Other public sector owned dwellings.}
#'   \item{STOCK}{Number of dwellings owned by encircling LA.}
#'   \item{STOCK_VALUE}{Value of dwellings owned by encircling LA in millions
#'       of pounds to 3.d.p.}
#'   \item{EPC}{EPC Band of the average SAP rating.}
#' }
#'
#' @source <https://www.gov.uk/government/statistical-data-sets/local-authority-housing-statistics-open-data>
"LAHS"
