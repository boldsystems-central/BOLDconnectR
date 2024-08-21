
<!-- README.md is generated from README.Rmd. Please edit that file -->

# BOLDconnectR

<!-- badges: start -->
<!-- badges: end -->

BOLDconnectR is a package designed for **retrieval**, **transformation**
and **analysis** of the data available in the *Barcode Of Life Data
Systems (BOLD)* database. This package provides the functionality to
obtain public and private user data available in the database in the
*Barcode Core Data Model (BCDM)* format. Data include information on the
**taxonomy**,**geography**,**collection**,**identification** and **DNA
sequence** of every submission.

## Installing BOLDConnectR

The package can be installed using `devtools::install_github` function
from the `devtools` package in R (which needs to be installed before
installing BOLDConnectR). *This package currently exists as a private
repo and thus has an authorization token*.

``` r

devtools::install_github("https://github.com/sameerpadhye/BOLDconnectR.git",
                         auth_token = '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')
#> Skipping install of 'BOLDconnectR' from a github remote, the SHA1 (fd8b8e23) has not changed since last install.
#>   Use `force = TRUE` to force installation

library(BOLDconnectR)
```

## The package currently has 9 functions:

1.  bold.fields.info
2.  bold.connectr
3.  bold.connectr.public
4.  gen.comm.mat
5.  analyze.alphadiv
6.  analyze.betadiv
7.  visualize.geo
8.  *align.seq*
9.  *analyze.seq*

*These functions are currently internal functions which require external
dependencies not included in the package. For their specific usage,
please see the details provided below.*

### Note on API key

The function `bold.connectr` requires an `api key` in order to access
and download all public + private user data. API key can be obtained by
emailing the BOLD support (<support@boldsystems.org>). API key is needed
only for the data retrieval and can be added directly within the
function. Alternatively, it can be set up as an environmental variable
using the ‘Sys.setenv’ function.

``` r

# The key can be added in place of "api.key" 
Sys.setenv ("api_key"="api.key")
```

It can then be retrieved using `Sys.getenv` function directly or by
storing it as another variable.

``` r

api.key <- Sys.getenv('api_key')
```

## Function usage:

### 1.bold.fields.info:

`bold.fields.info` provides all the metadata related to the various
fields (columns) currently available for download from BOLD. The
function gives the name, definition and the data type of each field.

<div class="datatables html-widget html-fill-item" id="htmlwidget-d207a5bfb434e264650e" style="width:100%;height:auto;"></div>
<script type="application/json" data-for="htmlwidget-d207a5bfb434e264650e">{"x":{"filter":"none","vertical":false,"data":[["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76"],["processid","sampleid","fieldid","museumid","record_id","specimenid","processid_minted_date","bin_uri","bin_created_date","collection_code","inst","taxid","kingdom","phylum","class","order","family","subfamily","tribe","genus","species","subspecies","species_reference","identification","identification_method","identification_rank","identified_by","identifier_email","taxonomy_notes","sex","reproduction","life_stage","short_note","notes","voucher_type","tissue_type","specimen_linkout","associated_specimens","associated_taxa","collectors","collection_date_start","collection_date_end","collection_event_id","collection_time","collection_notes","geoid","country/ocean","country_iso","province/state","region","sector","site","site_code","coord","coord_accuracy","coord_source","elev","elev_accuracy","depth","depth_accuracy","habitat","sampling_protocol","nuc","nuc_basecount","insdc_acs","funding_src","marker_code","primers_forward","primers_reverse","sequence_run_site","sequence_upload_date","bold_recordset_code_arr","ecoregion","biome","realm  string  default  Inferred RESOLVE defined realm based on collection coordinates.","sovereign_inst"],["BOLD System generated unique identifier for the sample being sequenced.","User generated identifier for the sample being sequenced, often identical to the Field ID or Museum ID.","Specimen or sample identifier generated in the field or lot number for a bulk collection event.","Catalog number from a museum collection.","A BOLD generated identifier for the marker and specimen sequence combination.","BOLD System generated numerical ID associated with the specimen record.","Date of record registration on BOLD.","The Barcode Index Number (BIN) assigned to the COI sequence.","Date of BIN creation in BOLD.","Code associated with a given collection within an institution.","Institution storing the physical specimen.","Identifier associated with the taxon assignment.","Taxonomy: Kingdom.","Taxonomy: Phylum.","Taxonomy: Class.","Taxonomy: Order.","Taxonomy: Family.","Taxonomy: Subfamily.","Taxonomy: Tribe","Taxonomy: Genus.","Taxonomy: Species.","Taxonomy: Subspecies.","Reference for species name/Authorship of the species name.","Taxonomic identification of the specimen.","The method used to identify the specimen.","Taxonomic rank of the identification associated with the specimen.","Full name of primary individual responsible for providing the taxonomic identification of the specimen.","Identifier email address.","General notes regarding the taxonomy of the specimen.","The sex of the specimen registered in the record. This field uses a controlled vocabulary: 'Male', 'female', 'hermaphrodite' only.","Sexual/asexual/cyclic parthenogen only.","The age class or life stage of the specimen(s) at the time of sampling. Contolled vocabulary: 'Adult', 'Immature', 'Juvenile', 'Pupa'.","A brief note or term associated with the specimen to add context to the record.","Detailed notes regarding the specimen.","Status of the specimen in an accessioning process.This field uses a controlled vocabulary: 'Museum Vouchered:Type', 'Museum Vouchered:Type Series', 'Vouchered:Registered Collection', 'To Be Vouchered:Holdup/Private', 'E-Vouchered:DNA/Tissue+Photo', 'Dna/Tissue Vouchered Only', 'No Specimen'.","A physical result of a sampling (or subsampling) event. In biological collections, the material sample is typically collected, and either preserved or destructively processed.","Link to an external resource for the specimen record.","A list (concatenated and comma separated) of other specimens associated with the subject specimen at the time of its collection. References to other specimen identifiers should be preceded by the relationship. Examples: 'host: PLANT23452, prey: USNM45677' when both prey and host specimens have been captured.","A list (concatenated and comma separated) of taxa associated with the specimen at the time of its collection. References to taxa should be preceded by the relationship. Use of this field implies knowledge of an associated specimen where the identification is an inference. Examples: [host: Quercus alba], [prey: caterpillar].","Comma separated list of full or abbreviated names of the individuals or teams responsible for collecting the sample in the field.","The start date for the associated collecting event.","The end date for the associated collecting event.","An identifier for the set of information associated with an Event (something that occurs at a place and time). May be a global unique identifier or an identifier specific to the data set.","The time or time of day during which the sample was collected.","Comments or notes about the collection event.","Unique identifier assigned to the most detailed or specific geographic division available, either country/ocean or province/state.","The full, unabbreviated name of the country, major political unit, or ocean.","Country ISO 3166-1 Alpha-2 code.","The full, unabbreviated name of the state, province, territory, or prefecture within the given country.","Park, county, district, lake or river.","Sector of park or county/city.","The name of the sampling location.","A short string representing the sampling location.","Latitude &amp; Longitude in decimal degrees (DD) format (e.g. 45.837).","Accuracy of coordinate in decimal degrees (DD).","The source of the coordinates.","Elevation of sampling site. Measured in meters relative to sea level. Negative values indicate a position below sea level.","Accuracy of the elevation value in meters.","For organisms collected beneath the surface of a water body. Measured in meters below the surface of water.","The accuracy of the depth value in meters.","A category or description of the habitat.","The names of, references to, or descriptions of the methods or protocols used to capture the associated specimen.","Nucleotide sequence as submitted.","Count of IUPAC non-degenerate nucleotide symbols.","Accession number assigned to a sequence upon its deposition in one of the databases affiliated with the International Nucleotide Sequence Database Collaboration, 'www.insdc.org'.","Source of funding for data generation, curation, and publication.","Short code associated with the sequenced marker(gene).","A comma separated list of forward primer code and sequence pairs, with each code and sequence separated by a colon.","A comma separated list of reverse primer code and sequence pairs, with each code and sequence separated by a colon.","Full name of the institution where sequencing was performed or the database the sequence was retrieved from.","Date the sequence was uploaded.","A comma separated list of Projects and Datasets on BOLD that this record is associated with.","Inferred RESOLVE defined ecoregion based on the collection coordinates.","Inferred RESOLVE defined biome based on the collection coordinates.","","Institution with sovereignty over the physical specimen."],["character","character","character","character","character","integer","Date","character","Date","character","character","numeric","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","character","Date","Date","character","character","character","integer","character","character","character","character","character","character","character",null,"numeric","character","numeric","numeric","numeric","numeric","character","character","character","integer","character","character","character","character","character","character","Date","character","character","character",null,"character"]],"container":"<table class=\"cell-border stripe\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>field<\/th>\n      <th>definition<\/th>\n      <th>R_field_types<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"columnDefs":[{"orderable":false,"targets":0},{"name":" ","targets":0},{"name":"field","targets":1},{"name":"definition","targets":2},{"name":"R_field_types","targets":3}],"order":[],"autoWidth":false,"orderClasses":false},"selection":{"mode":"multiple","selected":null,"target":"row","selectable":null}},"evals":[],"jsHooks":[]}</script>

### 2.bold.connectr:

This function retrieves public and private user data on BOLD using
the`api key`.The downloaded data can also be filtered using the various
filter arguments available (all arguments after the `api_key`). The
filtering happens locally after the data is downloaded. Care has to be
taken to select the filters properly. If wrong/too many filters are
applied, it can result in an empty result. The `fields` argument in the
function helps in selecting only the fields needed by the user.

Test data Test data is a data frame having 2 columns and 2100 unique
ids. First column has ‘processids’ while second has ‘sampleids’. Either
one can be used to retrieve data from BOLD.

``` r

data("test.data")

head(test.data,5)
#>    processid sampleid
#> 1 ACAM001-13  AC13A01
#> 2 ACAM008-13  AC13A14
#> 3 ACAM015-13  AC13A32
#> 4 ACAM027-13  AC13A72
#> 5 ACAM030-13  AC13A78
```

### 2a.Default (all data retrieved)

The arguments provided below need to be specified by default for every
request. Default settings retrieve data for all available fields for
those ids. Certain ids might not have information for certain fields in
which case the number of columns could be different

``` r

data("test.data")

api.key <- Sys.getenv('api_key')

# A small subset of the data used for data retrieval
to_download=test.data[1:100,]

result<-bold.connectr(input.data = to_download,
                                  param = 'processid',
                                  param.index = 1,
                                  api_key = api.key)

head(result,5)
#>    processid         record_id insdc_acs    sampleid specimenid taxid
#> 1  AJS105-19  AJS105-19.COI-5P           S-03-A-FBC5   10597471 52768
#> 2 ACAM001-13 ACAM001-13.COI-5P               AC13A01    3934418 24807
#> 3  AJS052-19  AJS052-19.COI-5P             S-03-A-MB   10597418 52768
#> 4  AJS071-19  AJS071-19.COI-5P             S-09-B-MB   10597437 52768
#> 5  AJS107-19  AJS107-19.COI-5P           S-03-A-FBC7   10597473 52768
#>   short_note identification_method museumid     fieldid collection_code
#> 1         NA                    NA          S-03-A-FBC5                
#> 2         NA                    NA             AC13AL01                
#> 3         NA                    NA            S-03-A-MB                
#> 4         NA                    NA            S-09-B-MB                
#> 5         NA                    NA          S-03-A-FBC7                
#>   processid_minted_date                                             inst
#> 1            2019-08-08                               Chapman University
#> 2            2013-10-30 South African Institute for Aquatic Biodiversity
#> 3            2019-08-08                               Chapman University
#> 4            2019-08-08                               Chapman University
#> 5            2019-08-08                               Chapman University
#>   specimendetails.verbatim_depository funding_src sex life_stage reproduction
#> 1                                  NA        <NA>  NA         NA           NA
#> 2                                  NA  iBOL:WG1.1  NA         NA           NA
#> 3                                  NA        <NA>  NA         NA           NA
#> 4                                  NA        <NA>  NA         NA           NA
#> 5                                  NA        <NA>  NA         NA           NA
#>   habitat collectors site_code specimen_linkout collection_event_id
#> 1      NA                   NA               NA                  NA
#> 2      NA A. Chakona        NA               NA                  NA
#> 3      NA                   NA               NA                  NA
#> 4      NA                   NA               NA                  NA
#> 5      NA                   NA               NA                  NA
#>   sampling_protocol tissue_type collection_date_start
#> 1                NA          NA                  <NA>
#> 2                NA          NA            2013-03-04
#> 3                NA          NA                  <NA>
#> 4                NA          NA                  <NA>
#> 5                NA          NA                  <NA>
#>   specimendetails.verbatim_collectiondate collection_time
#> 1                                      NA              NA
#> 2                                      NA              NA
#> 3                                      NA              NA
#> 4                                      NA              NA
#> 5                                      NA              NA
#>   collection_date_accuracy specimendetails.verbatim_collectiondate_precision
#> 1                       NA                                                NA
#> 2                       NA                                                NA
#> 3                       NA                                                NA
#> 4                       NA                                                NA
#> 5                       NA                                                NA
#>   associated_taxa associated_specimens voucher_type notes taxonomy_notes
#> 1              NA                   NA           NA    NA             NA
#> 2              NA                   NA           NA    NA             NA
#> 3              NA                   NA           NA    NA             NA
#> 4              NA                   NA           NA    NA             NA
#> 5              NA                   NA           NA    NA             NA
#>   collection_notes specimendetails.verbatim_kingdom
#> 1               NA                               NA
#> 2               NA                               NA
#> 3               NA                               NA
#> 4               NA                               NA
#> 5               NA                               NA
#>   specimendetails.verbatim_phylum specimendetails.verbatim_class
#> 1                              NA                             NA
#> 2                              NA                             NA
#> 3                              NA                             NA
#> 4                              NA                             NA
#> 5                              NA                             NA
#>   specimendetails.verbatim_order specimendetails.verbatim_family
#> 1                             NA                              NA
#> 2                             NA                              NA
#> 3                             NA                              NA
#> 4                             NA                              NA
#> 5                             NA                              NA
#>   specimendetails.verbatim_subfamily specimendetails.verbatim_tribe
#> 1                                 NA                             NA
#> 2                                 NA                             NA
#> 3                                 NA                             NA
#> 4                                 NA                             NA
#> 5                                 NA                             NA
#>   specimendetails.verbatim_genus specimendetails.verbatim_species
#> 1                             NA                               NA
#> 2                             NA                               NA
#> 3                             NA                               NA
#> 4                             NA                               NA
#> 5                             NA                               NA
#>   specimendetails.verbatim_subspecies
#> 1                                  NA
#> 2                                  NA
#> 3                                  NA
#> 4                                  NA
#> 5                                  NA
#>   specimendetails.verbatim_species_reference
#> 1                                         NA
#> 2                                         NA
#> 3                                         NA
#> 4                                         NA
#> 5                                         NA
#>   specimendetails.verbatim_identifier geoid location.verbatim_country
#> 1                                  NA   238                        NA
#> 2                                  NA   128                        NA
#> 3                                  NA   238                        NA
#> 4                                  NA   238                        NA
#> 5                                  NA   238                        NA
#>   location.verbatim_province location.verbatim_country_iso_alpha3 marker_code
#> 1                         NA                                   NA      COI-5P
#> 2                         NA                                   NA      COI-5P
#> 3                         NA                                   NA      COI-5P
#> 4                         NA                                   NA      COI-5P
#> 5                         NA                                   NA      COI-5P
#>    kingdom   phylum          class        order    family           subfamily
#> 1 Animalia Chordata Actinopterygii Cichliformes Cichlidae Pseudocrenilabrinae
#> 2 Animalia Chordata Actinopterygii Cichliformes Cichlidae Pseudocrenilabrinae
#> 3 Animalia Chordata Actinopterygii Cichliformes Cichlidae Pseudocrenilabrinae
#> 4 Animalia Chordata Actinopterygii Cichliformes Cichlidae Pseudocrenilabrinae
#> 5 Animalia Chordata Actinopterygii Cichliformes Cichlidae Pseudocrenilabrinae
#>   tribe       genus                 species subspecies          identification
#> 1    NA Oreochromis   Oreochromis niloticus         NA   Oreochromis niloticus
#> 2    NA Oreochromis Oreochromis mossambicus         NA Oreochromis mossambicus
#> 3    NA Oreochromis   Oreochromis niloticus         NA   Oreochromis niloticus
#> 4    NA Oreochromis   Oreochromis niloticus         NA   Oreochromis niloticus
#> 5    NA Oreochromis   Oreochromis niloticus         NA   Oreochromis niloticus
#>   identification_rank tax_rank.numerical_posit species_reference  identified_by
#> 1             species                       17    Linnaeus, 1758           <NA>
#> 2             species                       17      Peters, 1852 Albert Chakona
#> 3             species                       17    Linnaeus, 1758           <NA>
#> 4             species                       17    Linnaeus, 1758           <NA>
#> 5             species                       17    Linnaeus, 1758           <NA>
#>   specimendetails__identifier.person.email                sequence_run_site
#> 1                                     <NA>               Chapman University
#> 2                    a.chakona@saiab.ac.za Centre for Biodiversity Genomics
#> 3                                     <NA>               Chapman University
#> 4                                     <NA>               Chapman University
#> 5                                     <NA>               Chapman University
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                nuc
#> 1 CCTCTATCTAGTATTTGGTGCTTGAGCCGGAATAGTAGGAACTGCACTAAGCCTCCTAATTCGGGCAGAACTAAGCCAGCCCGGCTCTCTTCTCGGAGACGACCAAATCTATAATGTAATTGTTACAGCACATGCTTTCGTAATAATTTTCTTTATAGTAATACCAATTATGATTGGAGGCTTTGGAAACTGACTAGTACCCCTCATGATTGGTGCACCAGACATGGCCTTCCCTCGAATAAATAACATGAGCTTTTGACTTCTCCCCCCCTCATTTCTTCTTCTTCTCGCCTCATCTGGAGTCGAAGCAGGTGCCGGCACAGGATGGACTGTTTATCCCCCGCTCGCAGGCAATCTTGCCCACGCTGGACCTTCTGTTGACTTAACCATCTTCTCCCTCCACTTGGCCGGAGTGTCATCTATTTTAGGTGCAATTAATTTTATCACAACCATTATTAACATGAAACCCCCTGCCATCTCCCAATATCAAACACCCCTATTTGTGTGATCCGTCCTAATTACCGCAGTACTACTCCTTCTATCCCTGCCCGTTCT------------------------AACAGACCGAAACCTAAACACAACCTTCTTTGACCCTGCCGGAGGAGGAGACCCCACCCTATACCAACACTTAT---
#> 2     CCTCTATCTAGTATTTGGTGCTTGAGCCGGAATAGTAGGAACTGCATTAAGCCTCCTAATTCGGGCAGAACTAAGCCAGCCCGGCTCTCTCCTCGGAGACGACCAGATTTATAATGTAATTGTTACAGCACATGCTTTCGTAATAATTTTCTTTATAGTAATGCCAATTATAATTGGAGGTTTTGGAAACTGACTAGTGCCACTAATGATTGGTGCACCCGACATGGCCTTCCCTCGAATAAATAACATGAGTTTTTGACTCCTCCCCCCCTCATTTCTCCTTCTCCTCGCCTCATCCGGGGTCGAAGCAGGGGCCGGTACAGGATGGACTGTTTATCCCCCACTCGCAGGCAATCTCGCCCATGCTGGGCCTTCCGTTGACTTAACCATCTTCTCCCTCCACTTGGCCGGGGTGTCATCTATTTTAGGTGCAATTAATTTTATTACAACCATTATTAACATAAAACCCCCTGCCATCTCCCAATATCAAACACCCCTCTTTGTATGATCCGTTCTAATTACCGCAGTACTACTCCTACTATCCCTACCCGTTCTTGCCGCCGGCATCACAATACTTCTAACAGACCGAAACCTAAACACAACCTTCTTTGATCCTGCCGGAGGAGGAGACCCCATCCTTTACCAACACTTA
#> 3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 CAAATYTATAATGTAATTGTTACAGCRCATGCTTTCGTAATAATTTTCTTTATAGTAATACCAATTATRATTGGAGGCTT
#> 4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     CTCGGAGACGAYCAAATYTATAATGTRATTGTTACAGCRCATGCTTTCGTAATAATTTTCTTTATAGTAATACCAATWATRATTGGAGGCTT
#> 5 CCTCTATCTAGTATTTGGTGCTTGAGCCGGAATAGTAGGAACTGCACTAAGCCTCCTAATTCGGGCAGAACTAAGCCAGCCCGGCTCTCTTCTCGGAGACGACCAAATCTATAATGTAATTGTTACAGCACATGCTTTCGTAATAATTTTCTTTATAGTAATACCAATTATGATTGGAGGCTTTGGAAACTGACTAGTACCCCTCATGATTGGTGCACCAGACATGGCCTTCCCTCGAATAAATAACATGAGCTTTTGACTTCTCCCCCCCTCATTTCTTCTTCTTCTCGCCTCATCTGGAGTCGAAGCAGGTGCCGGCACAGGTTGGACTGTTTATCCCCCGCTCGCAGGCAATCTTGCCCACGCTGGACCTTCTGTTGACTTAACCATCTTCTCCCTCCACTTGGCCGGAGTGTCATCTATTTTAGGTGCAATTAATTTTATCACAACCATTATTAACATGAAGCCCCCTGCCATCTCCCAATATCAAACACCCCTATTTGTGTGATCCGTCCTAATTACCGCAGTACTACTCCTTCTATCCCTGCCCGTTCTTGCCGCCGGCATCACAATACTTCTAACAGACCGAAACCTAAACACAACCTTCTTTGACCCTGCCGGAGGAGGAGACCCCATCCTATACCAACACTTATTC-
#>   nuc_basecount sequence_upload_date      bin_uri bin_created_date elev
#> 1           629           2019-08-09 BOLD:AAC9904       2010-07-15   NA
#> 2           652           2014-05-08 BOLD:AAA8511       2010-07-15  532
#> 3            77           2019-08-08         <NA>             <NA>   NA
#> 4            86           2019-08-08         <NA>             <NA>   NA
#> 5           655           2019-08-09 BOLD:AAC9904       2010-07-15   NA
#>   location.verbatim_elev depth location.verbatim_depth       lat      lon
#> 1                     NA    NA                      NA        NA       NA
#> 2                     NA    NA                      NA -17.52523 35.20858
#> 3                     NA    NA                      NA        NA       NA
#> 4                     NA    NA                      NA        NA       NA
#> 5                     NA    NA                      NA        NA       NA
#>   location.verbatim_coord                      coord_source coord_accuracy
#> 1                      NA                              <NA>             NA
#> 2                      NA Coordinates from country centroid             NA
#> 3                      NA                              <NA>             NA
#> 4                      NA                              <NA>             NA
#> 5                      NA                              <NA>             NA
#>   location.verbatim_gps_accuracy elev_accuracy location.verbatim_elev_accuracy
#> 1                             NA            NA                              NA
#> 2                             NA            NA                              NA
#> 3                             NA            NA                              NA
#> 4                             NA            NA                              NA
#> 5                             NA            NA                              NA
#>   depth_accuracy location.verbatim_depth_accuracy      realm biome
#> 1             NA                               NA       <NA>    NA
#> 2             NA                               NA Afrotropic    NA
#> 3             NA                               NA       <NA>    NA
#> 4             NA                               NA       <NA>    NA
#> 5             NA                               NA       <NA>    NA
#>                           ecoregion region sector          site country_iso
#> 1                              <NA>   <NA>   <NA>          <NA>          US
#> 2 Zambezian-Limpopo_mixed_woodlands   <NA>   <NA> Muhukwa river          MZ
#> 3                              <NA>   <NA>   <NA>          <NA>          US
#> 4                              <NA>   <NA>   <NA>          <NA>          US
#> 5                              <NA>   <NA>   <NA>          <NA>          US
#>   country.ocean province.state              bold_recordset_code_arr
#> 1 United States                  AJS,DS-OREOSA,DS-OREOSARO,DS-CICHI
#> 2    Mozambique                ACAM,DS-CBOLW,DS-EDBRTEST,DS-INVASSP
#> 3 United States                           AJS,DS-OREOSA,DS-OREOSARO
#> 4 United States                           AJS,DS-OREOSA,DS-OREOSARO
#> 5 United States                  AJS,DS-OREOSA,DS-OREOSARO,DS-CICHI
#>   geopol_denorm.country_iso3 collection_date_end
#> 1                        USA                <NA>
#> 2                        MOZ                <NA>
#> 3                        USA                <NA>
#> 4                        USA                <NA>
#> 5                        USA                <NA>
```

### 2b.Institutes Filter

Data is downloaded followed by the ‘institute’ filter applied on it to
fetch only the relevant ‘institute’ (here South African Institute for
Aquatic Biodiversity) data.

``` r
api.key <- Sys.getenv('api_key')
# A small subset of the data used for data retrieval

to_download=test.data[1:100,]

result_institutes<-bold.connectr(input.data = to_download,
                                  param = 'processid',
                                  param.index = 1,
                                  api_key = api.key,
                      institutes = "South African Institute for Aquatic Biodiversity",
                      fields = c("bin_uri","processid","inst"))

head(result_institutes,5)
#>    processid sampleid      bin_uri
#> 1 ACAM015-13  AC13A32 BOLD:AAA8511
#> 2 ACAM030-13  AC13A78 BOLD:AAA8511
#> 3 ACAM008-13  AC13A14 BOLD:ACE5030
#> 4 ACAM001-13  AC13A01 BOLD:AAA8511
#> 5 ACAM073-13 AC13A103 BOLD:AAA8511
#>                                               inst
#> 1 South African Institute for Aquatic Biodiversity
#> 2 South African Institute for Aquatic Biodiversity
#> 3 South African Institute for Aquatic Biodiversity
#> 4 South African Institute for Aquatic Biodiversity
#> 5 South African Institute for Aquatic Biodiversity
#DT::datatable(result_institutes,class = 'cell-border stripe')
```

### 2c.Geographic location filter

Data is downloaded followed by the ‘geography’ filter applied on it to
fetch only the relevant locations (here Ciudad de Mexico,Antioquia
Colorado) data.

``` r
api.key <- Sys.getenv('api_key')
to_download=test.data[1:100,]

result_geography<-bold.connectr(input.data = to_download,
                                  param = 'processid',
                                  param.index = 1,
                                  api_key = api.key,
                                 geography=c("United States"),
                                fields = c("bin_uri","processid","province.state"))
 
head(result_geography,5)                 
#>   processid    sampleid      bin_uri province.state
#> 1 AJS107-19 S-03-A-FBC7 BOLD:AAC9904               
#> 2 AJS009-19   S-03-C-FB         <NA>               
#> 3 AJS084-19   S-13-C-MB         <NA>               
#> 4 AJS022-19   S-08-A-FB         <NA>               
#> 5 AJS079-19   S-12-A-MB         <NA>
#DT::datatable(result_geography,class = 'cell-border stripe')
```

### 2d.Altitude

Data is downloaded followed by the ‘Altitude’ filter applied on it to
fetch data only between the range of altitude specified (100 to 1500 m
a.s.l.) data.

``` r

api.key <- Sys.getenv('api_key')
result_altitude<-bold.connectr(input.data = test.data,
                                  param = 'processid',
                                  param.index = 1,
                                  api_key = api.key,
                                 altitude = c(100,1500),
                               fields = c("bin_uri","processid","family","elev"))
head(result_altitude,5)                    
#>    processid sampleid      bin_uri    family elev
#> 1 ACAM027-13  AC13A72 BOLD:AAA8511 Cichlidae  496
#> 2 ACAM001-13  AC13A01 BOLD:AAA8511 Cichlidae  532
#> 3 ACAM015-13  AC13A32 BOLD:AAA8511 Cichlidae  526
#> 4 ACAM008-13  AC13A14 BOLD:ACE5030 Cichlidae  501
#> 5 ACAM030-13  AC13A78 BOLD:AAA8511 Cichlidae  286
#DT::datatable(result_altitude,class = 'cell-border stripe')
```

### 2e.Collection period

Data is downloaded followed by the ‘Collection period’ filter applied on
it to fetch data only between the range of dates specified (2009-2010)
data.

``` r
api.key <- Sys.getenv('api_key')
result_collection.per<-bold.connectr(input.data = test.data,
                                  param = 'processid',
                                  param.index = 1,
                                  api_key = api.key,
                                 collection.period = c( "1995-05-26","2010-01-13"),
                                 fields=c("bin_uri","processid","collection_date_start","collection_date_end"))

#DT::datatable(result_collection.per,class = 'cell-border stripe')
head(result_collection.per,5)
#>       processid sampleid      bin_uri collection_date_start collection_date_end
#> 1 GBGCA11620-15 KJ669572 BOLD:AAA8511            2009-07-15          2010-01-13
#> 2 GBGCA11628-15 KJ669573 BOLD:AAA6537            2009-07-15          2010-01-13
```

### 3.bold.connectr.public

This function retrieves all the public available data based on the
query. NO `api key` is required for this function. It also differs from
`bold.connectr` with respect to the way the data is fetched. Search can
be based on Taxonomic names, geographical locations in addition to ids
(processid and sampleid) and BINs (BIN numbers). All the other filters
can then be used on the downloaded data to refine the result.

### 3a. All data retrieved based on taxonomy

``` r

result.public<-bold.connectr.public(taxonomy = c("Panthera leo"),fields = c("bin_uri","processid","genus","species"))
#> Warning in bold.connectr.public(taxonomy = c("Panthera leo"), fields =
#> c("bin_uri", : The combination of any of the taxonomy, geography, bins, ids and
#> datasets inputs should be logical otherwise output obtained might either be
#> empty or not correct

head(result.public,10)                    
#>       processid     sampleid      bin_uri    genus      species
#> 1   ABRMM002-06  ROM PM13004 BOLD:AAD6819 Panthera Panthera leo
#> 2   ABRMM043-06   ROM 101200 BOLD:AAD6819 Panthera Panthera leo
#> 3     CAR055-11       Ple153              Panthera Panthera leo
#> 4     CAR055-11       Ple153              Panthera Panthera leo
#> 5     CAR056-11       Ple185              Panthera Panthera leo
#> 6     CAR056-11       Ple185              Panthera Panthera leo
#> 7  GBCHO2596-23 XR_006196888              Panthera Panthera leo
#> 8  GBCHO2597-23 XR_006196890              Panthera Panthera leo
#> 9  GBCHO2598-23 XR_006196891              Panthera Panthera leo
#> 10 GBCHO2599-23 XR_006196892              Panthera Panthera leo
#DT::datatable(result.public,class = 'cell-border stripe')
```

### 3b.All data retrieved based on taxonomy and geography

``` r

result.public.geo<-bold.connectr.public(taxonomy = c("Panthera leo"),geography = "India",fields = c("bin_uri","processid","country.ocean","genus","species"))
#> Warning in bold.connectr.public(taxonomy = c("Panthera leo"), geography =
#> "India", : The combination of any of the taxonomy, geography, bins, ids and
#> datasets inputs should be logical otherwise output obtained might either be
#> empty or not correct

head(result.public.geo,5)                    
#>    processid        sampleid      bin_uri country.ocean    genus      species
#> 1  CAR056-11          Ple185                      India Panthera Panthera leo
#> 2  CAR056-11          Ple185                      India Panthera Panthera leo
#> 3 GENG056-12 BIOMTWL-BLE-017 BOLD:AAD6819         India Panthera Panthera leo
#> 4 GENG057-12 BIOMTWL-BLE-063                      India Panthera Panthera leo
#> 5 GENG105-12 BIOMTWL-BLE-043                      India Panthera Panthera leo
#DT::datatable(result.public.geo,class = 'cell-border stripe')
```

### 3c.All data retrieved based on taxonomy, geography and BIN id

``` r

result.public.geo.bin<-bold.connectr.public(taxonomy = c("Panthera leo"),geography = "India",bins = 'BOLD:AAD6819',fields = c("bin_uri","country.ocean","genus","species"))
#> Warning in bold.connectr.public(taxonomy = c("Panthera leo"), geography =
#> "India", : The combination of any of the taxonomy, geography, bins, ids and
#> datasets inputs should be logical otherwise output obtained might either be
#> empty or not correct
 
head(result.public.geo.bin)                   
#>    processid        sampleid      bin_uri country.ocean    genus      species
#> 1 GENG056-12 BIOMTWL-BLE-017 BOLD:AAD6819         India Panthera Panthera leo
#DT::datatable(result.public.geo.bin,class = 'cell-border stripe')
```

The search parameters of `bold.connectr.public` should be used carefully
if a filtered result (like above) is expected. Wrong combination of
parameters might not retrieve any data.

## 4.data.summary

`data.summary` provides a detailed profile of the data downloaded
through `bold.connectr` or `bold.connectr.public`. This profile is
further broken by data types wherein each type of data get some unique
measures (Ex.mean,mode for numeric data). Profile can also be created
for specific columns using the `columns` argument. The function also
prints the number of rows and columns in the console by default.

``` r

result.public.geo.bin<-bold.connectr.public(taxonomy = c("Mus musculus"),fields = c("bin_uri","country.ocean","genus","species"))
#> Warning in bold.connectr.public(taxonomy = c("Mus musculus"), fields =
#> c("bin_uri", : The combination of any of the taxonomy, geography, bins, ids and
#> datasets inputs should be logical otherwise output obtained might either be
#> empty or not correct
                    
data.summ.res<-data.summary(result.public.geo.bin)
#> The total number of rows in the dataset is: 625 
#> The total number of columns in the dataset is: 6

data.summ.res
```

**Variable type: character**

| skim_variable | n_missing | complete_rate | min | max | empty | n_unique | whitespace |
|:--------------|----------:|--------------:|----:|----:|------:|---------:|-----------:|
| processid     |         0 |             1 |   9 |  13 |     0 |      549 |          0 |
| sampleid      |         0 |             1 |   3 |  21 |     0 |      548 |          0 |
| bin_uri       |         0 |             1 |   0 |  12 |    88 |       12 |          0 |
| country.ocean |         0 |             1 |   0 |  19 |   265 |       38 |          0 |
| genus         |         0 |             1 |   3 |   3 |     0 |        1 |          0 |
| species       |         0 |             1 |  12 |  12 |     0 |        1 |          0 |

## 5.gen.comm.mat

The function transforms the `bold.connectr()` or
`bold.connectr.public()` downloaded data into a **site X species** like
matrix. Instead of species counts (or abundances) though, values in each
cell are the counts (or abundances) of a specific BIN from a site.cat
site category or a ‘grid’. These counts can be generated at any
taxonomic hierarchical level for a single or multiple taxa (This can
also be done for ‘bin_uri’; the difference being that the numbers in
each cell would be the number of times that respective BIN is found at a
particular site.cat or ‘grid’). site.cat can be any of the geography
fields (Meta data on fields can be checked using the
bold.fields.info()). Alternatively, grids = TRUE will generate grids
based on the BIN occurrence data (latitude, longitude) with the size of
the grid determined by the user (in sq.m.). For grids generation, rows
with no latitude and longitude data are removed (even if a corresponding
site.cat information is available) while NULL entries for site.cat are
allowed if they have a latitude and longitude value (This is done
because grids are drawn based on the bounding boxes which only use
latitude and longitude values).grids converts the Coordinate Reference
System (CRS) of the data to a ‘Mollweide’ projection by which distance
based grid can be correctly specified. A cell id is also given to each
grid with the lowest number assigned to the lowest latitudinal point in
the dataset. The cellids can be changed as per the user by making
changes in the grids_final sf data frame stored in the output. The grids
can be visualized with view.grids=TRUE. The plot obtained is a
visualization of the grid centroids with their respective names. Please
note that a) if the data has many closely located grids, visualization
with view.grids can get confusing. The argument pre.abs will convert the
counts (or abundances) to 1 and 0. This dataset can then directly be
used as the input data for functions from packages like vegan for
biodiversity analyses.

### community matrix based on grids

    #>        Panthera.leo Panthera.onca Panthera.pardus Panthera.tigris
    #> cell_1            4            14              11               4
    #> cell_2           13             0              61              46
    #> cell_3            0             0               1               0
    #> cell_4            1             0               0               2
    #> cell_5            1             0               1               0
    #>        Panthera.uncia
    #> cell_1              0
    #> cell_2              3
    #> cell_3              0
    #> cell_4              0
    #> cell_5              0

## analyze.alphadiv

    #>   |                                                                              |                                                                      |   0%  |                                                                              |=                                                                     |   1%  |                                                                              |=                                                                     |   2%  |                                                                              |==                                                                    |   3%  |                                                                              |===                                                                   |   4%  |                                                                              |====                                                                  |   5%  |                                                                              |====                                                                  |   6%  |                                                                              |=====                                                                 |   7%  |                                                                              |======                                                                |   8%  |                                                                              |======                                                                |   9%  |                                                                              |=======                                                               |  10%  |                                                                              |========                                                              |  11%  |                                                                              |========                                                              |  12%  |                                                                              |=========                                                             |  13%  |                                                                              |==========                                                            |  14%  |                                                                              |==========                                                            |  15%  |                                                                              |===========                                                           |  16%  |                                                                              |============                                                          |  17%  |                                                                              |=============                                                         |  18%  |                                                                              |=============                                                         |  19%  |                                                                              |==============                                                        |  20%  |                                                                              |===============                                                       |  21%  |                                                                              |===============                                                       |  22%  |                                                                              |================                                                      |  23%  |                                                                              |=================                                                     |  24%  |                                                                              |==================                                                    |  25%  |                                                                              |==================                                                    |  26%  |                                                                              |===================                                                   |  27%  |                                                                              |====================                                                  |  28%  |                                                                              |====================                                                  |  29%  |                                                                              |=====================                                                 |  30%  |                                                                              |======================                                                |  31%  |                                                                              |======================                                                |  32%  |                                                                              |=======================                                               |  33%  |                                                                              |========================                                              |  34%  |                                                                              |========================                                              |  35%  |                                                                              |=========================                                             |  36%  |                                                                              |==========================                                            |  37%  |                                                                              |===========================                                           |  38%  |                                                                              |===========================                                           |  39%  |                                                                              |============================                                          |  40%  |                                                                              |=============================                                         |  41%  |                                                                              |=============================                                         |  42%  |                                                                              |==============================                                        |  43%  |                                                                              |===============================                                       |  44%  |                                                                              |================================                                      |  45%  |                                                                              |================================                                      |  46%  |                                                                              |=================================                                     |  47%  |                                                                              |==================================                                    |  48%  |                                                                              |==================================                                    |  49%  |                                                                              |===================================                                   |  50%  |                                                                              |====================================                                  |  51%  |                                                                              |====================================                                  |  52%  |                                                                              |=====================================                                 |  53%  |                                                                              |======================================                                |  54%  |                                                                              |======================================                                |  55%  |                                                                              |=======================================                               |  56%  |                                                                              |========================================                              |  57%  |                                                                              |=========================================                             |  58%  |                                                                              |=========================================                             |  59%  |                                                                              |==========================================                            |  60%  |                                                                              |===========================================                           |  61%  |                                                                              |===========================================                           |  62%  |                                                                              |============================================                          |  63%  |                                                                              |=============================================                         |  64%  |                                                                              |==============================================                        |  65%  |                                                                              |==============================================                        |  66%  |                                                                              |===============================================                       |  67%  |                                                                              |================================================                      |  68%  |                                                                              |================================================                      |  69%  |                                                                              |=================================================                     |  70%  |                                                                              |==================================================                    |  71%  |                                                                              |==================================================                    |  72%  |                                                                              |===================================================                   |  73%  |                                                                              |====================================================                  |  74%  |                                                                              |====================================================                  |  75%  |                                                                              |=====================================================                 |  76%  |                                                                              |======================================================                |  77%  |                                                                              |=======================================================               |  78%  |                                                                              |=======================================================               |  79%  |                                                                              |========================================================              |  80%  |                                                                              |=========================================================             |  81%  |                                                                              |=========================================================             |  82%  |                                                                              |==========================================================            |  83%  |                                                                              |===========================================================           |  84%  |                                                                              |============================================================          |  85%  |                                                                              |============================================================          |  86%  |                                                                              |=============================================================         |  87%  |                                                                              |==============================================================        |  88%  |                                                                              |==============================================================        |  89%  |                                                                              |===============================================================       |  90%  |                                                                              |================================================================      |  91%  |                                                                              |================================================================      |  92%  |                                                                              |=================================================================     |  93%  |                                                                              |==================================================================    |  94%  |                                                                              |==================================================================    |  95%  |                                                                              |===================================================================   |  96%  |                                                                              |====================================================================  |  97%  |                                                                              |===================================================================== |  98%  |                                                                              |===================================================================== |  99%  |                                                                              |======================================================================| 100%

<img src="man/figures/README-alphadiv-1.png" width="100%" style="display: block; margin: auto;" /><img src="man/figures/README-alphadiv-2.png" width="100%" style="display: block; margin: auto;" />

## analyze.betadiv

<img src="man/figures/README-betadiv-1.png" width="100%" style="display: block; margin: auto;" />

## visualize.geo

<img src="man/figures/README-gen.comm.mat-1.png" width="100%" style="display: block; margin: auto;" />

    #> Simple feature collection with 6 features and 9 fields
    #> Geometry type: POINT
    #> Dimension:     XY
    #> Bounding box:  xmin: -103.755 ymin: 12.9716 xmax: 77.5946 ymax: 35.494
    #> Geodetic CRS:  WGS 84
    #>      processid      bin_uri     lat       lon country.ocean province.state
    #> 1  AGIRI228-17 BOLD:AAA6020 12.9716   77.5946         India               
    #> 2 BBDIT1074-11 BOLD:AAA6020 26.1870  -98.3790 United States          Texas
    #> 3 BBDIT1075-11 BOLD:AAA6020 27.2640  -82.3080 United States        Florida
    #> 4 BBDIT1076-11 BOLD:AAA6020 29.2690 -103.7550 United States          Texas
    #> 5 BBDIT1531-12 BOLD:AAA6020 35.4940  -95.6710 United States       Oklahoma
    #> 6 BBDIT1578-12 BOLD:AAA6020 34.9450 -101.6600 United States          Texas
    #>                                 region                         sector
    #> 1                            Bengaluru                               
    #> 2 Bentsen-Rio Grande Valley State Park visitors centre, nature centre
    #> 3                      Sarasota County        Myakka River State Park
    #> 4                                           Big Bend Ranch State Park
    #> 5                         Gentry Creek                     campground
    #> 6          Palo Duro Canyon State Park          around Fortress Cliff
    #>                           site                geometry
    #> 1                              POINT (77.5946 12.9716)
    #> 2 grass, rescata, short forest  POINT (-98.379 26.187)
    #> 3      Myakka River Upper Lake  POINT (-82.308 27.264)
    #> 4    Grassy Bank by Rio Grande POINT (-103.755 29.269)
    #> 5            tall trees, grass  POINT (-95.671 35.494)
    #> 6              dry scrub brush  POINT (-101.66 34.945)

## align.seq

This function is currently an internal function of the package (with
documentation). This function acts as a wrapper around the `msa` and
`Biostrings` package functions for users of `BOLDconnectR` by which they
can carry out multiple sequence alignment on the downloaded data by
`bold.connectr` and `bold.connectr.public` functions. In order to use
this function following notation needs to be used
`BOLDconnectR:::align.seq`. In addition, the users need to install and
load `msa` and `Biostrings` separately before using this function to
avoid any errors. A function performs alignment using the ‘ClustalOmega’
algorithm by default, though, more refined alignments can be done by
passing additional arguments of the `msa` function to `align.seq`.

    #> using Gonnet

## analyze.seq

This function along with `align.seq` is an internal function of the
package (with documentation). This function acts as a wrapper around the
`dist.dna` and `plot.phylo` functions from `ape` for users of
`BOLDconnectR`. The users can analyse the multiple sequence alignment
output from the `align.seq` to generate a distance matrix, a Neighbor
Joining (NJ) tree visualization and a newick tree output. In order to
use this function following notation needs to be used
`BOLDconnectR:::analyze.seq`. In addition, the users need to install and
load `msa` and `Biostrings` separately before using this function to
avoid any errors. Additional arguments of `dist.dna` can be passed to
`analyze.seq` for more robust analysis.

    #> using Gonnet

<img src="man/figures/README-analyze.seq-1.png" width="100%" style="display: block; margin: auto;" />
