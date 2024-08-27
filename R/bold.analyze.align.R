#' Transform and align the sequence data retrieved from BOLD (Internal function)
#'
#' @description
#' Function designed to transform and align the data retrieved from the functions `bold.fetch`.
#'
#' @param bold.df A data frame obtained from [bold.fetch()].
#' @param marker A single or multiple character vector specifying the gene marker for which the output is generated. Default is NULL (all data is used).
#' @param seq.name.fields A single or multiple character vector specifying the column headers which to be should be used to name each sequence in the fasta file. Default is NULL in which case, only the processid is used as a name.
#' @param ... additional arguments that can be passed to `msa::msa()` function.
#'
#' @details
#' `bold.analyze.align` retrieves the sequence information obtained using `bold.fetch` function and performs a multiple sequence alignment using ClustalOmega algorithm. It utilizes the msa::msa() function with default settings but additional arguments can be passed via the `...` argument. Marker name provided must match with the standard marker names available on the BOLD webpage. Name for individual sequences in the output can be customized by using the `sequence.name.fields` argument. If more than one field is specified, the name will follow the sequence of the fields given in the vector. Performing a multiple sequence alignment on large sequence data might slow the system. Additionally,users are responsible for verifying the sequence quality and integrity, as the function does not provide any checks on issues like STOP codons and indels within the data. The output of this function is a modified BCDM dataframe having two extra columns, one of the aligned sequence and the other of the name given to that sequence.
#'
#' \emph{Note: } This function is currently an internal function with documentation and can be accessed only by using the `:::` operator  (`BOLDconnectR:::bold.analyze.align`). Users are required to install and load the `Biostrings` and `msa` packages before running this function that are maintained by `Bioconductor`.
#'
#' @returns An 'output' list containing:
#' * bold.df.mod = A modified bold BCDM data frame with two additional columns ('aligned_seq' and 'sequence_name').
#'
#' @importFrom utils install.packages
#'
#' @examples
#' \dontrun{
#'
#' # Search for ids
#' seq.data.ids<-bold.public.search(taxonomy = c("Oreochromis tanganicae","Oreochromis karongae"))
#'
#' # Fetch the data using the ids
#' seq.data<-bold.fetch(param.data = seq.data.ids,query.param = "processid",param.index = 1,api_key = apikey)
#'
#' # Align the data (using species", bin_uri & country.ocean as a composite name for each sequence)
#' seq.align<-BOLDconnectR:::bold.analyze.align(seq.data, seq.name.fields = c("bin_uri"))
#'
#' # Dataframe of the sequences (aligned) with their corresponding names
#'  head(seq.align)
#
#'  }
#'
#'
bold.analyze.align<-function (bold.df,
                      marker=NULL,
                      seq.name.fields=NULL,
                      ...)

{


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


  # # Check if the necessary columns are present in the dataframe for further analysis

  if(any((c("processid","sampleid","nuc", seq.name.fields) %in% names(bold.df)))==FALSE)

  {

    warning("processid,sampleid and nuc have to be present in the dataset. Please re-check data")

    return(FALSE)

  }


  # Data for sequences to be pulled from the bold data frame


  seq.data=bold.df%>%
    dplyr::select(matches("^processid$",ignore.case=TRUE),
                  matches("sampleid",ignore.case=TRUE),
                  matches("^bin_uri$",ignore.case=TRUE),
                  matches("^marker_code$",ignore.case=TRUE),
                  matches("^nuc$",ignore.case=TRUE),
                  all_of(seq.name.fields))%>%
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

  if(!is.null(seq.name.fields))

  {

    obtain.seq.from.data=seq.data%>%
      dplyr::rowwise()%>%
      dplyr::mutate(across(all_of(seq.name.fields),
                           as.character))%>%
      dplyr::select(nuc,
                    processid,
                    all_of(seq.name.fields))%>%
      dplyr::mutate(msa.seq.name.pre=paste0(paste(as.character(c_across(all_of(seq.name.fields))),
                                                  collapse = "|")))%>%
      dplyr::mutate(msa.seq.name=paste0(processid,"_",msa.seq.name.pre,sep="|"))%>%
      dplyr::select(msa.seq.name,nuc)%>%
      dplyr::ungroup()%>%
      data.frame(.)


  }

  else

  {


    obtain.seq.from.data<-seq.data%>%
      dplyr::select(processid,nuc)%>%
      dplyr::rename("msa.seq.name"="processid")

  }


  gen.msa.res<-function(df,...)

  {

    #1. Obtain the data

    seq.from.data<-df%>%
      dplyr::select(nuc,
                    msa.seq.name)%>%
      dplyr::pull(nuc)%>%
      split(seq(nrow(df)))%>%
      lapply(function (x) unname(x))%>%
      base::unlist(.)

    #2. Giving it names based on names.fields

    names(seq.from.data)<-df$msa.seq.name

    #3. Performing a ClustalOmega/Muscle alignment of the sequence

    # A try catch here to check if the users have 'msa' installed or not

    alignment_seq<-DNAStringSet(seq.from.data)%>%
      msa(.,method = "ClustalOmega",...)

    #4. Converting the output into a DNAstringset object

    msa_dna_string_obj<-methods::as(alignment_seq,
                                    "DNAMultipleAlignment")%>%
      Biostrings::DNAStringSet(.)

    return(msa_dna_string_obj)

  }

  msa_dna_string_obj=gen.msa.res(obtain.seq.from.data,...)


  # Multiple sequence alignment result joined to the original fetched data

  # #1. DNAStringset object 'msa_dna_string_obj' is converted into a dataframe

  stringset.2.df<-msa_dna_string_obj%>%
    data.frame(.)%>%
    dplyr::rename("aligned_seq"=".")

  # #2. The processid as rownames are converted into a column
  #
  stringset.2.df$msa.seq.name<-rownames(stringset.2.df)

  # #3. Rownames are deleted
  #
  rownames(stringset.2.df)<-NULL

  #4. This df is joined to the original fetched data

  stringset.2.df.w.pid=stringset.2.df%>%
    dplyr::mutate(processid=sub("_.*","",msa.seq.name))

  bold.df.mod=bold.df%>%
    left_join(stringset.2.df.w.pid,
              join_by(processid))


  # The output is not printed in the console

  invisible(bold.df.mod)

}
