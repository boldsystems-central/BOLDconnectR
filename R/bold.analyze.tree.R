#' Analyze and visualize the multiple sequence alignment
#'
#' @description
#' Calculates genetic distances and performs a Neighbor Joining tree estimation of the multiple sequence alignment output obtained from `bold.analyze.align`.
#'
#' @param bold.df A modified BCDM data frame obtained from [bold.analyze.align()].
#' @param dist.model A character string specifying the model to generate the distances.
#' @param clus.method A character vector specifying either [ape::nj()] (neighbour joining) or [ape::njs()] (neighbour joining with NAs) clustering algorithm.
#' @param dist.matrix A logical value specifying whether the distance matrix should be saved in the output. Default is FALSE.
#' @param newick.tree.export A logical value specifying whether newick tree should be generated and ex- ported. Default value is FALSE.
#' @param newick.file.path A character value specifying the folder path where the file should be saved.
#' @param newick.file.name A character value specifying the name of the exported file.
#' @param tree.plot Logical value specifying if a neighbour joining plot should be generated. Default value is FALSE.
#' @param tree.plot.type The layout of the tree. Based on [ape::plot.phylo()] type.
#' @param ... additional arguments from [ape::dist.dna()]
#'
#' @details `bold.analyze.tree` analyzes the multiple sequence alignment output of the `bold.analyze.align` function to generate a distance matrix using the models available in the [ape::dist.dna()]. Setting `dist.matrix`= TRUE will store the underlying distance matrix in the output; however, the  default value for the argument is deliberately kept at FALSE to avoid potential memory issues with large data. Additional arguments for calculating distances can passed using the argument `...`. Setting `tree.plot`= TRUE generates a basic visualization of the Neighbor Joining (NJ) tree using the distance matrix from [ape::dist.dna()] and the [ape::plot.phylo()] function. `tree.plot.type` specifies the type of tree and has the following options ("phylogram", "cladogram", "fan", "unrooted", "radial", "tidy" based on `type` argument of [ape::plot.phylo()];The first alphabet can be used instead of the whole word). Both `ape::nj()` and `ape::njs()` are available for generating the tree. Additionally, the function provides base frequencies and offers an option to export the trees in a Newick format by specifying the name and path for output file.
#'
#' @returns An 'output' list containing:
#' *	dist_mat = A distance matrix based on the model selected if dist.matrix=TRUE.
#' *	base_freq = Overall base frequencies of the align.seq result.
#' *	plot = Neighbor Joining clustering visualization (if tree.plot=TRUE).
#' *	data_for_plot = A phylo object used for the plot.
#' *	NJ/NJS tree in a newick format (only if newick.tree.export=TRUE).

#' @examples
#' \dontrun{
#' library(msa)
#' library(Biostrings)
#'
#' # Download the data ids
#' seq.data.ids <- bold.public.search(taxonomy = c("Eulimnadia"), filt.marker = "COI-5P")
#'
#' # Fetch the data using the ids.
#' # api_key must be obtained from BOLD support before usage.
#'
#' seq.data <- bold.fetch(param.data = seq.data.ids, query.param = "processid",
#'                        param.index = 1, api_key = apikey)
#'
#' # Remove rows without species name information
#' seq <- seq.data[seq.data$species!="", ]
#'
#' # Align the data
#' # Users need to install and load packages `msa` and `Biostrings`.
#' seq.align<-BOLDconnectR:::bold.analyze.align(seq.data,
#'                                              seq.name.fields = c("species","bin_uri"),
#'                                              marker="COI-5P",
#'                                              align.method="ClustalOmega")
#'
#' #Analyze the data to get a tree
#' seq.analysis<-bold.analyze.tree(seq.align,
#'                                 dist.model = "K80",
#'                                 clus="nj",
#'                                 tree.plot.type='p',
#'                                 tree.plot=TRUE,
#'                                 dist.matrix = T)
#'
#' # Output
#' # A ‘phylo’ object of the plot
#' seq.analysis$data_for_plot
#' # A distance matrix based on the distance model selected
#' seq.analysis$dist_matrix
#' # Base frequencies of the sequences
#' seq.analysis$base_freq
#'}
#'
#' @importFrom ape dist.dna
#' @importFrom ape base.freq
#' @importFrom ape nj
#' @importFrom ape njs
#' @importFrom ape write.tree
#' @importFrom ape plot.phylo
#' @importFrom ape as.DNAbin
#'
#' @export
#'
bold.analyze.tree<-function(bold.df,
                            dist.model,
                            clus.method=c("nj",
                                          "njs"),
                            dist.matrix=FALSE,
                            newick.tree.export=FALSE,
                            newick.file.path=NULL,
                            newick.file.name=NULL,
                            tree.plot=FALSE,
                            tree.plot.type,
                            ...)

{


  seq.data=bold.df%>%
    dplyr::select(matches("^processid$",ignore.case=TRUE),
                  matches("sampleid",ignore.case=TRUE),
                  matches("^bin_uri$",ignore.case=TRUE),
                  matches("^marker_code$",ignore.case=TRUE),
                  #matches("^nuc_basecount$",ignore.case=TRUE),
                  matches("^nuc$",ignore.case=TRUE),
                  matches("^aligned_seq",ignore.case=TRUE),
                  matches("^msa.seq.name",ignore.case=TRUE))%>%
    dplyr::filter(!is.na(nuc))%>%
    dplyr::filter(!is.null(nuc))%>%
    dplyr::mutate(nuc=gsub("-","",nuc))%>%
    dplyr::filter(nuc!="")



  # Check if the necessary columns are present in the dataframe for further analysis

  if(any((c("processid","sampleid","nuc", "aligned_seq","msa.seq.name")%in% names(bold.df)))==FALSE)

  {

    warning("processid,sampleid, nuc and msa.seq.name have to be present in the dataset. Please re-check data")

    return(FALSE)

  }


  # Generate a dataframe of the aligned_seq and the seq.name and convert it to a ape DNAbin

  #1. Extract out the necessary columns

  ape_df<-seq.data%>%
    dplyr::select(msa.seq.name,
                  aligned_seq)

  #2. as.DNAbin accepts matrices so the above dataframe is converted into a matrix with each column being one alphabet of the basepair in lower case.

  ape.matrix<-t(sapply(strsplit(ape_df[,2],""), tolower))

  rownames(ape.matrix)<-ape_df$msa.seq.name

  #3. Converting the matrix to a DNAbin object

  ape_dnabin<-as.DNAbin(ape.matrix)

  # Empty output list defined

  output = list()

  # base frequencies (overall) of the aligned sequences

  base_freq = ape::base.freq(ape_dnabin)

  output$base_freq = base_freq

  # The distance object using the model (and other arguments if specified) specified is generated

  dnabin.dist=ape::dist.dna(ape_dnabin,
                            model="K80",
                            ...)

  # Based on the type of clus, clustering is carried out on the dist object

  if (length(clus.method)!=1)

  {

    stop("clus.method argument empty. Please select either 'nj' or 'njs'")

  }

  else

  {

    switch(clus.method,


           # nj (when there are no NAs)

           "nj" = {


             for_plot=ape::nj(dnabin.dist)

           },

           # when there could be potential NAs

           "njs" = {


             for_plot=ape::njs(dnabin.dist)

           }

    )

  }

  # Save a newick tree format for output

  tree_obj = ape::write.tree(for_plot)


  # If user wants to export the tree

  if(newick.tree.export)

  {

    # Output path and name cannot be left empty if tree export is TRUE

    if(is.null(newick.file.path)|is.null(newick.file.name))

    {

      stop("File path and file name must be provided if newick tree export is TRUE")

      return(FALSE)


    }


    else

    {

      # If the path and name are specified, the tree is saved as newick tree

      ape::write.tree(tree_obj,
                      file = paste(newick.file.path,
                                   "/",
                                   newick.file.name,
                                   sep=""),
                      tree.names = F)

    }


  }

  # File path and name cannot be filled if tree export is FALSE

  else if (newick.tree.export==F)

  {

    if(!is.null(newick.file.path)|!is.null(newick.file.name))

    {

      warning("File path and file name can only be provided when newick tree export is TRUE")

      return(FALSE)

    }



  }


  if(tree.plot)

  {

    tree_plot<-plot.phylo(for_plot,
                          type=tree.plot.type,
                          cex=0.8,
                          font=1,
                          tip.color = "darkblue",
                          edge.color = "orangered2",
                          edge.width=1.5)
    # Reset margins to original values

    output$plot=tree_plot

    # Save the plot as a phylo object

    output$data_for_plot=for_plot

  }


  # If distance matrix = TRUE

  if(dist.matrix)

  {

    output$dist_matrix=round(dnabin.dist,3)

  }

  # Output

  invisible(output)

}

