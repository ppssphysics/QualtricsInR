% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/survey-definitions-languages.R
\name{update_survey_languages}
\alias{update_survey_languages}
\title{Update the list of available survey languages for a survey}
\usage{
update_survey_languages(survey_id, language_codes)
}
\arguments{
\item{survey_id}{the survey id}

\item{language_codes}{Array of language codes to enable}
}
\value{
A \code{status}.
}
\description{
Enabling a new survey language is needed before being able to add a
translation for that language.
}
\examples{
\dontrun{update_survey_languages("SV_1873930DS2", c("EN", "ES"))}
}
