#' Helper functions for creating different data summaries
#' @keywords internal
#'
#' @importFrom skimr skim
#' @importFrom skimr partition
#' @importFrom skimr skim_with
#' @importFrom tidyr gather
#' @importFrom tidyr pivot_longer
#' @importFrom ggplot2 labeller
#' @importFrom ggplot2 element_text
#' @importFrom grid unit
#' @import dplyr
#'
# These functions are used in
# 1. bold.data.summary
#
# Function: Record counts for all levels of taxonomic hierarchy in the dataset

taxon_hierarchy_count<-function (bold_df)

{
  suppressMessages(
    taxonomy_hierarchy_count<-bold_df%>%
      group_by(kingdom,
               phylum,
               class,
               order,
               family,
               subfamily,
               genus,
               species) %>%
     summarise(total_records=n(),
                unique_BINs=n_distinct(bin_uri,
                                             na.rm = T),
                records_wo_bins=sum(is.na(bin_uri)),
                unique_countries=n_distinct(country.ocean,
                                            na.rm = T),
                unique_institutes=n_distinct(inst,
                                             na.rm = T))%>%
      ungroup()%>%
      dplyr::select(kingdom,
                    phylum,
                    class,
                    order,
                    family,
                    subfamily,
                    genus,
                    species,
                    total_records,
                    unique_BINs,
                    records_wo_bins,
                    unique_countries,
                    unique_institutes)
  )

  return(taxonomy_hierarchy_count)

}
# Function: DNA barcode based information summary

barcode_compliance<-function(bold_df,
                             primer_f=NULL,
                             primer_r=NULL)

{
  # Create two empty vectors values for which can be dynamically added as per the arguments of the function

  primer_vec_f=NULL

  primer_vec_r=NULL

  # Converting the nuc column (sequences) to character data

  sequences <- as.character(bold_df$nuc)

  # Converting the character data to a DNAStringset object

  sequences_set <- tryCatch(
    DNAStringSet(sequences),
    error= function(e)
    {
      message("Error creating DNAStringSet. Please check if there are NA values in the 'nuc' column ", e$message)
    }
  )

  #names(dna_set)<-branchi_barcode_compliance$sampleid

  # Condition when any or both primer arguments are non NULL. The empty vectors are used to populate the results based on the condition

  if(!is.null(primer_f))
  {
    primer_F <- Biostrings::DNAString(primer_f)

    primer_vec_f <- Biostrings::vcountPattern(primer_F, sequences_set) > 0
  }


  if(!is.null(primer_r))

    {

    primer_R <- Biostrings::DNAString(primer_r)

    primer_vec_r <- Biostrings::vcountPattern(primer_R, sequences_set) > 0

  }

  # Ambiguous codes vector (taken from https://www.bioinformatics.org/sms/iupac.html)

  ambiguous_codes <- c("N", "R", "Y", "S", "W", "K", "M", "B", "D", "H", "V")

  # Create a data frame to store results

  ambiguous_counts <- sapply(ambiguous_codes, function(code)
  {

    Biostrings::vcountPattern(Biostrings::DNAString(code),
                  sequences_set)
  })

  # Convert to data frame

  ambiguous_df <- as.data.frame(ambiguous_counts)

  #rownames(ambiguous_df) <- names(dna_set)

  # Final dataset

  compliance_df<-bold_df%>%
    dplyr::select(processid,bin_uri,country.ocean,inst,marker_code,nuc_basecount)%>%
    mutate(primer_exists_F = if (!is.null(primer_vec_f)) primer_vec_f else NA,
           primer_exists_R = if (!is.null(primer_vec_r)) primer_vec_r else NA,
           ambiguous_bp_no=rowSums(ambiguous_df))
    #bind_cols(ambiguous_df)

  return(compliance_df)


}

# Function 3: Concise overview of the data

concise_summary<-function(bold_df)

{

  concise_summary<-bold_df%>%
    summarise(Total_records=n(),
              Total_records_w_sequences=sum(!is.na(nuc)),
              Unique_species=n_distinct(species,
                                        na.rm = T),
              Unique_BINs=n_distinct(bin_uri,
                                     na.rm = T),
              Unique_countries=n_distinct(country.ocean,
                                          na.rm = T),
              Unique_institutes=n_distinct(inst,
                                           na.rm = T),
              Unique_identified_by=n_distinct(identified_by,
                                              na.rm = T),
              Unique_specimen_depositories=n_distinct(sequence_run_site,
                                                      na.rm = T),
              Unique_markers=paste(unique(marker_code),
                                   collapse = ','),
              Amplicon_length_range=paste(min(nuc_basecount,na.rm = T),"-",max(nuc_basecount,na.rm = T),
                                          sep=''))%>%
    gather(Category,
           Value,
           Total_records:Amplicon_length_range)

  return(concise_summary)

}

# Function 4: Data completeness

bold.completeness.profile<-function(bold_df)

{

  # Check if data is a data frame object

  df_checks(bold_df)

  # skim_summary_features required for the plots

  common_summ<-c("n_missing","complete_rate")

  char_date_summ<-c("character.n_unique","Date.n_unique")

  # Output list

  output=list()

  # Data profile using skimr
  suppressWarnings ({
  all_skim_summ=bold_df%>%
    skim()


  # Data frame for plotting the profile

  result_df=all_skim_summ%>%
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
  })
  # Facet label name change for the plot

  facetlabels <- c(
    'complete_rate'="Complete cases (%)",
    'n_missing'="Missing values (Total)")

  # plot

  summ_plot=result_df%>%
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
    theme_bw(base_size = 11) +
    ggplot2::coord_flip()+
    theme(axis.text.x = element_text(angle = 90,
                                     vjust = 0.5,
                                     hjust=1),
          panel.spacing=grid::unit(1,"lines"),
          strip.background = ggplot2::element_rect(fill="lightseagreen"),
          text = element_text(family = "arial"))+
    scale_y_continuous(expand = c(0,0)) +
    ggtitle('Completness profile of the downloaded data')

  suppressMessages(skim_with(numeric=list(digits=2)))

  # Compile output

  output$plot<-summ_plot

  output$summary<-all_skim_summ


  invisible(output)

}
