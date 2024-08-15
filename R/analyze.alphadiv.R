#' Create an alpha diversity profile of the retrieved data
#'
#' @description
#' This function analyzes the output from the `gen.comm.mat` to provide a richness and alpha diversity profile of the downloaded data.
#'
#' @param bin.comm the site X species like output from the `gen.comm.mat` function.
#' @param plot.curve A logical value specifying whether an accumulation curve should be plotted.Default value is FALSE.
#' @param curve.index A character value specifying which index should be used for the `curve.index` argument. Default value is NULL.
#' @param curve.xval A character value specifying whether sample or individuals should be used against the `curve.index`.Default value is NULL.
#' @param preston.res A logical value specifying whether the Preston results should be generated. Default value is FALSE.
#' @param pres.plot.y.label A character value specifying the taxonomic category (`taxon.rank` in [gen.comm.mat()]) which was used to generate the matrix.
#'
#' @details `analyze.alphadiv` estimates the richness and calculates the shannon diversity values using the [gen.comm.mat()] output. The estimations are based on BIN counts or presence absence data at the taxonomic level specified by the user in the `gen.comm.mat` function. The function also generates Preston plots and the associated numerical results. The richness profile is created using [BAT::alpha.accum()] while the preston and shannon diversity results are obtained using the [vegan::prestondistr()] and [vegan::diversity()] functions respectively. Preston plots are created using the data from the `prestondistr` results in [ggplot2].The cyan bars in the preston plot represent the observed species (or equivalent taxonomic group) while the orange dots represent the expected number of the same. Please note that some of the results (like Shannon/Preston) would depend on the input data (true abundances vs counts vs incidences). Additionally, Preston result's output gives a number of species by default. If another taxonomic rank is used in the [gen.comm.mat()] function, the 'species' number in the results would be the number of that taxonomic rank (even though the output would still print 'species').
#'
#' @returns A list containing containing:
#' * richness = A richness profile matrix
#' * output$Shannon_div = Shannon diversity values for the given sites/grids
#' * output$richness_plot = A ggplot2 visualization of the richness curve
#' * output$preston.res = a Preston plot numerical data output
#' * output$preston.plot = a ggplot2 visualization of the preston.plot
#'
#' @examples
#' # Download data from BOLD (removing species with blanks)
#' comm.mat.data<-bold.connectr.public(taxonomy = "Poecilia")
#'
#' comm.mat.data<-comm.mat.data[!comm.mat.data$species=="",]
#'
#' # Generate the community matrix based on grids
#' comm.data.grid<-gen.comm.mat(comm.mat.data,taxon.rank="species",grids = TRUE,gridsize = 1000000)
#'
#' grid.data<-comm.data.grid$comm.matrix
#'
#' # Diversity results with estimation curve and without preston results
#' div.res1<-analyze.alphadiv(grid.data,plot.curve=TRUE,curve.index="Jack1ab",curve.xval = "Sampl")
#'
#' # Richness estimations
#' head(div.res1$richness)
#'
#' # Richness plot
#' div.res1$richness_plot
#'
#' # Shannon diversity
#' head(div.res1$Shannon_div)
#'
#'
#' # Diversity results without estimation curve and with preston results
#' div.res2<-analyze.alphadiv(grid.data,preston.res = TRUE,pres.plot.y.label = "species")
#'
#' # Preston results
#' div.res2$preston.res
#'
#' # Preston plot
#' div.res2$preston.plot
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
#'
#' @export
#'
analyze.alphadiv <- function(bin.comm,
                            plot.curve=FALSE,
                            curve.index=NULL,
                            curve.xval=NULL,
                            preston.res=FALSE,
                            pres.plot.y.label=NULL)

{

  # Check if data is a data frame object

  if(is.data.frame(bin.comm)==FALSE)

  {

    stop("Input is not a data frame")

    return(FALSE)

  }


  # Check whether the data frame is empty

  if(nrow(bin.comm)==0)

  {

    stop("Dataframe is empty")

    return(FALSE)

  }


  # Empty output list

  output = list()


  # species richness estimation

  richness=alpha.accum(bin.comm,
                        runs=100)%>%
    data.frame(.)%>%
    dplyr::mutate(across(where(is.numeric), ~ round(., 2)))

  output$richness = richness

  warning("Shannon values are based on the assumption that the BIN community data have counts (or abundances)")

  # Shannon diversity


  shannon_div=vegan::diversity(bin.comm)%>%
    data.frame(.)%>%
    dplyr::rename("Shannon_values"=".")

  output$Shannon_div = shannon_div

  # Estimation curves

  if(plot.curve)

  {

    if(is.null(curve.index)|is.null(curve.xval))

    {

      stop("If plot.curve=TRUE, curve.index and curve.xval must be specified")

    }

    else

      {

        x_data = ggplot2::sym(curve.xval)


        y_data = ggplot2::sym(curve.index)


        richness = richness


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


  # Preston plots


  if(preston.res)

  {

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

      message("The following error is for the preston results due to an issue with the input data. Values need to be abundances: ",e$message)



    }
    )



  }

  invisible(output)


}
