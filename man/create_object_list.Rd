% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/wdds_schema.R
\name{create_object_list}
\alias{create_object_list}
\title{Create a list from a schema object}
\usage{
create_object_list(x, idx, schema_dir)
}
\arguments{
\item{x}{List. Schema property or definition}

\item{idx}{Name from schema property}

\item{schema_dir}{Character. directory where the schema is stored}
}
\value{
data frame with type and name
}
\description{
Creates a data.frame with the fields name and type
}
