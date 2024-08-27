#' Create an biodiversity profile of the retrieved data
#'
#' @description
#' This function creates a biodiversity profile of the downloaded data using [bold.fetch()].
#'
#' @param bold.df A data frame obtained from [bold.fetch()].
#' @param taxon.rank A single character value specifying the taxonomic hierarchical rank. Needs to be provided by default.
#' @param taxon.name A single or multiple character vector specifying the taxonomic names associated with the ‘taxon.rank’. Default value is NULL.
#' @param site.cat A single or multiple character vector specifying the countries for which a community matrix should be created. Default value is NULL.
#' @param grids.cat A logical value specifying Whether the community matrix should be based on grids as ‘sites’. Default value is NULL.
#' @param gridsize A numeric value of the size of the grid if the grids=TRUE;Size is in sq.m. Default value is NULL.
#' @param presence.absence A logical value specifying whether the generated matrix should be converted into a 'presence-absence' matrix.
#' @param richness.res A logical value specifying whether richness results should be calculated. Default value is FALSE.
#' @param rich.plot.curve A logical value specifying whether an accumulation curve should be plotted.Default value is FALSE.
#' @param rich.curve.estimatr A character value specifying which index should be used. Default value is NULL.
#' @param rich.curve.x.axis A character value specifying whether samples (Samples) or individuals (Individuals) should be used against the `curve.index`.Default value is NULL.
#' @param shannon.res A logical value specifying whether the Shannon diversity results should be generated. Default value is FALSE.
#' @param preston.res A logical value specifying whether the Preston results should be generated. Default value is FALSE.
#' @param pres.plot.y.label A character value specifying the taxonomic category (`taxon.rank`) which was used to generate the matrix.
#' @param beta.res A logical value specifying whether beta diversity results should be calculated. Default value is FALSE.
#' @param beta.index A character vector specifying the type of beta diversity index ('jaccard' or 'sorenson' available).
#'
#' @details `bold.analyze.diversity` estimates the richness, shannon diversity and beta diversity  from the BIN counts or presence-absence data. The function internally converts the downloaded BCDM data into a community matrix (~site X species) which is also generated as a part of the output.`grids.cat` converts the Coordinate Reference System (CRS) of the data to a ‘Mollweide' projection by which distance based grid can be correctly specified. A cell id is also given to each grid with the lowest number assigned to the lowest latitudinal point in the dataset. It uses this matrix to create richness profiles using [BAT::alpha.accum()] and Preston and Shannon diversity analyses using [vegan::prestondistr()] and [vegan::diversity()] respectively. The [BAT::alpha.accum()] currently has many richness estimators (Obs: Observed diversity; S1: Singletons; S2: Doubletons; Q1: Uniques; Q2: Duplicates; Jack1ab: Jackknife1 abundance; Jack1in: Jackknife1 incidence; Jack2ab: Jackknife2 abundance; Jack2in: Jackknife2 incidence; Chao1; Chao2). The results depend on the input data (true abundances vs counts vs incidences) and users should be careful in the subsequent interpretation. Preston plots are created using the data from the `prestondistr` results in `ggplot2` featuring cyan bars for observed species (or equivalent taxonomic group) and orange dots for expected counts. The argument `presence.absence` will convert the counts (or abundances) to 1 and 0. This dataset can then directly be used as the input data for functions from packages like `vegan` for biodiversity analyses.Beta diversity values are calculated using [BAT::beta()] function, which partitions the data using the Podani & Schmera (2011)/Carvalho et al. (2012) approach partitioning the beta diversity into ’species replacement’ and ’richness difference’ components. These results are stored as distance matrices in the output.
#' `\emph{Note on the community matrix}`: Instead of species counts (or abundances), values in each cell of this matrix are the counts (or abundances) of a specific BIN from a `site.cat` site category or a `grids.cat`. These counts can be generated at any taxonomic hierarchical level for a single or multiple taxa (This can also be done for 'bin_uri'; the difference being that the numbers in each cell would be the number of times that respective BIN is found at a particular `site.cat` or `grids.cat`). `site.cat` can be any of the `geography` fields (Meta data on fields can be checked using the [bold.fields.info()]). Alternatively, `grids.cat` = TRUE will generate grids based on the BIN occurrence data (latitude, longitude) with the size of the grid determined by the user (in sq.m.) with the `gridsize` argument. For `grids` generation, rows with no latitude and longitude data are removed (even if a corresponding `site.cat` information is available) while NULL entries for `site.cat` are allowed if they have a latitude and longitude value (This is done because grids are drawn based on the bounding boxes which only use latitude and longitude values).
#' `\emph{Note:}` Results, including species counts, adapt based on `taxon.rank` argument although the output label remains ‘species’ in some instances (`preston.res`).

#'
#' @returns An 'output' list containing containing:
#' * comm.matrix = site X species like matrix required for the biodiversity results
#' * grid_plot = A map of grids based on their centroids
#' * richness = A richness profile matrix
#' * Shannon_div = Shannon diversity values for the given sites/grids(from `gen.comm.mat`)
#' * richness_plot = A ggplot2 visualization of the richness curve
#' * preston.res = a Preston plot numerical data output
#' * preston.plot = a ggplot2 visualization of the preston.plot
#' * total.beta = beta.total
#' * replace = beta.replace (replacement)
#' * richnessd = beta.richnessd (richness difference)
#'
#' @examples
#' \dontrun{
#'
#' # Search for ids
#' comm.mat.data<-bold.public.search(taxonomy = "Poecilia")
#'
#' # Fetch the data using the ids
#' BCDMdata<-bold.fetch(param.data = comm.mat.data,query.param = "processid",param.index = 1,apikey)
#'
#' # Remove rows which have no species data
#' data<-BCDMdata[!BCDMdata$species=="",]#'
#'
#' #1. Analyze richness data (site.cat='country.ocean')
#' res.rich<-bold.analyze.diversity(BCDMdata,taxon.rank="species",'country.ocean',richness.res=TRUE)
#'
#' # Community matrix (BCDM data converted to community matrix)
#' res.rich$comm.matrix
#'
#' # richness results
#' res.rich$comm.matrix
#'
#' #2. Shannon diversity (taxon.rank = 'species'; site.cat='country.ocean')
#' res.shannon<-bold.analyze.diversity(BCDMdata,"species",'country.ocean',shannon.res = TRUE)
#'
#' # Shannon diversity results
#' res.shannon
#'
#' #3. Preston plots and results (taxon.rank = 'species'; site.cat='country.ocean')
#' pres.res<-bold.analyze.diversity(BCDMdata,"species",'country.ocean',preston.res=TRUE)
#'
#' # Preston plot
#' pres.res$preston.plot
#'
#' # Preston plot data
#' pres.res$preston.res
#'
#' #4. beta diversity (taxon.rank = 'species'; site.cat='country.ocean'; beta.index = "jaccard")
#' beta.res<-bold.analyze.diversity(BCDMdata,"species",'country.ocean',beta.res=TRUE,"jaccard")
#'
#' #Total diversity
#' beta.res$total.beta
#'
#' #Replacement
#' beta.res$replace
#'
#' #Richness difference
#' beta.res$richnessd
#'
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
bold.analyze.diversity <- function(bold.df,
                                   taxon.rank,
                                   taxon.name=NULL,
                                   site.cat=NULL,
                                   grids.cat=FALSE,
                                   gridsize=NULL,
                                   presence.absence=FALSE,
                                   richness.res=FALSE,
                                   rich.plot.curve=FALSE,
                                   rich.curve.estimatr=NULL,
                                   rich.curve.x.axis=NULL,
                                   shannon.res=FALSE,
                                   preston.res=FALSE,
                                   pres.plot.y.label=NULL,
                                   beta.res=FALSE,
                                   beta.index=NULL)

{

  # Check if data is a data frame object

  if(is.data.frame(bold.df)==FALSE)

  {

    stop("Input is not a data frame")

    return(FALSE)

  }


  # Check whether the data frame is empty

  if(nrow(bold.df)==0)

  {

    stop("Dataframe is empty")

    return(FALSE)

  }

  # Empty output list

  output = list()

  # Condition to check if grids.cat is specified or whether site.cat will be used

  if(grids.cat)

  {

    bin.comm.res = gen.comm.mat(bold.df=bold.df,
                                taxon.rank=taxon.rank,
                                taxon.name=taxon.name,
                                site.cat=site.cat,
                                grids=grids.cat,
                                gridsize=gridsize,
                                view.grids=TRUE)

    bin.comm = bin.comm.res$comm.matrix

    grids.map=bin.comm.res$grid_plot

    output$grid.map=grids.map


  }

  else

  {

    bin.comm.res = gen.comm.mat(bold.df=bold.df,
                                taxon.rank=taxon.rank,
                                taxon.name=taxon.name,
                                site.cat=site.cat)

    bin.comm = bin.comm.res$comm.matrix

  }


  # Check if the data is presence-absence

  if(presence.absence)

  {

    bin.comm=ifelse(bin.comm>=1,1,0)%>%data.frame(.)

  }


  # Output the community data

 output$comm.matrix = bin.comm

 # Richness results

  if(richness.res)

  {

    # species richness estimation

    richness=alpha.accum(bin.comm,
                         runs=100)%>%
      data.frame(.)%>%
      dplyr::mutate(across(where(is.numeric), ~ round(., 2)))


    output$richness = richness

    # Richness curves

    if(rich.plot.curve)

    {
      if(is.null(rich.curve.estimatr)|is.null(rich.curve.x.axis))

      {

        stop("If rich.plot.curve=TRUE, rich.curve.estimatr and rich.curve.x.axis must be specified")

      }

      else

      {
        # Estimation curves in ggplot2

        x_data = ggplot2::sym(rich.curve.x.axis)


        y_data = ggplot2::sym(rich.curve.estimatr)


        richness = richness

        colnames(richness)[colnames(richness) == 'Ind'] <- 'Individuals'

        colnames(richness)[colnames(richness) == 'Sampl'] <- 'Samples'

        richness_plot=richness%>%
          dplyr::select(!!x_data,
                        !!y_data)%>%
          ggplot(aes(x=!!x_data,
                     y=!!y_data)) +
          geom_line(linewidth=1.5)+
          theme_classic(base_size = 16) +
          theme(panel.grid.major = element_blank(),
                panel.grid.minor = element_blank())


        output$richness_plot = richness_plot

      }

    }

    else if (richness.res==FALSE && any((rich.plot.curve==TRUE)|!is.null(rich.curve.estimatr)|!is.null(rich.curve.x.axis)))

      stop("richness.res should be TRUE for plotting richness curves")

  }

 # Shannon diversity

  if (shannon.res)

  {

    if (all(bin.comm==0|bin.comm==1))

    {
      warning("Data is presence absence data. Shannon values calculated here are based on the assumption that the BIN community data have counts (or abundances)")
    }

    # Shannon diversity


    shannon_div=vegan::diversity(bin.comm)%>%
      data.frame(.)%>%
      dplyr::rename("Shannon_values"=".")

    output$Shannon_div = round(shannon_div,2)

  }

  # Preston plots


  if(preston.res)

  {

    if (all(bin.comm==0|bin.comm==1))

    {
      warning("Data is presence absence data. Preston results calculated here are based on the assumption that the BIN community data have counts (or abundances)")
    }


    tryCatch({

      preston.res = vegan::prestondistr(colSums(bin.comm))

      pres_res=data.frame(observed=as.matrix(preston.res$freq),
                          fitted=round(preston.res$fitted,2))

      pres_res$rownum = rownames(pres_res)

      pres_res=pres_res%>%
        dplyr::mutate(rownum=as.numeric(rownum))%>%
        dplyr::mutate(Octaves=as.factor(2^rownum))


      preston.plot=pres_res%>%
        ggplot(aes(x=Octaves,
                   y=observed))+
        geom_bar(stat = "identity",
                 position = 'dodge',
                 fill="darkcyan",
                 col="black",
                 width = 1) +
        geom_point(data = pres_res,
                   aes(x = Octaves,
                       y = fitted,
                       group=1),
                   pch=21,
                   color = "black",
                   fill="orangered",
                   size=4) +
        geom_line(data = pres_res,
                  aes(x = Octaves,
                      y = fitted,group=1),
                  color = "black",
                  lty=2,
                  linewidth=1) +
        theme_bw(base_size = 16) +
        theme(panel.grid.major = element_blank(),
              panel.grid.minor = element_blank())+
        ylab("Species")+
        xlab("Frequency") +
        scale_y_continuous(expand = c(0,0)) +
        ylab(pres.plot.y.label)+
        ggtitle("Preston plot")


      output$preston.plot = preston.plot

      output$preston.res = preston.res


    },

    error = function (e)

    {

      message("The following error is for the preston results due to an issue with the input data. Please re-check if the values used are abundances or presence-absences: ",e$message)



    }
    )



  }

 # Beta diversity


  if(beta.res)

  {


    beta.bin.div=BAT::beta(bin.comm,
                      func = beta.index,
                      abund = presence.absence,
                      runs=10,
                      comp = T)



    beta.total = beta.bin.div$Btotal

    beta.replace = beta.bin.div$Brepl

    beta.richnessd = beta.bin.div$Brich

    # Add results to output

    output$total.beta = beta.total


    output$replace = beta.replace


    output$richnessd = beta.richnessd


  }


  invisible(output)


}
