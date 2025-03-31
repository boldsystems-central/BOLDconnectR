#'Generate a summary of the data downloaded from BOLD
#'
#' @description
#' The function is used to obtain a detailed summary of the data obtained by `bold.fetch` function.
#'
#' @importFrom graphics par
#'
#' @param bold_df the data.frame retrieved from the `bold.fetch` function.
#' @param summarize_by A single character value specifying the type of summary required ("fields","presets","all_data" currently available)
#' @param columns A single or multiple character vector specifying the columns for which a data summary is sought. Default value is NULL.
#' @param presets A single character vector specifying a preset for which a data summary is sought (Check the `details` section for more information). Default value is NULL.
#' @param na.rm A logical value specifying whether NA values should be removed from the BCDM dataframe. Default value is FALSE.
#'
#' @details
#' `bold.data.summarize` provides summaries for the retrieved BOLD BCDM data. The function uses the `skimr::skim()` function to generate summary metrics based on the data types available in the downloaded data. Summaries can be created by one of three `summarize_by` options, a) `all_data` that considers all data that is entered, b) `presets`that are defined set of columns representing a specific aspect of the BOLD BCDM data (currently available are: `taxonomy`, `geography`,`sequences`, `attributions`, `ecology_biogeography` and `other_meta_data`; For more information on the presets, please read the details for the `bold.export` function) and c) `fields` which lets the user select any specific columns. `na.rm`= TRUE removes all NA values (Please note that this might result into empty data frames sometimes due to lot of missing data). The summary includes detailed summary statistics (includes counts for NULL values, unique values and the proportion of complete cases), a bar chart showing some of these statistics, especially pertaining to the completeness of the data and a concise summary that has a high level dataset profile (number of rows, columns, data type). Both `presets` and `fields` are set to NULL by default. Please note that if the `cols` argument from [bold.fetch()] has been used to filter for specific columns, only those will be summarized even if `all_data` option is selected. Similarly, `presets` option will not work in cases where the input data by default doesn't have the respective fields. Units for some of the fields can be checked using the `bold.field.info()`. For specific details on the `skim` output, refer to the `skimr` package documentation.
#'
#' @returns An output list containing:
#' * A data frame of detailed summary statistics of the columns (based on the summarize_by argument).
#' * A bar plot of some of the summary statistics
#' * A concise overview giving the total rows, columns and data types of the data based on the summarize_by argument
#' @importFrom grid unit
#' @examples
#' \dontrun{
# Download data
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
#' #1. Generate summary for the whole data
#'
#' test.data.summary <- bold.data.summarize(bold_df=bold.data,
#'                                          summarize_by = "all_data")
#'
#' # All summary
#' test.data.summary$summary
#'
#'
#' #2. Generate summary for specific fields (cols)
#' test.data.summary.cols <- bold.data.summarize(bold_df=bold.data,
#'                                               summarize_by = "fields",
#'                                               columns = c("country.ocean",
#'                                                           "nuc_basecount",
#'                                                           "inst",
#'                                                           "elev"),
#'                                               na.rm = F)
#'
#' # All summary
#' test.data.summary.cols$summary
#'
#'
#' #3. Preset based summary
#' test.data.summary.preset <- bold.data.summarize(bold_df=bold.data,
#'                                                 summarize_by = "presets",
#'                                                 presets = 'geography',
#'                                                 na.rm = F)
#'
#' # All summary with respect to geography related fields in the BCDM data
#' test.data.summary.preset$summary
#'}
#'
#' @importFrom skimr skim
#' @importFrom skimr partition
#' @importFrom skimr skim_with
#' @importFrom ggplot2 labeller
#' @importFrom ggplot2 element_text
#' @import dplyr
#'
#' @export
#'
bold.data.summarize<-function(bold_df,
                              summarize_by = c("fields","presets","all_data"),
                              columns = NULL,
                              presets = NULL,
                              na.rm=FALSE) {

  # Check if data is a non empty data frame object

  df_checks(bold_df)

  # If NA values should be removed

  if(na.rm)
  {
    bold_df=bold_df%>%
      tidyr::drop_na(.)
    }

  # Function to get the necessary long format data for plot

  obtain.long.summ.df<-function(df,
                                cols)

  {  # skim_summary_features required for the plots

    suppressWarnings({

      common_summ<-c("n_missing","complete_rate")

      #num_summ<-c("numeric.mean")

      char_date_summ<-c("character.n_unique","Date.n_unique")

      results=list()

      all_skim_summ=df%>%
        dplyr::select(all_of(!!cols))%>%
        #convert_coord_2_lat_lon(.)%>%
        skim()

      results$all_skim_summ = all_skim_summ

      concise_summ = all_skim_summ%>%
        summary()

      results$concise_summ = concise_summ

      result_df=all_skim_summ%>%
        filter(skim_variable %in% cols)%>%
        tidyr::gather(features,
                      values,
                      -c(skim_type,
                         skim_variable))%>%
        filter((skim_type == 'Date' & features %in% c(common_summ,
                                                      char_date_summ))|
                 (skim_type=='character' & features %in% c(common_summ,
                                                           char_date_summ))|
                 (skim_type=='numeric' & features %in% c(common_summ)))%>%
        mutate(values=round(as.numeric(values),3))%>%
        mutate(features = gsub('.*\\.','', features))%>%
        mutate(values=case_when(features=='n_missing'~ values,
                                features=='n_unique' ~ values,
                                features=='complete_rate' ~ values * 100,
                                TRUE~values))

      results$result_df=result_df

      return(results)
    })
  }

  # Function to visualize the data

  summary_plot<-function(summ.df)  {

    suppressWarnings({
      # Custom names of the facets
      facetlabels <- c(
        'complete_rate'="Complete cases (%)",
        'n_missing'="Missing values (Total)",
        'n_unique'="Unique values",
        'mean'= 'Mean value (numerical fields)')

      # Plot function
      summ_plot=summ.df%>%
        dplyr::filter(features %in% c('complete_rate',
                                      'n_missing'))%>%
        ggplot(aes(x=skim_variable,
                   y=values))+
        geom_bar(stat = "identity",
                 position = "dodge",
                 fill='#F78E1E',
                 alpha=0.9,
                 col='black')+
        ggplot2::facet_wrap(~features,
                            scales='free_x',
                            ncol=4,
                            labeller = labeller(features=facetlabels))+
        ylab('')+
        xlab('Fields')+
        theme_bw(base_size = 12) +
        ggplot2::coord_flip()+
        theme(axis.text.x = element_text(angle = 90,
                                         vjust = 0.5,
                                         hjust=1),
              panel.spacing=grid::unit(1,"lines"),
              strip.background = ggplot2::element_rect(fill="lightseagreen"),
              text = element_text(family = "arial"))+
        scale_y_continuous(expand = c(0,0)) +
        ggtitle('Completness profile of the downloaded data')

      return(summ_plot)
    })

  }

  suppressMessages(skim_with(numeric=list(digits=2)))

  output<-list()

  switch (summarize_by,

          "fields" =

            {
              if (is.null(columns)) stop("Columns should not be NULL when summarize_by=fields.")

              # Verification of column names

              if (any(!columns %in% colnames(bold_df))) stop("Column names given are not present in the input BCDM dataframe.")
              summary.bold.df = obtain.long.summ.df (df = bold_df,
                                                     cols = columns)

            },

          "presets" =

            {
              if (is.null(presets)) stop("Presets should not be NULL when summarize_by=presets.")

              data_for_summary = check_and_return_preset_df(df=bold_df,
                                                            category = "check_return",
                                                            preset = presets)

              summary.bold.df=suppressWarnings(suppressMessages(obtain.long.summ.df(df = data_for_summary,
                                                                                    cols = names(data_for_summary))))

            },

          "all_data" =

            {
              if (all(!is.null(columns),!is.null(presets))) stop("columns and presets should be NULL when summarize_by=all_data.")
              summary.bold.df=obtain.long.summ.df(df = bold_df,
                                                  cols = names(bold_df))
            }
          )


  # Plot of the result

  summ_plot=summary_plot(summary.bold.df$result_df)

  # Compile output

  output$plot<-summ_plot

  output$concise_summ<-summary.bold.df$concise_summ

  output$summary<-summary.bold.df$all_skim_summ

  print(output$concise_summ)

  print(output$plot)

  # Summary

  invisible(output)


}
