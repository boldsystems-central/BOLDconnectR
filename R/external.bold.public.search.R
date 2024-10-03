#' Search publicly available data on the BOLD database
#'
#' @description Retrieves record ids for publicly available data based on taxonomy, geography, bin_uris or datasets/project codes search.
#'
#' @param taxonomy A single or multiple character vector specifying the taxonomic names at any hierarchical level. Default value is NULL.
#' @param geography A single or multiple character vector specifying any of the country/province/state/region/sector/site names/codes. Default value is NULL.
#' @param bins A single or multiple character vector specifying the BIN ids. Default value is NULL.
#' @param dataset_codes A single or multiple character vector specifying the dataset codes. Default value is NULL.
#' @param project_codes A single or multiple character vector specifying the project codes. Default value is NULL.
#' @details `bold.public.search` searches publicly available data on BOLD, retrieving associated proccessids and sampleids, which can then be accessed using `bold.fetch`. Search parameters can include one or a combination of taxonomy, geography, bin uris, dataset or project codes. While there is no limit on the amount of ID data that can be downloaded, complex combinations of the search parameters may exceed the predetermined weburl character length (2048 characters). Searches using a single parameter are not subject to this limit. For multiparameter searches (e.g. taxonomy + geography + bins; see the example: Taxonomy + Geography + BIN id), it’s crucial that the parameters are logically combined to ensure accurate and non-empty results.
#'
#' @returns A data frame containing all the processids and sampleids related to the query search.
#'
#' @examples
#'
#' #Taxonomy
#' bold.data <- bold.public.search(taxonomy = "Panthera leo")
#'
#' #Result
#' head(bold.data,10)
#'
#' #Taxonomy and Geography
#' bold.data.taxo.geo <- bold.public.search(taxonomy = "Panthera uncia",
#' geography = "India")
#'
#' #Result
#' head(bold.data.taxo.geo,10)
#'
#' #Taxonomy, Geography and BINs
#' bold.data.taxo.geo.bin <- bold.public.search("Panthera leo",
#' geography = "India",
#' bins=c("BOLD:AAD6819"))
#'
#' #Result
#' bold.data.taxo.geo.bin
#'
#' @importFrom utils URLencode
#' @importFrom dplyr %>%
#'
#' @export
#'
bold.public.search <- function(taxonomy = NULL,
                               geography = NULL,
                               bins = NULL,
                               dataset_codes=NULL,
                               project_codes=NULL)

{

  # Arguments list (list used since combination could entail long vectors of any of the 5 arguments in any numbers and combinations)

  args <- list(taxonomy = taxonomy,
               geography = geography,
               bins = bins,
               dataset_codes=dataset_codes,
               project_codes=project_codes)

  # Filter out NULL values and get their values

  # Null arguments

  null_args=sapply(args,is.null)

  # Selecting the non null arguments

  non_null_args = args[!null_args]

  # The query input

  trial_query_input = unlist(non_null_args)|>unname()

  # Condition to see whether non null arguments are 1 or more than 1 and what the length of the query based on the arguments is

  if(length(non_null_args)>1||length(non_null_args)==1 && length(trial_query_input)<=5)
  {
    result = fetch.public.data(query = trial_query_input)
  }
  else
  {
    generate.batch.ids = generate.batches(trial_query_input,batch.size = 5)

    result.pre.filter = lapply(generate.batch.ids,
                               function(x) fetch.public.data(x))

    # Binding the list of dataframes

    result=result.pre.filter%>%
      bind_rows(.)
  }

  # if (length(non_null_args) > 1)
  #
  # {
  #   # Convert the list into a character vector
  #
  #   values_args_vec = unlist (non_null_args)|>unname()
  #
  #   trial_query_input<- values_args_vec
  #
  #   result = fetch.public.data(query = trial_query_input)
  #
  # }
  #
  # else if (length(non_null_args)==1)
  #
  #   # If only a single input is provided
  #
  # {
  #
  #   trial_query_input = unlist(non_null_args)|>unname()
  #
  #   if(length(trial_query_input)<=5)
  #   {
  #     result = fetch.public.data(query = trial_query_input)
  #
  #   }
  #
  #   else
  #
  #   {
  #     # Batch creation
  #
  #     generate.batch.ids = generate.batches(trial_query_input,batch.size = 5)
  #
  #     result.pre.filter = lapply(generate.batch.ids,
  #                                function(x) fetch.public.data(x))
  #
  #
  #     # Binding the list of dataframes
  #
  #     result=result.pre.filter%>%
  #       bind_rows(.)
  #     }
  #
  # }

  if(nrow(result)==0) stop("Data could not be retrieved. Please re-check the parameters.")

  if(nrow(result)>1050000) warning("Data cap of 1 million records reached. All records might not have been retrieved. Please rephrase the search")

  result = result%>%
    dplyr::select(processid,
                  sampleid)

  return(result)

}
