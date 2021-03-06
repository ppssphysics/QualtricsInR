% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/divisions.R
\name{update_division}
\alias{update_division}
\title{Update a division's settings}
\usage{
update_division(division_id, name = NULL, status = NULL, permissions = NULL)
}
\arguments{
\item{division_id}{the id of the division to update}

\item{name}{the new division name}

\item{status}{the new status of the division, can be "Active", "Disabled"}

\item{permissions}{a JSON object with permissions to update}
}
\value{
id of created message
}
\description{
Update a division's settings
}
\examples{
\dontrun{update_division("DV_1234567890AbCdE", name = "newdivisionname")}
\dontrun{
perms <- list(
"controlPanel" = list(
  "surveyPermissions" = list(
    "editSurveyFlow" = list("state" = "off"))))
update_division("DV_1234567890AbCdE", permissions = perms)
}

}
