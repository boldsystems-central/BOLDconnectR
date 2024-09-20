################## Obtain processids for bin_uri, dataset_codes and project codes using GET API ######################

# Function 1: The function that uses GET to retrieve pids

bin.dataset.project.pids<-function (get.data.input,
                                        query.param)

{

  # Base url for fetching these ids

  base_url_ids = "https://data.boldsystems.org/api/records/processids?"

  # Obtain the BIN ids as a list of comma separated vector with 'bin_uris' title

  query_ids = list(paste(get.data.input,
                                       collapse=','))

  names(query_ids)<-query.param

  # use GET API to fetch data

  get.data=httr::GET(url=base_url_ids,
                query=query_ids,
                add_headers('accept' = 'application/json',
                            'api-key' = apikey))


    # stopifnot("Error occurred during data dowload.Please re-check whether the correct get_by and corresponding identifier argument has been specified.",is.null(get.data))


  ## Obtain the content as Json strings

  suppressMessages(

    suppressWarnings(


      json_bin_dataset_project_cont<-content(get.data,"text")

    )

  )

  # Json strings to text to a list

  json_bins_datasets_project_data<- lapply(strsplit(json_bin_dataset_project_cont,
                                                    "\n")[[1]], # split the content (here each process or sample id)
                                           function(x) fromJSON(x)) # convert to JSON string and lapply converts that into a list

  # Convert the list to a data frame

  # pids_for_POST_api <- tryCatch({
  #   df <- json_bins_datasets_project_data %>%
  #     data.frame(.)
  # },
  # error = function(e) {
  #   # Handle the error for the data frame conversion
  #   stop("Error occurred during data download. Please re-check the param.data, query.param, param.index or the api_key.")
  #
  # })

  pids_for_POST_api<-json_bins_datasets_project_data %>%
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
