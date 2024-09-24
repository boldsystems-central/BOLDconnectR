#' Search publicly available data on the BOLD database
#'
#' @description Retrieves record ids for publicly available data based on taxonomy, geography or ids (dataset codes & bin_uri) search.
#'
#' @param taxonomy A single or multiple character vector specifying the taxonomic names at any hierarchical level. Default value is NULL.
#' @param geography A single or multiple character vector specifying any of the country/province/state/region/sector/site names/codes. Default value is NULL.
#' @param bins A single or multiple character vector specifying the BIN ids. Default value is NULL.
#' @details `bold.public.search` searches publicly available data on BOLD, retrieving associated proccessids and sampleids, which can then be accessed using `bold.fetch`. Search parameters can include one or a combination of taxonomy, geography, bin uri or dataset codes. While there is no limit on the amount of ID data that can be downloaded, complex combinations of the search parameters may exceed the predetermined weburl character length (2048 characters). Searches using a single parameter are not subject to this limit. For multiparameter searches (e.g. taxonomy + geography + bins/datasets; see the example: Taxonomy + Geography + BIN id), it’s crucial that the parameters are logically combined to ensure accurate and non-empty results.
#'
#' @returns A data frame containing all the processids and sampleids related to the query search.
#'
#' @examples
#'
#' # Taxonomy
#' bold.data <- bold.public.search(taxonomy = "Panthera leo")
#'
#' #Result
#' head(bold.data,10)
#'
#' # Taxonomy and Geography
#' bold.data.taxo.geo <- bold.public.search(taxonomy = "Panthera uncia",
#' geography = "India")
#'
#' #Result
#' head(bold.data.taxo.geo,10)
#'
#' # Taxonomy, Geography and BINs
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
                               bins = NULL)

{

  # Arguments list (list used since combination could entail long vectors of any of the 5 arguments in any numbers and combinations)

  args <- list(taxonomy = taxonomy,
               geography = geography,
               bins = bins)

  if (length(args)>1)

  {
    warning("The combination of any of the taxonomy, geography, bins, ids and datasets inputs should be logical otherwise output obtained might either be empty or not correct")
  }

  # Filter out NULL values and get their values

  # Null arguments

  nulls=sapply(args,is.null)

  # Selecting the non null arguments

  non_nulls = args[!nulls]

  # Check if at least one parameter is provided

  if (length(non_nulls) > 1)

  {
    values_args <- list()

    for (arg in names(non_nulls))

    {
      # Fetch value of the argument

      value <- non_nulls[[arg]]

      # Append it in the values_args list

      values_args[[arg]] <- value
    }

    # Convert the list into a character vector

    values_args_vec = unlist (values_args)|>unname()

    trial_query_input<- values_args_vec

    result = fetch.public.data(query = trial_query_input)

  }

  else if (length(non_nulls)==1)

    # If only a single input is provided

  {

    trial_query_input = unlist(non_nulls)|>unname()

    if(length(trial_query_input)<=5)
    {
      result = fetch.public.data(query = trial_query_input)

    }

    else

    {
      # Batch creation

      batch.size=5

      length.data<-seq_len(length(trial_query_input))

      batch.cutoffs=ceiling(length.data/batch.size)

      batch.indexes=split(length.data,
                          batch.cutoffs)|>
        unname()

      generate.batch.ids=lapply(batch.indexes,
                                function(x) trial_query_input[x])

      result.pre.filter = lapply(generate.batch.ids,
                                 function(x) fetch.public.data(x))

      # removing empty results

      result.post.filter = Filter(function(df) nrow(df) > 0,
                                  result.pre.filter)


      # Binding the list of dataframes

      result=result.post.filter%>%
        bind_rows(.)
        # dplyr::select(processid,
        #               sampleid)

    }

  }

  if(nrow(result)==0)

  {
    stop("Data could not be retrieved. Please re-check the parameters.")

  }

  return(result)

}
