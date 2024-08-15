#' Transform and align the sequence data retrieved from BOLD
#'
#' @description
#' Transforms and aligns the data retrieved from the `bold.connectr` and `bold.connectr.public` functions for various downstream analyses
#'
#' @param bold.df A data frame obtained from [bold.connectr()] or [bold.connectr.public()].
#' @param marker A single or multiple character vector specifying the gene marker for which the output is generated. Default is NULL (all data is used).
#' @param name.fields A single or multiple character vector specifying column headers which should be used to name each sequence in the fasta file. Default is NULL in which case, only the BIN id is used as a name.
#' @param file.path A character value specifying the folder path where the file should be saved.Default value is NULL.
#' @param file.name A character value specifying the name of the exported file.Default value is NULL.
#' @param raw.fas A logical input to specify whether a unaligned(raw) ‘fasta’ file should be created. Default value is FALSE.
#'
#' @details
#' ‘align.seq’ fetches the sequence information obtained using the connectr functions and performs a ClustalOmega multiple sequence alignment on it.  This is done using [msa::msa()] function with method = "ClustalOmega" & default settings. In addition, the function also provides a a)  ‘ape’ ‘DNAbin’ object , b) a data frame of the sequence data and the respective names and c) a raw (unaligned.fas) ‘fasta’ file. File path and file name need to be provided for if raw.fas=TRUE. ‘marker’ name provided must match with the standard marker names available in BOLD. Name for individual sequences in the output can be customized by using the names.field argument. If more than one field is specified, the name will follow the sequence of the fields given in the vector. Please note that a multiple sequence alignment on large sequence data might slow the machine.Also note that the function does not detect any STOP codons and indels in the data.
#'
#' @returns A list containing:
#' * ‘Biostrings’ DNAStringSet object of the multiple sequence alignment
#' * ‘ape’: a ‘DNAbin’ object
#' * seq.df: a data frame with sequences as one column and its name in the other (unaligned)
#' * raw.fas = TRUE: a ‘.fas’ file of unaligned sequences
#'
#' @importFrom Biostrings DNAStringSet
#' @importFrom msa msa
#' @importFrom ape read.dna
#' @importFrom ape write.FASTA
#' @importFrom methods as
#'
#' @export
#'
align.seq<-function (bold.df,
                            marker=NULL,
                            name.fields=NULL,
                            file.path=NULL,
                            file.name=NULL,
                            raw.fas=FALSE) {


  # Check if data is a data frame object

  if(is.data.frame(bold.df)==FALSE) {

    stop("Input is not a data frame")

    return(FALSE)

  }

  # Check whether the data frame is empty

  if(nrow(bold.df)==0) {

    stop("Dataframe is empty")

    return(FALSE)

  }


  # Check if the necessary columns are present in the dataframe for further analysis

  if(any((c("processid","sampleid","nuc", "marker_code",name.fields)%in% names(bold.df)))==FALSE)

  {

    warning("processid,sampleid, nuc and the selected columns for names (if/any) have to be present in the dataset. Please re-check data")

    return(FALSE)

  }



  # Processids and sampleids having no genetic data

  na.data=bold.df%>%
    dplyr::filter(is.na(nuc))%>%
    dplyr::filter(is.null(nuc))%>%
    dplyr::filter(is.na(marker_code))%>%
    dplyr::mutate(nuc=gsub("-","",nuc))%>%
    dplyr::filter(nuc=="")%>%
    dplyr::select(matches("^processid$",ignore.case=TRUE),
                  matches("sampleid",ignore.case=TRUE),
                  matches("^nuc$",ignore.case=TRUE),
                  matches("^marker_code$",ignore.case=TRUE))%>%
    dplyr::select(-matches("^nuc$",ignore.case=TRUE))


  ## Data for sequences to be pulled from the bold data frame


  seq.data=bold.df%>%
    dplyr::select(matches("^processid$",ignore.case=TRUE),
                  matches("sampleid",ignore.case=TRUE),
                  matches("^bin_uri$",ignore.case=TRUE),
                  matches("^marker_code$",ignore.case=TRUE),
                  #matches("^nuc_basecount$",ignore.case=TRUE),
                  matches("^nuc$",ignore.case=TRUE),
                  all_of(name.fields))%>%
    dplyr::filter(!is.na(nuc))%>%
    dplyr::filter(!is.null(nuc))%>%
    dplyr::mutate(nuc=gsub("-","",nuc))%>%
    dplyr::filter(nuc!="")


  # If marker is specified


  if(!is.null(marker))

  {

    # Check if marker code is available in the dataset


    if(any(!(marker %in% bold.df[['marker_code']])))

    {

      warning("Marker is not available in the dataset.Please re-check the marker code")

      return(FALSE)

    }


    ## Obtain the specific columns from the data frame

    obtain.data<-seq.data%>%
      dplyr::filter(!is.na(marker_code))%>%
      dplyr::filter(marker_code %in% !!marker)

  }


  else

  {

    obtain.data<-seq.data


  }


  # Check if the result is not empty

  if(nrow(obtain.data)==0) {

    warning("The result obtained does not have any data")

  }


  ## Create a dataframe of sequences and corresponding names using the columns specified for each sequence


  if(!is.null(name.fields))

  {

    obtain.seq.from.data<-obtain.data%>%
      dplyr::rowwise()%>%
      dplyr::mutate(across(all_of(name.fields),
                    as.character))%>%
      dplyr::select(nuc,
                    all_of(name.fields))%>%
      dplyr::mutate(seq.name=paste0(paste(as.character(c_across(all_of(name.fields))),
                                          collapse = "|")))%>%
      dplyr::ungroup()

  }

  else

    # The default naming will only have processids

  {

    obtain.seq.from.data<-obtain.data%>%
      dplyr::select(nuc)%>%
      dplyr::mutate(seq.name=paste(obtain.data[['processid']],
                                   sep=""))
  }


  ## Empty output list to store the results

  output = list()


  # Storing the raw sequence data asa  data frame

  output$seq.df<-obtain.seq.from.data


  # Sequence alignment and export as a fasta file


  #1. Obtain the data

  seq.from.data<-obtain.seq.from.data%>%
    dplyr::select(nuc,
                  seq.name)%>%
    dplyr::pull(nuc)%>%
    split(seq(nrow(obtain.seq.from.data)))%>%
    lapply(function (x) unname(x))%>%
    base::unlist(.)


  #2. Giving it names based on names.fields

  names(seq.from.data)<-obtain.seq.from.data$seq.name

  #3. Performing a ClustalOmega/Muscle alignment of the sequence


  alignment_seq<-Biostrings::DNAStringSet(seq.from.data)%>%
    msa::msa(.,
             method = "ClustalOmega")


  # alignment_seq<-Biostrings::DNAStringSet(seq.from.data)
  #
  #
  # alignment_seq_res<-suppressWarnings(muscle::muscle(alignment_seq,
  #                                                    quiet = TRUE))

  #4. Converting the output into a DNAstringset object

  msa_dna_string_obj<-methods::as(alignment_seq,
                         "DNAMultipleAlignment")%>%
    DNAStringSet(.)



  if(!is.null(file.path))

  {

    if(is.null(file.name))

    {

      warning("output name must be provided")

      return(FALSE)

    }

    #5. Writing the above result to local machine as per the path and name provided

  Biostrings::writeXStringSet(msa_dna_string_obj,
                  filepath=paste(file.path,
                                 "/",
                                 file.name,sep=""),
                  format="fasta")
  }


  # generate an ape object

  generate_ape_file<-function(data)

  {

    data$seq.name=paste(">",data$seq.name,sep="")


    seq.data.4.fasta<-paste0(data$seq.name,
                             "\n",
                             data$nuc)%>%
      unlist()


    result = ape::read.dna(textConnection(seq.data.4.fasta),
                           format = "fasta")


    return(result)

  }


  ape_result = generate_ape_file(data = obtain.seq.from.data)

  # Store the ape object in the output

  output$ape_obj = ape_result

  ## Export the result as a raw fasta file.


  if(raw.fas==TRUE)


  {

    result=generate_ape_file(data = obtain.seq.from.data)


    ape::write.FASTA(result,
                file=paste(file.path,
                           "/",
                           file.name,
                           "_raw",
                           sep=""))

   }


  # Multiple sequence alignment result

  output$msa.result = alignment_seq

  # NA data

  output$no.seq.id.info = na.data

  # The output is not printed in the console

  invisible(output)


}
