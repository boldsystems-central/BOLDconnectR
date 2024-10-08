#' @keywords internal

# Helper functions to obtain processids for bin_uri, dataset_codes and project codes using GET API
# These functions are used by
# #1. bold.fetch
#
# Function 1: The function that uses GET to retrieve pids (First a token is generated which is then used for obtaining the processids)

bin.dataset.project.pids<-function (get.data.input,
                                    query.param)

{

  # Base url for the obtaining the token that will be used for fetching the processids

  base_url_ids<-paste('https://data.boldsystems.org/api/sets/create?',
                      query.param,
                      '?',
                      sep='')

  # query parameters

  query_ids = list(paste(get.data.input,
                         collapse=','))

  # name of the query parameter

  names(query_ids)<-query.param

  # Using the GET API to fetch the token

  get.data=httr::GET(url=base_url_ids,
                     query=query_ids,
                     add_headers('accept' = 'application/json',
                                 'api-key' = apikey))

  ## Obtain the token as Json strings

  suppressMessages(

    suppressWarnings(


      json_bin_dataset_project_cont<-content(get.data,
                                             "text")

    )

  )

  # Token is extracted out from the json text

  json_bins_datasets_project_data<- lapply(strsplit(json_bin_dataset_project_cont,
                                                    "\n")[[1]], # split the content (here each process or sample id)
                                           function(x) fromJSON(x))

  # The token is pasted in the second url to fetch the processids

  url_get_pids_from_token<-paste('https://data.boldsystems.org/api/sets/retrieve/',json_bins_datasets_project_data[[1]]$token,'?','check_exists=false',sep='')


  get.data.pids=httr::GET(url=url_get_pids_from_token,
                          add_headers('accept' = 'application/json',
                                      'api-key' = apikey))

  if (httr::status_code(get.data.pids) < 200 || httr::status_code(get.data.pids)>=300)
  {
    stop(paste("Data could not be retrieved. Please check the get_by & identifiers. Please also re-confirm whether the API key has the necessary permissions to obtain any/all data (esp. datasets and projects)"))
  }

  ## Obtain the content as Json strings

  suppressMessages(

    suppressWarnings(


      json_bin_dataset_project_cont<-content(get.data.pids,"text")

    )

  )

  # Json strings to text to a list

  json_bins_datasets_project_pids<- lapply(strsplit(json_bin_dataset_project_cont,
                                                    "\n")[[1]], # split the content (here each process or sample id)
                                           function(x) fromJSON(x))

  pids_for_POST_api<-json_bins_datasets_project_pids %>%
    data.frame(.)


  return(pids_for_POST_api)

}


# Function 2: Function to actually retrieve processids based on the number of 'identifiers' rows.
# Since the BIN ids could be more than 100 and the GET limit currently is 100, batches are created if the number exceeds 100

get.bin.dataset.project.pids<-function(data.input,
                                          query_param)


{

  if(nrow(data.input)<=99)
  {

    bin_dataset_project_ids = data.input[,1]

    # get_data_bins is a function to obtain the processids using the BOLD GET API.

    processids_4_bin_dataset_project=bin.dataset.project.pids(bin_dataset_project_ids,
                                                              query.param = query_param)
  }


  else if (nrow(data.input)>99)
  {

    # The generate batches function is just for generating batches of 99 which will then be used to get the processids.

    batches_ids = generate.batches(data=data.input,
                                   batch.size = 99)

    # get_data_bins is used in combination with lapply to generate a list of processids for all batches

    processids_4_bin_dataset_project_list=lapply(batches_ids,
                                                 function (x) {
                                                   step1=unlist(x)
                                                   bin.dataset.project.pids(step1,
                                                                            query.param = query_param)})
    # Convert the list to a data frame of processids

    processids_4_bin_dataset_project = processids_4_bin_dataset_project_list%>%
      bind_rows(.)

  }

 return(processids_4_bin_dataset_project)

}
