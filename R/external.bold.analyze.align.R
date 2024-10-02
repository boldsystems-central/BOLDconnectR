#' Transform and align the sequence data retrieved from BOLD
#' @description
#' Function designed to transform and align the sequence data retrieved from the function `bold.fetch`.
#'
#' @param bold_df A data frame obtained from [bold.fetch()].
#' @param marker A single or multiple character vector specifying the gene marker for which the output is generated. Default is NULL (all data is used).
#' @param align_method Character vector specifying the type of multiple sequence alignment algorithm to be used.
#' @param cols_for_seq_names A single or multiple character vector specifying the column headers to be used to name each sequence in the fasta file. Default is NULL in which case, only the processid is used as a name.
#' @param ... additional arguments that can be passed to `msa::msa()` function.
#'
#' @details
#' `bold.analyze.align` retrieves the sequence information obtained using `bold.fetch` function and performs a multiple sequence alignment. It utilizes the `msa::msa()` function with default settings. Type of clustering method can be specified using the `align_method` argument (`Muscle`, `ClustalW` and `ClustalOmega` are available using the `msa` package). Additional arguments from the `msa` function can be passed via the `...` argument (arguments like `gapOpening`, `gapExtension`, `maxiters`, `substitutionMatrix`,`type`). Marker name provided must match with the standard marker names (Ex. COI-5P) available on the \href{https://boldsystems.org/}{BOLD webpage} (Ratnasingham et al. 2024; pg.404). Name for individual sequences in the output can be customized by using the `cols_for_seq_names` argument. If more than one field is specified, the name will follow the sequence of the fields given in the vector. Performing a multiple sequence alignment on large sequence data might slow the system. Additionally, users are responsible for verifying the sequence quality and integrity, as the function does not provide any checks on issues like STOP codons and indels within the data by default. The output of this function is a modified Barcode Core Data Model (BCDM) dataframe, which includes two additional columns: one for the aligned sequences and another for the names given to the sequences.
#'
#' \emph{Note: }. Users are required to install and load the `Biostrings` and `msa` packages using `BiocManager` before running this function.
#'
#' @returns
#' * bold_df.mod = A modified BCDM data frame with two additional columns (’aligned_seq’ and ’msa.seq.name’).
#'
#' @references
#' Ratnasingham S, Wei C, Chan D, Agda J, Agda J, Ballesteros-Mejia L, Ait Boutou H, El Bastami Z M, Ma E, Manjunath R, Rea D, Ho C, Telfer A, McKeowan J, Rahulan M, Steinke C, Dorsheimer J, Milton M, Hebert PDN . "BOLD v4: A Centralized Bioinformatics Platform for DNA-Based Biodiversity Data." In DNA Barcoding: Methods and Protocols, pp. 403-441. Chapter 26. New York, NY: Springer US, 2024.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Search for ids
#' seq.data.ids <- bold.public.search(taxonomy = c("Oreochromis tanganicae",
#'                                                 "Oreochromis karongae"))
#' # Fetch the data using the ids
#' #1. api_key must be obtained from BOLD support before usage
#' #2. The function `bold.apikey` should be used to set the apikey
#' bold.apikey('apikey')
#'
#' seq.data<-bold.fetch(get_by = "processid",
#'                      identifiers = seq.data.ids$processid)
#'
#' # R packages `msa` and `Biostrings` are required for this function to run.
#' # Both the packages are installed using `BiocManager`.
#'
#' # Align the data (using  bin_uri as the name for each sequence)
#' seq.align <- bold.analyze.align(seq.data,
#'                                 cols_for_seq_names = c("bin_uri"),
#'                                 align_method="ClustalOmega")
#'
#' # Dataframe of the sequences (aligned) with their corresponding names
#' head(seq.align[,c("aligned_seq","msa.seq.name")])
#'  }
#'
bold.analyze.align<-function (bold_df,
                              marker=NULL,
                              align_method,
                              cols_for_seq_names=NULL,
                      ...)

{


  # Check if data is a non empty data frame object

  if(any(is.data.frame(bold_df)==FALSE, nrow(bold_df)==0)) stop("Please re-check data input. Input needs to be a non-empty BCDM data frame")

  # Check if the necessary columns are present in the dataframe for further analysis

  check_and_return_preset_df(df=bold_df,
                             category = "check",
                             preset = 'bold_analyze_align_fields')

  # Data for sequences to be pulled from the bold data frame

  seq.data=bold_df%>%
    dplyr::select(matches("^processid$",ignore.case=TRUE),
                  matches("^marker_code$",ignore.case=TRUE),
                  matches("^nuc$",ignore.case=TRUE),
                  all_of(cols_for_seq_names))%>%
    dplyr::filter(!is.na(nuc))%>%
    dplyr::filter(!is.null(nuc))%>%
    dplyr::mutate(nuc=gsub("-","",nuc))%>%
    dplyr::filter(nuc!="")

  # If marker is specified

  if(!is.null(marker))

  {

    # Check if marker code is available in the dataset

    if(any(!(marker %in% bold_df[['marker_code']]))) stop("Marker is not available in the dataset.Please re-check the marker code")

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

 if(nrow(obtain.data)==0) stop("The result obtained does not have any data")

# if specific columns are provided for sequence names

  if(!is.null(cols_for_seq_names))

  {

    obtain.seq.from.data=seq.data%>%
      dplyr::rowwise()%>%
      dplyr::mutate(across(all_of(cols_for_seq_names),
                           as.character))%>%
      dplyr::select(nuc,
                    processid,
                    all_of(cols_for_seq_names))%>%
      dplyr::mutate(msa.seq.name.pre=paste0(paste(as.character(c_across(all_of(cols_for_seq_names))),
                                                  collapse = "|")))%>%
      dplyr::mutate(msa.seq.name=paste0(processid,
                                        "_",
                                        msa.seq.name.pre,
                                        sep="|"))%>%
      dplyr::select(msa.seq.name,
                    nuc,
                    processid)%>%
      dplyr::ungroup()%>%
      data.frame(.)

  }

  else
# just processids are used if no columns are given
  {

    obtain.seq.from.data<-seq.data%>%
      dplyr::select(processid,nuc)%>%
      dplyr::rename("msa.seq.name"="processid")%>%
      dplyr::mutate(processid=seq.data$processid)
  }


 msa_dna_string_obj=gen.msa.res(df=obtain.seq.from.data,
                                 alignmethod=align_method,
                                 ...)

  # Multiple sequence alignment result joined to the original fetched data

  # #1. DNAStringset object 'msa_dna_string_obj' is converted into a dataframe

  stringset.2.df<-msa_dna_string_obj%>%
    data.frame(.)%>%
    dplyr::rename("aligned_seq"=".")

  # #2. The processid as rownames are converted into a column
  #
  stringset.2.df$msa.seq.name<-names(msa_dna_string_obj)

  # #3. Rownames are deleted
  #
  rownames(stringset.2.df)<-NULL

  #4. This df is joined to the original fetched data

  stringset.2.df.w.pid=stringset.2.df%>%
    dplyr::mutate(processid=sub("_.*","",msa.seq.name))

  bold_df.mod=stringset.2.df.w.pid%>%
    left_join(bold_df,
              join_by(processid))

  # The output is not printed in the console

  invisible(bold_df.mod)

}
