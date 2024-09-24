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
#' @details The function transforms the [bold.fetch()] downloaded data into a site X species like matrix. Instead of species counts (or abundances) though, values in each cell are the counts (or abundances) of a specific BIN from a `site.cat` site category or a ‘grid’. These counts can be generated at any taxonomic hierarchical level for a single or multiple taxa (This can also be done for 'bin_uri'; the difference being that the numbers in each cell would be the number of times that respective BIN is found at a particular `site.cat` or 'grid'). `site.cat` can be any of the `geography` fields (Meta data on fields can be checked using the [bold.fields.info()]). Alternatively, `grids` = TRUE will generate grids based on the BIN occurrence data (latitude, longitude) with the size of the grid determined by the user (in sq.m.). For `grids` generation, rows with no latitude and longitude data are removed (even if a corresponding `site.cat` information is available) while NULL entries for `site.cat` are allowed if they have a latitude and longitude value (This is done because grids are drawn based on the bounding boxes which only use latitude and longitude values).`grids` converts the Coordinate Reference System (CRS) of the data to a ‘Mollweide' projection by which distance based grid can be correctly specified. A cell id is also given to each grid with the lowest number assigned to the lowest latitudinal point in the dataset. The cellids can be changed as per the user by making changes in the `grids_final` `sf` data frame stored in the output. The grids can be visualized with `view.grids`=TRUE. The plot obtained is a visualization of the grid centroids with their respective names. Please note that a) if the data has many closely located grids, visualization with `view.grids` can get confusing. The argument `pre.abs` will convert the counts (or abundances) to 1 and 0. This dataset can then directly be used as the input data for functions from packages like `vegan` for biodiversity analyses.
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
#' @importFrom sf st_centroid
#' @importFrom rnaturalearth ne_countries
#' @importFrom ggplot2 theme_minimal
#' @importFrom ggplot2 geom_sf_text
#' @importFrom ggplot2 labs
#' @importFrom stats as.formula
#'
#' @keywords internal
#'
gen.comm.mat<-function(bold.df,
                            taxon.rank,
                            taxon.name=NULL,
                            site.cat=NULL,
                            grids=FALSE,
                            gridsize=NULL,
                            pre.abs=FALSE,
                            view.grids=FALSE)
{


  # Check if data is a data frame object

  if(is.data.frame(bold.df)==FALSE)

    {
    stop("Input is not a data frame")
  }

  # Check whether the data frame is empty

  if(nrow(bold.df)==0)

    {
    stop("Dataframe is empty")
  }


  # if the site category is not null

  if (!(is.null(site.cat)))

  {
    # The following columns have to be present in the input data frame in order to get the results

    if(any((c("bin_uri",taxon.rank,site.cat)%in% names(bold.df)))==FALSE)

    {
      stop("bin ids, taxon rank & site.cat fields have to be present in the dataset. Please re-check data")
    }
  }

  # If site category is not specified but grids are TRUE

  else if (is.null(site.cat) & !is.null(grids))
  {
    # The following columns have to be present in the input data frame in order to get the results

    if(any((c("bin_uri",taxon.rank,"lat","lon")%in% names(bold.df)))==FALSE)

    {
      stop("bin ids, taxon rank, latitude and longitude columns have to be present in the dataset for defining grids. Please re-check data")
      }
  }

 # Empty list for output

  output = list()

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
    dplyr::arrange(!!site.cat)

  bin.comm.trial=bin.comm.trial[!is.na(bin.comm.trial[[taxon.rank]]), ]

  ## Taxon rank condition to get the necessary data


  if(is.null(taxon.rank))

  {
    ## Taxon rank cannot be empty

    warning ("Taxon rank cannot be empty")

  }

  # Condition for when Taxon rank is specified but taxon name not specified

  else if (!is.null(taxon.rank) & is.null(taxon.name))


  {

    bin.comm.trial=bin.comm.trial

  }

  # Condition for when both Taxon rank and taxon name are specified

  else if(!is.null(taxon.rank) & !is.null(taxon.name))


  {
    # The taxon name/s are filtered

    bin.comm.trial=bin.comm.trial%>%
      dplyr::filter(!!sym(taxon.rank)%in% taxon.name)
  }


  # The formula used for converting long to wide data

  dcast.formula=as.formula(paste(site.cat,"~",taxon.rank))

  # If the site category is not specified

  if(is.null(site.cat))


  {
    # if Grids is TRUE and grid size is defined

    if (grids==TRUE & !is.null(gridsize))

    {

      # NA lat lon values are filtered out

      bin.comm.trial=bin.comm.trial%>%
        dplyr::filter(!(is.na(lat))|!(is.na(lon)))

      # In case the resulting data is empty

      if (nrow(bin.comm.trial)==0)

      {
        stop("Dataset is empty.This could be due to no latitude and longitude data available for the taxa selected in the dataset")

         }

      # If the dataset is not empty

      else

      {

        # Mollweide CRS variable (This projection is used so that gridsize can be defined as a distance metric)

        mollweide<-st_crs("+proj=moll +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84")

        # Creating a Spatial data frame based filtered data above

        data_sf<-st_as_sf(x=bin.comm.trial,
                          coords = c("lon","lat"),
                          crs=4326,
                          remove=FALSE)%>%
          st_simplify(dTolerance = 0.001)%>%
          st_transform(.,
                       crs = mollweide)

        ## If the geometry ( lat lon points) are unique (as in just one location),bbox  drawing a grid subsequently wont be possible. A check for that

        if(length(unique(data_sf$geometry))<2)

        {

          stop("There arent enough distinct geographical points for creating an effective grid.Please re-check the data or use any of ther other site.cat categories instead")

        }


        # Creating a bounding box based on the geographical extent of the input data

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
          # arrange(grid_cent)%>%
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

      }

      # Formula for cell id and taxon rank

      dcast.formula=as.formula(paste("cell.id","~",taxon.rank))

    }

    # In case grids = FALSE and still grid size is provided

    else if (grids==TRUE & is.null(gridsize))

    {
      stop("If grids = TRUE, gridsize needs to be specified")
    }

  }

  # If site.cat is not null and grids = T or gridsize is given

  else if (!is.null(site.cat) & grids==TRUE|!is.null(gridsize))

  {
    stop("Either site.cat or grid information should be used at one time")
}

 else

    # If the site.cat is not null, bin.comm.trial created at the taxon condition level will be returned

  {

    bin.comm.trial=bin.comm.trial

    dcast.formula=as.formula(paste(site.cat,"~",taxon.rank))

  }


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

  if(view.grids)

  {
    if(grids==TRUE & is.null(gridsize))

    {
      stop("Grids can be viewed only when grids = T and gridsize is specified")

     }

    else

    {

      overview_map <- rnaturalearth::ne_countries(scale = 110)

      overview_map<-st_transform(overview_map,crs = st_crs(grids_final))

      centroids_for_mapping = suppressWarnings(st_centroid(grids_final))

      grid_plot=ggplot(data=centroids_for_mapping) +
        geom_sf(color="black",
                fill="gray90",
                alpha=0.2) +
          geom_sf(#fill="steelblue",
          pch=0,
          color="black",
          size=5,
          stroke=1,
          alpha=0.7) +
        geom_sf(data = overview_map,
                alpha=0.3,
                linewidth=0.4) +
        geom_sf_text(aes(label = cell.id),
                     size = 3.5,
                     nudge_y = 300000) +
        theme_minimal(base_size = 15) +
        labs(title = "Grid positions (approximate) for the data",
             x = "Longitude",
             y = "Latitude")

      output$grid_plot = grid_plot

      # Adding the grid data to the output

      output$grids=grids_final%>%
        dplyr::mutate(centroid=centroids_for_mapping$geometry)

    }

  }

  # convert the site.cat/cell.id to rownames

  rownames(result)=result[,1]

  # Remove the column

  result = result%>%
    dplyr::select(-1)

 output$comm.matrix = result

  invisible(output)

}
