#'Generate specific summaries from the downloaded BCDM data
#'
#' @description
#' The function is used to obtain a different types of data summaries for the downloaded BCDM data via `bold.fetch` function.
#'
#' @param bold_df the data.frame retrieved from the `bold.fetch` function.
#' @param summary_type A single character value specifying the type of summary required (concise_summary, detailed_taxon_counts,barcode_summary,data_completeness,all)
#' @param primer_f A character vector specifying the forward primer. Default value is NULL.
#' @param primer_r A character vector specifying the reverse primer. Default value is NULL.
#' @param rem_na_bin A logical value specifying whether NA BINs should be removed from the BCDM dataframe. Default value is FALSE.
#'
#' @details
#' `bold.data.summarize` provides different types of data summaries for the downloaded BCDM dataset. The function uses the `skimr::skim()` function to generate summary metrics based on the data types available in the downloaded data. Summaries can be created by one of three `summarize_by` options, a) `all_data` that considers all data that is entered, b) `presets`that are defined set of columns representing a specific aspect of the BOLD BCDM data (currently available are: `taxonomy`, `geography`,`sequences`, `attributions`, `ecology_biogeography` and `other_meta_data`; For more information on the presets, please read the details for the `bold.export` function) and c) `fields` which lets the user select any specific columns. `na.rm`= TRUE removes all NA values (Please note that this might result into empty data frames sometimes due to lot of missing data). The summary includes detailed summary statistics (includes counts for NULL values, unique values and the proportion of complete cases), a bar chart showing some of these statistics, especially pertaining to the completeness of the data and a concise summary that has a high level dataset profile (number of rows, columns, data type). Both `presets` and `fields` are set to NULL by default. Please note that if the `cols` argument from [bold.fetch()] has been used to filter for specific columns, only those will be summarized even if `all_data` option is selected. Similarly, `presets` option will not work in cases where the input data by default doesn't have the respective fields. Units for some of the fields can be checked using the `bold.field.info()`. For specific details on the `skim` output, refer to the `skimr` package documentation.
#'
#'\emph{Note: }. Users are required to install and load the `Biostrings` package in case they want to generate the `barcode_summary` before running this function.
#'
#' @returns An output list containing:
#' * A data frame of detailed summary based on the `summary_type`
#' * A bar chart in case `summary_type=data_completeness` in addition to the dataframe.
#'
#' @examples
#' \dontrun{
#  # Download data
#' bold_data.ids <- bold.public.search(taxonomy = "Oreochromis")
#'
#' # Fetch the data using the ids.
#' #1. api_key must be obtained from BOLD support before using `bold.fetch` function.
#' #2. Use the `bold.apikey` function  to set the apikey in the global env.
#'
#' bold.apikey('apikey')
#'
#' bold.data <- bold.fetch(get_by = "processid",
#'                         identifiers = bold_data.ids$processid)
#'
#' #1. Generate a concise summary of the data
#'
#' test.data.summary.concise <- bold.data.summarize(bold_df=bold.data,
#'                                        summarize_type = "concise_summary")
#' # Result
#'  test.data.summary.concise$concise_summary
#'
#'
#' #2. Generate a detailed taxon counts summary
#'
#' test.data.summary <- bold.data.summarize(bold_df=bold.data,
#'                                          summarize_type = "detailed_taxon_counts")
#'
#' # Result
#' test.data.summary$detailed_taxon_counts
#'
#'
#' #3. Generate data completeness profile
#'
#' test.data.summary.completeness <- bold.data.summarize(bold_df=bold.data,
#'                                               summarize_type = "data_completeness")
#'
#' # Results
#' # Summary
#' test.data.summary.completeness$completeness_summary
#'
#' # Plot
#' test.data.summary.completeness$completeness_plot
#'
#'
#' #4. Barcode summary (forward primer LCO1490)
#' test.data.summary.barcode <- bold.data.summarize(bold_df=bold.data,
#'                                                 summarize_by = "barcode_summary",
#'                                                 primer_f='GGTCAACAAATCATAAAGATATTGG')
#'
#' # Results
#' test.data.summary.barcode$barcode_summary
#'}
#'
#' @export
#'
bold.data.summarize <- function(bold_df,
                                summary_type = c("concise_summary",
                                                 "detailed_taxon_counts",
                                                 "barcode_summary",
                                                 "data_completeness",
                                                 "all"),
                                primer_f=NULL,
                                primer_r=NULL,
                                rem_na_bin=FALSE)

{

  # Check if data is a data frame object

  df_checks(bold_df)

  # If data with no BINs should be removed

  if(rem_na_bin==TRUE)
  {
    bold_df = bold_df%>%
      drop_na(bin_uri)
  }
  else
  {
    bold_df
  }


  # Empty output list

  output = list()

  # Condition to check if grids.cat is specified or whether site.cat will be used


  switch(summary_type,

         "concise_summary"=

           {

             data_for_summary = check_and_return_preset_df(df=bold_df,
                                                           category = "check_return",
                                                           preset = 'bold_concise_summary')

             concise_summ = concise_summary(bold_df=data_for_summary)

             output$concise_summary = concise_summ


           },

         "detailed_taxon_counts"=

           {

             data_for_summary = check_and_return_preset_df(df=bold_df,
                                                           category = "check_return",
                                                           preset = 'bold_detailed_taxon_count')

             taxon_counts = taxon_hierarchy_count (bold_df=data_for_summary)

             output$detailed_taxon_counts = taxon_counts

           },

         "barcode_summary"=

           {

             if (summary_type %in% c('barcode_compliance','all') && is.null(primer_f) && is.null(primer_r))

             {

               stop("primers (either F/R or both) must be specified for the summary")
             }

             else

             {

               data_for_summary = check_and_return_preset_df(df=bold_df,
                                                             category = "check_return",
                                                             preset = 'bold_barcode_summary')

               barcode_df = barcode_compliance (bold_df=data_for_summary,
                                                primer_f = primer_f,
                                                primer_r = primer_r)

               output$barcode_summary = barcode_df

             }


           },

         "data_completeness" =

           {

             completeness_profile = bold.completeness.profile(bold_df)

             output$completeness_summary = completeness_profile$summary

             output$completeness_plot = completeness_profile$plot

           },


         "all" =

           {
             # concise summary
             concise_summ = concise_summary(bold_df=bold_df)


             # taxon counts
             taxon_counts = taxon_hierarchy_count (bold_df=bold_df)


             # barcode compliance
             barcode_df = barcode_compliance (bold_df=bold_df,
                                              primer_f = primer_f,
                                              primer_r = primer_r)

             # completeness
             completeness_profile = bold.completeness.profile(bold_df)

             output = list(concise_summary = concise_summ,
                           detailed_taxon_counts = taxon_counts,
                           barcode_summary = barcode_df,
                           data_completeness=completeness_profile)


           }
  )


  invisible(output)

}
