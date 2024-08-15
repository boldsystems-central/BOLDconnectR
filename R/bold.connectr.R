#' Retrieve data from the BOLD database
#'
#' @description
#' Retrieves public and private user data based on different ids (processid,sampleid, dataset codes & bin_uri) input.
#'
#' @param input.data A file path pointing to either a CSV/TSV/txt file with the ids or a data frame where ids are stored
#' @param param A character string specifying one of “processid”, “sampleid”, "bin_uri" or "dataset_codes"
#' @param param.index A number indicating the column index of the `params` in the dataset.
#' @param api_key A character string required for authentication and data access.
#' @param taxonomy A single or multiple character vector of taxonomic names at any hierarchical level. Default value is NULL.
#' @param geography A single or multiple character vector of any of country/province/state/region/sector/site names/codes. Default value is NULL.
#' @param latitude A single or a vector of two numbers specifying the latitudinal range. Values should be separated by a comma. Default value is NULL.
#' @param longitude A single or a vector of two numbers specifying the longitudinal range. Values should be separated by a comma. Default value is NULL.
#' @param shapefile A file path pointing to a shapefile or name of the shapefile imported in the R session. Default value is NULL.
#' @param institutes A single or multiple character vector specifying names of institutes. Default value is NULL.
#' @param identified.by A single or multiple character vector specifying names of people responsible for identifying the organism. Default value is NULL.
#' @param seq.source A single or multiple character vector specifying the data portals from where the (sequence) data was mined. Default value is NULL.
#' @param marker A single or multiple character vector specifying  of gene names. Default value is NULL.
#' @param collection.period A single or a vector of two date values specifying the collection period range (start, end). Values should be separated by a comma. Default value is NULL.
#' @param basecount A single or a vector of two numbers specifying range of basepairs number. Values should be separated by a comma. Default value is NULL.
#' @param altitude A single or a vector of two numbers specifying the altitude range. Values should be separated by a comma. Default value is NULL.
#' @param depth A single or a vector of two numbers specifying the depth range. Values should be separated by a comma. Default value is NULL.
#' @param fields A single or multiple character vector specifying columns needed in the final dataframe. Default value is NULL.
#' @param export A logical value specifying whether the output should be exported locally. Default value is FALSE.
#' @param file.type A character value specifying the type of file to be exported. Currently ‘.csv’ and ‘.tsv’ options are available
#' @param file.path A character value specifying the folder path where the file should be saved.
#' @param file.name A character value specifying the name of the exported file.
#'
#' @details This function retrieves both public as well as private user data and can effectively download data in bulk. Currently ‘processids’, ‘sampleids’, ‘bin_uri’ and ‘dataset codes’ are available as search `param`.There is no cap on the upper limit of the data that can be retrieved though, that depends on the net connection and the machine specs. Data input is either as a data path to a flat file having `.csv/.tsv/.txt` extensions or a R `data.frame` object. Import assumes a header present for the input data. The function provides post download (optional) filters on various fields like `taxonomy`, `geography`, `institutions` etc. with the default being NULL for all. Using the `fields` argument will let the user select any specific columns that need to be in the final data frame instead of the whole data though, processids and sampleids will be present in the data by default. The default NULL value of the argument will result in all columns being downloaded. `api_key` is a UUID v4 hexadecimal string obtained by requesting BOLD. The validity of the key will be for one year and would need to be renewed after. Please note that the `param` and `param.index` must be correctly matched to avoid getting any errors.Also, it could be likely that certain values/fields are not currently available and will be so in the near future.
#'
#' @examples
#' \dontrun{
#' data(test.data)
#' #With processids ('processid' param is assumed to be in the first column (param.index=1))
#' res<-bold.connectr(input.data = test.data, param = 'processid',param.index = 1,api_key = "key")
#' head(data,10)
#'
#' #With sampleids (the 'sampleid' param is assumed to be in the second column (param.index=2))
#' res<-bold.connectr(test.data,'sampleid',2,api_key = "key")
#' head(data,10)
#'
#' ## Using filters
#'
#' #Geography
#' res<-bold.connectr(test.data, param = 'processid',param.index = 1,api_key = "key",geography="India")
#'
#' #Sequence length
#' res<-bold.connectr(test.data, 'processid',1,api_key = "key",nuc_basecount=c(500,600))
#'
#' #Gene marker
#' res<-bold.connectr(test.data, 'processid',1,api_key = "key",marker="COI-5P")
#'
#'}
#'
#' @returns A data frame containing all the information related to the processids/sampleids and the filters applied (if/any)
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

bold.connectr<-function(input.data,
                      param,
                      param.index,
                      api_key,
                          taxonomy=NULL,
                          geography=NULL,
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
                          export=FALSE,
                          file.type=NULL,
                          file.path=NULL,
                          file.name=NULL)

{

  # First If condition to check if the input data is a file path or not (Single character implies a single data path)

  if(is.character(input.data))

  {
    # and if that is a data path

    if(file.exists(input.data))

    {

      if (grepl("\\.(csv|txt|tsv)$", input.data))

      {

        if(grepl("\\.csv$", input.data))

        {

          input_data=read.delim(input.data,
                                header = T,
                                sep=",")


        }

        else if (grepl("\\.(txt|tsv)$"))

        {


          input_data=read.delim(input.data,
                                header = T,
                                sep="\t")
        }


      }


      else

      {

        stop("Check input file. File should be one of csv tsv or txt formats")

      }

      # If its not a data path but a single search query

    }

  }

  # If the input is not a data path or a vector but a data frame

  else if (is.data.frame(input.data))

  {

    # Re-assert it as data frame in case packages such as readr are used where it could be imported as a tibble)

    input_data=data.frame(input.data)

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

  if (nrow(input_data)>250000) {

    warning(" Input data has more than 250000 rows. Retrieving data might take time")

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

  if (param=="processid")

  {

   json.df=fetch.bold.processid(data.input = input_data,
                                          param.index=param.index,
                                          api_key=api_key)

  }

  #2. Sampleids

  else if (param=='sampleid')


  {

    json.df=fetch.bold.sampleid(data.input = input_data,
                                 param.index=param.index,
                                 api_key=api_key)
  }

  #3. Dataset codes

  else if (param=='dataset_codes')

  {


    json.df = fetch.bold.datasets(data.input = input_data,
                                  param.index = param.index,
                                  api_key = api_key)
  }

  #4. BIN ids

  else if (param=='bin_uri')

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


    # a separate filter function is used to filter the retrieved data

    json.df = bold.connectr.filters(bold.df = json.df,
                                          taxon.name=taxonomy,
                                          location.name=geography,
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

  # }



  #If the user wants specific fields from the data. By default processid and sampleid will be retained


  if(!is.null(fields))

    {



    json.df=json.df%>%
      dplyr::select(processid,
                    sampleid,
                    all_of(fields))


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
