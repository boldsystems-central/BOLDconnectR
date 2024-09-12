#' Helper function using GET to get the processids from bin ids
#'
#' @param data_for_bins input data containing BIN information
#' @param api.key API key required to fetch the data
#' @keywords internal
#'
#'
#'

get_data_bins<-function (data_for_bins,
                         api.key)

{

  # Base url for fetching BIN ids

  base_url_bins = "https://data.boldsystems.org/api/records/processids?"

  # Obtain the BIN ids as a list of comma separated vector with 'bin_uris' title

  bin_uris = list('bin_uris'= paste(data_for_bins,
                                    collapse=','))

  # use GET API to fetch data

  get.data=tryCatch(

    {

    httr::GET(url=base_url_bins,
                     query=bin_uris,
                     add_headers('accept' = 'application/json',
                                 'api-key' = api.key))
    },

    error = function(e)

    {

      # Handle the error for the POST request
      stop("An error occurred during data download: ", e$message)


    }

  )

  if (!is.null(get.data) && http_error(get.data))

    {

    message(paste("HTTP error: ", http_status(get.data)$message,"\n","Error occurred during data dowload"))

    return(NULL)

}





  ## Obtain the content as Json strings

  suppressMessages(

    suppressWarnings(


      json_cont_bins<-content(get.data,"text")

    )

  )

  # Json strings to text to a list

  json_data_bins<- lapply(strsplit(json_cont_bins,
                                   "\n")[[1]], # split the content (here each process or sample id)
                          function(x) fromJSON(x)) # convert to JSON string and lapply converts that into a list

  # Convert the list to a data frame

  input_data2 <- tryCatch({
    df <- json_data_bins %>%
      data.frame(.)

    if (nrow(df) == 0) {
      stop("The resulting data frame is empty.")
    }

    df
  }, error = function(e) {
    # Handle the error for the data frame conversion
    stop("Error occurred during data download. Please re-check the param.data, query.param, param.index or the api_key.")

  })


  return(input_data2)

}
