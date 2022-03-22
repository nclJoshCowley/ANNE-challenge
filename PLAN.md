# Plan

Decided to loosely implement the 6 main stages of CRISP-DM following the
initial research stage (inspired by the [NICD workshop][NICD-workflow]).

Dates are attached to each step to determine the **main** time to be working on
each step but these are loose as each step may cause backtracking.

## Business Understanding

See [IDEAS.md](IDEAS.md)

## Data Understanding (21st April - 27th April)

- Initial data determined to be open data: local authority housing
  statistics [(LAHS)][lahs2022].

- Supplementing data would be a good objective to aim for but not required.

## Data Preparation (21st April - 27th April)

- LAHS data takes the form of many features such as "a1a" that correspond to
  answers for each local authority (LA) in a supplied form.

- As such cleaning the data is a must to reduce ambiguous names and select the
  data relevant to the project.
  For instant, we're interested in EPC average but not properties' demolitions.

- Feature names will be made less ambiguous but still need to be concise,
  as such,a dataset description is an objective.

## Modelling (28th April - 3rd May)

- This will be updated following the data steps but at the time of the initial
  plan, the data seems to be annual time series where features should affect
  the response variable in the future: EPC average (ordinal categorical).

## Evaluation (4th May - 6th May)

In summary, the objectives are:

- Create a data cleaning report to encourage reproducibility of government
  data.

- Create a (RMD) report with a yet to be determined modelling technique.

- Convert said report to a dashboard ("hook the reader") that conveys
  information at a glance with a link to the more detailed report.

- Unambiguously define some indicator that builds upon EPC but also
  incorporates trend (or the original idea of difficulty).

## Deployment (4th May - 6th May)

This step is simply producing the final report and dashboard and submitting to
the SharePoint folder before the deadline of 6th April 2022.

[NICD-workflow]:
  https://nicd-uk.github.io/workflow-workshop/#15
  "Data Science Workflow Workshop, Matthew Edwards"

[lahs2022]:
  https://www.gov.uk/government/statistical-data-sets/local-authority-housing-statistics-open-data
  "Local authority housing statistics open data"
