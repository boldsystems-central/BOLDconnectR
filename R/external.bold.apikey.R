#' Set the BOLD private data API key
#'
#' @description
#' Stores the BOLD-provided access token ‘api key’ in a variable, making it available for use in other function within the R session.
#'
#' @param apikey A character string required for authentication and data access.
#'
#' @details `bold.apikey` creates a variable called `apikey` that stores the access token provided by BOLD. This apikey variable is then used internally by the [bold.fetch()] function, so that the user does not have need to input it again. To set the `apikey`, the token must be provided as an input for the function before any other functions are called. The api_key is a UUID v4 hexadecimal string obtained upon request from BOLD at `support@boldsystems.org` and is valid for one year,  after which it must be renewed.
#'
#' @returns Token saved as 'apikey'
#'
#' @examples
#' \dontrun{
#'
#' #This example below is for documentation only
#'
#' bold_apikey(‘00000000-0000-0000-0000-000000000000’)
#'
#' }
#'
#'
#' @export
#'
bold.apikey<-function(apikey)

  {

  default_options<-options()

  assign("apikey",
         apikey,
         envir=.GlobalEnv)

  return(get("apikey",
             envir = .GlobalEnv))

  on.exit(default_options)
}


