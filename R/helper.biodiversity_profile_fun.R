#' Helper functions for generating a diversity profile
#' @keywords internal
#'
# This function is used by
# 1. bold.analyze.diversity
#
# Function: Richness profile
#
richness_profile <- function (df)
{

  richness=alpha.accum(df,
                       runs=100)%>%
    data.frame(.)%>%
    dplyr::mutate(across(where(is.numeric), ~ round(., 2)))

}

# Function: Preston results profile

preston_profile <- function (df,
                             y_label)
{

  preston_results = list()

    preston.res = vegan::prestondistr(colSums(df))

    pres_res=data.frame(observed=as.matrix(preston.res$freq),
                        fitted=round(preston.res$fitted,2))
    pres_res_coef=data.frame(values=round(preston.res$coefficients,3))

    #pres_res$rownum = rownames(pres_res)

    # Data summary printed on the console
      cat("Preston results:\n\n")
      cat(preston.res$method, '\n\n')
      cat('Total number of taxa:', sum(preston.res$freq), '\n\n')
      cat("Coefficients:\n")
      print(pres_res_coef)
      cat('\n')
      cat("Frequencies by Octave:\n\n")
      print(pres_res)

    # Plot

    pres_res_plot=pres_res%>%
      dplyr::mutate(rownum=rownames(.))%>%
      dplyr::mutate(rownum=as.numeric(rownum))%>%
      dplyr::mutate(Octaves=as.factor(2^rownum))

    preston.plot=pres_res_plot%>%
      ggplot(aes(x=Octaves,
                 y=observed))+
      geom_bar(stat = "identity",
               position = 'dodge',
               fill="lightseagreen",
               col="black",
               width = 1) +
      geom_point(data = pres_res_plot,
                 aes(x = Octaves,
                     y = fitted,
                     group=1),
                 pch=21,
                 color = "#011B26",
                 fill="#CC4945",
                 size=4) +
      geom_line(data = pres_res_plot,
                aes(x = Octaves,
                    y = fitted,group=1),
                color = "#011B26",
                lty=2,
                linewidth=1) +
      theme_bw(base_size = 16) +
      theme(panel.grid.major = element_blank(),
            panel.grid.minor = element_blank())+
      ylab("Species")+
      xlab("Frequency") +
      scale_y_continuous(expand = c(0,0),,breaks = ~round(unique(pretty(.)))) +
      ylab(y_label)+
      ggtitle("Preston plot")

    preston_results$preston.plot = preston.plot

    preston_results$preston.res = preston.res

    return(preston_results)
}

# Function: Shannon diversity profile

shannon_div_profile<-function(df)

  {

  # Shannon diversity

  shannon_div=vegan::diversity(df)%>%
    data.frame(.)%>%
    dplyr::rename("Shannon_values"=".")

  return(shannon_div)

}

# Function: Beta diversity profile

beta_div_profile<-function(df,
                           beta.index,
                           pre_abs)

{
  beta_div_res = list()

  beta.bin.div=BAT::beta(df,
                         func = beta.index,
                         abund = pre_abs,
                         runs=10,
                         comp = T)

  beta.total = beta.bin.div$Btotal

  beta.replace = beta.bin.div$Brepl

  beta.richnessd = beta.bin.div$Brich

  # Add results to output

  beta_div_res$total.beta = beta.total

  beta_div_res$replace = beta.replace

  beta_div_res$richnessd = beta.richnessd

  return(beta_div_res)

}
