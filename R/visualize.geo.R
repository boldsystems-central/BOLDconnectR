#' Visualize organism occurrence data on maps
#'
#' #' @description
#' This function creates basic maps of organism occurrence data on different scales
#'
#' @export
#'
#' @param bold.df the data.frame retrieved from the connectr functions
#' @param country A single or multiple character vector of country names. Default is NULL
#' @param bbox  A numeric vector specifying the min,max values of the latitude and longitude. Default is NULL
#' @param export A logical value asking if the output should be exported locally
#' @param file.type A character value specifying the type of file to be exported. Currently ‘.csv’ and ‘.tsv’ options are available
#' @param file.path A character value specifying the folder path where the file should be saved
#' @param file.name A character value specifying the name of the exported file.
#'
#' @details ‘visualize.geo’ extracts out the geographic information from the ‘connectr’ output. Data points having NA values for either latitude or longitude or both are removed. Latitude and longitude values are in ‘decimal degrees’ format. Default view includes data mapped on a world shapefile downloaded using the ‘rnaturalearth’ library. If the ‘country’ is specified (single or multiple values), the function will specifically plot the occurrences on the specified country. Alternatively, a bounding box can be defined for a specific region to be visualized. If export = TRUE, an image file will be saved based on the type (jpg, tiff), and file path. The function also provides a ‘sf’ data frame of the GIS data which can be used for any other application/s
#'
#' @returns
#' geo.df = A  simple features (sf) ‘data.frame’ containing the geographic data
#' map_plot = A visualization of the occurrences
#'
#' @importFrom sf st_as_sf
#' @importFrom sf st_simplify
#' @importFrom rnaturalearth ne_countries
#' @importFrom sf st_set_crs
#' @importFrom ape njs
#' @importFrom ape write.tree
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 geom_sf
#' @importFrom ggplot2 geom_point
#' @importFrom ggplot2 theme_bw
#' @importFrom ggplot2 theme
#' @importFrom ggplot2 ggtitle
#' @importFrom ggplot2 coord_sf
#' @importFrom ggplot2 ggsave
#' @importFrom ggplot2 aes
#' @importFrom ggplot2 element_line
#' @importFrom ggplot2 xlab
#' @importFrom ggplot2 ylab
#'
#' @export
#'
visualize.geo<-function(bold.df,
                       country=NULL,
                       bbox=NULL,
                       export=FALSE,
                       file.path=NULL,
                       file.name=NULL,
                       file.type=NULL)
{


  # Check if data is a data frame object

  if(is.data.frame(bold.df)==FALSE) {

    stop("Input is not a data frame")

    return(FALSE)

  }

  # Check whether the data frame is empty

  if(nrow(bold.df)==0) {

    stop("Dataframe is empty")

    return(FALSE)

  }

  # Output list (empty)

  output = list()


  # Keep a check to see if the requisite columns are present and give an error if not

  # Select the specific geo spatial related fields from the data to create a 'sf' data frame. All lat lon NA values are removed by default. CRS is 4326

  geo.data=bold.df%>%
    dplyr::select(matches("^processid$",
                          ignore.case=TRUE),
                  matches("^bin_uri$",
                          ignore.case=TRUE),
                  matches("^lat$",
                          ignore.case=TRUE),
                  matches("^lon$",
                          ignore.case=TRUE),
                  matches("^country.ocean$",
                          ignore.case=TRUE),
                  matches("^province.state$",
                          ignore.case=TRUE),
                  matches("^region$",
                          ignore.case=TRUE),
                  matches("^sector$",
                          ignore.case=TRUE),
                  matches("^site$",
                          ignore.case=TRUE))%>%
    dplyr::filter(!is.na(lat),
                  !is.na(lon))%>%
    #dplyr::filter(!is.na(bin_uri))%>%
    st_as_sf(.,
             coords = c("lon","lat"),
             crs=4326,
             remove=FALSE)%>%
    st_simplify(dTolerance = 0.001)



  # IF country is not specified. All points will be mapped by default on a world map

  if(is.null(country))

  {

    bin.geo.df<-geo.data

    map_data <- rnaturalearth::ne_countries(scale = 110)

  }

  else

    # Specific countries that are listed in the function will be mapped

  {

    bin.geo.df<-geo.data%>%
      dplyr::filter(country.ocean %in% !!country)

    map_data<-rnaturalearth::ne_countries(country = country,
                                          scale = 110)

    map_data <- st_set_crs(map_data,
                           4326)

  }


  # plot


  map_plot<-ggplot() +
    geom_sf(data = map_data,
            alpha=0.3,
            linewidth=0.4) +
    geom_point(data = bin.geo.df,
               mapping = aes(x = lon,
                             y = lat),
               colour = "black",
               fill="orangered2",
               size=3,
               pch=21) +
    theme_bw(base_size = 15) +
    theme(panel.grid.major = element_line(colour = 'grey50',
                                          size = 0.3,
                                          linetype = 3))+
    xlab("Longitude")+
    ylab("Latitude") +
   coord_sf(expand = FALSE) +
  ggtitle("Distribution map")
   # scale_y_continuous(limits = c(-80, 80))


  # If a specific region is defined by a bbox

  if(!is.null(bbox))

  {

    # first two elements of the bbox are lon values (xmin and xmax) and the remaining two are lat values (ymin and ymax)

    lon_coord = bbox[1:2]

    lat_coord = bbox[3:4]

    # Using the default map created above, a specific part of that map is the plotted

    map_plot<-map_plot +
      coord_sf(xlim = lon_coord,
               ylim = lat_coord)

  }

  else

  {

    map_plot<-map_plot

  }

  # If map needs to be saved. Type will be all the formats available through 'ggsave'

  if(export==TRUE)

  {

    if(is.null(file.path)|is.null(file.name)|is.null(file.type))

    {

      warning("The file name, type and the path must be specified if export = TRUE")

      return(FALSE)

    }

    else

      {

    ggplot2::ggsave(filename=paste(file.name,
                                   ".",
                                   file.type,
                                   sep = ""),
                    plot=map_plot,
                    path = file.path,
                    device = file.type,
                    width = 10,
                    height = 3)

        }



    output$geo.df=bin.geo.df

    output$plot=map_plot

  }


  else if (export==FALSE && !(is.null(file.path))|!(is.null(file.name))|!(is.null(file.type)))

  {


    stop("File name, type and path have been specified when export = FALSE. Please re-check the input")

    return(FALSE)


  }


  else

  {

    output$geo.df=bin.geo.df

    output$plot=map_plot

    print(map_plot)


  }

  invisible(output)

}
