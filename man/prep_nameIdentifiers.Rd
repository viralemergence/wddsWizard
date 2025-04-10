% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prep_for_json.R
\name{prep_nameIdentifiers}
\alias{prep_nameIdentifiers}
\title{Prepare Name identifiers}
\usage{
prep_nameIdentifiers(x)
}
\arguments{
\item{x}{Data frame from "creators"}
}
\value{
data frame with a nameIdentifiers column as list
}
\description{
These are Persistent identifiers associated with a creator.
}
\details{
Name identifiers in datacite is an array of objects
with properties "nameIdentifier", "nameIdentifierScheme" ,
and "schemeUri". This function takes the \verb{name identifiers} fields and restructures
as a list within the data frame.
}
