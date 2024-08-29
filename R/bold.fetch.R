#' Retrieve all data from the BOLD database
#'
#' @description
#' Retrieves public and private user data based on different parameters (processid, sampleid, dataset codes & bin_uri) input.
#'
#' @param param.data A file path pointing to either a csv/tsv/txt file with the ids or a data frame where ids are stored.
#' @param query.param The parameter on which the data should be fetched. “processid”, “sampleid”, "bin_uri" or "dataset_codes".
#' @param param.index A number indicating the column index (position) of the `query.params` in the dataset.
#' @param api_key A character string required for authentication and data access.
#' @param filt.taxonomy A single or multiple character vector of taxonomic names at any hierarchical level. Default value is NULL.
#' @param filt.geography A single or multiple character vector specifying any of the country/province/state/region/sector/site names/codes. Default value is NULL.
#' @param filt.latitude A single or a vector of two numbers specifying the latitudinal range in decimal degrees. Values should be separated by a comma. Default value is NULL.
#' @param filt.longitude A single or a vector of two numbers specifying the longitudinal range in decimal degrees. Values should be separated by a comma. Default value is NULL.
#' @param filt.shapefile A file path pointing to a shapefile or name of the shapefile (.shp) imported in the R session. Default value is NULL.
#' @param filt.institutes A single or multiple character vector specifying names of institutes. Default value is NULL.
#' @param filt.identified.by A single or multiple character vector specifying names of people responsible for identifying the organism. Default value is NULL.
#' @param filt.seq.source A single or multiple character vector specifying the data portals from where the (sequence) data was mined. Default value is NULL.
#' @param filt.marker A single or multiple character vector specifying of gene names. Default value is NULL.
#' @param filt.collection.period A single or a vector of two date values specifying the collection period range (start, end). Values should be separated by a comma. Default value is NULL.
#' @param filt.basecount A single or a vector of two numbers specifying range of basepairs number. Val- ues should be separated by a comma. Default value is NULL.
#' @param filt.altitude A single or a vector of two numbers specifying the altitude range in meters. Values should be separated by a comma. Default value is NULL.
#' @param filt.depth A single or a vector of two numbers specifying the depth range. Values should be separated by a comma. Default value is NULL.
#' @param filt.fields A single or multiple character vector specifying columns needed in the final dataframe. Default value is NULL.
#' @param export A logical value specifying whether the output should be exported locally. De- fault value is FALSE.
#' @param file.type A character value specifying the type of file to be exported. Currently ‘.csv’ and ‘.tsv’ options are available.
#' @param file.path A character value specifying the folder path where the file should be saved.
#' @param file.name A character value specifying the name of the exported file.
#'
#' @details `bold.fetch` retrieves both public as well as private user data, where private data refers to data that the user has permission to access. The data is downloaded in the Barcode Core Data Model (BCDM) format. It supports effective download data in bulk using search parameters `query.params` such as ‘processids’, ‘sampleids’, ‘bin_uri’ and ‘dataset codes’. Data input can be either through a path to a flat file with extensions like `.csv/.tsv/.txt` or a R `data.frame` object. The import process assumes that the input data includes a header. Users must specify only one of the `query.params` at a time for retrieval. Multi-parameter searches combining fields like ‘processids’+ ‘sampleids’ + ‘bin_uri’ are not supported, regardless of the parameters available. The `filt.` or filter parameter arguments provide further data sorting by which a specific user defined data can be obtained. Note that any/all `filt.`argument names must be written explicitly to avoid any errors (Ex. `filt.institutes` = ’CBG’ instead of just ’CBG’). Using the `filt.fields` argument allows users to select specific columns for inclusion in the final data frame, though, processids and sampleids, are included by default. If this argument is left as NULL all columns will be downloaded. There is no upper limit to the volume of data that can be retrieved, however, this depends on the user’s internet connection and computer specifications. The `api_key` is a UUID v4 hexadecimal string obtained upon request from BOLD at support@boldsystems.org and is valid for one year, requiring renewal thereafter. The names of the columns in the downloaded data correspond to those specified in bold.fields.info. It is important to correctly match the `query.param` and `param.index` to avoid getting any errors. Note that some values or fields might currently be unavailable but may be accessible future.
#'
#' @examples
#' \dontrun{
#' data(test.data)
#'
#' # key' would the 'api_key' provided to the user
#'
#' #With processids ('processid' param is the first column in the data (param.index=1))
#' res <- bold.fetch(param.data = test.data,
#' query.param = 'processid',
#' param.index = 1,
#' api_key = "key")
#'
#'
#' #With sampleids ('sampleid' param is the second column in the data (param.index=2))
#' res<-bold.fetch(param.data = test.data,
#' query.param = 'sampleid',
#' param.index = 2,
#' api_key = "key")
#'
#' ## Using filters
#'
#' #Geography
#' res <- bold.fetch(param.data = test.data,
#' query.param = 'processid',
#' param.index = 1,
#' api_key = "key",
#' filt.geography = "Churchill")
#'
#' #Sequence length
#' res <- bold.fetch(param.data = test.data,
#' query.param = 'processid',
#' param.index = 1,
#' api_key  =  "key",
#' filt.basecount = c(500,600))
#'
#' #Gene marker & sequence length
#' res<-bold.fetch(param.data = test.data,
#' query.param = 'processid',
#' param.index = 1,
#' api_key  =  "key",
#' filt.marker = "COI-5P",
#' filt.basecount = c(500, 600))
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

bold.fetch<-function(param.data,
                      query.param,
                      param.index,
                      api_key,
                          filt.taxonomy=NULL,
                          filt.geography=NULL,
                          filt.latitude=NULL,
                          filt.longitude=NULL,
                          filt.shapefile=NULL,
                          filt.institutes=NULL,
                          filt.identified.by=NULL,
                          filt.seq.source=NULL,
                          filt.marker=NULL,
                          filt.collection.period=NULL,
                          filt.basecount=NULL,
                          filt.altitude=NULL,
                          filt.depth=NULL,
                          filt.fields=NULL,
                          export=FALSE,
                          file.type=NULL,
                          file.path=NULL,
                          file.name=NULL)

{


  # First If condition to check if the input data is a file path or not (Single character implies a single data path)

  if(is.character(param.data))

  {

    if(length(param.data)==1)

    {

      if(file.exists(param.data))

      {

        if(grepl("\\.csv$", param.data))

        {

          input_data=read.delim(param.data,
                                header = T,
                                sep=",")
        }

        else if (grepl("\\.(txt|tsv)$",param.data))

        {

          input_data=read.delim(param.data,
                                header = T,
                                sep="\t")
        }

        else

        {

          stop("Check input file. File should be one of csv tsv or txt formats")

        }

        # If its not a data path but a single search query or character vector of queries

      }

      else if (length(param.data)>=1)

      {

        input_data=data.frame(col1=param.data)

      }

    }

    else

    {

      stop("Please re-check the input.")

    }


  }

  # If the input is not a data path or a vector but a data frame

  else if (is.data.frame(param.data))

  {

    # Re-assert it as data frame in case packages such as readr are used where it could be imported as a tibble)

    input_data=data.frame(param.data)

  }


  else

  {

    stop("Please re-check the Input")

  }


  # Check whether the data frame is empty

  if(nrow(input_data)==0) {

    stop("Input data is empty")

   }


  # Check the limit of the data

  if (nrow(input_data)>25000) {

    warning(" Input data has more than 25000 rows. Retrieving data might take time")

  }


  # Check param.index is a number

  if(is.numeric(param.index)==FALSE) {

    stop("param index needs to be a number")

    return(FALSE)

  }


  # API key data type check

  if(is.character(api_key)==FALSE) {

    stop("api key should be character")

    return(FALSE)

  }

  ## API key format check

  api_key_format<-"^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$"


  if(grepl(api_key_format,
           api_key)==FALSE) {

    warning("Incorrect api key format. Please re-check the API key")

    return(FALSE)

  }


  # If conditions for each type of fetch parameters. Each function used is a separate function generating the BOLD data output

   #1. Processids

  if (query.param=="processid")

  {

   json.df=fetch.bold.processid(data.input = input_data,
                                          param.index=param.index,
                                          api_key=api_key)

  }

  #2. Sampleids

  else if (query.param=='sampleid')


  {

    json.df=fetch.bold.sampleid(data.input = input_data,
                                 param.index=param.index,
                                 api_key=api_key)
  }

  #3. Dataset codes

  else if (query.param=='dataset_codes')

  {


    json.df = fetch.bold.datasets(data.input = input_data,
                                  param.index = param.index,
                                  api_key = api_key)
  }

  #4. BIN ids

  else if (query.param=='bin_uri')

  {


    json.df = fetch.bold.bins(data.input = input_data,
                                  param.index = param.index,
                                  api_key = api_key)


  }

  else

    {

     stop("Input params can only be either processid, sampleid, datasets or bin_uri")

     return(FALSE)

      }


  if(nrow(json.df)==0)

  {

    stop("Data could not be retrieved. Please re-check the parameters.")

  }


    # a separate filter function is used to filter the retrieved data

    json.df = bold.connectr.filters(bold.df = json.df,
                                          taxon.name=filt.taxonomy,
                                          location.name=filt.geography,
                                          latitude=filt.latitude,
                                          longitude=filt.longitude,
                                          shapefile=filt.shapefile,
                                          institutes=filt.institutes,
                                          identified.by=filt.identified.by,
                                          seq.source=filt.seq.source,
                                          marker=filt.marker,
                                          collection.period=filt.collection.period,
                                          basecount=filt.basecount,
                                          altitude=filt.altitude,
                                          depth=filt.depth)

  # }



  #If the user wants specific fields from the data. By default processid and sampleid will be retained


  if(!is.null(filt.fields))

    {



    json.df=json.df%>%
      dplyr::select(processid,
                    sampleid,
                    all_of(filt.fields))


  }

  # If the resulting data (after filtering) is empty

  if(nrow(json.df)==0)

  {

    stop("The output has no data.It could either be due to wrong range of values or incorrect names. Please re-check the filter/s used")

    return(FALSE)

  }



  # If user wants to export the data

  if (export)

  {

    if(file.type=="csv")

    {

      tryCatch(

        {
          utils::write.table(json.df,
                      paste(file.path,
                            "/",
                            file.name,
                            ".",
                            file.type,
                            sep=""),
                      sep = ",",
                      row.names = FALSE,
                      quote = FALSE)

        },
        error = function(e)

        {

          # Handle the error for the POST request

          message("When export=TRUE, file.path, filename & file.type need to be provided: ", e$message)

          return(NULL)

        }
      )

    }

    else if (file.type=="tsv")

    {

       tryCatch(

         {
        write.table(json.df,
                paste(file.path,
                      "/",
                      file.name,
                      ".",
                      file.type,
                      sep=""),
                sep = "\t",
                row.names = FALSE,
                quote = FALSE)

      },
       error = function(e)

    {

      # Handle the error for the POST request

      message("When export=TRUE, file.path, filename & file.type need to be provided: ", e$message)

      return(NULL)

       }
    )

    }
  }

  # Return the output

  return(json.df)

}
