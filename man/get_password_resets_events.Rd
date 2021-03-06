% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/audit.R
\name{get_password_resets_events}
\alias{get_password_resets_events}
\title{Retrieve the collection of password_resets events}
\usage{
get_password_resets_events(...)
}
\arguments{
\item{...}{a vector of named parameters.}
}
\value{
A \code{tibble} or a {json} with all return events
}
\description{
By default a given audit will return all historical events. This can be an unreasonnable number of events to return. The
opitional paramets allow you to specific and start date and an enddate for the audit as well as other filters. See the \href{https://api.qualtrics.com/api-reference/reference/audits.json/paths/~1logs/get}{official documentation} for all available parameters.
}
\examples{
\dontrun{get_password_resets_events()}
}
