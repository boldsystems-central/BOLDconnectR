#' Analyze and visualize the multiple sequence alignment
#'
#' @importFrom ape add.scale.bar
#'
#' @description
#' Calculates genetic distances and performs a Neighbor Joining tree estimation of the multiple sequence alignment output obtained from `bold.analyze.align`.
#'
#' @param bold_df A modified BCDM data frame obtained from [bold.analyze.align()].
#' @param dist_model A character string specifying the model to generate the distances.
#' @param clus_method A character vector specifying either `nj` (neighbour joining) or `njs` (neighbour joining with NAs) clustering algorithm.
#' @param save_dist_mat A logical value specifying whether the distance matrix should be saved in the output. Default is FALSE.
#' @param newick_tree_export  character value specifying the folder path where the file should be saved along with the name for the file.Default value is NULL.
#' @param tree_plot Logical value specifying if a neighbour joining plot should be generated. Default value is FALSE.
#' @param tree_plot_type The layout of the tree.
#' @param ... additional arguments from `ape::dist.dna`.
#'
#' @details `bold.analyze.tree` analyzes the multiple sequence alignment output of the `bold.analyze.align` function to generate a distance matrix using the models available in the [ape::dist.dna()]. Two forms of Neighbor Joining clustering are currently available ([ape::nj()] & [ape::njs()]). Setting `save_dist_mat`= TRUE will store the underlying distance matrix in the output; however, the  default value for the argument is deliberately kept at FALSE to avoid potential memory issues with large data.
#' `newick_tree_export` will save the tree in a newick format locally. Data path with the name of the file should be provided (Ex. 'C:/Users/xyz/Desktop/newickoutput'). Setting `tree_plot`= TRUE generates a basic visualization of the Neighbor Joining (NJ) tree using the distance matrix from [ape::dist.dna()] and the [ape::plot.phylo()] function. `tree_plot_type` specifies the type of tree and has the following options ("phylogram", "cladogram", "fan", "unrooted", "radial", "tidy" based on `type` argument of [ape::plot.phylo()];The first alphabet can be used instead of the whole word). Both [ape::nj()] and [ape::njs()] are available for generating the tree.  Additional arguments for calculating distances can be passed to [ape::dist.dna()] using the `...` argument. The function also provides base frequencies from the data.
#'
#' @returns An 'output' list containing:
#' *	dist_mat = A distance matrix based on the model selected if save_dist_mat=TRUE.
#' *	base_freq = Overall base frequencies of the align.seq result.
#' *	plot = Neighbor Joining clustering visualization (if tree_plot=TRUE).
#' *	data_for_plot = A phylo object used for the plot.
#' *	NJ/NJS tree in a newick format (only if newick_tree_export=TRUE).

#' @examples
#' \dontrun{
#' #Download the data ids
#' seq.data.ids <- bold.public.search(taxonomy = c("Eulimnadia"))
#'
#' # Fetch the data using the ids.
#' #1. api_key must be obtained from BOLD support before usage
#' #2. the function `bold.apikey` should be used to set the apikey in the global env
#'
#' seq.data <- bold.fetch(get_by = "processid",
#'                        identifiers = seq.data.ids$processid,
#'                        filt_marker = "COI-5P")
#'
#' # Remove rows without species name information
#' seq <- seq.data[seq.data$species!="", ]
#'
#' # Align the data
#' # Users need to install and load packages `msa` and `Biostrings`.
#' seq.align<-bold.analyze.align(bold_df=seq.data,
#'                               marker="COI-5P",
#'                               align_method="ClustalOmega",
#'                               cols_for_seq_names = c("species","bin_uri"))
#'
#' #Analyze the data to get a tree
#'
#' seq.analysis<-bold.analyze.tree(bold_df=seq.align,
#'                                 dist_model = "K80",
#'                                 clus_method="nj",
#'                                 tree_plot=TRUE,
#'                                 tree_plot_type='p',
#'                                 save_dist_mat = T)
#'
#' # Output
#' # A ‘phylo’ object of the plot
#' seq.analysis$data_for_plot
#' # A distance matrix based on the distance model selected
#' seq.analysis$save_dist_mat
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
bold.analyze.tree<-function(bold_df,
                            dist_model,
                            clus_method=c("nj",
                                          "njs"),
                            save_dist_mat=FALSE,
                            newick_tree_export=NULL,
                            tree_plot=FALSE,
                            tree_plot_type,
                            ...)

{

  # check if the minimum fields required for the analysis are present

  check_and_return_preset_df(df=bold_df,
                             category = "check",
                             preset = 'bold_analyze_tree_fields')

# Generate a dataframe of the aligned_seq and the seq.name and convert it to a ape DNAbin

  #1. Extract out the necessary columns

  ape_df<-bold_df%>%
    dplyr::select(matches("^aligned_seq",ignore.case=TRUE),
                  matches("^msa.seq.name",ignore.case=TRUE),
                  matches("^nuc",ignore.case=TRUE))%>%
    dplyr::filter(!is.na(nuc))%>%
    dplyr::filter(!is.null(nuc))%>%
    dplyr::mutate(nuc=gsub("-","",nuc))%>%
    dplyr::filter(nuc!="")

  #2. as.DNAbin accepts matrices so the above dataframe is converted into a matrix with each column being one alphabet of the basepair in lower case.

  ape.matrix<-t(sapply(strsplit(ape_df[['aligned_seq']],""), tolower))

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

  if (length(clus_method)!=1)
  {
    stop("clus_method argument empty. Please select either 'nj' or 'njs'")
  }

  # Swtich for either nj or njs

    switch(clus_method,


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

  if(!is.null(newick_tree_export))
  {

    # save the file
    ape::write.tree(tree_obj,
                    file = newick_tree_export,
                    tree.names = F)

  }


  if(tree_plot)

  {

    plot.phylo(ape::ladderize(for_plot,right = FALSE),
                          type=tree_plot_type,
                          cex=0.8,
                          font=1,
                          tip.color = "darkblue",
                          edge.color = "orangered2",
                          edge.width=1.5)

    # Get the plot limits
    plot_limits <- par("usr")

    on.exit(plot_limits)

    # Add a scale bar dynamically
    add.scale.bar(x = plot_limits[1] + 0.7 * (plot_limits[2] - plot_limits[1]), # Adjust x position
                  y = plot_limits[3] + 0.05 * (plot_limits[4] - plot_limits[3]), # Adjust y position
                  cex = 1,
                  lwd = 3,
                  font = 2,
                  col = "black")

    # Save the plot as a phylo object

    output$data_for_plot=for_plot

  }

  # If save_dist_mat = TRUE

  if(save_dist_mat)

  {
    output$save_dist_mat=round(dnabin.dist,3)
  }

  # Output

  invisible(output)

}

