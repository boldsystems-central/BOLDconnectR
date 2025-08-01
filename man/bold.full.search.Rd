% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/external.bold.full.search.R
\name{bold.full.search}
\alias{bold.full.search}
\title{Search user based (private) and publicly available data on the BOLD database}
\usage{
bold.full.search(
  taxonomy = NULL,
  geography = NULL,
  marker = NULL,
  marker_min_length = NULL,
  marker_max_length = NULL,
  collection_start_date = NULL,
  collection_end_date = NULL,
  institutes = NULL
)
}
\arguments{
\item{taxonomy}{A list of single or multiple character strings specifying the taxonomic names at any hierarchical level. Default value is NULL.}

\item{geography}{A list of single or multiple character strings any of the country/province/state/region/sector codes. Default value is NULL.}

\item{marker}{A character string specifying the particular marker gene. Default value is NULL.}

\item{marker_min_length}{A numerical value of the minimum length of the specified marker gene. Default value is NULL.}

\item{marker_max_length}{A numerical value of the maximum length of the specified marker gene. Default value is NULL.}

\item{collection_start_date}{A date value specifying the start date of a date range. Default value is NULL.}

\item{collection_end_date}{A date value specifying the end date of a date range. Default value is NULL.}

\item{institutes}{A list of single or multiple character strings specifying the institute names. Default value is NULL.}
}
\value{
A data frame containing all the processids and marker codes related to the query search..
\emph{Important Note}: \code{bold.apikey()} should be run prior to running \code{bold.full.search()} to setup the \code{apikey} which is needed for the latter.
}
\description{
Retrieves record ids accessible to the particular user along with publicly available data based on taxonomy, geography, markers and collection dates
}
\details{
\code{bold.full.search()} searches user accessible and publicly available data on BOLD, retrieving proccessid and their respective marker codes. All the BCDM data can then be retrieved using the processids as inputs for the \code{bold.fetch()} function. Search parameters can include one or a combination of taxonomy, geography, institutes, markers, marker lengths and collection dates. Taxonomy, geography and institutes inputs are provided as lists if provided as text values directly (Ex. taxonomy = list("Panthera","Poecilia")). A dataframe column can also be used as an input for these 3 parameters using the '$' operator (e.g., df$column_name). If this is the case (i.e. df$colum_name), \code{as.list} should be used instead of just \code{list} (Ex. taxonomy = as.list (df$column_name), geography = as.list(df$column_name)) in order to preserve the query structure for internal operation. The function will return NULL output unless this is adhered to. Marker is given as a character value. Names of the markers can be found on the BOLD webpage. Marker length and collection dates are provided as numeric and character values respectively. Marker lengths without specifying the marker will generate an error but just specifying the marker will provide all the data for that marker available based on the user access. In such a case, the function has a default minimum length of 5 and a maximum length of 2000 base pairs. If one of the two lengths are provided, default value of the other will be used (Example: if marker_min_length is given by the user, the default marker_maximum_length of 2000). Collection dates work in a similar way with a default start date of '2000-01-01' and a end date of '2075-01-01'.Any misspellings (Ex. Canadaa),incorrect placements of search terms (Ex. taxa names in geography) or terms having no data on BOLD at the time when the function is executed will result in a NULL output. There is a hard limit of 1 million record downloads for each search.
}
\examples{

\dontrun{
#Taxonomy
bold.data.tax <- bold.full.search(taxonomy = list("Panthera leo"))

#Result
head(bold.data.tax,10)

#Taxonomy and Geography
bold.data.taxo.geo <- bold.full.search(taxonomy = list("Panthera uncia"),
geography = list("India"))

#Result
head(bold.data.taxo.geo,10)

#Taxonomy, Geography and marker
bold.data.taxo.geo.marker <- bold.full.search(taxonomy = list("Poecilia reticulata"),
geography = list("India"),marker = "COI-5P", marker_min_length=300,marker_max_length=700)

#Result
bold.data.taxo.geo.marker

# Input as a dataframe column
df_test<-data.frame(taxon_name=c("Panthera leo","Panthera uncia"),
locations = c("India","Sri Lanka"))

# Result (correct way)
bold.data.taxo.geo.df.col <- bold.full.search(taxonomy = as.list(df_test$taxon_name),
geography = as.list(df_test$locations))

# Incorrect way

bold.data.taxo.geo.df.col <- bold.full.search(taxonomy = list(df_test$taxon_name),
geography = list(df_test$locations))

}

}
