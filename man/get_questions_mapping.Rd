% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/survey-definitions-questions.R
\name{get_questions_mapping}
\alias{get_questions_mapping}
\title{Get survey question mapping}
\usage{
get_questions_mapping(survey_id)
}
\arguments{
\item{survey_id}{the survey id}
}
\value{
A list
}
\description{
This function returns a tibble formatted result of the list_question result, allowing for an easy
inspection of the relation between question IDs and question export tags.
}
\examples{
\dontrun{get_questions_mapping("SV_012345678901234")}
}
