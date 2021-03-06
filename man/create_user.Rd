% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/users.R
\name{create_user}
\alias{create_user}
\title{Create a new user account}
\usage{
create_user(params)
}
\arguments{
\item{params}{a named list of account parameters}
}
\value{
The created user id
}
\description{
Create a new user account
}
\section{Account parameters}{
 user settings that can be passed are user_name,
first_name, last_name, user_type, email, password, language, time_zone,
division_id, account_expiration_date. Currently Qualtrics does not provide
an endpoint to retrieve user types so you must infer them from other calls
such as \code{get_user}.
}

\examples{
\dontrun{
params <- list(
"username" = "firt.last@qualtrics.com",
"firstName" = "first name",
"lastName" = "last name",
"userType" = "UT_012345678912345",
"email" = "firt.last@qualtrics.com",
"password" = "$123456789!",
"language" = "en",
"timeZone" = NULL,
"divisionId" = NULL,
"accountExpirationDate" = NULL
)
create_user(params)}
}
