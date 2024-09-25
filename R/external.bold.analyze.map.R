#' Visualize BIN occurrence data on maps
#'
#' @description
#' This function creates basic maps of BIN occurrence data at different scales.
#'
#' @export
#'
#' @param bold_df The data.frame retrieved from [bold.fetch()].
#' @param country A single or multiple character vector of country names. Default value is NULL.
#' @param bbox  A numeric vector specifying the min, max values of the latitude and longitude. Default value is NULL.
#'
#' @details `bold.analyze.map` extracts out the geographic information from the [bold.fetch()] output to generate an occurrence map. Data points having NA values for either latitude or longitude or both are removed. Latitude and longitude values are in ‘decimal degrees’ format with a ’WGS84’ Coordinate Reference System (CRS) projection. Default view includes data mapped onto a world shape file using the `rnaturalearth::ne_countries()` at a 110 scale (low resolution). If the country is specified (single or multiple values), the function will specifically plot the occurrences on the specified country. Alternatively, a bounding box (bbox) can be defined for a specific region to be visualized. The function also provides a `sf` data frame of the GIS data which can be used for any other application/s.
#'
#' @returns An 'output' list containing:
#' *	geo.df = A simple features (sf) ‘data.frame’ containing the geographic data.
#' *	plot = A visualization of the occurrences.
#'
#' @examples
#' \dontrun{
#' #Download the ids
#' geo_data.ids <- bold.public.search(taxonomy = "Musca domestica")
#'
#' # Fetch the data using the ids.
#' #1. api_key must be obtained from BOLD support before usage
#' #2. the function `bold.apikey` should be used to set the apikey in the global env
#'
#' geo_data <- bold.fetch(get_by = "processid",
#'                        identifiers = geo_data.ids$processid)
#'
#' # All data plotted.
#' geo.viz <- bold.analyze.map(geo_data)
#' # View plot
#' geo.viz$plot
#' # Data plotted only in one country
#' geo.viz.country <- bold.analyze.map(geo_data,
#'                                     country = c("Saudi Arabia"))
#' # View plot
#' geo.viz.country$plot
#' # The sf dataframe of the downloaded data
#' geo.viz$geo.df
#'}
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
bold.analyze.map<-function(bold_df,
                       country=NULL,
                       bbox=NULL)
{


  # Check if data is a data frame object

  if(is.data.frame(bold_df)==FALSE)
  {
    stop("Input is not a data frame")
  }

  # Check whether the data frame is empty

  if(nrow(bold_df)==0)
    {
    stop("Dataframe is empty")
  }

  # Output list (empty)

  output = list()

  # Select the necessary columns preset for the analysis along with a check to see if the requisite columns are present

  geo_df = check_and_return_preset_df(df=bold_df,
                                      category = "check_return",
                                      preset = 'geography')

  # Convert the 'coord' column into lat and lon for mapping and create a 'sf' data frame. All lat lon NA values are removed by default. CRS is 4326

  geo_data = convert_coord_2_lat_lon(geo_df)%>%
    dplyr::filter(!is.na(lat),
                  !is.na(lon))%>%
    #dplyr::filter(!is.na(bin_uri))%>%
    st_as_sf(.,
             coords = c("lon","lat"),
             crs=4326,
             remove=FALSE)%>%
    st_simplify(dTolerance = 0.001)


  # Generate a base map with a low resolution

  map_data <- rnaturalearth::ne_countries(scale = 110)

  # IF country is not specified. All points will be mapped by default on a world map

  if(is.null(country))

  {
    bin.geo.df<-geo_data
  }

  else
    # Specific countries that are listed in the function will be mapped
  {

    bin.geo.df<-geo_data%>%
      dplyr::filter(country.ocean %in% !!country)

   # US names mismatch is corrected

    map_data[which(map_data$name_en=="United States of America"),"name_en"]<-"United States"

    map_data<-map_data%>%
      dplyr::filter(name_en %in% !!country)

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

    output$geo.df=bin.geo.df

    output$plot=map_plot

  print(map_plot)

  invisible(output)

}
