# Variables of Interest in EHS

Date: 30th March - 31st March 2022

Purpose: Summarise variables of interest in EHS (End User Licence only)
from data dictionaries.

## Physical Cohort

The following variables (alphabetical order) are found in the datasheets
labelled `physical`.

1. `alltypex`. Dwelling age and type.

    - -8.0: unknown.
    - 1.0: purpose built flat, high rise.
    - 2.0: purpose built flat, low rise.
    - 3.0: converted flat.
    - 4.0: bungalow : all ages.
    - 5.0: detached house : pre 1919.
    - 6.0: detached house : post 1919.
    - 7.0: semi detached & terraced : pre 1919.
    - 8.0: semi detached & terraced : 1919-1944.
    - 9.0: semi detached & terraced : 1945-1964.
    - 10.0: semi detached & terraced : 1965 onwards.

1. `boiler`. Type of boiler.

    - -9.0: no boiler.
    - 1.0: standard boiler (floor or wall).
    - 2.0: back boiler (to fire or stove).
    - 3.0: combination boiler.
    - 4.0: condensing boiler.
    - 5.0: condensing-combination boiler.

1. `dampalf`. Dampness problems in one or more rooms

    - 0: not present.
    - 1: problem present.

1. `dblglaz2`. Extent of double glazing (80%).

    - -8.0: unknown.
    - 1.0: less than 80% double glazed.
    - 2.0: 80% or more double glazed.

1. `dblglaz4`. Extent of double glazing (50%).

    - -8.0: unknown.
    - 1.0: no double glazing.
    - 2.0: less than half.
    - 3.0: more than half.
    - 4.0: entire house.

1. `EPceeb12e`. Energy efficiency rating band (EHS SAP 2012).

    - Derived from `sap12`.
    - 2.0: A/B.
    - 3.0: C.
    - 4.0: D.
    - 5.0: E.
    - 6.0: F.
    - 7.0: G.

1. `EPceir12e`. Environmental impact rating (EHS SAP 2012).

1. `EPceib12e`. Environmental impact rating band (EHS SAP 2012).

    - Derived from `EPceir12e`.
    - 2.0: A/B.
    - 3.0: C.
    - 4.0: D.
    - 5.0: E.
    - 6.0: F.
    - 7.0: G.

1. `fuelx`. Main fuel type used for primary space heating system.

    - -8.0: not identified - communal systems.
    - 1.0: gas fired system.
    - 2.0: oil fired system.
    - 3.0: solid fuel fired system.
    - 4.0: electrical system.

1. `loftinsx`. Loft insulation (continuous).

    - 0: no insulation.
    - -9.0: not applicable - no roof directly above.
    - Possible grouping inspired by `loftins6`:
        - 1.0: none.
        - 2.0: less than 50mm.
        - 3.0: 50 up to 99mm.
        - 4.0: 100 up to 149mm.
        - 5.0: 150 up to 199mm.
        - 6.0: 200mm or more.

1. ~~`rdsap09`. Reduced data energy efficiency rating (SAP 2009 based).~~

1. `sap12`. Energy efficiency (SAP12) rating.

1. `wallinsz`. Type of wall and insulation.

    - 1.0: cavity with insulation.
    - 2.0: cavity uninsulated.
    - 3.0: solid with insulation.
    - 4.0: solid uninsulated.
    - 5.0: other.

1. `watersys`. Water heating system.

    - Where the water heating is unknown, an electric immersion assumed.
    - 1.0: with central heating.
    - 2.0: dedicated boiler.
    - 3.0: electric immersion heater.
    - 4.0: instantaneous.
    - 5.0: other.

## Extra Information

All datasheets that report a single dwelling per row can be joined by the
unique identifier `serialanon`, a 11 digit numeric where the first 4 digits
represent the reporting years. E.g. 14150012345 represents an observation
from April 2014 to March 2015.

This variable replaces `aacode`, a 8 digit string where a leading character
represented reporting year.

In `general`, we find the following of interest.

1. `gorEHS`. Government office region EHS version.

    - 1.0: North East.
    - 2.0: North West.
    - 4.0: Yorkshire and the Humber.
    - 5.0: East Midlands.
    - 6.0: West Midlands.
    - 7.0: East.
    - 8.0: London.
    - 9.0: South East.
    - 10.0: South West.

1. `imd1510`. IMD 2015 decile ranking of areas (lower layer SOA).

    - Available from 2015/16 (SN: 8350).
    - Takes value 1 through 10 meaning:
        - 1.0: most deprived 10% of areas.
        - ...
        - 10.0: "least deprived 10% of areas.

1. `tenure4x`. Type of tenure.

    - 1.0: owner occupied.
    - 2.0: private rented.
    - 3.0: local authority.
    - 4.0: housing association.

1. `vacantx`.

    - 1.0: occupied.
    - 2.0: vacant.
