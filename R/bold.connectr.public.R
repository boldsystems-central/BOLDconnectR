#' Fetch publicly available data from the BOLD database
#'
#' @description
#' Retrieves publicly available data based on taxonomy,geography or ids (processid,sampleid, dataset codes & bin_uri) input
#'
#' @param taxonomy A single character string or a vector of taxonomic names at any hierarchical level. Default value is NULL
#' @param geography A single character string or a vector of country/province/state/region/sector/site names/codes. Default value is NULL.
#' @param bins A single character string or a vector of BIN ids. Default value is NULL.
#' @param ids A single character string or a vector of either processids or sampleids. Default value is NULL.
#' @param datasets A single character string or a vector of dataset codes. Default value is NULL.
#' @param latitude A number or a vector of two numbers indicating the latitudinal range. Values separated by a comma. Default value is NULL.
#' @param longitude A number or a vector of two numbers indicating the longitudinal range. Values separated by a comma. Default value is NULL.
#' @param shapefile A file path pointing to a shapefile or name of the shapefile imported in the session. Default value is NULL.
#' @param institutes A character string or a vector specifying names of institutes. Default value is NULL.
#' @param identified.by A character string or a vector specifying names of people responsible for identifying the organism. Default value is NULL.
#' @param seq.source A character string or a vector specifying data portals from where the (sequence) data was mined. Default value is NULL.
#' @param marker A character string or a vector specifying  of gene names. Default value is NULL.
#' @param collection.period A Date or a vector of two values specifying the collection period range (start, end). Values separated by comma. Default value is NULL.
#' @param basecount A number or a vector of two numbers indicating the base pairs number range. Values separated by a comma. Default value is NULL.
#' @param altitude A number or a vector of two numbers indicating the altitude range. Values separated by a comma. Default value is NULL.
#' @param depth A number or a vector of two numbers indicating the depth range. Values separated by a comma. Default value is NULL.
#' @param fields A character string or a vector specifying columns needed in the final dataframe. Default value is NULL.
#' @param export A logical value asking if the output should be exported locally
#' @param file.type A character value specifying the type of file to be exported. Currently ‘.csv’ and ‘.tsv’ options are available
#' @param file.path A character value specifying the folder path where the file should be saved
#' @param file.name A character value specifying the name of the exported file.
#'
#' @details Function to retrieve publicly available data on BOLD. Data can be retrieved by providing either one or a combination of `taxonomy`, `geography`, `bins`, `ids` or `datasets` codes. There is no limit on the data that can be downloaded but complex combinations of the search parameters can lead to weburl character length exceeding the predetermined limit (2048 characters). Downloaded data can then be filtered on either one or a combination of arguments (such as `institutes`, `identifiers`, `altitude`, `depth` etc.). Using the `fields` argument will let the user select any specific columns that need to be in the final data frame instead of the whole data. The default NULL value will result in all data being acquired.Please note that for every request, it could be likely that certain values/fields are not currently available and will be so in the near future.
#'
#' @returns A data frame containing all the information related to the query search
#'
#' @examples
#'
#' # Taxonomy
#' bold.data<-bold.connectr.public(taxonomy = "Panthera leo")
#' head(bold.data,10)#'
#'
#' # Taxonomy and Geography
#' bold.data.taxo_geo<-bold.connectr.public(taxonomy = "Panthera uncia",geography = "India")
#' head(bold.data.taxo_geo,10)
#'
#' # Taxonomy, Geography and BINs
#' bold.data.taxo_geo<-bold.connectr.public(taxonomy = "Panthera uncia",geography = "India",bins=c(""))
#'
#' @importFrom utils URLencode
#'
#' @export
#'
bold.connectr.public <- function(taxonomy = NULL,
                                 geography = NULL,
                                 bins = NULL,
                                 ids = NULL,
                                 datasets = NULL,
                                 latitude=NULL,
                                 longitude=NULL,
                                 shapefile=NULL,
                                 institutes=NULL,
                                 identified.by=NULL,
                                 seq.source=NULL,
                                 marker=NULL,
                                 collection.period=NULL,
                                 basecount=NULL,
                                 altitude=NULL,
                                 depth=NULL,
                                 fields=NULL,
                                 export=NULL,
                                 file.type,
                                 file.path,
                                 file.name)

{

  # Arguments list (list used since combination could entail long vectors of any of the 5 arguments in any numbers and combinations)

  args <- list(taxonomy = taxonomy,
               geography = geography,
               bins = bins,
               ids = ids,
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

  else

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

      result = lapply(generate.batch.ids,
                      function(x) fetch.public.data(x))%>%
        rbindlist(.,fill = TRUE)%>%
        data.frame()


    }

  }



  # For filtering the data

  filter_list<-c(latitude=latitude,
                 longitude=longitude,
                 shapefile=shapefile,
                 institutes=institutes,
                 identified.by=identified.by,
                 seq.source=seq.source,
                 marker=marker,
                 collection.period=collection.period,
                 basecount=basecount,
                 altitude=altitude,
                 depth=depth)

  # Use the filter_list only if the condition is met

  if (length(filter_list)>=1)


  {

    result = bold.connectr.filters(bold.df = result,
                                   latitude=latitude,
                                   longitude=longitude,
                                   shapefile=shapefile,
                                   institutes=institutes,
                                   identified.by=identified.by,
                                   seq.source=seq.source,
                                   marker=marker,
                                   collection.period=collection.period,
                                   basecount=basecount,
                                   altitude=altitude,
                                   depth=depth)

  }



  # Select the necessary fields

  if(!is.null(fields))

  {


    result=result%>%
      dplyr::select(processid,
                    sampleid,
                    all_of(fields))


  }



  # Condition to state if the result is empty

  if(nrow(result)==0)

  {

    stop("Result is an empty dataframe. Please recheck the search queries")

    return(FALSE)

  }


  # If user wants to export the data

  if (!is.null(export))

  {


    write.table(result,
                paste(file.path,
                      "/",
                      file.name,
                      ".",
                      file.type,
                      sep=""),
                row.names = FALSE,
                quote = FALSE)



  }


  return(result)

}
