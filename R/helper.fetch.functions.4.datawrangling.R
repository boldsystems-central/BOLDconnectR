#' Helper Functions for fetching data
#' @importFrom tidyr separate
#'
#' @keywords internal
#'
# This function is used by
# #1. bold.fetch
# #2. bold.public.search

#1. Function for creating temp files for POST.

id.files<-function (ids)

{


  step1=paste(unname(unlist(ids)), collapse = ",")

  temp_file <- tempfile()

  writeLines(step1,
             temp_file)

  temp_file


}

# This function is used by
# #1. bold.fetch
# #2. bold.public.search

#2. Function to generate batches

generate.batches<-function (data,
                            batch.size)

{

  # Extract the ids to a single character file to be used for the url used for POST


  #data=data[,1]


  length.data<-seq_len(length(data))


  batch.cutoffs=ceiling(length.data/batch.size)


  batch.indexes=unname(split(length.data,batch.cutoffs))



  generate.batch.ids=lapply(batch.indexes,
                            function(x) data[x])

  return(generate.batch.ids)

}

#3. Function to convert the multi-record fields into a single character.
# These columns in the downloaded data are arrays which are converted into a comma separated value

# This function is used by
# #1. bold.fetch
# #2. bold.public.search

bold.multirecords.set.csv<-function(edited.json)
{

  lapply(edited.json, function(x) {

    columns_to_collapse <- c("bold_recordset_code_arr", "coord", "marker_code",
                             "primers_forward", "primers_reverse")

    for (col in columns_to_collapse) {
      if (!is.null(x[[col]])) {
        x[[col]] <- paste(unlist(x[[col]]), collapse = ",")
      }
    }

    return(x)  # Return the modified x
  })

}


#4.Function to reaasign data type based on R standards function

# This function is used by
# #1. bold.fetch
# #2. bold.public.search

reassign.data.type<-function (x)

{

  bold_field_data = bold.fields.info(print.output = F)%>%
    dplyr::select(field,
                  R_field_types)

  # Selecting out (by column index) the necessary fields of each type of data

  numeric.fields.intersectn=intersect(bold_field_data[bold_field_data$R_field_types=="numeric","field"],names(x))

  integer.fields.intersectn=intersect(bold_field_data[bold_field_data$R_field_types=="integer","field"],names(x))

  date.fields.intersectn=intersect(bold_field_data[bold_field_data$R_field_types=="Date","field"],names(x))

  character.fields.intersectn=intersect(bold_field_data[bold_field_data$R_field_types=="character","field"],names(x))

  # Convert/reaffirm numeric fields

  x[numeric.fields.intersectn]<-lapply(x[numeric.fields.intersectn],function(x) (x=as.numeric(x)))

  # Convert/reaffirm integer fields

  x[integer.fields.intersectn]<-lapply(x[integer.fields.intersectn],function(x) (x=as.integer(x)))

  # Convert/reaffirm Date fields

  x[date.fields.intersectn]<-lapply(x[date.fields.intersectn], function (x) {as.Date(x,"%Y-%m-%d")})

  # Convert/reaffirm character fields

  x[character.fields.intersectn]<-lapply(x[character.fields.intersectn], function(x) (x=as.character(x)))


  # Convert two fields taxid and specimenid to character

  taxid_specimenid_vec<-c("taxid","specimenid")

  for (col in taxid_specimenid_vec) {
    if(!is.null(x[col])) {
      x[[col]]<-as.character(x[[col]])
    }
  }

  return(x)

}

#5. Function to convert the 'coord' column to lat and lon columns

# This function is used by
# #1. bold.fetch
# #2. bold.analyze.map

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

#6. Check if the input data is a dataframe and is non-empty
# This function is used by
# #1. bold.analyze.align
# #2. bold.analyze.tree
# #3. bold.analyze.map
# #4. bold.export
# #5. bold.data.summarize

df_checks<-function(df){

  if(any(is.data.frame(df)==FALSE,nrow(df)==0)) stop("Please re-check data input. Input needs to be a non-empty BCDM data frame")
  }

#7. Check the data type
# This function is used by
# #1. bold.fetch.filters

data_type_check<-function (col,type = c("character","numeric"))
{

  switch(type,

         "character" =
           {
             if(!is.character(col)) stop ("Data type should be character. Please re-check the filter input.")

           },

         "numeric" =
           {

             if(!is.numeric(col)) stop("Data type should be numeric. Please re-check the filter input.")

           }

  )


}
