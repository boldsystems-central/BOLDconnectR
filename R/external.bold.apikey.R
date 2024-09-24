#' Set the BOLD private data API key
#'
#' @description
#' Generates an 'apikey' variable in the R session
#'
#' @param apikey A character string required for authentication and data access.
#'
#' @details
#' `bold.apikey` generates a variable called `apikey` that stores the access token provided by BOLD. The token must be provided as an input for the function. The `apikey` variable is then used by the [bold.fetch()] internally so that the user does not have to input it again.
#'
#'
#' @returns Token saved as 'apikey'
#'
#' @export
#'
bold.apikey<-function(apikey)

  {

  default_options<-options()

  ## API key format check

  api_key_format<-"^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$"

  if(grepl(api_key_format,
           apikey)==FALSE) {
    stop("Incorrect api key format. Please re-check the API key")
  }

  assign("apikey",
         apikey,
         envir=.GlobalEnv)

  return(get("apikey",
             envir = .GlobalEnv))

  on.exit(default_options)
}

bold.apikey('58EEAA88-D681-49AB-A4AC-79779E1AF3D9')

