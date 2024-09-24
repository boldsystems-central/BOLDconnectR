#'Define and select column presets from the BCDM data
#'
#' @importFrom dplyr pull
#'
#' @keywords internal
#'
presets<-function(col_groups)
{
  bold_fields<-bold.fields.info()

  bold_fields[which(bold_fields$field=='country/ocean'),]<-"country.ocean"

  bold_fields[which(bold_fields$field=='province/state'),]<-"province.state"

  common_ids<-c("processid","sampleid")

  switch(col_groups,

         "public.data.fields"=
           {
             preset<-bold_fields%>%
               dplyr::select(field)%>%
               dplyr::filter(field %in% c(common_ids))
           },
         "taxonomy" =
           {
             preset<-bold_fields%>%
               dplyr::select(field)%>%
               dplyr::filter(field %in% c(common_ids,
                                          "kingdom",
                                          "phylum",
                                          "class",
                                          "order",
                                          "family",
                                          "subfamily",
                                          "genus",
                                          "species",
                                          "bin_uri"))
           },
         "geography" =
           {
             preset<-bold_fields%>%
               dplyr::select(field)%>%
               dplyr::filter(field %in% c(common_ids,
                                          "country.ocean",
                                          "country_iso",
                                          "province.state",
                                          "region",
                                          "sector",
                                          "site",
                                          "site_code",
                                          "coord",
                                          "coord_accuracy",
                                          "coord_source"))
           },
         "sequences"=
           {
             preset<-bold_fields%>%
               dplyr::select(field)%>%
               dplyr::filter(field %in% c(common_ids,
                                          "nuc",
                                          "nuc_basecount",
                                          "marker_code",
                                          "sequence_run_site",
                                          "sequence_upload_date"))
           },
         "attributions"=
           {
             preset<-bold_fields%>%
               dplyr::select(field)%>%
               dplyr::filter(field %in% c(common_ids,
                                          "inst",
                                          "identification",
                                          "identification_method",
                                          "identification_rank",
                                          "identified_by",
                                          "collectors"))
           },
         "ecology_biogeography"=
           {
             preset<-bold_fields%>%
               dplyr::select(field)%>%
               dplyr::filter(field %in% c(common_ids,
                                          "elev",
                                          "elev_accuracy",
                                          "depth",
                                          "depth_accuracy",
                                          "habitat",
                                          "ecoregion",
                                          "biome",
                                          "realm",
                                          "coord",
                                          "coord_source"))
           },
         "other_meta_data"=
           {

             preset<-bold_fields%>%
               dplyr::select(field)%>%
               dplyr::filter(field %in% c(common_ids,
                                          "notes",
                                          "taxonomy_notes",
                                          "funding_src",
                                          "voucher_type",
                                          "tissue_type",
                                          "sampling_protocol"))
           },

         "bold_analyze_align_fields" =
           {

             preset<-bold_fields%>%
               dplyr::select(field)%>%
               dplyr::filter(field %in% c(common_ids,
                                          "marker_code",
                                          "nuc"))
           },
         "bold_analyze_tree_fields" =
           {

             preset<-data.frame(field = c("processid",
                                          "aligned_seq",
                                          "msa.seq.name"))
           },
         "bol_analyze_map_fields" =
           {

             preset<-bold_fields%>%
               dplyr::select(field)%>%
               dplyr::filter(field %in% c(common_ids,
                                          "bin_uri",
                                          "marker_code",
                                          "nuc"))
           }

  )

  return(preset)

}
# The function to check and return the data with the necessary columns

check_and_return_preset_df<-function (df,
                                      category = c("check","check_return"),
                                      preset)
{

  preset = presets(col_groups = preset)

  preset_col = preset%>%
    dplyr::pull(field)


  switch (category,


          "check" =

            {

              if(!any(preset_col %in% names(df)))
              {
                stop("Please re-check if column names match with the available field names for BCDM dataframe and that minimum field requirement for the analysis is satisfied. Please read the details section of 'bold.export' help for more information on presets.")

              }
            },

          "check_return" =

            {

              if(!any(preset_col %in% names(df)))
              {
                stop("Please re-check if column names match with the available field names for the BCDM dataframe and that minimum field requirement for the analysis is satisfied. Please read the details section of 'bold.export' help for more information on presets.")
              }
              else
              {
                preset_df = df%>%
                  dplyr::select(all_of(preset_col))

              }
              return(preset_df)
            }
  )

}
