#' Create an biodiversity profile of the retrieved data
#'
#' @description
#' This function creates a biodiversity profile of the downloaded data using [bold.fetch()].
#'
#' @param bold_df A data frame obtained from [bold.fetch()].
#' @param taxon_rank A single character value specifying the taxonomic hierarchical rank. Needs to be provided by default.
#' @param taxon_name A single or multiple character vector specifying the taxonomic names associated with the ‘taxon_rank’. Default value is NULL.
#' @param site_type A character vector specifying one of two broad categories of `sites` considered here (`locations` or `grids`).
#' @param location_type A single character vector specifying the geographic category for which a community matrix should be created. Default value is NULL.
#' @param gridsize A numeric value of the size of the grid if location_type=grid; Size is in sq.m. Default value is NULL.
#' @param presence_absence A logical value specifying whether the generated matrix should be converted into a ’presence-absence’ matrix.
#' @param diversity_profile A character value specifying the type of diversity profile ("richness","preston","shannon","beta")
#' @param beta_index A character vector specifying the type of beta diversity index (’jaccard’ or ’sorensen’ available).
#'
#' @details `bold.analyze.diversity` estimates the richness & calculates the Shannon and beta diversity from the BIN counts or presence-absence data. Internally, the function converts the downloaded BCDM data into a community matrix (site X species) which is also generated as a part of the output. `taxon_rank` has to be provided by default while `taxon_name` if given, will create the matrix for that specific taxon/taxa. `site_type` = 'locations' can be used when a profile pertaining to particular geographic category is needed. This category can be specified using the `location_type` argument. `site_type`= grids creates a grid based on BIN occurrence data (latitude, longitude) with grid size determined by the user in square meters using the `gridsize` argument. The the Coordinate Reference System (CRS) of this data is converted to a ‘Mollweide’ projection by which distance-based grid can be correctly specified (Gott III et al. 2007). Each grid is also assigned a cell id, with the lowest number given to the lowest latitudinal point in the dataset. The `presence_absence` argument converts the counts (or abundances) to 1s and 0s.
#' The community matrix is then used to create one of the following `diversity_profile` using functions from `BAT` and `vegan` packages:
#' * `richness`(`BAT::alpha.accum()`)
#' * `preston`(plots and results)(`vegan::prestondistr()`)
#' * `shannon`(`vegan::diversity()`)
#' * `beta`(`BAT::beta()`)
#' The option `all` generates results for all of the above.
#' `BAT::alpha.accum()` currently offers various richness estimators, including Observed diversity (Obs); Singletons (S1); Doubletons (S2); Uniques (Q1); Duplicates (Q2); Jackknife1 abundance (Jack1ab); Jackknife1 incidence (Jack1in); Jackknife2 abundance (Jack2ab); Jackknife2 incidence (Jack2in); Chao1 and Chao2. The results depend on the input data (true abundances vs counts vs incidences) and users should be careful in the subsequent interpretation.
#' Preston plots feature cyan bars for observed species (or equivalent taxonomic group) and orange dots for expected counts.
#' `BAT::beta()` partitions the data using the Podani & Schmera (2011)/Carvalho et al. (2012) approach partitioning the beta diversity into ’species replacement’ and ’richness difference’ components. These results are stored as distance matrices in the output. The type of beta index can be specified using the `beta_index` argument.
#' \emph{Note on the community matrix}: Each cell in this matrix contains the counts (or abundances) of the specimens whose sequences have an assigned BIN, in a given a `site_type` (`locations` or `grids`). These counts can be generated at any taxonomic hierarchical level, applicable to one or multiple taxa including ’bin_uri’. `location_type` can refer to any geographic field, and metadata on these fields can be checked using the `bold.fields.info()`. Rows lacking latitude and longitude data are removed when `site_type` = 'grids', while NULL entries for `site_type` = 'locations' are allowed if they have a latitude and longitude value. This is because grids are drawn based on the bounding boxes which only use latitude and longitude values.
#' \emph{Important Note}: Results, including species counts, adapt based on taxon_rank argument although the output label remains ‘species’ in case of `preston` results.
#'
#' @returns An 'output' list containing containing results based on the profile selected:
#' #Common to all
#' *	comm.matrix = site X species like matrix required for the biodiversity results
#' #1. richness
#' *	richness = A richness profile matrix
#' #2. shannon
#' *	Shannon_div = Shannon diversity values for the given sites/grids (from gen.comm.mat)
#' #3. preston
#' *	preston.res = a Preston plot numerical data output
#' *	preston.plot = a ggplot2 visualization of the preston.plot
#' #4. beta
#' *	total.beta = beta.total
#' *	replace = beta.replace (replacement)
#' *	richnessd = beta.richnessd (richness difference)
#' #5. all
#' *  All of the above results
#'
#' @references
#' Carvalho, J.C., Cardoso, P. & Gomes, P. (2012) Determining the relative roles of species replace- ment and species richness differences in generating beta-diversity patterns. Global Ecology and Biogeography, 21, 760-771.
#'
#' Podani, J. & Schmera, D. (2011) A new conceptual and methodological framework for exploring and explaining pattern in presence-absence data. Oikos, 120, 1625-1638.
#'
#' Richard Gott III, J., Mugnolo, C., & Colley, W. N. (2007). Map projections minimizing distance errors. Cartographica: The International Journal for Geographic Information and Geovisualization, 42(3), 219-234.
#'
#' @examples
#' \dontrun{
#' # Search for ids
#' comm.mat.data <- bold.public.search(taxonomy = "Poecilia")
#'
#' # Fetch the data using the ids
#' #1. api_key must be obtained from BOLD support before usage
#' #2. the function `bold.apikey` should be used to set the apikey in the global env
#'
#' BCDMdata <- bold.fetch(get_by = "processid",
#'                        identifiers = comm.mat.data$processid)
#'
#' # Remove rows which have no species data
#' BCDMdata <- BCDMdata[!BCDMdata$species== "",]
#'
#' #1. Analyze richness data
#' res.rich <- bold.analyze.diversity(bold_df=BCDMdata,
#'                                    taxon_rank = "species",
#'                                    site_type = "locations",
#'                                    location_type = 'country.ocean',
#'                                    diversity_profile = "richness")
#'
#' # Community matrix (BCDM data converted to community matrix)
#' res.rich$comm.matrix
#'
#' # richness results
#' res.rich$richness
#'
#' #2. Shannon diversity
#' res.shannon <- bold.analyze.diversity(bold_df=BCDMdata,
#'                                       taxon_rank = "species",
#'                                       site_type = "locations",
#'                                       location_type = 'country.ocean',
#'                                       diversity_profile = "shannon")
#'
#' # Shannon diversity results
#' res.shannon
#'
#' #3. Preston plots and results
#' pres.res <- bold.analyze.diversity(bold_df=BCDMdata,
#'                                    taxon_rank = "species",
#'                                    site_type = "locations",
#'                                    location_type = 'country.ocean',
#'                                    diversity_profile = "preston")
#'
#' # Preston plot
#' pres.res$preston.plot
#'
#' # Preston plot data
#' pres.res$preston.res
#'
#' #4. beta diversity
#' beta.res <- bold.analyze.diversity(bold_df=BCDMdata,
#'                                    taxon_rank = "species",
#'                                    site_type = "locations",
#'                                    location_type = 'country.ocean',
#'                                    diversity_profile = "beta",
#'                                    beta_index = "jaccard")
#'
#' #Total diversity
#' beta.res$total.beta
#'
#' #Replacement
#' beta.res$replace
#'
#' #Richness difference
#' beta.res$richnessd
#'}
#'
#' @importFrom BAT alpha.accum
#' @importFrom vegan diversity
#' @importFrom vegan prestondistr
#' @importFrom ggplot2 geom_line
#' @importFrom ggplot2 theme_classic
#' @importFrom ggplot2 sym
#' @importFrom ggplot2 geom_bar
#' @importFrom ggplot2 scale_y_continuous
#' @importFrom ggplot2 element_blank
#' @importFrom stats fitted
#' @importFrom BAT beta
#' @export
#'
bold.analyze.diversity <- function(bold_df,
                                   taxon_rank,
                                   taxon_name=NULL,
                                   site_type = c("locations","grids"),
                                   location_type=NULL,
                                   gridsize=NULL,
                                   presence_absence=FALSE,
                                   diversity_profile = c("richness","preston","shannon","beta","all"),
                                   beta_index=NULL)

{

  # Check if data is a data frame object

  if(any(is.data.frame(bold_df)==FALSE,nrow(bold_df)==0))

  {
    stop("Please re-check data input. Input needs to be a non-empty data frame")
  }

  # Check if taxon_rank is empty

  if(is.null(taxon_rank))
  {
    ## Taxon rank cannot be empty
    stop ("Taxon rank cannot be left empty")
  }

  # Empty output list

  output = list()

  # Condition to check if grids.cat is specified or whether site.cat will be used


  switch(site_type,

         "locations"=

           {
             if(!is.null(gridsize))
             {
               stop("Grid size must only be specified when site_type='grids'")
             }

             bin.comm.res = gen.comm.mat(bold.df=bold_df,
                                         taxon.rank=taxon_rank,
                                         taxon.name=taxon_name,
                                         site.cat=location_type)

             bin.comm = bin.comm.res$comm.matrix


           },

         "grids"=

           {
             if(is.null(gridsize))
             {
               stop("When site_type='grids',gridsize must be specified.")
             }

             bin.comm.res = gen.comm.mat(bold.df=bold_df,
                                         taxon.rank=taxon_rank,
                                         taxon.name=taxon_name,
                                         site.cat=NULL,
                                         grids=TRUE,
                                         gridsize=gridsize,
                                         view.grids=TRUE)

             bin.comm = bin.comm.res$comm.matrix

             grids.map=bin.comm.res$grid_plot

             output$grid.map=grids.map

             output$grid_dta = bin.comm.res$grids
           }
  )


  # Check if the data is presence-absence

  if(presence_absence)

  {
    bin.comm=ifelse(bin.comm>=1,1,0)%>%data.frame(.)
  }

  if (all(bin.comm==0|bin.comm==1))

  {
    warning("Data is presence absence data. Preston and/or Shannon results if calculated, are based on the assumption that the community data has counts.")
  }

  # Output the community data

  output$comm.matrix = bin.comm

  # Richness results


  switch(diversity_profile,

         "richness"=
           {

             # species richness estimation

             richness_res= richness_profile(df=bin.comm)

             output$richness = richness_res

           },

         "preston"=

           {

             tryCatch({

               preston_results<-preston_profile(df=bin.comm,
                                                y_label = taxon_rank)

               output$preston.plot = preston_results$preston.plot

               output$preston.res = preston_results$preston.res


             },
             error = function (e)
             {
               message("The following error is for the preston results due to an issue with the input data. Please re-check if the values used are abundances or presence-absences: ",e$message)
             }
             )
           },

         "shannon"=

           {
             # Shannon diversity

             shannon_results=shannon_div_profile(df=bin.comm)

             output$shannon_div = round(shannon_results,2)

           },

         "beta"=

           {

             beta_div_results=beta_div_profile(df=bin.comm,
                                               beta.index=beta_index,
                                               pre_abs=presence_absence)



             # Add results to output

             output$total.beta = beta_div_results$total.beta

             output$replace = beta_div_results$replace

             output$richnessd = beta_div_results$richnessd
           },

         "all"=


           {

             richness_res= richness_profile(df=bin.comm)


             preston_results<-preston_profile(df=bin.comm,
                                              y_label = taxon_rank)

             shannon_results=shannon_div_profile(df=bin.comm)

             beta_div_results=beta_div_profile(df=bin.comm,
                                               beta.index=beta_index,
                                               pre_abs=presence_absence)


             output$richness = richness_res

             output$preston.plot = preston_results$preston.plot

             output$preston.res = preston_results$preston.res

             output$shannon_div = round(shannon_results,2)

             output$total.beta = beta_div_results$total.beta

             output$replace = beta_div_results$replace

             output$richnessd = beta_div_results$richnessd


           }
  )

  invisible(output)

}
