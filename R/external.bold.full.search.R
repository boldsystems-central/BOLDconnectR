#' Search user based (private) and publicly available data on the BOLD database
#'
#' @description Retrieves record ids accessible to the particular user along with publicly available data based on taxonomy, geography, markers and collection dates
#'
#' @param taxonomy A list of single or multiple character strings specifying the taxonomic names at any hierarchical level. Default value is NULL.
#' @param geography A list of single or multiple character strings any of the country/province/state/region/sector codes. Default value is NULL.
#' @param institutes A list of single or multiple character strings specifying the institute names. Default value is NULL.
#' @param marker A character string specifying the particular marker gene. Default value is NULL.
#' @param marker_min_length A numerical value of the minimum length of the specified marker gene. Default value is NULL.
#' @param marker_max_length A numerical value of the maximum length of the specified marker gene. Default value is NULL.
#' @param collection_start_date A date value specifying the start date of a date range. Default value is NULL.
#' @param collection_end_date A date value specifying the end date of a date range. Default value is NULL.
#' @details `bold.full.search` searches user accessible and publicly available data on BOLD, retrieving proccessid and their respective marker codes. All the BCDM data can then be retrieved using the processids as inputs for the `bold.fetch` function. Search parameters can include one or a combination of taxonomy, geography, institutes, markers, marker lengths and collection dates. Taxonomy, geography and institutes inputs are provided as lists if provided as text values directly (Ex. taxonomy = list("Panthera","Poecilia")). A dataframe column can also be used as an input for these 3 parameters using the '$' operator (e.g., df$column_name). If this is the case (i.e. df$colum_name), `as.list` should be used instead of just `list` (Ex. taxonomy = as.list (df$column_name), geography = as.list(df$column_name)) in order to preserve the query structure for internal operation. The function will return NULL output unless this is adhered to. Marker is given as a character value. Names of the markers can be found on the BOLD webpage. Marker length and collection dates are provided as numeric and character values respectively. Marker lengths without specifying the marker will generate an error but just specifying the marker will provide all the data for that marker available based on the user access. In such a case, the function has a default minimum length of 5 and a maximum length of 2000 base pairs. If one of the two lengths are provided, default value of the other will be used (Example: if marker_min_length is given by the user, the default marker_maximum_length of 2000). Collection dates work in a similar way with a default start date of '2000-01-01' and a end date of '2075-01-01'.The character length of the search query should also be considered as the function wont be able to retrieve records if that exceeds the predetermined web URL character length (2048 characters). There is a hard limit of 1 million record downloads for each search.
#'
#' @returns A data frame containing all the processids and marker codes related to the query search..
#' \emph{Important Note}: `bold.apikey()` should be run prior to running `bold.full.search` to setup the `apikey` which is needed for the latter.
#'
#' @examples
#'
#'\dontrun{
#' #Taxonomy
#' bold.data.tax <- bold.full.search(taxonomy = list("Panthera leo"))
#'
#' #Result
#' head(bold.data.tax,10)
#'
#' #Taxonomy and Geography
#' bold.data.taxo.geo <- bold.full.search(taxonomy = list("Panthera uncia"),
#' geography = list("India"))
#'
#' #Result
#' head(bold.data.taxo.geo,10)
#'
#' #Taxonomy, Geography and marker
#' bold.data.taxo.geo.marker <- bold.full.search(taxonomy = list("Panthera uncia"),
#' geography = list("India"),marker = "COI-5P", marker_min_length=300,marker_max_length=700)
#'
#' #Result
#' bold.data.taxo.geo.marker
#'
#' # Input as a dataframe column
#' df_test<-data.frame(taxon_name=c("Panthera leo","Panthera uncia"),
#' locations = c("India","Sri Lanka"))
#'
#' # Result (correct way)
#' bold.data.taxo.geo.df.col <- bold.full.search(taxonomy = as.list(df_test$taxon_name),
#' geography = as.list(df_test$locations))
#'
#' # Incorrect way
#'
#' bold.data.taxo.geo.df.col <- bold.full.search(taxonomy = list(df_test$taxon_name),
#' geography = list(df_test$locations))
#'
#' }
#'
#' @importFrom stats setNames
#' @importFrom httr GET
#'
#' @export
#'
#'
bold.full.search <- function(taxonomy=NULL,
                             geography=NULL,
                             marker=NULL,
                             marker_min_length=NULL,
                             marker_max_length=NULL,
                             collection_start_date = NULL,
                             collection_end_date = NULL,
                             institutes=NULL) {

  # URLs

  url_step_1 = "https://data.boldsystems.org/api/search/terms"

  url_step_2 = "https://data.boldsystems.org/api/search/records??include_public=true"


  # Colors for printing the progress on the console

  green_col <- "\033[32m"

  red_col<-"\033[31m"

  reset_col <- "\033[0m"


  # Making a list of collection_dates for JSON input

  if(!is.null(collection_start_date) || !is.null(collection_end_date))

  {

    # One of the dates (start or end) are not specified then default of 2000-01-01 for start and 2075-01-01 for end are used. In case the user specifies the values, the defaults are overwritten

    collection_start_date = ifelse(is.null(collection_start_date),as.Date("2000-01-01"),collection_start_date)

    collection_end_date = ifelse(is.null(collection_end_date),as.Date("2075-01-01"),collection_end_date)

    collection_date <-  list(
      min = as.Date(collection_start_date),
      max = as.Date(collection_end_date))
  }

  else

  {

    collection_date<-NULL

  }

  # If the marker is not specified but user inputs min and max length. The function stops

  if (is.null(marker) && (!is.null(marker_min_length) || !is.null(marker_max_length))) stop("marker lengths provided without specifying the marker")

  # If  marker is specified and

  else if(!is.null(marker))

  {

    # Marker is specified but the min and max lengths are not specified then default of 5 and 2000 are used. In case the user specifies the values, the defaults are overwritten

    marker_min_length = ifelse(is.null(marker_min_length),5,marker_min_length)

    marker_max_length = ifelse(is.null(marker_max_length),2000,marker_max_length)

    # the marker list is then compiled in accordance with the JSON requirements of the API

    marker_final =  setNames(list(list(min = marker_min_length,
                                       max = marker_max_length)),
                             marker)

    # The final data list to input

    data_list <- list(
      tax = taxonomy,
      geo = geography,
      marker = marker_final,
      collection_date = collection_date,
      inst = institutes)

  }

  else

  {

    # In case marker is not specified at all


    data_list <- list(
      tax = taxonomy,
      geo = geography,
      collection_date = collection_date,
      inst = institutes)
  }



  # To select all the non null arguments from the data_list. This has been added especially for the other input parameters since marker part is covered above

  null_args=sapply(data_list,
                   is.null)

  # Selecting the non null arguments

  non_null_args = data_list[!null_args]

  # If condition to check if the input arguments is/are list/s

  if (any(!sapply(non_null_args, is.list))) {

    stop("Input data must be a list.")
  }

  # The final list is then used to compile a JSON that is used by the API.

  json_output <- jsonlite::toJSON(non_null_args,
                                  auto_unbox = TRUE,
                                  pretty = TRUE)

  # Creating a temp file (Since the API takes a file as an input)

  temp_file_step1 <- tempfile()

  # writing the JSON data to the temp file

  writeLines(json_output,
             temp_file_step1)

  # STEP1:  This json output will used for the first POST call

  step1 = POST(
    url = url_step_1,
    add_headers(
      'accept' = 'application/json',
      'api-key' = apikey,
      'Content-Type' = 'multipart/form-data'
    ),
    body = list(
      input_file = upload_file(temp_file_step1),
      type = "application/json")
  )

  # Extracting the text from the output

  #1.

  suppressMessages(json_content_step1_text1<-httr::content(step1,"text"))

  #2.

  json_content_step1_text2<-fromJSON(json_content_step1_text1)

  if(any(names(json_content_step1_text2)=="collection_date"))
  {

    # Unbox is used here in order to match the JSON format required for the step2 input (the output has dates in arrays while the input requires  the collection_date to be an object with min and max values)

    json_content_step1_text2$collection_date$min<-jsonlite::unbox(json_content_step1_text2$collection_date$min)

    json_content_step1_text2$collection_date$max<-jsonlite::unbox(json_content_step1_text2$collection_date$max)

    json_content_step1_clean_json<-jsonlite::toJSON(json_content_step1_text2,
                                                    pretty = TRUE)

  }
  else
  {
    json_content_step1_clean_json<-jsonlite::toJSON(json_content_step1_text2,
                                                    pretty = TRUE)
  }

  # Converting the text to JSON for step2

  json_content_step1_clean_json<-jsonlite::toJSON(json_content_step1_text2, pretty = TRUE)

  # Creating a temp file (Since the API takes a file as an input)

  temp_file_step2 <- tempfile()

  # writing the JSON data to the temp file

  writeLines(json_content_step1_clean_json,
             temp_file_step2)


  # STEP2: Uploading the clean JSON to get a search query id

  step2 = POST(
    url = url_step_2,
    add_headers(
      'accept' = 'application/json',
      'api-key' = apikey,
      'Content-Type' = 'multipart/form-data'
    ),
    body = list(
      input_file = upload_file(temp_file_step2),
      type = "application/json")
  )

  # Data API token is generated

  suppressMessages(json_content_step2_text1<-httr::content(step2,"text"))

  json_content_step2_text2<-fromJSON(json_content_step2_text1)

  # If condition added in case the search query combination does not yield any result

  if(any(names(json_content_step2_text2)=="detail")){

    print(cat("\n",json_content_step2_text2$detail,"\n"))

    return(NULL)
  }

  # # The total number of records available based on the search are printed on the console.
  #
  # cat("\nBased on the search query,total number of records available are:",json_content_step2_text2$num_of_accessible,"\n")
  #
  # # Given the number of records, the user is prompted to whether the data download should proceed or not
  #
  # proceed_or_not<-readline(prompt = "Given the number of records, do you want to download the data? (yes/no):")
  #
  # if(tolower(proceed_or_not)!='yes')
  #
  # {
  #
  #   cat("Download aborted.\n")
  #
  #   return(NULL)
  #
  # } else
  #
  # {

    # Initating download print in the console

    cat(red_col,"Downloading ids.",reset_col,'\r')

    # STEP3: The token is used to make a GET call to get list of ids based on the search


    ids_download<-paste('https://data.boldsystems.org/api/sets/retrieve/',
                        json_content_step2_text2$token,
                        "?",
                        "check_exists=false",
                        sep='')

    step3=httr::GET(
      url = ids_download,
      add_headers(
        'accept' = 'application/json',
        'api-key' = apikey))


    suppressMessages(json_content_step3_text1<-httr::content(step3,
                                                             "text"))

    downloaded_ids<-fromJSON(json_content_step3_text1)


    downloaded_ids_clean<-as.character(unname(unlist(downloaded_ids)))

    downloaded_ids_fordf<-gsub('\\..*','',downloaded_ids_clean)

    downloaded_markers_df <- ifelse(grepl('\\.', downloaded_ids_clean),
                                    gsub('.*\\.', '', downloaded_ids_clean),
                                    NA)
    #
    # The id vector will be converted to a dataframe so that bold.fetch.ids can be used here internally. Here the column name 'processid' is hard coded since the output of full search API is always a processid

    input_data=data.frame(processid=downloaded_ids_fordf,
                          marker_code=downloaded_markers_df)

    if(!is.null(input_data)) cat("\n", green_col, "Download complete.\n", reset_col, sep = "")


  #}

  invisible(input_data)

}
