#' Search publicly available data on the BOLD database
#'
#' @description Retrieves record ids for publicly available data based on taxonomy, geography, institutes, bin_uris or datasets/project codes search.
#'
#' @param taxonomy A list of single or multiple characters specifying the taxonomic names at any hierarchical level. Default value is NULL.
#' @param geography A list of single or multiple characters specifying any of the country/province/state/region/sector/site names/codes. Default value is NULL.
#' @param institutes A list of single or multiple characters specifying the institutes. Default value is NULL.
#' @param bins A list of single or multiple characters specifying the BIN ids. Default value is NULL.
#' @param dataset_codes A list of single or multiple characters specifying the dataset codes. Default value is NULL.
#' @param project_codes A list of single or multiple characters specifying the project codes. Default value is NULL.
#' @details `bold.public.search` searches publicly available data on BOLD, retrieving associated proccessids and marker codes. All the BCDM data can then be retrieved using the processids as inputs for the `bold.fetch` function. Search parameters can include one or a combination of taxonomy, geography, bin uris, dataset or project codes. Each input should be provided as a separate list (Ex. taxonomy = list("Panthera", "Poecilia"), geography = list("India)). A dataframe column can also be used as an input using the '$' operator (e.g., df$column_name). If this is the case (i.e. df$column_name), `as.list` should be used instead of just `list` (Ex. taxonomy = as.list (df$column_name), geography = as.list(df$column_name)). The character length of a search query should also be considered as the function wont be able to retrieve records if that exceeds the predetermined web URL character length (2048 characters). For multi-parameter searches (e.g. taxonomy + geography + bins; see the example: Taxonomy + Geography + BIN id), it’s important to logically  combine the parameters to ensure accurate and non-empty results. There is a hard limit of 1 million record downloads for each search.
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
#' # Input as a dataframe column
#' df_test<-data.frame(taxon_name=c("Panthera uncia"),
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
                               bins = NULL,
                               institutes = NULL,
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
  #
  if (any(!sapply(non_null_args, is.list))) {

    stop("Input data must be a list.")
  }

  # The query input

  # trial_query_input = unlist(non_null_args)|>unname()

  trial_query_input = unname(unlist(non_null_args))

  ## Multi-parameter query (taxonomy + geography + ids; will follow AND principle)

  if(length(non_null_args)>1)

  {
    cat(red_col,"Downloading ids.",reset_col,'\r')

    # Parsing the query

    step1 = parse_query(trial_query_input)

    step2 = preprocess_query(step1)

    result = tryCatch({

      # Pre-processing the query

      # Adding counts (data points) for each query

      step3 = counts_query(step2)

      # Function checks whether the input query terms entered are in their respective parameter arguments. Example: Costa Rica should be placed in geography and not in taxonomy. If the functions finds such a placement, the code will stop and the final result obtained will be NULL

      parameter_validation(step3,
                           non_null_args)

      # Generate the query id

      step4 = generate_query_id(step3)

      # Download the data using the query id

      obtain_data(step4)

    },

    error = function(e) {

      message("No records found with given criteria")

      return(NULL)
    })

  }

  ## Single parameter query (just taxonomy or geography or codes etc.; will follow OR principle)

  else if (length(non_null_args)==1)
  {
    cat(red_col,"Downloading ids.",reset_col,'\r')

    # To capture the query being too long error (character limit)

    step1 = parse_query(trial_query_input)

    step2 = preprocess_query(step1)

    result = tryCatch(

      {
        step3 = counts_query(step2)

        # Function checks whether the input query terms entered are correctly added in the respective parameter arguments. Example: Costa Rica should be placed in geography and not in taxonomy. If the function finds such a placement, the code will stop and the final result obtained will be NULL.

        parameter_validation(step3,non_null_args)

        # Generate the query id

        step4 = generate_query_id(step3)

        # Download the data using the query id

        obtain_data(step4)

      },

      error = function(e) {

        message("No records found with given criteria")

        return(NULL)

      }
    )

  }

  # Console message only printed when non null result obtained

  if(!is.null(result)) cat("\n", green_col, "Download complete.\n", reset_col, sep = "")

  # Final result

  invisible(result)
}
