#' Retrieve all data from the BOLD database
#'
#' @description
#' Retrieves public and private user data based on different parameters (processid, sampleid, dataset or project codes & bin_uri) input.
#'
#' @param get_by The parameter used to fetch data (“processid”, “sampleid”, "bin_uri", "dataset_codes" or "project_codes")
#' @param identifiers A vector (or a data frame column) pointing to the `get_by` parameter specified.
#' @param filt_taxonomy A single or multiple character vector of taxonomic names at any hierarchical level. Default value is NULL.
#' @param filt_geography A single or multiple character vector specifying any of the country/province/state/region/sector/site names/codes. Default value is NULL.
#' @param filt_latitude A single or a vector of two numbers specifying the latitudinal range in decimal degrees. Values should be separated by a comma. Default value is NULL.
#' @param filt_longitude A single or a vector of two numbers specifying the longitudinal range in decimal degrees. Values should be separated by a comma. Default value is NULL.
#' @param filt_shapefile A file path pointing to a shapefile or name of the shapefile (.shp) imported in the R session. Default value is NULL.
#' @param filt_institutes A single or multiple character vector specifying names of institutes. Default value is NULL.
#' @param filt_identified.by A single or multiple character vector specifying names of people responsible for identifying the organism. Default value is NULL.
#' @param filt_seq_source A single or multiple character vector specifying the data portals from where the (sequence) data was mined. Default value is NULL.
#' @param filt_marker A single or multiple character vector specifying of gene names. Default value is NULL.
#' @param filt_collection_period A single or a vector of two date values specifying the collection period range (start, end). Values should be separated by a comma. Default value is NULL.
#' @param filt_basecount A single or a vector of two numbers specifying range of basepairs number. Val- ues should be separated by a comma. Default value is NULL.
#' @param filt_altitude A single or a vector of two numbers specifying the altitude range in meters. Values should be separated by a comma. Default value is NULL.
#' @param filt_depth A single or a vector of two numbers specifying the depth range. Values should be separated by a comma. Default value is NULL.
#' @param cols A single or multiple character vector specifying columns needed in the final dataframe. Default value is NULL.
#' @param export A character value specifying the data path where the file should be exported locally along with the name of the file. Default value is NULL.
#' @param na.rm A logical value specifying whether NA values should be removed from the BCDM dataframe. Default value is FALSE.
#'
#' @details `bold.fetch` retrieves both public as well as private user data, where private data refers to data that the user has permission to access. The data is downloaded in the Barcode Core Data Model (BCDM) format. It supports effective download data in bulk using search parameters like ‘processids’, ‘sampleids’, ‘bin_uris’, ‘dataset_codes’ and 'project_codes' through the `get_by` argument. Users must specify only one of the parameters at a time for retrieval. Multi-parameter searches combining fields like ‘processids’+ ‘sampleids’ + ‘bin_uri’ are not supported, regardless of the parameters available. Data input is via the `identifier` argument and it can either be a single or multiple character vector containing data for one of the parameters. A dataframe column can be used as an input using the '$' operator (e.g., df$column_name). It is important to correctly match the `get_by` and `identifiers` arguments to avoid getting any errors. The `filt_` or filter parameter arguments provide further data sorting by which a specific user defined data can be obtained. Note that any/all `filt_`argument names must be written explicitly to avoid any errors (Ex. `filt_institutes` = ’CBG’ instead of just ’CBG’). Using the `cols` argument allows users to select specific columns for inclusion in the final data frame. If this argument is left as NULL all columns will be downloaded. Providing a data path for the `export` argument will save the data locally. Data path with the name of the output file should be provided (Ex. 'C:/Users/xyz/Desktop/fetch_data_output'). Data is saved as a tsv file. There is no upper limit to the volume of data that can be retrieved, however, this depends on the user’s internet connection and computer specifications. Downloaded data includes information (wherever available) for the columns given in the `field` column of the `bold.fields.info()`. Metadata on the columns fetched in the downloaded data can also be obtained using `bold.fields.info()`.
#' \emph{Important Note}: `bold.apikey()` should be run prior to running `bold.fetch` to setup the `apikey` which is needed for the latter.
#'
#' @examples
#' \dontrun{
#' #Test data with processids
#' data(test.data)
#'
#' # Fetch the data using the ids.
#' #1. api_key must be obtained from BOLD support before using `bold.fetch` function.
#' #2. Use the `bold.apikey` function  to set the apikey in the global env.
#'
#' bold.apikey('apikey')
#'
#' # With processids
#' res <- bold.fetch(get_by = "processid",
#'                   identifiers = test.data$processid)
#'
#'
#' # With sampleids
#' res<-bold.fetch(get_by = "sampleid",
#'                 identifiers = test.data$sampleid)
#'
#' # With datasets (publicly available dataset provided)
#' res<-bold.fetch(get_by = "dataset_codes",
#'                 identifiers = "DS-IBOLR24")
#'
#' ## Using filters
#'
#' # Geography
#' res <- bold.fetch(get_by = "processid",
#'                   identifiers = test.data$processid,
#'                   filt_geography = "Churchill")
#'
#' # Sequence length
#' res <- bold.fetch(get_by = "processid",
#'                   identifiers = test.data$processid,
#'                   filt_basecount = c(500,600))
#'
#' # Gene marker & sequence length
#' res<-bold.fetch(get_by = "processid",
#'                 identifiers = test.data$processid,
#'                 filt_marker = "COI-5P",
#'                 filt_basecount = c(500, 600))
#'}
#'
#' @returns A data frame containing all the information related to the processids/sampleids and the filters applied (if/any).
#'
#' @importFrom dplyr %>%
#' @importFrom dplyr select
#' @importFrom dplyr filter
#' @importFrom utils read.delim
#' @importFrom httr POST
#' @importFrom dplyr bind_rows
#' @importFrom tidyr all_of
#' @importFrom tidyr  separate
#' @importFrom dplyr if_any
#' @importFrom dplyr between
#' @importFrom sf st_read
#' @importFrom sf st_transform
#' @importFrom sf st_simplify
#' @importFrom tidyr drop_na
#' @importFrom data.table rbindlist
#' @importFrom sf st_drop_geometry
#' @importFrom dplyr ungroup
#' @importFrom dplyr c_across
#' @importFrom dplyr if_all
#' @importFrom dplyr across
#' @importFrom sf st_transform
#' @importFrom httr upload_file
#' @importFrom httr add_headers
#' @importFrom dplyr rowwise
#' @importFrom sf st_crs
#' @importFrom sf st_intersection
#' @importFrom utils write.table
#' @importFrom httr content
#' @importFrom jsonlite fromJSON
#' @importFrom httr http_error
#' @importFrom httr http_status
#' @importFrom tidyr starts_with
#'
#' @export
#'
bold.fetch<-function(get_by,
                       identifiers,
                       cols=NULL,
                       export=NULL,
                       na.rm=FALSE,
                       filt_taxonomy=NULL,
                       filt_geography=NULL,
                       filt_latitude=NULL,
                       filt_longitude=NULL,
                       filt_shapefile=NULL,
                       filt_institutes=NULL,
                       filt_identified.by=NULL,
                       filt_seq_source=NULL,
                       filt_marker=NULL,
                       filt_collection_period=NULL,
                       filt_basecount=NULL,
                       filt_altitude=NULL,
                       filt_depth=NULL)

{

  # Check if the identifier vector is not empty

  stopifnot(nrow(identifiers)>0)

  #Input data

  input_data=data.frame(col1=base::unique(identifiers))

 # renaming the headers as per the get_by argument

  names(input_data)[names(input_data)=="col1"]<-get_by

  # Using switch for get_by to call the appropriate function based on the value of get_by

  switch(get_by,

         "processid" =,

         "sampleid" = {

           # Check if the input going in fetch has data

           if(!nrow(input_data)>0)stop("Please re-check the data provided in the identifiers argument.")

             json.df = fetch.bold.id(
             data.input = input_data,
             query_param = get_by)

          },


         "dataset_codes" =,

         "project_codes" =,

         "bin_uris" =

           {
             # Check if the input going in fetch has data

             if(!nrow(input_data)>0)stop("Please re-check the data provided in the identifiers argument.")

             #1. Processids are retrieved based on the get_by argument using the get.bin.dataset.project.pids helper function
             processids = get.bin.dataset.project.pids(data.input=input_data,
                                                          query_param = get_by)

             #2. BCDM data is then fetched using the processids obtained above using the fetch.bold.id function
             json.df = fetch.bold.id(data.input = processids,
                                     query_param = "processid")

             },

         # Default case for invalid input
         stop("Input params can only be processid, sampleid, dataset_codes, project_codes, or bin_uris.")
  )


  # Select only the core BCDM fields

  json.df = json.df[,intersect(names(json.df),bold.fields.info()$field)]

 # The helper filter function is used to filter the retrieved data

  json.df = bold.fetch.filters(bold.df = json.df,
                                  taxon.name=filt_taxonomy,
                                  location.name=filt_geography,
                                  latitude=filt_latitude,
                                  longitude=filt_longitude,
                                  shapefile=filt_shapefile,
                                  institutes=filt_institutes,
                                  identified.by=filt_identified.by,
                                  seq.source=filt_seq_source,
                                  marker=filt_marker,
                                  collection.period=filt_collection_period,
                                  basecount=filt_basecount,
                                  altitude=filt_altitude,
                                  depth=filt_depth)

  #If the user wants specific fields from the data.

  if(!is.null(cols))

  {

    bold_field_data = bold.fields.info(print.output = F)%>%
      dplyr::select(field)

    if(!all(cols %in% bold_field_data$field)) stop("Names provided in the 'cols' argument must match with the names in the 'field' column that is available using the bold.fields.info function.")

    json.df=json.df%>%
      dplyr::select(all_of(cols))

  }


  if(na.rm)

  {
    json.df = json.df%>%
      tidyr::drop_na(.)

    }

  # If the user wants to export the data
  if (!is.null(export))

  {
    utils::write.table(json.df,
                       paste0(export,".tsv",sep=""),
                       sep = "\t",
                       row.names = FALSE,
                       quote = FALSE)
  }


  return(json.df)

}
