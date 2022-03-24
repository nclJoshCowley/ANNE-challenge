#' Subset of Local Authority Housing Statistics
#'
#' We focus on the subset of the data that could be relevant from an
#'   environmental perspective.
#'
#' @format A data frame with 1961 rows and 23 variables:
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
#'   \item{NEW_BOILERS}{Boiler replacements, regardless of the energy
#'       efficiency rating of the boiler.}
#'   \item{INSULATION}{Total number of insulations installed.}
#'   \item{INSULATION_SOLID}{Number of solid wall insulations.}
#'   \item{INSULATION_CAVITY}{Number of cavity wall insulations.}
#'   \item{INSULATION_LOFT}{Number of loft or roof insulations.}
#'   \item{INSULATION_FLOOR}{Number of floor insulations.}
#'   \item{RT_TOTAL}{Number of dwellings with renewable technology installed.}
#'   \item{RT_PVPANELS}{True if any photovoltaic panels have been installed.}
#'   \item{RT_SOLARTHERMAL}{True if any solar thermals have been installed.}
#'   \item{RT_HEATPUMP}{True if any heat pumps have been installed.}
#'   \item{RT_BIOMASS}{True if any biomass boilers have been installed.}
#'   \item{RT_TURBINE}{True if any wind turbines have been installed.}
#'   \item{RT_OTHER}{True if any other technologies have been installed.}
#' }
#'
#' @source <https://www.gov.uk/government/statistical-data-sets/local-authority-housing-statistics-open-data>
"LAHS"

#' LAHS_FULL
#'
#' `LAHS_FULL` is greater dataset with LA(s) that hold no dwelling stock.
#'
#' @rdname LAHS
"LAHS_FULL"
