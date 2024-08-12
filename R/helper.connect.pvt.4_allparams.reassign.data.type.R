################################## Helper function reassign.data.type ##############################################


reassign.data.type<-function (x) {
  
  bold_field_data = bold.fields.info(print.output = F)%>%
    dplyr::select(field,R_field_types)
  
  # Selecting out (by column index) the necessary fields of each type of data
  
  numeric.fields.intersectn=intersect(bold_field_data[bold_field_data$R_field_types=="numeric","field"],names(x))
  
  integer.fields.intersectn=intersect(bold_field_data[bold_field_data$R_field_types=="integer","field"],names(x))
  
  date.fields.intersectn=intersect(bold_field_data[bold_field_data$R_field_types=="Date","field"],names(x))
  
  
  # Convert/reaffirm numeric fields   
  
  x[numeric.fields.intersectn]<-lapply(x[numeric.fields.intersectn],function(x) (x=as.numeric(x)))
  
  # Convert/reaffirm integer fields 
  
  x[integer.fields.intersectn]<-lapply(x[integer.fields.intersectn],function(x) (x=as.integer(x)))
  
  # Convert/reaffirm Date fields 
  
  x[date.fields.intersectn]<-lapply(x[date.fields.intersectn], function (x) {as.Date(x,"%Y-%m-%d")})  
  
  return(x)
  
}