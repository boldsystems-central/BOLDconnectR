########################################################### Helper Function id.files ##############################################



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
