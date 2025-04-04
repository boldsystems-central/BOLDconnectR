#' Search publicly available data on the BOLD database
#'
#' @description Retrieves record ids for publicly available data based on taxonomy, geography, bin_uris or datasets/project codes search.
#'
#' @param taxonomy A list of single or multiple characters specifying the taxonomic names at any hierarchical level. Default value is NULL.
#' @param geography A list of single or multiple characters specifying any of the country/province/state/region/sector/site names/codes. Default value is NULL.
#' @param institutes A list of single or multiple characters specifying the institutes. Default value is NULL.
#' @param bins A list of single or multiple characters specifying the BIN ids. Default value is NULL.
#' @param dataset_codes A list of single or multiple characters specifying the dataset codes. Default value is NULL.
#' @param project_codes A list of single or multiple characters specifying the project codes. Default value is NULL.
#' @details `bold.public.search` searches publicly available data on BOLD, retrieving associated proccessids and marker codes. All the BCDM data can then be retrieved using the processids as inputs for the `bold.fetch` function. Search parameters can include one or a combination of taxonomy, geography, bin uris, dataset or project codes. Each input should be provided as a separate list (Ex. taxonomy = list("Panthera", "Poecilia"), geography = list("India)). A dataframe column can also be used as an input using the '$' operator (e.g., df$column_name). If this is the case (i.e. df$colum_name), `as.list` should be used instead of just `list` (Ex. taxonomy = as.list (df$column_name), geography = as.list(df$column_name)). The character length of a search query should also be considered as the function wont be able to retrieve records if that exceeds the predetermined web URL character length (2048 characters). For multi-parameter searches (e.g. taxonomy + geography + bins; see the example: Taxonomy + Geography + BIN id), it’s important to logically  combine the parameters to ensure accurate and non-empty results. There is a hard limit of 1 million record downloads for each search.
#'
#' @returns A data frame containing all the processids and marker codes related to the query search.
#'
#' @examples
#'
#' #Taxonomy
#' bold.data <- bold.public.search(taxonomy = list("Panthera leo"))
#'
#' #Result
#' head(bold.data,10)
#'
#' #Taxonomy and Geography
#' bold.data.taxo.geo <- bold.public.search(taxonomy = list("Panthera uncia"),
#' geography = list("India"))
#'
#' #Result
#' head(bold.data.taxo.geo,10)
#'
#' #Taxonomy, Geography and BINs
#' bold.data.taxo.geo.bin <- bold.public.search(taxonomy=list("Panthera leo"),
#' geography = list("India"),
#' bins=list("BOLD:AAD6819"))
#'
#' #Result
#' bold.data.taxo.geo.bin
#'
#' # Input as a dataframe column
#' df_test<-data.frame(taxon_name=c("Panthera leo","Panthera uncia"),
#' locations = c("India","Sri Lanka"))
#'
#' # Result
#' bold.data.taxo.geo.df.col <- bold.public.search(taxonomy = as.list(df_test$taxon_name),
#' geography = as.list(df_test$locations))
#'
#'
#' @importFrom utils URLencode
#' @importFrom dplyr %>%
#' @importFrom dplyr distinct
#'
#' @export
#'
bold.public.search <- function(taxonomy = NULL,
                               geography = NULL,
                               institutes = NULL,
                               bins = NULL,
                               dataset_codes=NULL,
                               project_codes=NULL)

{

  # Arguments list (list used since combination could entail long vectors of any of the 5 arguments in any numbers and combinations)

  args <- list(taxonomy = taxonomy,
               geography = geography,
               bins = bins,
               institutes = institutes,
               dataset_codes=dataset_codes,
               project_codes=project_codes)

  # Colors for printing the progress on the console

  green_col <- "\033[32m"

  red_col<-"\033[31m"

  reset_col <- "\033[0m"

  # Filter out NULL values and get their values

  # Null arguments

  null_args=sapply(args,is.null)

  # Selecting the non null arguments

  non_null_args = args[!null_args]

  # If condition to check if the input arguments is/are list/s

  if (any(!sapply(non_null_args, is.list))) {

    stop("Input data must be a list.")
  }


  # The query input

  trial_query_input = unname(unlist(non_null_args))

  # Empty list for the data if downloaded in batches

  downloaded_data<-list()

  # Condition to see whether non null arguments are 1 or more than 1 and what the length of the query based on the arguments is

  if(length(non_null_args)>1||length(non_null_args)==1 && length(trial_query_input)<=5)
  {
    cat(red_col,"Downloading ids.",reset_col,'\r')

    result = suppressWarnings(fetch.public.data(query = trial_query_input))

    cat("\n", green_col, "Download complete.\n", reset_col, sep = "")

  }
  else
  {
    generate.batch.ids = generate.batches(trial_query_input,batch.size = 5)

    cat(red_col,"Downloading ids.",reset_col,'\r')

    # The tryCatch here has been added such that for every loop, if the search terms do not fetch any results, those will return NULL instead of the function entirely stopping and no output generated.

    result.pre.filter = lapply(generate.batch.ids,function(x){
      result <- tryCatch(
        {
          # Download the data
          suppressWarnings(fetch.public.data(x))
        },
        error = function(e) {
          # Error
          # message(paste("Error with", batch, ":", e$message))
          return(NULL)
        }
      )
     # appending the result to the empty list
      downloaded_data[[length(downloaded_data) + 1]] = result
    })

    # Binding the list of dataframes

    result=result.pre.filter%>%
      bind_rows(.)

    cat("\n", green_col, "Download complete.\n", reset_col, sep = "")
  }

  # If the query doesnt return anything due to query terms not existing in the database or the combination of search returning zero

  if(is.null(result)||nrow(result)==0) return(NULL)

  if(nrow(result)>1000000) warning("Data cap of 1 million records has been reached. If there are still more data available on BOLD, please contact BOLD support for obtaining the same OR (if applicable) break the query into subsets and use the function to loop through it.")

  # result = result%>%
  #   dplyr::select(processid,
  #                 sampleid,
  #                 marker_code)%>%
  #   dplyr::filter(sampleid!='')

  invisible(result)

}
