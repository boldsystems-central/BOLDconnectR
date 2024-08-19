#' Helper function to retrieve public data
#' @param query the output of any of the id fetch functions
#' @importFrom dplyr %>%
#' @keywords internal

fetch.public.data<-function (query)

{

  # URLs

  base_url_parse<- "https://portal.boldsystems/api/query/parse?query="

  base_url_preprocess<-'https://portal.boldsystems/api/query/preprocessor?query='

  base_url_query<-'https://portal.boldsystems/api/query?query='

  options(timeout = 1800)

  #1.trial_query parse

  # Remove the commas and substitute it with space

  trial_query_internal<-gsub(",",
                             " ",
                             query)


  # Add double quotes around each element and substitute necessary web url encoding for the spaces and quotes

  trial_query_quoted <-gsub(",",
                            " ",
                            trial_query_internal)%>%
    paste0('"',
           .,
           '"')%>%
    paste(.,
          collapse = " ")%>%
    gsub('"',
         '%22',
         .)%>%
    gsub(' ',
         '%20',
         .)

  # Full url parse

  full_url_parse <- URLencode(paste0(base_url_parse,
                                     trial_query_quoted,sep=""))

  # Get the data

  get.data_parse=fromJSON(url(full_url_parse))



  #2. Preprocess


  query_preprocess<-gsub(",",
                         "%2C",
                         get.data_parse$terms)%>%
    gsub(":","%3A",.)%>%
    gsub(";","%3B",.)%>%
    gsub(' ','%20',.)

  full_url_preprocess<-URLencode(paste0(base_url_preprocess,
                                        query_preprocess,
                                        sep=""))
  # Downloading the data

  get.data.pre=httr::GET(url=full_url_preprocess,
                         add_headers('accept' = 'application/json'))



  if (get.data.pre$status_code==422)

    stop ("Query limit exceeded. Please reduce the number of search terms")

  # Extracting the content as jsonlines

  suppressWarnings(suppressMessages(json_preprocess<-content(get.data.pre,
                                                             "text")))


  json_preprocess_data<-lapply(strsplit(json_preprocess,
                                        "\n")[[1]], # split the content (here each process or sample id)
                               function(x) fromJSON(x))



  json_preprocess_data_final<-json_preprocess_data[[1]]$successful_terms

  # Here only the first hit of the matched column is selected so that the search query can accommodate more names,ids

  json_preprocess_data_final$matched<-gsub(',.*',"",json_preprocess_data_final$matched)


  #3. query generation

  query_url_part1<-gsub(",",
                        "%2C",
                        paste(json_preprocess_data_final$matched,
                              collapse = ";"))%>%
    gsub(";","%3B",.)%>%
    gsub(":","%3A",.)%>%
    gsub(" ","%20",.)%>%
    gsub('/','%2F',.)



  full_query<-paste0(base_url_query,
                     query_url_part1,
                     "&extent=full",
                     sep="")

  # Download the data

  get.data.query=httr::GET(url=full_query,
                           add_headers('accept' = 'application/json'))


  if (get.data.query$status_code==422)

    stop ("Query limit exceeded. Please reduce the number of search terms")

  # Convert the data into text

  suppressWarnings(suppressMessages(json_query<-content(get.data.query,
                                                        "text")))


  # Extract the data

  json_query_data<-lapply(strsplit(json_query,
                                   "\n")[[1]], # split the content (here each process or sample id)
                          function(x) fromJSON(x))



  #4. Obtain the data based on the query

  url_download_data<-paste("https://portal.boldsystems/api/documents/",
                           gsub("=",
                                "%3D",
                                json_query_data[[1]][1]),
                           "/download?format=tsv",
                           sep="")


  suppressWarnings(final_data<-data.table::fread(url_download_data,
                                                 sep = '\t',
                                                 quote = "",
                                                 data.table = FALSE,
                                                 showProgress = F)%>%
                     data.frame())



  # Some of the column data types are reassigned


  final_data=reassign.data.type(final_data)

  final_data$bin_created_date<-as.Date(final_data$bin_created_date,format("%Y-%m-%d"))

  final_data$processid_minted_date<-as.Date(final_data$processid_minted_date,format("%Y-%m-%d"))

  final_data$collection_date_start<-as.Date(final_data$collection_date_start,format("%Y-%m-%d"))

  final_data$collection_date_end<-as.Date(final_data$collection_date_end,format("%Y-%m-%d"))

  final_data$collection_time<-as.character(final_data$collection_time)

  # Convert the 'coord' character data into two numeric columns 'lat','lon'

  final_data$coord <- gsub('\\[|\\]','',final_data$coord)

  final_data = suppressWarnings(final_data%>%
                                  tidyr::separate(coord,
                                                  c("lat","lon"),
                                                  sep=",",
                                                  remove = T)%>%
                                  dplyr::mutate(across(c(lat,lon), ~ as.numeric(.x))))


  return(final_data)

}
