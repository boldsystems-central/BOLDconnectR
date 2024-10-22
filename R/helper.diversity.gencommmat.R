#' Create a community matrix based on BINs abundances/incidences
#'
#' @description
#' This function generates a community matrix (~site X species) using the data retrieved [bold.fetch()] based on BIN abundances/incidences.
#'
#' @param bold.df the bold ‘data.frame’ generated from [bold.fetch()].
#' @param taxon.rank A single character value specifying the taxonomic hierarchical rank. Needs to be provided by default.
#' @param taxon.name A single or multiple character vector specifying the taxonomic names associated with the ‘taxon.rank’. Default value is NULL.
#' @param site.cat A single or multiple character vector specifying the countries for which a community matrix should be created. Default value is NULL.
#' @param grids A logical value specifying Whether the community matrix should be based on grids as ‘sites’. Default value is NULL.
#' @param gridsize A numeric value of the size of the grid if the grids=TRUE;Size is in sq.m. Default value is NULL.
#' @param pre.abs A logical value specifying whether the generated matrix should be converted into a 'presence-absence' matrix.
#' @param view.grids A logical value specifying viewing the grids overlaid on a map with respective cell ids. Default value is FALSE.
#'
#' @details The function transforms the [bold.fetch()] downloaded data into a site X species like matrix. Instead of species counts (or abundances) though, values in each cell are the counts (or abundances) of a specific BIN from a `site.cat` site category or a ‘grid’. These counts can be generated at any taxonomic hierarchical level for a single or multiple taxa (This can also be done for 'bin_uri'; the difference being that the numbers in each cell would be the number of times that respective BIN is found at a particular `site.cat` or 'grid'). `site.cat` can be any of the `geography` fields (Meta data on fields can be checked using the [bold.fields.info()]). Alternatively, `grids` = TRUE will generate grids based on the BIN occurrence data (latitude, longitude) with the size of the grid determined by the user (in sq.m.). For `grids` generation, rows with no latitude and longitude data are removed (even if a corresponding `site.cat` information is available) while NULL entries for `site.cat` are allowed if they have a latitude and longitude value (This is done because grids are drawn based on the bounding boxes which only use latitude and longitude values).`grids` converts the Coordinate Reference System (CRS) of the data to a ‘Mollweide' projection by which distance based grid can be correctly specified. A cell id is also given to each grid with the lowest number assigned to the lowest latitudinal point in the dataset. The cellids can be changed as per the user by making changes in the `grids_final` `sf` data frame stored in the output. The grids can be visualized with `view.grids`=TRUE. The plot obtained is a visualization of the grids with their respective names. Please note that a) if the data has many closely located grids, visualization with `view.grids` can get confusing. The argument `pre.abs` will convert the counts (or abundances) to 1 and 0. This dataset can then directly be used as the input data for functions from packages like `vegan` for biodiversity analyses.
#'
#' @returns An 'output' list containing:
#' * comm.matrix = A site X species like matrix based on BINs.
#' * grids = A `sf` data frame containing the grid geometry and corresponding cell id.
#' * grid_plot = A grid_plot overlaid on a world map with cell ids.
#'
#' @importFrom reshape2 dcast
#' @importFrom httr POST
#' @importFrom dplyr bind_rows
#' @importFrom tidyr all_of
#' @importFrom tidyr  separate
#' @importFrom tidyr unite
#' @importFrom dplyr if_any
#' @importFrom dplyr between
#' @importFrom sf st_crs
#' @importFrom sf st_read
#' @importFrom sf st_transform
#' @importFrom sf st_simplify
#' @importFrom sf st_as_sf
#' @importFrom sf st_bbox
#' @importFrom sf st_as_sfc
#' @importFrom sf st_make_grid
#' @importFrom sf st_intersects
#' @importFrom sf st_sf
#' @importFrom ggplot2 theme_minimal
#' @importFrom ggplot2 geom_sf_text
#' @importFrom ggplot2 labs
#' @importFrom stats as.formula
#' @importFrom rnaturalearth ne_countries
#'
#' @keywords internal
#'
# This function is used by
# #1. bold.analyze.diversity
#
gen.comm.mat<-function(bold.df,
                       taxon.rank,
                       taxon.name=NULL,
                       site.cat=NULL,
                       grids=FALSE,
                       gridsize=NULL,
                       pre.abs=FALSE,
                       view.grids=FALSE)
{

  # Check if data is a non empty data frame object

  df_checks(bold.df)

  # Empty list for output

  output = list()

 # Taxon rank condition to get the necessary data

  if(is.null(taxon.rank)) stop("Taxon rank cannot be empty.")

  if(!any(names(bold.df) %in% presets('taxonomy')[3:11,])) stop ("Please re-check if the required taxonomic fields are available in the dataset.")

  # Obtaining the data from the fetched data for the transformation. NAs in site.cat and taxon.rank are removed

  bin.comm.trial=bold.df%>%
    convert_coord_2_lat_lon(.)%>%
    dplyr::select(matches("bin_uri$",
                          ignore.case=TRUE),
                  matches("lat$",
                          ignore.case=TRUE),
                  matches("lon$",
                          ignore.case=TRUE),
                  !!site.cat,
                  !!taxon.rank)%>%
    dplyr::filter(!is.na(bin_uri))%>%
    tidyr::drop_na(!!site.cat)%>%
    #dplyr::filter(!(!!site.cat==""))%>%
    dplyr::arrange(!!site.cat)

  #bin.comm.trial=bin.comm.trial[!is.na(bin.comm.trial[[taxon.rank]]), ]

  # Is site.cat is provided

  if(!is.null(site.cat))
  {
    bin.comm.trial=bin.comm.trial

    dcast.formula=as.formula(paste(site.cat,"~",taxon.rank))
  }
  # If grids and gridsize are provided

  else if (is.null(site.cat) && all(grids==TRUE & !is.null(gridsize)))
  {
    bin.comm.trial=bin.comm.trial

    mollweide<-st_crs("+proj=moll +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84")

  # Creating a Spatial data frame based filtered data above

    data_sf<-st_as_sf(x=bin.comm.trial,
                      coords = c("lon","lat"),
                      crs=4326,
                      remove=FALSE,
                      na.fail = FALSE)%>%
      st_simplify(dTolerance = 0.001)%>%
      st_transform(.,
                   crs = mollweide)

    if(length(unique(data_sf$geometry))<2) stop("There arent enough distinct geographical points for creating an effective grid.Please re-check the data or use site_type + location_type categories instead.")

    bbox_data<-st_bbox(data_sf)%>%
      st_as_sfc(.)

    # Creating a square grid based on the bounding box and the cellsize provided by the user. Cellsize here represents distance in sq. meters.

    data_sf_grid <- tryCatch({
      st_make_grid(bbox_data,
                   cellsize = gridsize,
                   what = 'polygons',
                   square = TRUE) %>%
        st_simplify(dTolerance = 0.001) %>%
        st_transform(.,
                     crs = mollweide)
    },
    error = function(e)
    {
      message(paste("An error occurred while creating the grids: ", e$message))
      stop("This could likely be due to the very small grid size being added. Please select a bigger area for grids")
    }
    )

    # Generating an index of the grids which overlap the sampled data

    grids_selected_indexes<-st_intersects(data_sf_grid,
                                          data_sf,
                                          sparse = TRUE)

    # Using the index to filter the spatial data to obtain the grids for the input data. st_centroid is used to get a c

    grids_selected<-data_sf_grid[lengths(grids_selected_indexes)>0]%>%
      st_sf(.)%>%
      dplyr::mutate(index=1:nrow(.))%>%  # Generating a row id based on the selected grids
      dplyr::mutate(cell.id=paste("cell",
                                  "_",
                                  index,
                                  sep=''))

    # Extracting out the input data based on the filtered data

    bin.comm.trial=suppressWarnings(st_intersection(data_sf,
                                                    grids_selected,
                                                    sparse = T))

    # Adding the grid cell ids and removing the grid numbers

    grids_final=grids_selected%>%
      dplyr::select(geometry,
                    cell.id)
    # Adding the grid data to the output

    output$grids=grids_final

    # Formula for cell id and taxon rank

    dcast.formula=as.formula(paste("cell.id","~",taxon.rank))

  }
  else if (grids==TRUE & is.null(gridsize)) stop("If grids = TRUE, gridsize needs to be specified")

  else if (!is.null(site.cat) & grids==TRUE|!is.null(gridsize)) stop("Either site.cat or grid information should be used at one time")

  # The long to wide function which converts the long data into wide one by taking the counts of BINS based on the site category or grid cells and the taxon rank used

  long.2.wide.coversn = function (df,
                                  dcast.form)

  {
    result.df=df%>%
      reshape2::dcast(dcast.formula,
                      value.var = "bin_uri",
                      fun.aggregate = length)|>
      data.frame()
  }


  result=long.2.wide.coversn(bin.comm.trial,
                             dcast.form = dcast.formula)

  ## If the grids are used, the following code first checks if cell.id column is present. then it separates the numbers from the names,arranges it in a ascending fashion and then re-unites it with the 'cell' word

  if (any(colnames(result)=="cell.id"))

  {
    result=result%>%
      data.frame()%>%
      tidyr::separate(cell.id,
                      sep="_",
                      into = c("cell","index"))%>%
      dplyr::mutate(index=as.numeric(index))%>%
      dplyr::arrange(index)%>%
      tidyr::unite(cell.id,
                   cell:index,
                   remove = T)
  }

  else

  {
    result = result
  }

  # If grids.view=T

  if(view.grids)

  {
    if(grids==TRUE & is.null(gridsize)) stop("Grids can be viewed only when grids = T and gridsize is specified")

    overview_map <- rnaturalearth::ne_countries(scale = 110)

    overview_map<-st_transform(overview_map,crs = st_crs(grids_final))

    grid_plot=ggplot(data=overview_map) +
      geom_sf(linewidth=0.3,
              col='#011B26',
              fill='white') +
      geom_sf(data = grids_final,
              linewidth=0.3,
              col="#011B26",
              fill='white',
              alpha=0.4) +
      geom_sf_text(data = grids_final,
                   aes(label = cell.id),
                   size = 2.5,
                   col='#011B26',
                   alpha=0.7,
                   nudge_y = 300000) +
      theme_minimal(base_size = 15) +
      labs(title = "Grid map of the data",
           x = "Longitude",
           y = "Latitude")

    output$grid_plot = grid_plot

    # Adding the grid data to the output

    output$grids=grids_final

  }

  # convert the site.cat/cell.id to rownames

  rownames(result)=result[,1]

  # Remove the column

  result = result%>%
    dplyr::select(-1)

  output$comm.matrix = result

  invisible(output)

}
