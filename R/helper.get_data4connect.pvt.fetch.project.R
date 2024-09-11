#' Helper function using GET to get the processids from project codes
#'
#' @param data_for_projects input data containing dataset codes information
#' @param api.key API key required to fetch the data
#' @keywords internal
#'
get_data_projects<-function (data_for_projects,
                             api.key)

{


  # base url

  base_url_project = "https://data.boldsystems.org/api/records/processids?"


  # Obtain the dataset codes as a list of comma separated vector with 'dataset_codes' title

  query_params_project = list('project_codes'= paste(data_for_projects,
                                                     collapse=','))

  # add a condition to check  the number of dataset codes

  get.data=tryCatch(

    {


      httr::GET(url=base_url_project,
                query=query_params_project,
                add_headers('accept' = 'application/json',
                            'api-key' = api.key))

    },

    error = function(e)

    {

      # Handle the error for the POST request

      message("An error occurred during data download: ", e$message)

      return(NULL)


    }

  )

  if (!is.null(get.data) && http_error(get.data))
  {

    message(paste("HTTP error: ", http_status(result)$message,"\n","Error occurred during data download"))

    return(NULL)

  }




  ## Obtain the content as Json strings

  suppressMessages(

    suppressWarnings(

      json_cont_project<-content(get.data,"text")

    )

  )

  # Json strings to text to a list

  json_data_project<- lapply(strsplit(json_cont_project,
                                       "\n")[[1]], # split the content (here each process or sample id)
                              function(x) fromJSON(x)) # convert to JSON string and lapply converts that into a list

  # COnvert the list to a data frame

  input_data2 = json_data_project%>%
    data.frame(.)


  return(input_data2)

}
