#' Helper functions for sequence based data
#'
#' @keywords internal
#'
# # These functions are used by
# #1. bold.analyze.align
#
# Function 1: Function to obtain the multiple sequence alignment from the BCDM dataframe
gen.msa.res <- function(df,
                        alignmethod,
                        ...) {
  if (!requireNamespace(c("Biostrings", "msa", "muscle"), quietly = TRUE)) stop("Biostrings, msa and muscle packages are required to generate the output")
  # Obtain the data
  seq.from.data <- df %>%
    dplyr::select(
      nuc,
      msa.seq.name
    ) %>%
    dplyr::pull(nuc) %>%
    split(seq(nrow(df))) %>%
    lapply(function(x) unname(x)) %>%
    base::unlist(.)
  # Giving it names based on names.fields
  names(seq.from.data) <- df$msa.seq.name
  # Create a DNAStringSet object for alignment
  dna.4.align <- Biostrings::DNAStringSet(seq.from.data)
  switch(alignmethod,
    "ClustalOmega" = {
      alignment_seq <- dna.4.align %>%
        msa(.,
          method = "ClustalOmega",
          ...
        )
    },
    "Muscle" = {
      alignment_seq <- muscle::muscle(dna.4.align,
        quiet = T,
        ...
      )
    }
  )
  # Converting the output into a DNAstringset object
  msa_dna_string_obj <- methods::as(
    alignment_seq,
    "DNAMultipleAlignment"
  ) %>%
    Biostrings::DNAStringSet(.)

  return(msa_dna_string_obj)
}
# Function: generate a ape file for unaligned sequence fasta file export
generate_ape_file <- function(data,
                              align_unaligned) {
  data$seq.name <- paste(">", data$seq.name, sep = "")
  seq.data.4.fasta <- paste0(
    data$seq.name,
    "\n",
    data[[align_unaligned]]
  ) %>%
    unlist()
  result <- ape::read.dna(textConnection(seq.data.4.fasta),
    format = "fasta"
  )
  return(result)
}
