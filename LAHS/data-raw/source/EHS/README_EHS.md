# EHS

This file describes the structure of the EHS archives found at the UK data
archive.

## Description

To understand what the EHS is, consider this quote from the [UKDA][UKDA]:

> **English Housing Survey (formerly English House Condition Survey and Survey
> of English Housing)**
>
> The English Housing Survey (EHS) began in 2008-09, bringing together two
> previous housing surveys into a single fieldwork operation: the English
> House Condition Survey (EHCS) which ran in five years between 1967 and 2001
> and became continuous from 2002 to 2007, and the Survey of English Housing
> (SEH) which ran from 1993/94 to 2007-08. Commissioned by the Department
> for Communities and Local Government (DCLG), the EHS collects information
> from households on housing circumstances.

## Key Terms

The EHS invites *households* to complete a survey and follows up with a
physical inspection of *dwellings*. They use the following definitions in
the "Housing Stock Data User Guide (2008)":

### Dwelling

> A dwelling is a self-contained unit of accommodation (normally a house or
> flat) where all the rooms and amenities (i.e. kitchen, bath/shower room and
> WC) are for the exclusive use of the household(s) occupying them.

### Household

> A Household is defined as one person or a group of people, who have the
> accommodation as their only or main residence and (for a group) either share
> at least one meal a day or share the living accommodation, that is, a living
> or sitting room.

[UKDA]:
  https://ukdataservice.ac.uk/help/data-types/uk-surveys/

## Sections

### Folder Structure

Assuming the tab format was selected, the zipped folder will look as so:

- *mrdoc*, all documentation, most useful is the user guide (PDF).

  - *pdf*, publications, reports, etc.

  - *allissue*, data dictionaries, split by section.

- *tab*, data files split by section.

### Section headings

In each data or dictionary directory we see the following clusters.

- Derived.

- Fuel Poverty.

- Interview.

- Market value,

- Physical.

More information about each of these can be found in the user guide.
