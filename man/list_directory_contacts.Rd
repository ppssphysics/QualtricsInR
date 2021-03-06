% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/xm-directory-api.R
\name{list_directory_contacts}
\alias{list_directory_contacts}
\title{List Directories for a Brand}
\usage{
list_directory_contacts(page_size = 5)
}
\arguments{
\item{page_size}{The maximum number of items to return per request (max and default is 5)}
}
\value{
A \code{tibble} of all mailing list with properties
}
\description{
Using this API, the client can retrieve a list of directories with summary information for each directory.
This API is paginated, but currently returns a single page of up to 5 results and a null next page token.
Pagination is handled automatically.
}
\examples{
\dontrun{list_directory_contacts()}

}
