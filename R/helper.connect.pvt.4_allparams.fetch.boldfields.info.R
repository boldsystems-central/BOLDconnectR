########################################### 1.bold.BCDM.fields ##############################################################


# The function downloads the latest field names and its meta data which is used by the package to match field names and data types


bold.fields.info<-function (print.output=FALSE) {
  
  
  bold.fields.data= suppressMessages(data.table::fread("https://github.com/DNAdiversity/BCDM/raw/main/field_definitions.tsv",
                                                       sep = '\t',
                                                       quote = "",
                                                       verbose = FALSE,
                                                       showProgress = FALSE,
                                                       data.table = FALSE,
                                                       fill=TRUE,
                                                       tmpdir = tempdir()))%>%
    dplyr::select(dplyr::matches("field",ignore.case=TRUE),
                  dplyr::matches("definition",ignore.case=TRUE),
                  dplyr::matches("data_type",ignore.case=TRUE))%>%
    dplyr::mutate(R_field_types=case_when(data_type=="string"~"character",
                                          data_type %in% c("char","array") ~"character",
                                          data_type=="float"~"numeric",
                                          data_type=="number"~"numeric",
                                          data_type=="integer"~"integer",
                                          data_type=="string:date"~"Date"))%>%
    dplyr::select(-dplyr::matches("data_type",ignore.case=TRUE))
  
  
  
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
