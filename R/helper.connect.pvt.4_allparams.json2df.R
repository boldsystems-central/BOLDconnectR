#' Helper Function: Fetching the data based on the temp file
#' @param result the output of any of the id fetch functions
#' @keywords internal

fetch.data<-function(result)

  {

  if(is.null(result))

  {

    stop("Please re-check the input parameter")


  }

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


  #5. Assign the particular data types to the columns

  json.df=reassign.data.type(json.df)


  #6. The above function provides a default long unusable rowname; that is changed to NULL

  rownames(json.df)<-NULL

  return(json.df)

}
