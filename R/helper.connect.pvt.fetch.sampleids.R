############################################### bold.fetch.data sampleid #################################################

fetch.bold.sampleid<-function(data.input,
                              param.index,
                              api_key) 
  
{
  
  
  if(nrow(data.input)==1)
    
  {
    
    json.df=get_data_sampleid(input_data = data.input,
                              param.index = param.index,
                              api.key = api_key) 
  }
  
  
  query_params <- list('input_type'= "sampleid",
                       'record_sep' = ",",
                       last_updated_threshold=0)
  
  
  
  base_url= "https://data.boldsystems.org/api/records?"
  
  
  
  ## Check to assess the number of requests
  
  # < 5000
  
  if (1 < nrow(data.input) && nrow(data.input) <= 5000)
    
    
  {
    
    # Extract the ids to a single character file to be used for the url used for POST
    
    id_data<-paste(data.input[,param.index],
                   collapse = ",")
    
    # Custom function id.files used here. This will generate the ids as a temp_file required by the body of the POST API
    
    temp_file=id.files(id_data)
    
    
    # The helper function 'post.api.res.fetch' is used to retrieve the data
    
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
  
  # > 5000
  
  else if (nrow(data.input)>5000)
    
  {
    
    ## If the ids input is more than 5000, a batch of 5000 ids is generated and used to create the temp_files for POST. 
    
    # Declare batch size
    
    generate.batch.ids = generate.batches(data = data.input,
                                          param.index = param.index,
                                          batch.size = 5000)
    
    
    # generate the temp_file/s
    
    
    temp_file = lapply(generate.batch.ids,
                       id.files)
    
    
    # Obtain the POST result
    
    result = lapply(temp_file, 
                    function (file) {post.api.res.fetch(base.url=base_url,
                                                        query.params=query_params,
                                                        api.key=api_key,
                                                        temp.file=file)})
    
    if (unlist(result,
               use.names = T)$status_code!=200)
      
    {
      
      stop("Error occurred during data download. Please check the input data, parameter or the api_key")
      
    }
    
    
    # Generating the data frame
    
    
    json.df=lapply(result,
                   fetch.data)%>%
      dplyr::bind_rows(.)
    
  }
  
  
  # Convert the 'coord' character data into two numeric columns 'lat','lon'
  
  
  json.df = json.df%>%
    tidyr::separate(coord,
                    c("lat","lon"),
                    sep=",",
                    remove = T)%>%
    dplyr::mutate(across(c(lat,lon), ~ as.numeric(.x)))
  
  
  # Return the output
  
  return(json.df)
  
}
