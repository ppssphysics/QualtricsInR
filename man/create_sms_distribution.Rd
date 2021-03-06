% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/distributions.R
\name{create_sms_distribution}
\alias{create_sms_distribution}
\title{Create a new survey distribution via SMS}
\usage{
create_sms_distribution(
  send_date,
  method,
  survey_id,
  name,
  mailinglist_id,
  message_id = NULL,
  library_id = NULL,
  messagetext = NULL,
  contact_id = NULL,
  parentdistribution_id = NULL
)
}
\arguments{
\item{send_date}{date for distribution to be sent}

\item{method}{Determines how the survey will be sent out via SMS. Can be
either Invite, Interactive, Reminder or Thankyou.}

\item{survey_id}{the id of survey to copy}

\item{name}{Name for the SMS distribution}

\item{mailinglist_id}{Mailing List ID for a batch distribution - Required for
Invite and Interactive method. Cannot be provided for Reminder and Thankyou}

\item{message_id}{ID of the message. The messageId is required in conjunction
with the libraryId if no messageText is supplied. A message object is only
required with the Invite, Reminder, and Thankyou methods.}

\item{library_id}{Library ID of the message. libraryId is required in
conjunction with the messageId if no messageText is supplied. A message
object is only required by "Invite" method.}

\item{messagetext}{Custom message text. Either messageText or messageId must
be provided but not both. A message object is only required with the Invite,
Reminder, and Thankyou methods.}

\item{contact_id}{Contact ID for an individual distribution. Cannot be
provided for Reminder and Thankyou}

\item{parentdistribution_id}{ID of the distribution to send a Reminder or
Thankyou distribution. Can be used only with these two methods.}
}
\value{
A \code{list}
}
\description{
Create a new survey distribution via SMS
}
