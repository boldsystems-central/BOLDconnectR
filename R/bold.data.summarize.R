#'Generate a summary of the data downloaded from BOLD
#'
#' @description
#' The function is used to obtain a detailed summary of the data obtained by `bold.fetch` function.
#'
#' @param bold.df the data.frame retrieved from the `bold.fetch` function.
#' @param cols A single or multiple character vector specifying the columns for which a data summary is sought. Default value is NULL.
#'
#' @details
#' `bold.data.summarize` provides summaries for each data type available in the downloaded dataset. The function uses the `skimr::skim()` function to generate a list of data frames which are then separated by data type using `skimr::partition()` to facilitate streamlined export. The summary includes counts for NULL values, unique values and the proportion of complete cases. The cols argument allows users to select specific fields for summarization; by default, it is set to NULL, meaning all columns are summarized. Summaries are printed to the console and can also be saved. Please note that if the fields argument from bold.fetch has been used to filter for specific columns,  and only those will be summarized by default. For specific details on the skim output, refers to the `skimr` package documentation.
#'
#' @returns A list of data frames. Each data frame is a data summary of a specific data type.
#'
#' @examples
#' \dontrun{
#' # Download data
#' bold_data.ids <- bold.public.search(taxonomy = "Oreochromis")
#'
#' bold.data <- bold.fetch(bold_data.ids,
#' query.param = "processid",
#' param.index = 1,
#' api_key = apikey)
#'
#' # Generate summary for specific fields (cols)
#' test.data.summary <- bold.data.summarize(bold.data,
#'                                          cols = c("country.ocean", "nuc_basecount", "inst", "elev"))
#'
#' # Character data fields summary
#' test.data.summary$character
#'
#' # Numerical data fields summary
#' test.data.summary$numeric
#'}
#'
#' @importFrom skimr skim
#' @importFrom skimr partition
#' @importFrom skimr skim_with
#' @import dplyr
#'
#' @export
#'
bold.data.summarize<-function(bold.df,
                            cols=NULL) {

  # Check for data structure


    if(is.data.frame(bold.df)==FALSE)

      {

      stop("Input is not a data frame")

      return(FALSE)

    }

    # Check whether the data frame is empty

    if(nrow(bold.df)==0)

      {

      stop("Dataframe is empty")

      return(FALSE)

    }



  # Condition to check if there are NA values in the data and print a message if there are any


  if(any(is.na(bold.df)))

  {

    warning("There are NA values in the dataset which might generate Inf or NA values in the summary")


  }


  # If specific fields are selected for generating summary

  if(!is.null(cols))

  {

    # Verification of column names

    if (any(!cols %in% colnames(bold.df)))

    {

      warning("column names provided do not match with the names in the bold dataframe")

      return(FALSE)

    }

    suppressMessages(skim_with(numeric=list(digits=2)))


    # generate the summary

    summary.bold.df=suppressWarnings(bold.df%>%
      dplyr::select(all_of(cols))%>%
      skimr::skim(.)%>%
      mutate(across(where(is.numeric), ~ round(., 2)))%>%
      skimr::partition(.))

  }

  else

  {

    summary.bold.df=suppressWarnings(bold.df%>%
      skimr::skim(.)%>%
      mutate(across(where(is.numeric), ~ round(., 2)))%>%
      skimr::partition(.))


  }



  # Summary


  Rows=nrow(bold.df)

  Columns=ncol(bold.df)

  message<-paste("The total number of rows in the dataset is:",Rows,"\nThe total number of columns in the dataset is:",Columns)

  cat(message,"\n")


 return(summary.bold.df)

}
