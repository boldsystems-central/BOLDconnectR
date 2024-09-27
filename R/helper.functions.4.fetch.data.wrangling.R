#' Helper Functions for fetching data
#' @importFrom tidyr separate
#'
#' @keywords internal
#'
#1. Function for creating temp files for POST.

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

#2. Function to generate batches

generate.batches<-function (data,
                            batch.size)

{

  # Extract the ids to a single character file to be used for the url used for POST


  data=data[,1]


  length.data<-seq_len(length(data))


  batch.cutoffs=ceiling(length.data/batch.size)


  batch.indexes=split(length.data,
                      batch.cutoffs)|>
    unname()


  generate.batch.ids=lapply(batch.indexes,
                            function(x) data[x])

  return(generate.batch.ids)

}

#3. Function to convert the multi-record fields into a single character.
# These columns in the downloaded data are arrays which are converted into a comma separated value

bold.multirecords.set.csv <- function(edited.json) {

  lapply(edited.json,

         function(x) {


           if (!is.null(x[["bold_recordset_code_arr"]]))

           {

             x[["bold_recordset_code_arr"]] <- paste(unlist(x[["bold_recordset_code_arr"]]),
                                                     collapse = ",")
           }


           if(!is.null(x[["coord"]]))

           {

             x[['coord']]<-paste(unlist(x[["coord"]]),
                                 collapse = ",")
           }

           if(!is.null(x[["marker_code"]]))

           {

             x[['marker_code']]<-paste(unlist(x[["marker_code"]]),
                                       collapse = ",")
           }


           if(!is.null(x[["primers_forward"]]))

           {

             x[["primers_forward"]]<-paste(unlist(x[["primers_forward"]]),
                                           collapse = ",")
           }


           if(!is.null(x[["primers_reverse"]]))

           {

             x[["primers_reverse"]]<-paste(unlist(x[["primers_reverse"]]),
                                           collapse = ",")
           }


           return(x)

         })
}


#4.Function to reaasign data type based on R standards function

reassign.data.type<-function (x)

{

  bold_field_data = bold.fields.info(print.output = F)%>%
    dplyr::select(field,
                  R_field_types)

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

#5. Function to convert the 'coord' column to lat and lon columns

convert_coord_2_lat_lon<-function (df)

{

  if(any(names(df)=='coord'))
  {

    result = df %>%
      tidyr::separate(coord, c("lat", "lon"),
                      sep = ",",
                      remove = FALSE) %>%
      dplyr::mutate(across(c(lat,
                             lon),
                           ~ as.numeric(.x)))

  }
  else
  {
    result = df
  }

  return(result)
}
