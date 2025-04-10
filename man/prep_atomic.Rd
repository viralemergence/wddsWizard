% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prep_for_json.R
\name{prep_atomic}
\alias{prep_atomic}
\title{Prepare atomic}
\usage{
prep_atomic(x)
}
\arguments{
\item{x}{vector}
}
\value{
an unboxed dataframe with 1 row
}
\description{
This is a thin wrapper for \code{jsonlite::unbox}. It stops \code{jsonlite} from
representing single character, numeric, logical, etc. items as arrays.
}
\details{
This is useful when a property or definition is of type string, number, logical and of length 1.
}
\examples{

x <- 1

# values in x are stored in an array
x|>
jsonlite::toJSON()
 # output is [1]

# values in x are NOT stored in an array (no square brackets)
prep_atomic(x) |>
  jsonlite::toJSON()
# output is 1

}
