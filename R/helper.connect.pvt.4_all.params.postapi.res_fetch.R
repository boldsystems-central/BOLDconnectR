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

