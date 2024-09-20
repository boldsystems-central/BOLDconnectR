##################################### fetch.bold.id for all params ##################################################

fetch.bold.id<-function(data.input,
                               query_param)

{

  # query parameters for API

  query_params <- list('input_type'= query_param,
                       'record_sep' = ",",
                       last_updated_threshold=0)

  # base url for API

  base_url= "https://data.boldsystems.org/api/records?"

  # Colors for printing the progress on the console

  green_col <- "\033[32m"

  red_col<-"\033[31m"

  reset_col <- "\033[0m"



  ## Check to assess the number of requests

  # < 5000

  if (nrow(data.input) <= 5000)


  {

    # Extract the ids to a single character file to be used for the url used for POST

    id_data<-paste(data.input[,1],
                   collapse = ",")

    # Custom function id.files used here. This will generate the ids as a temp_file required by the body of the POST API

    temp_file=id.files(id_data)


    # The helper function 'post.api.res.fetch' is used to retrieve the data.

    cat(green_col,"Initiating download",reset_col,'\n',sep="")

    cat(red_col,"Downloading data in a single batch",reset_col,'\r')

    result=post.api.res.fetch(base.url=base_url,
                              query.params=query_params,
                              temp.file=temp_file)

    # Custom function fetch.data used here. The function will convert the POST output to a dataframe (text/jsonlines->json->data.frame). The function also resolves the issues of columns having multiple values in single cells into a single character with values separated by commas using helper function 'bold.multirecords.set'. Helper function 'reassign.data.type' is then used to assign the requisite data types to respective columns.

    json.df=fetch.data(result)

    # Stop if there is no data

    stopifnot("The output generated has no data. Please re-check whether the correct get_by and corresponding identifier argument has been specified." = nrow(json.df) > 0)

    # Else print the output

    cat("\n", green_col, "Download complete & BCDM dataframe generated", reset_col, sep = "")

  }

  # > 5000

  else if (nrow(data.input)>5000)

  {

    ## If the ids input is more than 5000, a batch of 5000 ids is generated using the 'generate.batches' helper function, output of which is used to create the temp_files for POST.

    # Declare batch size

    generate.batch.ids = generate.batches(data = data.input,
                                          batch.size = 5000)


    # generate the temp_file/s

    temp_file = lapply(generate.batch.ids,
                       id.files)


    # Obtain the POST result. Here lapply is used with the post.api.res.fetch to generate the output (BOLD data) based on the 5000 processids. A custom message is printed on the console displaying the status of download.

    # Defining the colors for printing download updates on the console

    cat(green_col,"Initiating download in batches",reset_col,'\n',sep='')

    result <- lapply(seq_along(temp_file), function(f) {

      # file index

      file <- temp_file[[f]]

      # Print the index and total number of files using sprintf

      #a

      download_message<-sprintf("Downloading batch: %d of %d", f, length(temp_file))

      #b
      cat(red_col,download_message,reset_col,'\r')

      # Download data (list of data frames)

      post_res=post.api.res.fetch(
        base.url = base_url,
        query.params = query_params,
        temp.file = file)

      result_df=fetch.data(post_res)

    })

    cat("\n", green_col, "Batch download complete", reset_col, sep = "")

    # Generating the final data frame
    cat("\n", red_col,"Generating the combined BCDM dataframe",reset_col,"\n",sep="")

    json.df=result%>%
      dplyr::bind_rows(.)

    # Stop if there is no data
    stopifnot("The output generated has no data. Please re-check whether the correct get_by and corresponding identifier argument has been specified." = nrow(json.df) > 0)

    cat(green_col,"BCDM dataframe generated",reset_col,"\n",sep="")
  }

  return(json.df)

}
