#' Analyze and visualize the output from the `align.seq`
#'
#' @description
#' This function provides a distance matrix and a NJ clustering of the multiple sequence alignment output of the `align.seq`.
#'
#' @export
#'
#' @param aligned.seq A DNAStringset multiple sequence alignment object returned by `align.seq` function
#' @param dist.model A character string specifying the model to generate the distances
#' @param clus A character vector specifying either"nj" (neighbour joining) or "njs" (neighbour joining with NAs) clustering algorithm
#' @param tree.export Logical value specifying whether newick tree should be generated and exported. Default value is FALSE,
#' @param file.path A character value specifying the folder path where the file should be saved
#' @param file.name A character value specifying the name of the exported file.
#' @param plot Logical value specifying if a neighbour joining plot should be generated. Default value is FALSE
#' @param ... additional arguments that can be provided to the `dist.dna` function from ape
#'
#' @details ‘analyze.seq’ analyzes the output of the `align.seq` function to generate a distance matrix using the models available in the `dist.dna` function of the ape library. The function also has an option to plot the distances as a basic Neighbour joining cluster. Additionally, the function provides base frequencies and a option to export the trees in 'newick' format.
#'
#'
#' @returns
#' dist_mat = A distance matrix based on the model selected
#' base_freq = Overall base frequencies of the 'align.seq' result
#' newick_tree = NJ/NJS tree in a newick format (only if tree.export=TRUE)
#' plot = Neighbour Joining clustering visualization (if plot=TRUE)

#' @importFrom msa msaConvert
#' @importFrom ape dist.dna
#' @importFrom ape base.freq
#' @importFrom ape nj
#' @importFrom ape njs
#' @importFrom ape write.tree
#' @importFrom ggtree ggtree
#' @importFrom ggtree geom_tiplab
#' @importFrom ggtree geom_treescale
#' @importFrom ggtree geom_nodepoint
#' @importFrom ggplot2 ggtitle
#' @export



analyze.seq<-function(aligned.seq,
                       dist.model,
                       clus=c("nj",
                              "njs"),
                       tree.export=FALSE,
                       file.path=NULL,
                       file.name=NULL,
                       plot=FALSE,
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

    # Store the original margins

    # original_mar <- par("mar")
    #
    # par(mar = c(0.1, 0.1, 0.1, 0.1))
    #
    # plot(for_plot,
    #      type=plot.type,
    #      cex=0.8)
    #
    # # Reset margins to original values
    #
    # par(mar = original_mar)


    options(ignore.negative.edge=TRUE)

    tree_plot<-ggtree(for_plot,
           ladderize = T,
           col="orangered",
           size=0.6) +
      geom_tiplab(size=3,
                  color="darkblue") +
      geom_treescale(x=1,
      y=20,
      fontsize=6,
      linesize=2,
      offset=1)+
      geom_nodepoint(color="forestgreen",
                     alpha=0.5,
                     size=1.5) +
      # geom_rootedge(rootedge = 0.001,
      #               col="orangered")+
      ggtitle("Neighbour Joining clustering of the data")



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
