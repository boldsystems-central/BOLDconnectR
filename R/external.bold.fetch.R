#' Retrieve all data from the BOLD database
#'
#' @description
#' Retrieves public and private user data based on different parameters (processid, sampleid, dataset or project codes & bin_uri) input.
#'
#' @param get_by The parameter on which the data should be fetched (“processid”, “sampleid”, "bin_uri", "dataset_codes" or "project_codes")
#' @param identifiers A vector (or a data frame column) pointing to the `get_by` parameter specified.
#' @param cols A single or multiple character vector specifying columns needed in the final dataframe. Default value is NULL.
#' @param export A logical value specifying whether file path where the file should be exported locally along with the name of the file. Default value is NULL.
#' @param na.rm A logical value specifying whether NA values should be removed from the BCDM dataframe. Default value is FALSE.
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
#'
#' @details `bold.fetch` retrieves both public as well as private user data, where private data refers to data that the user has permission to access. The data is downloaded in the Barcode Core Data Model (BCDM) format. It supports effective download data in bulk using search parameters `query.params` such as ‘processids’, ‘sampleids’, ‘bin_uri’ and ‘dataset codes’. Data input can be either through a path to a flat file with extensions like `.csv/.tsv/.txt` or a R `data.frame` object. The import process assumes that the input data includes a header. Users must specify only one of the `query.params` at a time for retrieval. Multi-parameter searches combining fields like ‘processids’+ ‘sampleids’ + ‘bin_uri’ are not supported, regardless of the parameters available. The `filt_` or filter parameter arguments provide further data sorting by which a specific user defined data can be obtained. Note that any/all `filt_`argument names must be written explicitly to avoid any errors (Ex. `filt_institutes` = ’CBG’ instead of just ’CBG’). Using the `filt_fields` argument allows users to select specific columns for inclusion in the final data frame, though, processids and sampleids, are included by default. If this argument is left as NULL all columns will be downloaded. There is no upper limit to the volume of data that can be retrieved, however, this depends on the user’s internet connection and computer specifications. The `api_key` is a UUID v4 hexadecimal string obtained upon request from BOLD at support@boldsystems.org and is valid for one year, requiring renewal thereafter. The names of the columns in the downloaded data correspond to those specified in bold.fields.info. It is important to correctly match the `query.param` and `param.index` to avoid getting any errors. Note that some values or fields might currently be unavailable but may be accessible future.
#'
#' @examples
#' \dontrun{
#' #Test data with processids
#' data(test.data)
#'
#' # apikey is loaded in the R environment using `bold.apikey` function
#' # Key(token) should be pasted in the function between single quotes.
#' bold.apikey()
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

           if(!nrow(input_data)>0)
           {
             stop("Please re-check the column name specified in the identifiers.")
           }

             json.df = fetch.bold.id(
             data.input = input_data,
             query_param = get_by)

         },


         "dataset_codes" =,

         "project_codes" =,

         "bin_uris" =

           {
             # Check if the input going in fetch has data

             if(!nrow(input_data)>0)
             {
               stop("Please re-check the column name specified in the identifiers.")
             }

             processids = get.bin.dataset.project.pids(data.input=input_data,
                                                          query_param = get_by)

             json.df = fetch.bold.id(data.input = processids,
                                     query_param = "processid")
           },

         # Default case for invalid input
         stop("Input params can only be processid, sampleid, dataset_codes, project_codes, or bin_uris")
  )

 # a separate filter function is used to filter the retrieved data

  json.df = bold.connectr.filters(bold.df = json.df,
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
    ## add a check here to compare the column names specified with the BCDM fields using bold.fields.info()

    bold_field_data = bold.fields.info(print.output = F)%>%
      dplyr::select(field)

    if(!all(cols %in% bold_field_data$field))
    {
      stop("Names provided in the 'cols' argument must match with the names in the 'field' column that is available using the bold.fields.info function. Column name match currently")
    }

    json.df=json.df%>%
      dplyr::select(all_of(cols))

  }


  if(na.rm)

  {
    json.df = json.df%>%
      tidyr::drop_na(.)
     #dplyr::filter(if_all(everything(),~.!="")) # if empty rows should also be removed
    # print the number of rows removed from the dataset. Add filter to remove empty (not NA) cells
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
