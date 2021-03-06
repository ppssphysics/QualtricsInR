
.build_temp_dir <- function() {
  tmpDir <- tempdir()
  tmpFil <- paste0(
    tmpDir,
    ifelse(
      substr(tmpDir, nchar(tmpDir), nchar(tmpDir)) == "/",
      "temp.zip",
      "/temp.zip"))

  return(list(tmpDir, tmpFil))
}

.get_export_status <- function(surveyId, exportId) {
  params <- c("surveys", surveyId, "export-responses", exportId)
  getresp <- .qualtrics_get(params, NULL, NULL)
  return(c(getresp$result$status,getresp$result$percentComplete, getresp$result$fileId))
}

.get_export_file <- function(surveyId, fileId, fileType, saveDir, filename) {

  tmps <- .build_temp_dir()
  params <- c("surveys",surveyId,"export-responses",fileId,"file")
  status <- .qualtrics_export(params, tmps[[2]])
  file <- unzip(tmps[[2]], exdir = tmps[[1]])

  if (fileType == "json")
    data <- fromJSON(file)
  else if (fileType == "csv") {
    data <- read_csv(file, col_types = cols()) %>%
      slice(-1, -2)
  }
  else if (fileType == "tsv")
    data <- read_tsv(file)

  if (!is.null(saveDir)) {
    if (is.null(filename))
      file.copy(file, paste0(saveDir, surveyId, ".", fileType), overwrite = TRUE)
    else
      file.copy(file, paste0(saveDir, filename, ".", fileType), overwrite = TRUE)
  }

  file.remove(tmps[[2]])
  file.remove(file)
  return(data)
}

#' Export a survey's responses into R
#'
#' @description
#' Export survey responses into R and/or save exported file. Currently single
#' exports calls are limited to 1.8 GB. Above that size, we recommend you split
#' your export accross different date ranges. When exporting a large number of
#' surveys successively, we recommend using the more efficient \code{request_downloads} and
#' \code{download_requested} functions.
#'
#' @param survey_id the id of survey to copy
#' @param format file format csv, by default (can be json or tsv). We don't provide SPSS yet.
#' @param verbose default FALSE
#' @param saveDir path to a local directory to save the exported file. Default is a temporary file in rds format that is removed at the end of your session. Default name will be the surveyId.
#' @param filename specify filename for saving. If NULL, uses the survey id
#' @param ... a vector of named parameters, see all parameters in reference documentation.
#' 
#' @examples
#' \dontrun{get_survey_responses("SV_012345678901234", "csv")}
#' \dontrun{get_survey_responses("SV_012345678901234", format = "csv",verbose = TRUE,
#' saveDir = "./", filename = "name_export", useLabels = TRUE, limit = 10)}
#'
#' @return A status code
#' @export
get_survey_responses <- function(
  survey_id,
  format = "csv",
  verbose = FALSE,
  saveDir = NULL,
  filename = NULL,
  ...) {

  # Check consistency filename and dir specified
  if (!is.null(filename) & (is.null(saveDir) || saveDir == "")) {
    saveDir <- "./"
    cat("Saving files in local directory", saveDir, "\n")
  }
  
  # Check input parameters
  if (!is.null(saveDir)) saveDir <- .check_directory(saveDir)

  # Step 1: Creating Data Export
  params <- c("surveys", survey_id, "export-responses")
  body <- list("format" = format, ...)
  getcnt <- .qualtrics_post(params, NULL, body)

  # Step 2: Checking on Data Export Progress and waiting until export is ready

  if (verbose) pbar <- txtProgressBar(min = 0, max = 100, style = 3)

  progressVec <- .get_export_status(survey_id, getcnt$result$progressId)
  while(progressVec[1] != "complete" & progressVec[1]!="failed") {
    progressVec <- .get_export_status(survey_id, getcnt$result$progressId)
    Sys.sleep(1)
  }

  if (verbose) close(pbar)

  #step 2.1: Check for error
  if (progressVec[1]=="failed")
    stop("export failed", call. = FALSE)

  # Step 3: Downloading file
  data <- .get_export_file(survey_id, progressVec[3], format, saveDir, filename)

  return(data)

}

#' @export
print.qualtrics_download <- function(x,...){
  counts <- table(x$success)
  t <- unname(counts["TRUE"])
  f <- unname(counts["FALSE"])
  cat(
    "Download Requests:\n",
    crayon::green(symbol$tick), .na20(t), " Successful\n",
    red(symbol$cross), .na20(f), " Unsuccessful\n"
  )
}

#' Success?
#'
#' Check which request was successful and which was not.
#'
#' @inheritParams bulk-download
#'
#' @examples
#' \dontrun{requests <- request_downloads(c(1,2))}
#' \dontrun{success <- is_success(requests, TRUE)}
#'
#' @name is_success
#' @export
is_success <- function(requests, verbose = FALSE) UseMethod("is_success")

#' @rdname is_success
#' @method is_success qualtrics_download
#' @export
is_success.qualtrics_download <- function(requests, verbose = FALSE){
  ids <- requests %>%
    mutate(
      surveyIds = ifelse(success == TRUE, crayon::green(surveyIds), red(surveyIds))
    ) %>%
    pull(surveyIds)

  if(isTRUE(verbose))
    ids %>%
    paste0(collapse = "\n") %>%
    cat("\n")

  class(requests) <- "data.frame"
  return(requests)
}

#' Request downloads
#'
#' Request survey response downloads.
#'
#' @param surveyIds A vector of survey ids.
#' @param format file format json, by default (can be csv or tsv). We don't provide SPSS yet.
#' @param ... a vector of named parameters, see \url{https://api.qualtrics.com/reference} *Create Response Export* for parameter names.
#' @param retryOnRateLimit Whether to retry if initials API call fails.
#' @param verbose Whether to print helpful messages to the console.
#'
#' @details The \href{https://www.qualtrics.com}{Qualtrics} API downloads survey responses in several steps.
#' First a download is \emph{requested}. Qualtrics prepares the file and \code{\link{download_requested}}
#' can be triggered to download the file when it is ready. When downloading responses from a large nuimber of
#' surveys, it is more efficient to request all downloads if a first place, check that the downloads are ready
#' and then retrieve all the files. The performances will headvily depend on the number
#' of surveys and the amount of data the user ultimately wants to obtain.
#'
#' @section Functions:
#' \itemize{
#'   \item{\code{request_downloads}: Request download (prepares files).}
#'   \item{\code{download_requested}: Download requested files.}
#' }
#'
#' @examples
#' \dontrun{
#' requests <- request_downloads(c("SV_2uAzZmuCOb7zyYZ","SV_eL2OmawGm5GlzTf")))
#' data <- download_requested(requests)}
#'
#' @return A \code{request_downloads} returns object of class \code{qualtrics_download} while
#' \code{download_requested} returns a \code{list}.
#' @importFrom methods new
#' @import dplyr
#' @name bulk-download
#' @export
request_downloads <- function(
  surveyIds,
  format = "json",
  ...,
  verbose = interactive(),
  retryOnRateLimit = TRUE
  ) {

  if(missing(surveyIds))
    stop("missing surveyIds", call. = FALSE)

  requests <- map(
    surveyIds,
    function(x){
      params <- c("surveys", x, "export-responses")
      body <- list("format" = format, ...)
      resp <- tryCatch(.qualtrics_post(params, NULL, body), error = function(e) e)

      .catch_token_error(resp)

      #print(resp)

      if(retryOnRateLimit){
        cnt <- 1
        while(inherits(resp, "error")){

          Sys.sleep(4)
          if(verbose)
            cli_alert_warning(paste0("Retry #", cnt, " on '", x, "'"))
          resp <- tryCatch(.qualtrics_post(params, NULL, body), error = function(e) e)

          if(cnt == 15)
            break;

          cnt <- cnt + 1
        }
      }

      if(inherits(resp, "error")){
        if(verbose)
          cli_alert_danger(paste0("Could not request '", x, "'"))
        return(tibble(
          "surveyId" = x,
          "progressId" = NA,
          "status" = FALSE
        ))
      }

      if(verbose)
        cli_alert_success(paste0("Successfully requested: '", x, "'"))

      tibble(
        "surveyId" = x,
        "progressId" = ifelse(!is.null(resp$result$progressId), resp$result$progressId, NA),
        "status" = ifelse(resp$meta$httpStatus != "200 - OK", FALSE, TRUE)
      )
    }
  ) %>% 
    map_dfr(bind_rows)

  structure(
    tibble(
      surveyIds = requests$surveyId,
      progressIds = requests$progressId,
      success = requests$status,
      format = format
      ),
    class = c("qualtrics_download", "data.frame")
  )
}

#' @rdname bulk-download
#' @export
download_requested <- function(
  requests,
  saveDir = NULL,
  verbose = interactive(),
  retryOnRateLimit = TRUE
){
  UseMethod("download_requested")
}

#' @rdname bulk-download
#' @param requests the list output of request_downloads
#' @param saveDir the output dir to save the data
#' @param verbose print progress for heavy downloads (default is FALSE)
#' @param retryOnRateLimit Whether to retry if initials API call fails.
#' 
#' @method download_requested qualtrics_download
#' @export
download_requested.qualtrics_download <- function(
  requests,
  saveDir = NULL,
  verbose = interactive(),
  retryOnRateLimit = TRUE
){

  # Check input parameters
  if (!is.null(saveDir))
    saveDir <- .check_directory(saveDir)

  valid <- requests %>%
    filter(success == TRUE)

  invalid <- requests %>%
    anti_join(valid, by = "surveyIds")

  if(nrow(invalid))
    cat(
      "Not downloading unsuccessful requests:",
      paste0("\n", red(symbol$cross), " '", invalid$surveyIds, "'"), "\n"
    )

  format <- unique(valid$format)

  data <- map2(
    valid$surveyIds,
    valid$progressIds,
    function(surveyId, progressId, format, saveDir){

      progressVec <- .get_export_status(surveyId, progressId)
      while(progressVec[1] != "complete" & progressVec[1]!="failed") {
        progressVec <- .get_export_status(surveyId, progressId)
        Sys.sleep(1)
      }

      if (progressVec[1]=="failed")
        stop("export failed", call. = FALSE)

      resp <- tryCatch(.get_export_file(surveyId, progressVec[3], format, saveDir, filename = NULL), error = function(e) e)

      .catch_token_error(resp)

      if(retryOnRateLimit){
        cnt <- 1

        while(inherits(resp, "error")){
          Sys.sleep(4)
          if(verbose)
            cli_alert_warning(paste0("Retry #", cnt, " on '", surveyId, "'"))
          resp <- tryCatch(.get_export_file(surveyId, progressVec[3], format, saveDir, filename = NULL), error = function(e) e)

          if(cnt == 15)
            break;

          cnt <- cnt + 1
        }
      }

      if(inherits(resp, "error")){
        if(verbose)
          cli_alert_danger(paste0("Could not download '", surveyId, "'"))
        return(list())
      }

      if(verbose)
        cli_alert_success(paste0("Successfully downloaded: '", surveyId, "'"))

      return(resp)
    },
    format = format,
    saveDir = saveDir
  )

  names(data) <- valid$surveyIds

  return(data)
}

#' @rdname bulk-download
#' @export
check_status <- function(requests) UseMethod("check_status")

#' @method check_status qualtrics_download
#' @export
check_status.qualtrics_download <- function(requests){
  status <- requests %>% 
    transpose() %>% 
    map(function(x){
    tryCatch(
      .get_export_status(x$surveyId, x$progressId)[1],
      error = function(e) "error"
    )
  }) %>% 
    unlist()

  tibble(
    surveyId = requests$surveyId,
    status = status
  )
}


#' Update the value of an embedded data field in a survey response
#'
#' @param surveyId the id of survey to copy
#' @param responseId ID of the response to be deleted
#' @param embeddedData JSON object representing the embedded data fields to set.
#' @param resetRecordedDate Default: true - Sets the recorded date to the current
#' time. If false, the recorded date will be incremented by one millisecond.
#' @examples
#' \dontrun{update_response("SV_012345678912345", "R_012345678912345",
#' {"EDField": "EDValue"}, FALSE)}
#' @return A \code{status}.
#' @export
update_response <- function(
  surveyId,
  responseId,
  embeddedData,
  resetRecordedDate=TRUE) {

  params <- c("responses", responseId)
  body <- list(
    "surveyId" = surveyId,
    "embeddedData" = embeddedData,
    "resetRecordedDate" = resetRecordedDate
    )

  getcnt <- .qualtrics_put(params, NULL, body)
  getcnt$meta$httpStatus
  }

#' Delete a survey response
#'
#' @param surveyId ID of the survey to delete the response from
#' @param responseId ID of the response to be deleted
#' @param decrementQuotas If true, any relevant quotas will be decremented
#'
#' @examples
#' \dontrun{delete_response("SV_012345678912345", "R_012345678912345", TRUE)}
#' @return A \code{status}.
#' @export
delete_response <- function(
  surveyId,
  responseId,
  decrementQuotas) {

  params <- c("responses", responseId)
  getcnt <- .qualtrics_delete(params, list("surveyId"=surveyId, "decrementQuotas" = decrementQuotas), NULL)
  getcnt$meta$httpStatus
}
