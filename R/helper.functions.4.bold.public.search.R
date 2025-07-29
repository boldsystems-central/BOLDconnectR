#' Helper functions for bold.public.search
#' @keywords internal
#' @importFrom utils download.file
#'
# URLs

base_url_parse<- "https://portal.boldsystems.org/api/query/parse?query="

base_url_preprocess<-'https://portal.boldsystems.org/api/query/preprocessor?query='

base_url_summary<-'https://portal.boldsystems.org/api/summary?query='

base_url_query<-'https://portal.boldsystems.org/api/query?query='


#1.Parse the query

# Remove the commas and substitute it with space

parse_query<-function(query)

{

  trial_query_internal<-gsub(",",
                             " ",
                             query)

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

  get.data_parse=fromJSON(url(full_url_parse))

  return(get.data_parse)

}

#2. Preprocess the query

preprocess_query<-function(parsed_query)
{
  query_preprocess<-gsub(",",
                         "%2C",
                         parsed_query$terms)%>%
    gsub(":","%3A",.)%>%
    gsub(";","%3B",.)%>%
    gsub(' ','%20',.)

  full_url_preprocess<-URLencode(paste0(base_url_preprocess,
                                        query_preprocess,
                                        sep=""))

  # Downloading the preprocess data

  get.data.pre=tryCatch({

    result<-httr::GET(url=full_url_preprocess,
                      add_headers('accept' = 'application/json'))

    stop_for_status(result)

    result
  },
  error = function(e) {
    stop(paste("Download failed.\nDetails:",e$message))
  }
  )

  suppressWarnings(suppressMessages(json_preprocess<-content(get.data.pre,
                                                             "text")))

  json_preprocess_data_final<-fromJSON(json_preprocess)

  json_preprocess_data_final<-fromJSON(json_preprocess)$successful_terms

  json_preprocess_data_final$matched<-gsub(',.*',"",json_preprocess_data_final$matched)

  # A separate column for names is created that will be used to print the query terms

  json_preprocess_data_final=json_preprocess_data_final%>%
    dplyr::mutate(names=gsub("^na:na:",'',.$submitted))

  tryCatch({
    if (any(grepl("ids:", json_preprocess_data_final$matched))) {
      stop("Re-check search queries")
    }
    # Code continues here if no error
  }, error = function(e) {
    stop(e)
  })

  return(json_preprocess_data_final)

}

#3. Count for a) selecting the number of records which have more than 0 counts for each term & b) displaying the total number of specimens data available for download

counts_query<-function (preprocessed_query)
{

  #a. Record counts url (will be separate for each triplet)

  query_preprocess_summ<-gsub(":","%3A",preprocessed_query$matched)%>%
    gsub(";","%3B",.)%>%
    gsub(' ','%20',.)%>%
    gsub('/','%2F',.)

  # Function to GET the number of specimen data for each triplet. It takes the query_preprocess_summ as input

  get_counts<-function (summ_url)
  {

    full_url_preprocess_summ<-paste0(base_url_summary,
                                     summ_url,
                                     "&fields=specimens&reduce_operation=count",
                                     sep="")

    get.data.pre.summ=tryCatch({

      result<-httr::GET(url=full_url_preprocess_summ,
                        add_headers('accept' = 'application/json'))

      stop_for_status(result)

      result
    },
    error = function(e) {
      stop(paste("Download failed.\nDetails:",e$message))
    }
    )

    suppressWarnings(suppressMessages(json_preprocess_summ<-content(get.data.pre.summ,
                                                                    "text")))

    json_preprocess_summ_counts<-fromJSON(json_preprocess_summ)$counts$specimens

    json_preprocess_summ_counts <- if (is.null(json_preprocess_summ_counts)) 0 else json_preprocess_summ_counts

    result=unname(json_preprocess_summ_counts)

    return(result)

  }

  ## There are two aspects of taking the count. 1. Is to get numbers for each query term in each parameters searches so that the ones with zero can be removed (in step 4) and 2. to display the total number of specimen data available for the query search. The reasons for getting 0 specimens data could perhaps be due to data not being available on BOLD at the time of download or due to user misspelling any/all of the query terms. If this step is not implemented the whole query would yield a NULL result even due to a single error (Ex. Panthera leo + India vs Panthera leoss + India; the latter has a misspelled word).

  # Creating an empty result list

  result = list()

  # For use in the filtering in step4

  query_search_counts_values <- sapply(query_preprocess_summ,function(x){get_counts(summ_url = x)})

  query_search_counts_df=preprocessed_query%>%
    dplyr::mutate(observations=query_search_counts_values)

  result[['counts_df']]<-query_search_counts_df

  # For displaying number of specimen records available


  # Check for 0 observations. This is put to check any misspellings or no data availability condition in the multi parameter queries which if not dealt with will return the entire dataset of the correctly spelled/available data query terms. Ex. Panthera leo + India vs Panthera leoss + India; the former will correctly query using 'and' logic while the latter due to a misspelling would retrieve all the data pertaining to India.

  if (any(result$counts_df[["observations"]] == 0, na.rm = TRUE)) return(NULL)

  return(result)

}


# Query terms validation (correct placement of terms)

parameter_validation <- function(df_counts, non_null_args)
{

  df_counts = df_counts$counts_df

  # Prefixes for the arguments used in the function

  expected_prefixes <- c(
    taxonomy = "tax",
    geography = "geo",
    bins = "bin",
    institutes = "inst",
    dataset_codes = "recordsetcode",
    project_codes = "recordsetcode"
  )

  # The first part of the triplet (bin,geo,tax) is extracted. A new column of the extracted string is added to the input

  df_counts$prefix = sub(":.*", "", df_counts$matched)

  # Loop which checks and compares the relevant prefixes and the expected prefixes

  for (query_param in names(non_null_args)) {

    prefix_expected <- expected_prefixes[[query_param]]

    # filter the df_counts by prefix column created above

    relevant_names <- df_counts$names[df_counts$prefix == prefix_expected]

    # Logical condition to check whether the prefixes in data match any of the expected prefixes

    if (!all(non_null_args[[query_param]] %in% relevant_names)) stop("")

    #stopifnot(all(non_null_args[[query_param]] %in% relevant_names))
  }

}


#4. Generate a query id based on the matched terms

generate_query_id<-function (matched_terms)
{
  for_query<-matched_terms$counts_df

  matched_terms_non_zero<-for_query%>%
    dplyr::filter(observations>0)%>%
    dplyr::arrange(desc(observations))

  query_url_part1<-gsub(",",
                        "%2C",
                        paste(matched_terms_non_zero$matched,
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

  get.data.query=tryCatch({

    result<-httr::GET(url=full_query,
                      add_headers('accept' = 'application/json'))

    stop_for_status(result)

    result
  },
  error = function(e) {
    stop(paste("Download failed.\nDetails:",e$message))
  }
  )

    # Extract the data

    suppressWarnings(suppressMessages(json_query<-content(get.data.query,
                                                          "text")))


  # Convert the data into text

  json_query_data<-fromJSON(json_query)


  out = json_query_data$query_id


  #4. Obtain the data based on the query

  url_download_data<-paste("https://portal.boldsystems.org/api/documents/",
                           gsub("=",
                                "%3D",
                                out),
                           "/download?format=tsv",
                           "&fields=processid,marker_code",
                           sep="")

  return(url_download_data)

}


#5. Obtain the data based on the query

obtain_data<-function(download_url)
{

  temp_file <- tempfile()

  suppressWarnings(download_data<-download.file(download_url,
                                                destfile = temp_file,
                                                quiet = TRUE))

  unlink(tempdir())

  # Check to see if there is data downloaded. If no data is available, it will return NULL

  if(file.size(temp_file)==0)return(NULL)


  final_data<-read.delim(temp_file,
                         sep='\t')

  return(final_data)
}



