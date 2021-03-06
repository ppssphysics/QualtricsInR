% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/groups.R
\name{create_group}
\alias{create_group}
\title{Create a new group}
\usage{
create_group(type, name, division_id = NULL)
}
\arguments{
\item{type}{group type.}

\item{name}{new group name}

\item{division_id}{default NULL but specific division id can be specified to
automatically assign the division properties}
}
\value{
id of newly created group
}
\description{
Currently this is a GAP as you cannot create group types with an API nor
look them up. But you need that to create a Group.
}
