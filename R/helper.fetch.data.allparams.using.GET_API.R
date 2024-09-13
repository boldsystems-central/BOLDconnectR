#' GET_data helper functions for ids
#' @keywords internal
#'
#'
#'
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


################################## get_data_bins helper function ######################################################


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


################################## get_data_datasets helper function ######################################################

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

################################## get_data_projects helper function ######################################################

get_data_projects<-function (data_for_projects,
                             api.key)

{


  # base url

  base_url_project = "https://data.boldsystems.org/api/records/processids?"


  # Obtain the dataset codes as a list of comma separated vector with 'dataset_codes' title

  query_params_project = list('project_codes'= paste(data_for_projects,
                                                     collapse=','))

  # add a condition to check  the number of dataset codes

  get.data=tryCatch(

    {


      httr::GET(url=base_url_project,
                query=query_params_project,
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

      json_cont_project<-content(get.data,"text")

    )

  )

  # Json strings to text to a list

  json_data_project<- lapply(strsplit(json_cont_project,
                                      "\n")[[1]], # split the content (here each process or sample id)
                             function(x) fromJSON(x)) # convert to JSON string and lapply converts that into a list

  # Convert the list to a data frame

  input_data2 <- tryCatch({
    df <- json_data_project %>%
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
