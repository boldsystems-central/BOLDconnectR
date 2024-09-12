#' Helper function using GET to get the processids from dataset codes
#'
#' @param data_for_datasets input data containing dataset codes information
#' @param api.key API key required to fetch the data
#' @keywords internal


get_data_datasets<-function (data_for_datasets,
                         api.key)

{


  # base url

  base_url_dataset = "https://data.boldsystems.org/api/records/processids?"


  # Obtain the dataset codes as a list of comma separated vector with 'dataset_codes' title

  query_params_dataset = list('dataset_codes'= paste(data_for_datasets,
                                                     collapse=','))

  # add a condition to check  the number of dataset codes

  get.data=tryCatch(

    {


      httr::GET(url=base_url_dataset,
                query=query_params_dataset,
                add_headers('accept' = 'application/json',
                            'api-key' = api.key))

    },

    error = function(e)

    {

      # Handle the error for the POST request

      message("An error occurred during data download: ", e$message)

      return(NULL)


    }

  )

  if (!is.null(get.data) && http_error(get.data))
  {

    message(paste("HTTP error: ", http_status(result)$message,"\n","Error occurred during data download"))

    return(NULL)

  }




  ## Obtain the content as Json strings

  suppressMessages(

    suppressWarnings(

      json_cont_data_sets<-content(get.data,"text")

    )

  )

  # Json strings to text to a list

  json_data_datasets<- lapply(strsplit(json_cont_data_sets,
                                   "\n")[[1]], # split the content (here each process or sample id)
                          function(x) fromJSON(x)) # convert to JSON string and lapply converts that into a list

  # Convert the list to a data frame

  input_data2 <- tryCatch({
    df <- json_data_datasets %>%
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
