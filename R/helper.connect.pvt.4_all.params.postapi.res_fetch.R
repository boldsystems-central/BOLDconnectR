#' Helper function to fetch the data using POST API
#' @importFrom httr POST
#' @param base.url base url for POST API
#' @param query.params the query parameters for the POST API
#' @param api.key the API key needed to access the data
#' @param temp.file the tempfile on which data is written for the POST API


post.api.res.fetch<-function (base.url,
                        query.params,
                        api.key,
                        temp.file)

{


  result <- POST(
    url = base.url,
    query=query.params,
    add_headers(
      'accept' = 'application/json',
      'api-key' = api.key,
      'Content-Type' = 'multipart/form-data'
    ),
    body = list(
      input_file = upload_file(temp.file)
    )
  )


return(result)

}

