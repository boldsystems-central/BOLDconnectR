#' Helper function bold.multirecords.set.csv
#' @param edited.json edited json file obtained after the fetch functions for any of the id types

#. Function to convert the multirecord fields into a single character. These columns in the downloaded data are arrays which are converted into a comma separated value


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
