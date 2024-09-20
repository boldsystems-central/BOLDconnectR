#' Helper Functions: Retrieve the data using POST API and convert it into a data frame
#' @importFrom httr POST
#'
#' @keywords internal

# Function 1: Retrieve data using the POST API

post.api.res.fetch<-function (base.url,
                              query.params,
                              temp.file)

{


  result <- POST(
    url = base.url,
    query=query.params,
    add_headers(
      'accept' = 'application/json',
      'api-key' = apikey,
      'Content-Type' = 'multipart/form-data'
    ),
    body = list(
      input_file = upload_file(temp.file)
    )
  )


  return(result)

}


# Function 2: Converting the retrieved data into a data frame

fetch.data<-function(result)

  {


 # Json content to dataframe. Has a few steps

  #1. Obtain the JSON strings object from the POST result

  suppressWarnings(suppressMessages(json_content<-httr::content(result,"text")))

  #2. Convert JSON strings to a list

  suppressWarnings(json_data <- lapply(strsplit(json_content, "\n")[[1]], # split the content (here each processid)
                                       function(x) jsonlite::fromJSON(x))) # convert to JSON string and lapply converts that into a list


  # #3. Using the helper function 'bold.multirecords.set.csv' on the edited json data to convert multirecord fields into a single comma separated character

  edited.json.w.multi.entries=bold.multirecords.set.csv(json_data)


  #4. Convert the cleaned list to data.frame. Records have differences in the information that is available and filled for the different fields. This would result in rows having varying number of elements. To ensure a consistency, 'fill' argument has a default TRUE value here so that all such empty cells will be converted to NA's

  suppressWarnings(json.df<-data.table::rbindlist(edited.json.w.multi.entries,
                                      fill=TRUE)%>%
                     data.frame())


  #5. Assign the particular data types to the columns using the helper function

  json.df=reassign.data.type(json.df)


  #6. The above function provides a default long unusable rowname; that is changed to NULL

  rownames(json.df)<-NULL

  return(json.df)

}
