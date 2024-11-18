#' Helper function to retrieve public data
#' @param query the output of any of the id fetch functions
#' @importFrom dplyr %>%
#' @importFrom utils download.file
#' @keywords internal
# This function is used by
# #1. bold.public.search
#
fetch.public.data<-function (query)

{

  # URLs

  base_url_parse<- "https://portal.boldsystems.org/api/query/parse?query="

  base_url_preprocess<-'https://portal.boldsystems.org/api/query/preprocessor?query='

  base_url_summary<-'https://portal.boldsystems.org/api/summary?query='

  base_url_query<-'https://portal.boldsystems.org/api/query?query='

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



  if (get.data.pre$status_code==422) stop ("Please reduce the number of search terms.")

  # Extracting the content as jsonlines

  suppressWarnings(suppressMessages(json_preprocess<-content(get.data.pre,
                                                             "text")))

  json_preprocess_data_final<-fromJSON(json_preprocess)$successful_terms

  json_preprocess_data_final$matched<-gsub(',.*',"",json_preprocess_data_final$matched)

  # A separate column for query terms is created that will be used to print the terms for which there is no data available on BOLD. The terms might also be misspelled or old names of the organisms

  json_preprocess_data_final=json_preprocess_data_final%>%
    dplyr::mutate(query_terms=gsub("^na:na:",'',.$submitted))

  #2b. Counts of the records available for every matched query. This is used here to first check how many records for the query term exist. Each term is assessed separately irrespective of the combination of queries used in the search. This is used internally to filter out the terms for which no data is available.

  query_preprocess_summ<-gsub(":","%3A",json_preprocess_data_final$matched)%>%
    gsub(";","%3B",.)%>%
    gsub(' ','%20',.)

  query_search_counts <- sapply(query_preprocess_summ, function (x){

    full_url_preprocess_summ<-paste0(base_url_summary,
                                     x,
                                     "&fields=specimens&reduce_operation=count",
                                     sep="")

    get.data.pre.summ=httr::GET(url=full_url_preprocess_summ,
                                add_headers('accept' = 'application/json'))

    suppressWarnings(suppressMessages(json_preprocess_summ<-content(get.data.pre.summ,
                                                                    "text")))

    json_preprocess_summ_counts<-fromJSON(json_preprocess_summ)$counts$specimens

    json_preprocess_summ_counts <- if (is.null(json_preprocess_summ_counts)) 0 else json_preprocess_summ_counts

    result=unname(json_preprocess_summ_counts)

    result

  })

  # Adding the counts to the data

  json_preprocess_data_final=json_preprocess_data_final%>%
    dplyr::mutate(matched_terms_no=query_search_counts)

  # Filtering the data to keep data having counts 1 or above. A separate variable is created so that the original df can be used for other tasks

  json_preprocess_data_final_sel=json_preprocess_data_final%>%
    dplyr::filter(matched_terms_no>0)

  #3. query generation

  query_url_part1<-gsub(",",
                        "%2C",
                        paste(json_preprocess_data_final_sel$matched,
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

  # if (get.data.query$status_code==422)stop("Download was not successful.Please check the number of query terms and/or availability of the terms on BOLD (Names of taxa, places code numbers etc.).")

  if (get.data.query$status_code==502) stop ("Download request failed. Please try again in a few minutes.")

  # Convert the data into text

  suppressWarnings(suppressMessages(json_query<-content(get.data.query,
                                                        "text")))

  # Extract the data

  json_query_data<-fromJSON(json_query)$query_id

  # If the query id is not generated due to absence of any matched query terms, the output should be NULL implying no record is available currently

  if(is.null(json_query_data)) return(NULL)

  #4. Obtain the data based on the query

  url_download_data<-paste("https://portal.boldsystems.org/api/documents/",
                           gsub("=",
                                "%3D",
                                json_query_data),
                           "/download?format=tsv",
                           sep="")

  original_timeout = getOption('timeout')

  options(timeout=1800)

  on.exit(original_timeout)

  temp_file <- tempfile()

  suppressWarnings(download_data<-download.file(url_download_data,
                               destfile = temp_file,
                               quiet = TRUE))

  # Check to see if there is data downloaded. If no data is available, it will return NULL

  if(file.size(temp_file)==0)return(NULL)

  # if(file.size(temp_file)==0)stop("Please re-check the search terms and their combinations if/any. Data could not be retrieved based on the query terms.")

  final_data<-read.delim(temp_file,
                         sep='\t')

  # Some of the column data types are reassigned

  final_data=reassign.data.type(final_data)

  final_data=final_data[,intersect(names(final_data),bold.fields.info()$field)]

  final_data$collection_date_start<-as.Date(final_data$collection_date_start,format("%Y-%m-%d"))

  final_data$collection_date_end<-as.Date(final_data$collection_date_end,format("%Y-%m-%d"))

  return(final_data)
}
