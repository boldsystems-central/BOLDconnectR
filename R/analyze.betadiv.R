#' Create a beta diversity profile of the retrieved data
#'
#' @description
#' This function analyzes the output from the `gen.comm.mat` to provide a beta diversity (and its partitions) profile of the downloaded data.
#'
#' @param bin.comm the site X species like output from the `gen.comm.mat` function.Default value is FALSE.
#' @param index A character vector specifying the type of beta diversity index ('jaccard' or 'sorenson' currently available).
#' @param pre.abs A logical value specifying whether the input data is presence-absence. Default value is FALSE.
#' @param heatmap A logical value specifying whether a heatmap of the beta diversity values should be plotted.Default value is FALSE.
#' @param component A character value specifying which beta diversity component should be used for the heatmap. Default value is NULL.
#' @param grids A logical value specifying Whether the community matrix is generated using grids. Default value is FALSE.
#' @param grids.df If `grids` = TRUE, a [sf] grid data frame generated along with the community matrix using the [gen.comm.mat()] function.Default value is NULL.
#'
#' @details `analyze.betadiv` calculates either a sorenson or jaccard beta dissimilarity using the [gen.comm.mat()] output. It also generates matrices of 'species replacement' and 'richness difference' components of the total beta diversity. The values are calculated using [BAT::beta()] function which partitions the data using the Podani approach. A corresponding 'heatmap' can also be obtained when `heatmap`=TRUE. In case of grid based heatmaps, grids are arranged on the heatmap based on their centroid distances (i.e. nearest grids are placed closest). For site categories, the heatmap labels are arranged alphabetically. Grid based heatmaps can only be generated when `grids` = TRUE and a [sf] 'grid.df' which is generated from the `gen.comm.mat` function is provided to the function.
#'
#' @returns A list containing:
#' * output$total.beta = beta.total
#' * output$replace = beta.replace (replacement)
#' * output$richnessd = beta.richnessd (richness difference)
#' * output$heatmap.viz = heatmap_final
#'

#' @examples
#'
#' #Download data from BOLD (removing species with blanks)
#' comm.mat.data<-bold.connectr.public(taxonomy = "Poecilia")
#'
#' #Generate the community matrix based on grids
#' comm.data.beta<-gen.comm.mat(comm.mat.data,taxon.rank="species",site.cat = "country.ocean")
#'
#' beta.data<-comm.data.beta$comm.matrix
#'
#' #beta diversity without the heatmaps
#' beta.div.res<-analyze.betadiv(beta.data,index="sorenson")
#'
#' #Total diversity
#' beta.div.res$total.beta
#'
#' #Replacement
#' beta.div.res$replace
#'
#' #Richness difference
#' beta.div.res$richnessd
#'
#'
#' #beta diversity with the heatmaps
#' beta.div.res2<-analyze.betadiv(beta.data,index="sorenson",heatmap = TRUE,component = "total")
#'
#' #Total diversity
#' beta.div.res2$total.beta
#'
#' #Replacement
#' beta.div.res2$replace
#'
#' #Richness difference
#' beta.div.res2$richnessd
#'
#' #Visualize the heatmap
#' beta.div.res$heatmap.viz
#'
#' @importFrom BAT beta
#' @importFrom dplyr left_join
#' @importFrom ggplot2 geom_tile
#' @importFrom ggplot2 coord_fixed
#' @importFrom ggplot2 scale_fill_gradient
#' @importFrom ggplot2 scale_x_discrete
#' @importFrom ggplot2 scale_y_discrete
#' @importFrom ggplot2 guides
#' @importFrom ggplot2 theme_light
#' @importFrom ggplot2 element_text
#' @importFrom ggplot2 geom_text
#' @importFrom ggplot2 guide_legend
#' @importFrom tidyr pivot_longer
#' @importFrom sf st_distance
#' @importFrom stats reorder
#'
#' @export
#'
analyze.betadiv <- function (bin.comm,
                            index,
                            pre.abs=FALSE,
                            heatmap=FALSE,
                            component,
                            grids=FALSE,
                            grids.df=NULL)
{

  output = list()

  beta.bin.div=beta(bin.comm,
                    func = index,
                    abund = pre.abs,
                    runs=10,
                    comp = T)



  beta.total = beta.bin.div$Btotal

  beta.replace = beta.bin.div$Brepl

  beta.richnessd = beta.bin.div$Brich



  output$total.beta = beta.total


  output$replace = beta.replace


  output$richnessd = beta.richnessd



  if(heatmap)


  {

    # Switch based on the type of partitioning component specified

    switch(component,

           # Processids

           'total' =

             {

               beta.data.plot = beta.total

             },

           # Sampleids

           'replace' =


             {

               beta.data.plot = beta.replace


             },

           "richnessd" =

             {

               beta.data.plot = beta.richnessd


             }


    )


    beta.bin.df=as.matrix(beta.data.plot,
                          labels=T)%>%
      data.frame(.)%>%
      dplyr::mutate(Row = rownames(.))%>%
      tidyr::pivot_longer(cols = -Row,
                          names_to = "Column",
                          values_to = "Value")%>%
      dplyr::filter(!is.na(Value))%>%
      dplyr::mutate(Value=round(Value,2),
                    index=row_number())


    output$beta.bin.df = beta.bin.df

    # If the data is grid based, grids on the heatmap are arranged based on distances between each grids (closest to farthest)

    if(grids)


    {

      if(is.null(grids.df))

      {

        stop("a grid dataframe must be provided if grids=TRUE")

        return(FALSE)

      }


      else if (!is.null(grids.df))

      {

      grids.data=grids.df

      }

      dist.grids<-st_distance(grids.data)

      rownames(dist.grids)<-grids.data$cell.id

      colnames(dist.grids)<-grids.data$cell.id

      dist.df=as.matrix(dist.grids,
                        labels=T)%>%
        data.frame(.)%>%
        dplyr::mutate(Row = rownames(.))%>%
        tidyr::pivot_longer(cols = -Row,
                            names_to = "Column",
                            values_to = "Value")%>%
        dplyr::filter(!is.na(Value))%>%
        dplyr::mutate(Value=round(Value,3),
                      index=row_number())


      combo_df<- beta.bin.df%>%
        left_join(dist.df,
                  join_by(Row,Column,index))%>%
        # dplyr::select(-contains("Row_leftjoined"),
        #               -matches("Column_leftjoined"))%>%
        dplyr::arrange(Value.y)%>%
        dplyr::rename("Value"="Value.x")


      beta.base.heatmap=heatmap=combo_df%>%
        ggplot(aes(reorder(Row,
                           Value.y),
                   reorder(Column,
                           Value.y),
                   fill= Value)) +
        geom_tile(color = "white",
                  lwd = 0.1,
                  linetype = 1)

     }

    else if (grids==FALSE && !is.null(grids.df))

    {

      stop("grids.df is specified when grids=FALSE. Please re-check the input")


    }

    else

    {


      beta.base.heatmap=beta.bin.df%>%
        ggplot(aes(Row,
                   Column,
                   fill= Value)) +
        geom_tile(color = "white",
                  lwd = 0.1,
                  linetype = 1)


    }


    ## Add a if condition by which if the rownames contain the "cell.id", it would use similar

    heatmap_final= beta.base.heatmap +
      coord_fixed() +
      geom_text(aes(label = Value),
                color = "white",
                size = 2.5) +
      scale_fill_gradient(low="#E66100",
                          high="#006CD1")+
      scale_x_discrete(expand = c(0,0))+
      scale_y_discrete(expand = c(0,0))+
      guides(fill=guide_legend("Beta diversity values"))+
      theme_light()+
      theme(axis.title.x = element_blank(),
            axis.title.y = element_blank(),
            axis.text.x = element_text(angle = 90))+
      ggtitle("Heatmap of beta diversity values")



    output$heatmap.viz = heatmap_final



  }

  invisible(output)


}
