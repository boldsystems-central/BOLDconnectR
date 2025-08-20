#' Set the BOLD private data API key
#'
#' @description
#' Stores the BOLD-provided access token ‘api key’ in a variable, making it available for use in other function within the R session.
#'
#' @param apikey A character string required for authentication and data access.
#'
#' @details `bold.apikey` creates a variable called `apikey` that stores the access token provided by BOLD. This apikey variable is then used internally by the [bold.fetch()] function, so that the user does not have need to input it again. To set the `apikey`, the token must be provided as an input for the function before any other functions are called. The api_key is a UUID v4 hexadecimal string and is valid for one year,  after which it must be renewed.
#' \emph{Obtaining the API key}: The API key is found in the BOLD 'Workbench'<https://bench.boldsystems.org/index.php/Login/page?destination=MAS_Management_UserConsole>. After logging in, navigate to 'Your Name' (located at the top left-hand side of the window) and click 'Edit User Preferences'. You can find the API key in the 'User Data' section. Please note that to have an API key available in the workbench, a user must have uploaded at least 10,000 records to BOLD.
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
# bold.apikey<-function(apikey)
#
#   {
#
#   assign("apikey",
#          apikey,
#          envir=.GlobalEnv)
#
#    return(get("apikey",
#              envir = .GlobalEnv))
#
#
# }
bold.apikey <- function(apikey)
{
  # check if the key is provided

  stopifnot(!is.null(apikey))

  # check if the format of key is correct

  api_key_format <- "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$"

  if (!grepl(api_key_format, apikey)) {
    stop("Incorrect API key format. Please re-check the API key")
  }

  # Set the key in R session

  Sys.setenv(api_key = apikey)
}

