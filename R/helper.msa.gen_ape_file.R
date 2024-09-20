#' Helper functions for sequence based data
#'
#' @keywords internal
#'
# Function 1: Function to obtain the multiple sequence alignment from the BCDM dataframe
gen.msa.res<-function(df,
                      alignmethod,
                      ...)

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
    msa(.,
        method = alignmethod,
        ...)

  #4. Converting the output into a DNAstringset object

  msa_dna_string_obj<-methods::as(alignment_seq,
                                  "DNAMultipleAlignment")%>%
    Biostrings::DNAStringSet(.)

  return(msa_dna_string_obj)

}

# Function: generate a ape file for unaligned sequence fasta file export

generate_ape_file<-function(data,
                              align_unaligned)

  {

    data$seq.name=paste(">",data$seq.name,sep="")


    seq.data.4.fasta<-paste0(data$seq.name,
                             "\n",
                             data[[align_unaligned]])%>%
      unlist()


    result = ape::read.dna(textConnection(seq.data.4.fasta),
                           format = "fasta")


    return(result)

  }
