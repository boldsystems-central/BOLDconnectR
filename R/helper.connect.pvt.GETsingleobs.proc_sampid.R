#' GET_data helper functions for single records of processids and sampleids
#'
#' @param input_data input data
#' @param param.index the column number in the data which has bin_uri data
#' @param api.key API key required to fetch the data

################################## get_data_processid helper function ######################################################

get_data_processid<-function (input_data,
                             param.index,
                             api.key)

{

  # base url

  base_url_process= "https://data.boldsystems.org/api/records?"


  # Obtain the dataset codes as a list of comma separated vector with 'dataset_codes' title

  query_params_1 = list("processids" = paste(input_data,
                                               collapse=','))

  # add a condition to check  the number of dataset codes

  get.data=tryCatch(

    {


      httr::GET(url=base_url_process,
                query=query_params_1,
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

    message(paste("HTTP error: ", http_status(get.data)$message,"\n","Error occurred during data download"))

    return(NULL)

  }


  # COnvert the list to a data frame

  # result=fetch.data(result=get.data)

  result=fetch.data(get.data)


  return(result)


}


################################## get_data_sampleid helper function ######################################################

get_data_sampleid<-function (input_data,
                             param.index,
                             api.key)

{

  # base url

  base_url_sample= "https://data.boldsystems.org/api/records?"


  # Obtain the dataset codes as a list of comma separated vector with 'dataset_codes' title

  query_params_1 = list("sampleids" = paste(input_data,
                                            collapse=','))

  # add a condition to check  the number of dataset codes

  get.data=tryCatch(

    {


      httr::GET(url=base_url_sample,
                query=query_params_1,
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

    message(paste("HTTP error: ", http_status(get.data)$message,"\n","Error occurred during data download"))

    return(NULL)

  }


  # COnvert the list to a data frame

  # result=fetch.data(result=get.data)

  result=fetch.data(get.data)

  return(result)


}
