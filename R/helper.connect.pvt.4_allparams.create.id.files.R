#' Helper Function id.files
#'
#' @param ids Character string which are converted to temp file/s which then are used by the POST function



### Function for creating temp files for POST.

id.files<-function (ids)

  {


  step1=ids|>
    unlist()|>
    unname()|>
    paste(collapse = ",")

  temp_file <- tempfile()

  writeLines(step1,
             temp_file)

  temp_file


}
