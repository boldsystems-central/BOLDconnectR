#' Filters for specific parameters to customize the search for private data
#'
#' @param bold.df the output from the connectr functions
#' @param taxon.name A single character string or a vector of taxonomic names at any hierarchical level. Default value is NULL
#' @param location.name A single character string or a vector of  country/province/state/region/sector/site names/codes. Default value is NULL.
#' @param latitude A number or a vector of two numbers indicating the latitudinal range. Values separated by a comma. Default value is NULL.
#' @param longitude A number or a vector of two numbers indicating the longitudinal range. Values separated by a comma. Default value is NULL.
#' @param shapefile A file path pointing to a shapefile or name of the shapefile imported in the session. Default value is NULL.
#' @param institutes A character string or a vector specifying names of institutes. Default value is NULL.
#' @param identified.by A character string or a vector specifying names of people responsible for identifying the organism. Default value is NULL.
#' @param seq.source A character string or a vector specifying data portals from where the (sequence) data was mined. Default value is NULL.
#' @param marker A character string or a vector specifying  of gene names. Default value is NULL.
#' @param collection.period A Date or a vector of two values specifying the collection period range (start, end). Values separated by comma. Default value is NULL.
#' @param basecount A number or a vector of two numbers indicating the base pairs number range. Values separated by a comma. Default value is NULL.
#' @param altitude A number or a vector of two numbers indicating the altitude range. Values separated by a comma. Default value is NULL.
#' @param depth A number or a vector of two numbers indicating the depth range. Values separated by a comma. Default value is NULL.
#' @keywords internal

bold.connectr.filters<-function (bold.df,
                                 taxon.name=NULL,
                                 location.name=NULL,
                                 latitude=NULL,
                                 longitude=NULL,
                                 shapefile=NULL,
                                 institutes=NULL,
                                 identified.by=NULL,
                                 seq.source=NULL,
                                 marker=NULL,
                                 collection.period=NULL,
                                 basecount=NULL,
                                 altitude=NULL,
                                 depth=NULL)
{

#1. specific taxon name

# condition to check if the taxon name is of the correct data type

if(!is.null(taxon.name))

{
  # condition to check if taxonomy filters are of the correct data type

  stopifnot(is.character(taxon.name))

  # filter condition to select the specific taxon name.

  bold.df=bold.df%>%
    dplyr::filter(if_any(c("kingdom",
                           "phylum",
                           "class",
                           "order",
                           "family",
                           "subfamily",
                           "genus",
                           "species"),
                         ~.x %in% !!taxon.name))
}

#2. specific country/region/site/sector

if(!is.null(location.name))

{
  # condition to check if geography filters are of the correct data type

  stopifnot(is.character(location.name))

  bold.df=bold.df%>%
    dplyr::filter(if_any(c("country.ocean",
                           "province.state",
                           "region",
                           "sector",
                           "site"),
                         ~.x %in% !!location.name))
}

#3. Latitude

if(!is.null(latitude))

{
  # condition to check if Latitude is of the correct data type

  if(!is.numeric(latitude)) stop("Latitude should be a numeric data type")

  if(length(latitude)!=2) stop("Latitude should be a range separated by a comma (start date, end date)")

  # Latitude is a vector of length two giving a latitudinal extent

  latitude1=latitude[1]

  latitude2=latitude[2]

  bold.df=bold.df%>%
    convert_coord_2_lat_lon(.)%>%
    dplyr::filter(dplyr::between(lat,latitude1,latitude2))%>%
    dplyr::select(everything(),-c(lat,lon))

}

#5. Longitude


if(!is.null(longitude))

{

  # condition to check if Latitude is of the correct data type

  if(!is.numeric(longitude)) stop("longitude should be a numeric data type")

  if(length(longitude)!=2) stop("Longitude should be a range separated by a comma (start date, end date)")

  # Longitude is a vector of length two giving a longitudinal extent

  longitude1=longitude[1]

  longitude2=longitude[2]

  bold.df=bold.df%>%
    convert_coord_2_lat_lon(.)%>%
    dplyr::filter(dplyr::between(lon,longitude1,longitude2))%>%
    dplyr::select(everything(),-c(lat,lon))

}

#6. Shapefile data


if (!is.null(shapefile))

{

  # Check for whether the input is a read.delim file or a file path

  if(is.character(shapefile))

  {
    # make sure that the file is csv or txt

    if(!grepl("*.shp$",shapefile)) stop("Check input file. File should be a shapefile")

    # Input data as a file path. The shapefile is simplified to avoid large shapefile issues

    shp_input= suppressWarnings(suppressMessages(sf::st_read(shapefile)%>%st_simplify(dTolerance = 0.001)))

    shp_input = suppressWarnings(suppressMessages(st_transform(shp_input,4326)))

  }

  # If its a R object, condition to check if its a 'Simple features' object

  else if (class(shapefile)[1]=="sf")

  {
    # Import the csv data

    shp_input=shapefile

    shp_input = suppressWarnings(suppressMessages(st_transform(shp_input,4326)))

    shp_input=suppressWarnings(suppressMessages(shp_input%>%st_simplify(dTolerance = 0.001)))
  }

  else

  {
    stop("Please check the Input")
  }


  spatial.bold.df= suppressWarnings(suppressMessages(bold.df%>%
    convert_coord_2_lat_lon(.)%>%
    tidyr::drop_na(lat,lon)%>%
    sf::st_as_sf(x=.,
                 coords = c("lon","lat"),
                 crs=4326,
                 remove=FALSE)))

  spatial.bold.df=suppressWarnings(suppressMessages(st_transform(spatial.bold.df,
                               st_crs(shp_input))))

  bold.df=suppressWarnings(suppressMessages(st_intersection(spatial.bold.df,
                          shp_input)%>%
    sf::st_drop_geometry(.)%>%
    data.frame(.)))

}


#6. Institutes storing the specimen


if(!is.null(institutes))

{

  if(!is.character(institutes)) stop ("Institute names should be character")

  bold.df=bold.df%>%
    dplyr::filter(inst %in% !!institutes)

}


#7. Identified by


if(!is.null(identified.by))

{

  if(!is.character(identified.by)) stop ("identified by should be a character data type")

  bold.df=bold.df%>%
    dplyr::filter(identified_by %in% !!identified.by)
}


#8. sequence source


if(!is.null(seq.source))

{
  if(!is.character(seq.source)) stop ("Sequence source should be character")

  bold.df=bold.df%>%
    dplyr::filter(sequence_run_site %in% !!seq.source)
}


#9. Type of marker


if(!is.null(marker))

{

  if(!is.character(marker)) warning("Marker names should be character")

  bold.df=bold.df%>%
    dplyr::filter(marker_code %in% !!marker)

}


#10. basecount


if(!is.null(basecount))

{

  if(!is.numeric(basecount)) stop("Basecount/s should either be a single number of a range separated by a comma")

  if(length(basecount)==1)

  {

    bold.df=bold.df%>%
      dplyr::filter(nuc_basecount %in% basecount)

  }

  else if (length(basecount)==2)

  {

    first_val=basecount[1]

    last_val=basecount[2]

    bold.df=bold.df%>%
      dplyr::filter(if_all(nuc_basecount,
                           ~ between(.x,first_val,
                                     last_val)))
  }

  else

  {
    stop("Incorrect value input")
  }

}


if(!is.null(collection.period))

{

  if(as.Date(collection.period[1],"%Y-%m-%d")==FALSE & as.Date(collection.period[2],"%Y-%m-%d")==FALSE) stop ("Collection period should be a date object in %Y-%m-%d format ")

  if(length(collection.period)<2) stop ("Collection period should be a range of date data type separated by a comma (start date, end date)")

  start_date=as.Date(collection.period[1])

  end_date=as.Date(collection.period[2])

  bold.df=bold.df%>%
    dplyr::filter(if_all(c(collection_date_start,
                           collection_date_end),
                         ~ between(.x,start_date,
                                   end_date)))
}

#12. elevation

if(!is.null(altitude))

{

  if(is.numeric(altitude)==FALSE) stop("Altitude should either be a single number of a range separated by a comma")

  if(length(altitude)==1)

  {
    bold.df=bold.df%>%
      dplyr::filter(elev == altitude)
  }

  else if (length(altitude)==2)
  {

    first_val=altitude[1]

    last_val=altitude[2]

    bold.df=bold.df%>%
      dplyr::filter(if_all(elev,
                           ~ between(.x,first_val,
                                     last_val)))
    }

  else

  {
    stop("Please check input")
  }

}

#13. depth


if(!is.null(depth))

{

  if(!is.numeric(depth)) stop("Depth should either be a single number of a range separated by a comma")

  if(length(depth)==1)

  {
    bold.df=bold.df%>%
      dplyr::filter(depth == depth)
  }

  else if (length(depth)==2)

  {

    first_val=depth[1]

    last_val=depth[2]

    bold.df=bold.df%>%
      dplyr::filter(if_all(depth,
                           ~ between(.x,first_val,
                                     last_val)))
  }

  else

  {
    stop("Please check input")

  }

}
  return(bold.df)
}
