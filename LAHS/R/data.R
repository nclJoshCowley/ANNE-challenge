#' Subset of Local Authority Housing Statistics
#'
#' We focus on the subset of the data that could be relevant from an
#'   environmental perspective.
#'
#' @format A data frame with 1943 rows and 23 variables:
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


#' Local Authority Carbon Dioxide Emissions
#'
#' CO2 emissions for local authorities within the UK.
#'
#' @format A data frame with 129388 rows and 10 variables:
#' \describe{
#'   \item{LA_CODE}{Local authority code at the time the data was collected.}
#'   \item{LA_NAME}{Local Authority name at the time the data was collected.}
#'   \item{LA_REGION}{English Region name.}
#'   \item{YEAR}{Reporting calendar year.}
#'   \item{CO2_SECTOR}{Sector responsible for CO2 emissions.}
#'   \item{CO2_SUBSECTOR}{Sub-sector (electricity, gas, etc.) responsible for
#'       CO2 emissions.}
#'   \item{CO2_EMISSIONS}{Terrotorial emission in kilotonnes.}
#'   \item{CO2_LA_EMISSIONS}{Emissions defined as 'within the scope of
#'       influence' of the LA.}
#'   \item{LA_POPULATION}{Mid-year population in the thousands.}
#'   \item{LA_AREA}{Area in square kilometres.}
#' }
#'
#' @source <https://data.gov.uk/dataset/723c243d-2f1a-4d27-8b61-cdb93e5b10ff/uk-local-authority-and-regional-carbon-dioxide-emissions-national-statistics-2005-to-2019>
"LACO2"

#' English Housing Survey
#'
#' Subset of EHS dataset relating to emissions and energy efficiency.
#'   Missing from package when installed via git due to UKDA End-user Licence.
#'
#' @format A data frame with 36,971 rows and 17 variables:
#' \describe{
#'  \item{YEAR}{Reporting financial year, (i.e. April-`YEAR` to Mar-`YEAR` + 1.}
#'  \item{serialanon}{EHS case number.}
#'  \item{gorEHS}{Government office region EHS version.}
#'  \item{tenure4x}{Type of tenure.}
#'  \item{vacantx}{Indicator of property being occupied or vacant.}
#'  \item{alltypex}{Dwelling age and type.}
#'  \item{boiler}{Type of boiler.}
#'  \item{dampalf}{`TRUE` when dampness problems found in one or more rooms.}
#'  \item{dblglaz4}{Extent of double glazing (50%).}
#'  \item{EPceeb12e}{Energy efficiency rating band (EHS SAP 2012).}
#'  \item{EPceir12e}{Environmental impact rating (EHS SAP 2012).}
#'  \item{EPceib12e}{Environmental impact rating band (EHS SAP 2012).}
#'  \item{fuelx}{Main fuel type used for primary space heating system.}
#'  \item{loftins6}{Loft insulation (6 ordinal levels).}
#'  \item{sap12}{Energy efficiency (SAP12) rating.}
#'  \item{wallinsz}{Type of wall and insulation.}
#'  \item{watersys}{Water heating system.}
#' }
"EHS"
