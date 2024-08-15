#'Generate a summary of the data retrieved by the connectr functions
#'
#'@description
#'The function is used to obtain a detailed summary of the data obtained by `bold.fetch.data`
#'
#' @param bold.df the data.frame retrieved from the connectr functions
#' @param cols Logical value indicating whether the names of (all) the columns currently available in the database be printed in the console
#'
#' @details
#' ‘data.summary’ provides summaries for each data type available in the fetched dataset. The function uses the [skimr::skim()] function  to generate a list of data frames followed by the [skimr::partition()] which separates the summary based on the data type for easy export. The summary includes counts for NULL, unique values along with proportion of complete cases. The 'columns' argument will select any specific field required. The output is printed on the console and can be saved as well. Please note that if the 'fields' argument from the 'bold.fetch.data' has been used to filter certain columns, summaries of only those columns will be available by default.
#'
#' @returns A list of data frames. Each data frame is a data summary of a specific data type.
#'
#' @examples
#' # Download data
#' bold_data<-bold.connectr.public(taxonomy = "Oreochromis")
#'
#' # Generate summary for specific fields (cols)
#' test.data.summary<-data.summary(bold_data,cols = c("country.ocean","nuc_basecount","inst","elev"))
#'
#' # Character data fields summary
#' test.data.summary$character
#'
#' # Numerical data fields summary
#' test.data.summary$numeric
#'
#' @importFrom skimr skim
#' @importFrom skimr partition
#' @importFrom skimr skim_with
#' @import dplyr
#'
#' @export
#'
data.summary<-function(bold.df,
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
