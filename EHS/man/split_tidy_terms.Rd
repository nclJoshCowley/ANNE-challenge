% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tidy-lm.R
\name{split_tidy_terms}
\alias{split_tidy_terms}
\title{Split Tidy Terms}
\usage{
split_tidy_terms(x, xlevels)
}
\arguments{
\item{x}{tibble. Expected to be \code{tidy.lm} output}

\item{xlevels}{list. Expected to be the \code{fit$xlevels} from the same \code{lm}.}
}
\description{
Split \code{term} column from \code{tidy.lm} output for factors. By default, constrasts
make columns names like "Speciesvirginica" where factor name and level are
ambiguous.
}
\keyword{internal}
