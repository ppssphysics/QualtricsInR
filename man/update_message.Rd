% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/message-library.R
\name{update_message}
\alias{update_message}
\title{Update an existing library message}
\usage{
update_message(library_id, message_id, description, messages)
}
\arguments{
\item{library_id}{The Library ID can be one of the following IDs: User ID, Group ID, ThreeSixty ID}

\item{message_id}{Message ID}

\item{description}{defines a description for the message}

\item{messages}{A JSON object mapping language codes to messages. Existing languages will be replaced; others will be added}
}
\value{
A \code{tibble}.
}
\description{
This call is particularly useful is you want to update the translations and/or languages
available for a given library message.
}
\details{
The message id can be found using the 'list_messages' call.
}
\examples{
 \dontrun{
   message = list(
     "en" = "Thank you again for taking this survey.", 
      "es" = "Gracias por participar en esta encuesta")
   update_message(
     "UR_0NXtl92JJWqfWcJ", 
     "MS_3qR8d4mAkgD0fKl", 
     "My Most Recent Invite Message", 
     message)
}

}
