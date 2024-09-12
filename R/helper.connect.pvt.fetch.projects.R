#' fetch processids data using the project_codes
#'
#'
#' @param data.input input data
#' @param param.index the column number in the data which has the dataset_codes
#' @param api_key API key required to fetch the data
#' @keywords internal
#'
fetch.bold.project<-function(data.input,
                              param.index,
                              api_key)


{

  # base url for fetching the processids using the datasets input

  base_url_dataset = "https://data.boldsystems.org/api/records/processids?"

  # Since the dataset codes could be more than 100 and the GET limit currently is 100, batches are created if the number exceeds 100

  if(nrow(data.input)<=99)

  {

    data_for_projects = data.input[,param.index]

    # get_data_bins is a function to obtain the processids using the BOLD GET API.

    input_data2=get_data_projects(data_for_projects,
                                  api.key = api_key)


  }

  else if (nrow(data.input)>99)

  {

    # The generate batches function is just for generating batches of 100 which will then be used to get the processids. The param index in this case is set to 1

    batches_projects = generate.batches(data=data.input,
                                        param.index = 1,
                                        batch.size = 99)

    # get_data_bins is used in combination with lapply to generate a list of processids for all batches

    input_data2_list=lapply(batches_projects, function (x) get_data_projects(x,
                                                                             api.key = api_key))
    # Convert the list to a data frame of processids

    input_data2 = input_data2_list%>%
      bind_rows(.)

  }

  # this is the base_url used for obtaining the BOLD data using the POST API

  base_url = "https://data.boldsystems.org/api/records?"

  # Defining the query params for the POST API. Since the POST API here specifically is for the processids, 'processid' is hard coded in the code.

  query_params = list('input_type'= "processid",
                      'record_sep' = ",",
                      last_updated_threshold=0)

  # Check to assess the number of requests

  #  < 5000

  if (nrow(input_data2)<=5000)


  {

    # Extract the ids to a single character file to be used for the url used for POST

    id_data<-paste(input_data2[,1],
                   collapse = ",")

    # Custom function id.files used here. This will generate the ids as a temp_file required by the body of the PSOT API

    temp_file=id.files(id_data)

    # the post.api.res.fetch function uses the POST function to obtain the json output based on the processid query param

    result=post.api.res.fetch(base.url=base_url,
                              query.params=query_params,
                              api.key=api_key,
                              temp.file=temp_file)


    if (result$status_code!=200)

    {

      stop("Error occurred during data download. Please check the input data, parameter or the api_key")

    }


    # Custom function fetch.data used here. The function will convert the POST output to a dataframe (text/jsonlines->json->data.frame). The function also resolves the issues of columns having multiple values in single cells into a single character with values separated by commas using helper function 'bold.multirecords.set.csv'. Helper function 'reassign.data.type' is then used to assign the requisite data types to respective columns.

    json.df=fetch.data(result)

  }

  #  > 5000

  else if (nrow(input_data2)>5000)

  {

    ## If the ids input is more than 5000, a batch of 5000 ids is generated and used to create the temp_files for POST. 'generate batches' function is used here again but the batch.size here is given as 5000

    generate.batch.ids = generate.batches(data = input_data2,
                                          param.index = 1,
                                          batch.size=5000)

    # generate the temp_file/s


    temp_file=lapply(generate.batch.ids,
                     id.files)

    # Obtain the POST result. Here lapply is used with the post.api.res.fetch to generate the output (BOLD data) based on the 5000 processids


    result = lapply(temp_file,
                    function (file) {post.api.res.fetch(base.url=base_url,
                                                        query.params=query_params,
                                                        api.key=api_key,
                                                        temp.file=file)})

    if (unlist(result,
               use.names = T)$status_code!=200)

    {

      stop("Error occurred during data download. Please re-check param.data,param.query, param.index or the api_key")

    }


    # # removing empty results
    #
    # result = Filter(function(df) nrow(df) > 0, result.pre.filter)


    # Generating the data frame


    json.df=lapply(result,
                   fetch.data)%>%
      dplyr::bind_rows(.)


    if(nrow(json.df)==0)

    {

      stop("Search resulted in an empty dataset. Please re-check the input data.")

    }

    else

    {

      json.df

    }


  }


  # Convert the 'coord' character data into two numeric columns 'lat','lon'

  json.df <- tryCatch({
    json.df %>%
      tidyr::separate(coord, c("lat", "lon"), sep = ",", remove = TRUE) %>%
      dplyr::mutate(across(c(lat, lon), ~ as.numeric(.x)))
  }, error = function(e) {
    message("Error occurred during data download. Please re-check the param.data, query.param, param.index or the api_key.")
    return(NULL)
  })


  return(json.df)


}
