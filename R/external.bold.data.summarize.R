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
#' `bold.data.summarize` provides different types of data summaries for the downloaded BCDM dataset. Current options include:
#' * concise_summary = A high level overview of the downloaded data that would include total records, counts of unique BINs, countries , institutes etc.
#' * data_completeness = A data profile that includes information on missing data, proportion of complete cases for each field in the BCDM data along with data type specific insights like distribution, average and median values for numeric data. Also provides a bar chart visualizing the missing data and total records.
#' * detailed_taxon_counts = Taxonomy focused counts of total records with and without BINs, unique countries and institutes.
#' * barcode_summary = BIN focused summary of nucleotide basepair length, ambiguous basepair number (if present), presence of primer sequences (forward and/or reverse) in the sequence along with the processid, country and institute associated with the BIN.
#' * all = Summary containing all of the above results.
#' `rem_na_bin`= TRUE removes all records that don’t have a BIN (Please note that this might result into empty data frames sometimes due to lot of missing data). `barcode_summary` requires the `Biostrings` package to be installed and imported in the session. The forward or reverse primer also needs to be specified. Details on all/specific fields can be checked using the `bold.field.info()`.
#'
#'\emph{Note: }. Users are required to install and load the `Biostrings` package in case they want to generate the `barcode_summary` before running this function. For the data in the `nuc_basecount` column in the `barcode_summary`, please refer to the `bold.field.info()` for details.
#'
#' @returns An output list containing:
#' * A data frame of detailed summary based on the `summary_type`
#' * A bar chart in case `summary_type = data_completeness` in addition to the dataframe.
#'
#' @examples
#' \dontrun{
#' bold_data.ids <- bold.public.search(taxonomy = list("Oreochromis"))
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
#'                                                  summary_type = "concise_summary")
#' # Result
#' test.data.summary.concise$concise_summary
#'
#'
#' #2. Generate a detailed taxon counts summary
#'
#' test.data.summary <- bold.data.summarize(bold_df=bold.data,
#'                                          summary_type = "detailed_taxon_counts")
#'
#' # Result
#' test.data.summary$detailed_taxon_counts
#'
#'
#' #3. Generate data completeness profile
#'
#' test.data.summary.completeness <- bold.data.summarize(bold_df=bold.data,
#'                                                       summary_type = "data_completeness")
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
#'
#' library(Biostrings)
#'
#' test.data.summary.barcode <- bold.data.summarize(bold_df=bold.data,
#'                                                  summary_type = "barcode_summary",
#'                                                  primer_f='GGTCAACAAATCATAAAGATATTGG')
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

         "barcode_summary" = {

           data_for_summary <- check_and_return_preset_df(df = bold_df,
                                                          category = "check_return",
                                                          preset = "bold_barcode_summary")

           if (summary_type %in% c("barcode_compliance", "all")) {

             if (is.null(primer_f) && is.null(primer_r)) {

               # Both primers not provided

               barcode_df <- data_for_summary

               # Adding two columns with NA values

               barcode_df$primer_exists_F <- NA

               barcode_df$primer_exists_R <- NA

             } else if (!is.null(primer_f) && is.null(primer_r)) {

               # Only forward primer provided

               barcode_df <- barcode_compliance(bold_df = data_for_summary,
                                                primer_f = primer_f,
                                                primer_r = NULL)
               barcode_df$primer_exists_R <- NA  # Add only reverse primer column

             } else if (is.null(primer_f) && !is.null(primer_r)) {

               # Only reverse primer provided

               barcode_df <- barcode_compliance(bold_df = data_for_summary,
                                                primer_f = NULL,
                                                primer_r = primer_r)
               barcode_df$primer_exists_F <- NA  # Add only forward primer column

             } else {

               # Case 3: Both primers provided
               barcode_df <- barcode_compliance(bold_df = data_for_summary,
                                                primer_f = primer_f,
                                                primer_r = primer_r)
             }

             output$barcode_summary <- barcode_df
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

             if (is.null(primer_f) && is.null(primer_r))stop("primers (either F/R or both) must be specified for the summary")

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
