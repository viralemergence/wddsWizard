% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prep_for_json.R
\name{prep_titles}
\alias{prep_titles}
\title{Prepare Titles}
\usage{
prep_titles(x)
}
\arguments{
\item{x}{list of tibbles/data frames or a tibble/data frame}
}
\value{
list of single row unboxed data frames
}
\description{
Prepares an array of objects
}
\examples{

wddsWizard::becker_project_metadata$titles |>
prep_titles()

}
