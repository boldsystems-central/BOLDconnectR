#' Search publicly available data on the BOLD database
#'
#' @description Retrieves record ids for publicly available data based on taxonomy, geography or ids (dataset codes & bin_uri) search.
#'
#' @param taxonomy A single or multiple character vector specifying the taxonomic names at any hierarchical level. Default value is NULL.
#' @param geography A single or multiple character vector specifying any of the country/province/state/region/sector/site names/codes. Default value is NULL.
#' @param bins A single or multiple character vector specifying the BIN ids. Default value is NULL.
#' @param datasets A single or multiple character vector specifying dataset codes. Default value is NULL.
#' @param filt_latitude A single or a vector of two numbers specifying the latitudinal range in decimal degrees. Values should be separated by a comma. Default value is NULL.
#' @param filt_longitude A single or a vector of two numbers specifying the longitudinal range in decimal degrees. Values should be separated by a comma. Default value is NULL.
#' @param filt_shapefile A file path pointing to a shapefile or name of the shapefile (.shp) imported in the R session. Default value is NULL.
#' @param filt_institutes A single or multiple character vector specifying names of institutes. Default value is NULL.
#' @param filt_identified.by A single or multiple character vector specifying names of people responsible for identifying the organism. Default value is NULL.
#' @param filt_seq.source A single or multiple character vector specifying the data portals from where the (sequence) data was mined. Default value is NULL.
#' @param filt_marker A single or multiple character vector specifying of gene names. Default value is NULL.
#' @param filt_collection.period A single or a vector of two date values specifying the collection period range (start, end). Values should be separated by a comma. Default value is NULL.
#' @param filt_basecount A single or a vector of two numbers specifying range of basepairs number. 	Values should be separated by a comma. Default value is NULL.
#' @param filt_altitude A single or a vector of two numbers specifying the altitude range in meters. Values should be separated by a comma. Default value is NULL.
#' @param filt_depth A single or a vector of two numbers specifying the depth range. Values should be separated by a comma. Default value is NULL.
#'
#' @details `bold.public.search` searches publicly available data on BOLD, retrieving associated proccessids and sampleids, which can then be accessed using `bold.fetch`. Search parameters can include one or a combination of taxonomy, geography, bin uri or dataset codes. While there is no limit on the amount of ID data that can be downloaded, complex combinations of the search parameters may exceed the predetermined weburl character length (2048 characters). Searches using a single parameter are not subject to this limit. For multiparameter searches (e.g. taxonomy + geography + bins/datasets; see the example: Taxonomy + Geography + BIN id), it’s crucial that the parameters are logically combined to ensure accurate and non-empty results. Downloaded IDs can be filtered further on one or a combination of arguments (such as institutes, identifiers, altitude, depth etc.). It is essential to explicitly name the filter arguments (eg. `filt_institutes` = ’CBG’ instead of just ’CBG’) to avoid any errors.
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
                               bins = NULL,
                               datasets = NULL,
                               filt_latitude=NULL,
                               filt_longitude=NULL,
                               filt_shapefile=NULL,
                               filt_institutes=NULL,
                               filt_identified.by=NULL,
                               filt_seq.source=NULL,
                               filt_marker=NULL,
                               filt_collection.period=NULL,
                               filt_basecount=NULL,
                               filt_altitude=NULL,
                               filt_depth=NULL)

{

  # Arguments list (list used since combination could entail long vectors of any of the 5 arguments in any numbers and combinations)

  args <- list(taxonomy = taxonomy,
               geography = geography,
               bins = bins,
               datasets = datasets)

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

      # removing unwanted columns

      result.rem.col=lapply(result.post.filter,
                            function (df)
                              {
                              res=check_and_return_preset_df(df,
                                        category = "check_return",
                                        preset = public.data.fields)
                              return(res)
                              }
                            )

      # Finding out the common columns from all the results

      # common.cols=Reduce(intersect,
      #                    lapply(result.rem.col,
      #                           colnames))

      # Using the above column names vector to select common columns from all dataframes

      # res.comm.col <- lapply(result.rem.col,
      #                        function(df) df[, common.cols, drop = FALSE])


      # Binding the list of dataframes

      result=result.rem.col%>%
        bind_rows(.)

    }

  }

  if(nrow(result)==0)

  {
    stop("Data could not be retrieved. Please re-check the parameters.")

  }

result = bold.connectr.filters(bold.df = result,
                                   latitude=filt_latitude,
                                   longitude=filt_longitude,
                                   shapefile=filt_shapefile,
                                   institutes=filt_institutes,
                                   identified.by=filt_identified.by,
                                   seq.source=filt_seq.source,
                                   marker=filt_marker,
                                   collection.period=filt_collection.period,
                                   basecount=filt_basecount,
                                   altitude=filt_altitude,
                                   depth=filt_depth)

  # Generate only processid and sampleid output

  final.res = result%>%
    dplyr::select(processid,
                  sampleid)

  # Condition to state if the result is empty

  if(nrow(final.res)==0)

  {
    stop("Result is an empty dataframe. Please recheck the search queries")
  }

  return(final.res)

}
