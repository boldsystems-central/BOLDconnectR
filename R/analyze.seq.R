#' Analyze and visualize the output from `align.seq`
#'
#' @description
#' Calculates genetic distances and performs a Neighbor Joining tree estimation of the multiple see- quence alignment output obtained from `align.seq`.
#'
#' @param aligned.seq A DNAStringSet multiple sequence alignment object returned by the `align.seq` function.
#' @param dist.model A character string specifying the model to generate the distances.
#' @param clus A character vector specifying either [ape::nj()] (neighbour joining) or [ape::njs()] (neighbour joining with NAs) clustering algorithm.
#' @param tree.export Logical value specifying whether newick tree should be generated and exported. Default value is FALSE.
#' @param file.path A character value specifying the folder path where the file should be saved.
#' @param file.name A character value specifying the name of the exported file.
#' @param plot Logical value specifying if a neighbour joining plot should be generated. Default value is FALSE.
#' @param plot.type The layout of the tree. Based on [ape::plot.phylo()] `type`.Default value is 'c' (for cladogram).
#' @param ... additional arguments from [ape::dist.dna()]
#'
#' @details `analyze.seq` analyzes the multiple sequence alignment output of the `align.seq` function to generate a distance matrix using the models available in the [ape::dist.dna()]. The function does not check for any STOP codons or indels. `plot`= TRUE will generate a basic visualization of the Neighbor Joining (NJ) tree of the distance matrix using [ape::plot.phylo()]. Both `ape::nj()` and `ape::njs()` are available for generating the tree. Additionally, the function provides base frequencies and an option to export the trees in a newick format.
#' `\emph{Note: }` This function is currently an internal function with documentation. Users are required to install and load the  `msa` package before running this function that is maintained by `Bioconductor`.
#'
#' @returns An 'output' list containing:
#' * dist_mat = A distance matrix based on the model selected.
#' * base_freq = Overall base frequencies of the `align.seq` result.
#' * Newick_tree = NJ/NJS tree in a newick format (only if `tree.export`=TRUE).
#' * plot = Neighbor Joining clustering visualization (if `plot`=TRUE).
#' * data_for_plot = A `phylo` object used for the plot.
#'
#' @examples
#' \dontrun{
#' #Download the data
#' seq.data<-bold.connectr.public(taxonomy = c("Eulimnadia"),marker = "COI-5P")
#' seq<-seq.data[!seq.data$species=="",]
#'
#' # Align the data (using species" and bin_uri  as a composite name for each sequence)
#' seq.align<-align.seq(seq,name.fields = c("species","bin_uri"),marker="COI-5P")
#'
#' #Analyze the data
#' seq.analysis<-analyze.seq(seq.align$msa.result,"K80",clus="njs",plot=TRUE)
#'
#' #Visualize the plot
#' seq.analysis$plot
#'
#' #A 'phylo' object of the plot
#' seq.analysis$data_for_plot
#'
#' #A distance matrix based on the distance model selected
#' seq.analysis$dist_matrix
#'
#' # Base frequencies of the sequences
#' seq.analysis$base_freq
#'}
#'
#' # Function used by `analyze.seq` (for which the users need to install `msa`).
#' #importFrom msa msaConvert
#'
#' @importFrom ape dist.dna
#' @importFrom ape base.freq
#' @importFrom ape nj
#' @importFrom ape njs
#' @importFrom ape write.tree
#' @importFrom ape plot.phylo
#'
#' @keywords internal
#'
analyze.seq<-function(aligned.seq,
                      dist.model,
                      clus=c("nj",
                             "njs"),
                      tree.export=FALSE,
                      file.path=NULL,
                      file.name=NULL,
                      plot=FALSE,
                      plot.type,
                      ...)

{



  # Empty output list defined

  output = list()


  # The aligned sequence is converted into a DNAbin

  align.2.dnabin=msa::msaConvert(aligned.seq,
                                 "ape::DNAbin")

  # The distance object using the model (and other arguments if specified) specified is generated

  dnabin.dist=ape::dist.dna(align.2.dnabin,
                            model=dist.model,
                            ...)

  # base frequencies (overall) of the aligned sequences


  base_freq = ape::base.freq(align.2.dnabin)


  # Based on the type of clus, clustering is carried out on the dist object

  if (length(clus)!=1)

  {

    stop("clus argument empty. Please select either 'nj' or 'njs'")

  }

  else

  {

    switch(clus,


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

  if(tree.export)

  {

    # Output path and name cannot be left empty if tree export is TRUE

    if(is.null(file.path)|is.null(file.name))

    {

      stop("File path and file name must be provided is tree export is TRUE")

      return(FALSE)


    }


    else

    {

      # If the path and name are specified, the tree is saved as newick tree

      ape::write.tree(for_plot,
                      file = paste(file.path,
                                   "/",
                                   file.name,
                                   sep=""),
                      tree.names = F)

    }


  }

  # File path and name cannot be filled if tree export is FALSE

  else if (tree.export==F)

  {

    if(!is.null(file.path)|!is.null(file.name))

    {

      warning("File path and file name can only be provided when tree export is TRUE")

      return(FALSE)

    }



  }


  if(plot)

  {


    tree_plot<-plot.phylo(for_plot,
                          type=plot.type,
                          cex=0.8,
                          font=1,
                          tip.color = "darkblue",
                          edge.color = "orangered2",
                          edge.width=1.5)

    # Reset margins to original values




    output$plot=tree_plot

    output$data_for_plot=for_plot

  }



  # Appending the results to the output


  output$dist_matrix=round(dnabin.dist,4)

  output$base_freq = base_freq

  output$newick_tree=tree_obj

  # Output

  invisible(output)

}
