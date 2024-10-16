#' Retrieve metadata of the BOLD data fields
#'
#' @description Provides information on the field (column) names and their respective data type, all of which are compliant with the Barcode Core Data Model (BCDM), the latest data model of the BOLD database.
#'
#' @param print.output Whether the output should be printed in the console. Default is FALSE.
#'
#' @details The function downloads the latest field (column) meta data (file type and brief description) which is currently available for download from BOLD.print,output = TRUE will print the information in the console.
#'
#' @returns A data frame containing information on all fields (columns).
#'
#' @examples
#'
#' bold.field.data<-bold.fields.info()
#' head(bold.field.data,10)
#'
#' @importFrom dplyr matches
#' @importFrom dplyr case_when
#' @importFrom dplyr select
#' @importFrom dplyr mutate
#' @importFrom data.table fread
#'
#' @export
#'
bold.fields.info<-function (print.output=FALSE) {

  # Saving the original options of the user

  original_timeout = getOption('timeout')

  # Setting new options for the function

  options(timeout=350)

  # Reset the options on exit

  on.exit(original_timeout)

  bold.fields.data= suppressMessages(data.table::fread("https://github.com/DNAdiversity/BCDM/raw/main/field_definitions.tsv",
                                                       sep = '\t',
                                                       quote = "",
                                                       check.names = FALSE,
                                                       verbose = FALSE,
                                                       showProgress = FALSE,
                                                       data.table = FALSE,
                                                       fill=TRUE,
                                                       tmpdir = tempdir()))%>%
    dplyr::select(dplyr::matches("field",ignore.case=TRUE),
                  dplyr::matches("definition",ignore.case=TRUE),
                  dplyr::matches("data_type",ignore.case=TRUE))%>%
    dplyr::mutate(R_field_types=dplyr::case_when(data_type=="string"~"character",
                                                 data_type %in% c("char","array") ~"character",
                                                 data_type=="float"~"numeric",
                                                 data_type=="number"~"numeric",
                                                 data_type=="integer"~"integer",
                                                 data_type=="string:date"~"Date"))%>%
    dplyr::select(-dplyr::matches("data_type",ignore.case=TRUE))%>%
    dplyr::mutate(field=case_when(field=='country/ocean'~'country.ocean',
                                  field=='province/state'~'province.state',
                                  TRUE~field))


  if(print.output==TRUE)

    {

    return(bold.fields.data)

  }

  else

    {
    # This is so that the whole output is not printed in the console

    invisible(bold.fields.data)
      }
}
