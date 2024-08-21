
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

## Installation

The package can be installed using `devtools::install_github` function
from the `devtools` package in R (which needs to be installed before
installing BOLDConnectR). *This package currently exists as a private
repo and thus has an authorization token*.

``` r

devtools::install_github("https://github.com/sameerpadhye/BOLDconnectR.git",
                         auth_token = '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')
```

``` r
library(BOLDconnectR)
```

## BOLDconnectR currently has 10 functions:

1.  bold.fields.info
2.  bold.connectr
3.  bold.connectr.public
4.  data.summary
5.  gen.comm.mat
6.  analyze.alphadiv
7.  analyze.betadiv
8.  visualize.geo
9.  *align.seq*
10. *analyze.seq*

*Functions 9 and 10 are currently internal functions which require
external dependencies not included in the package. For their specific
usage, please see the details provided below.*

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

## Functions usage:

### 1.bold.fields.info:

`bold.fields.info` provides all the metadata related to the various
fields (columns) currently available for download from BOLD. The
function gives the name, definition and the data type of each field.

``` r

bold.field.info<-bold.fields.info(print.output = FALSE)

knitr::kable(head(bold.field.info,5))
```

| field     | definition                                                                                              | R_field_types |
|:----------|:--------------------------------------------------------------------------------------------------------|:--------------|
| processid | BOLD System generated unique identifier for the sample being sequenced.                                 | character     |
| sampleid  | User generated identifier for the sample being sequenced, often identical to the Field ID or Museum ID. | character     |
| fieldid   | Specimen or sample identifier generated in the field or lot number for a bulk collection event.         | character     |
| museumid  | Catalog number from a museum collection.                                                                | character     |
| record_id | A BOLD generated identifier for the marker and specimen sequence combination.                           | character     |

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

knitr::kable(head(test.data,5))
```

| processid  | sampleid |
|:-----------|:---------|
| ACAM001-13 | AC13A01  |
| ACAM008-13 | AC13A14  |
| ACAM015-13 | AC13A32  |
| ACAM027-13 | AC13A72  |
| ACAM030-13 | AC13A78  |

### 2a.Default (all data retrieved)

The arguments provided below need to be specified by default for every
request. Default settings retrieve data for all available fields for
those ids.

``` r
api.key <- Sys.getenv('api_key')
# A small subset of the data used for data retrieval
to_download=test.data[1:100,]

result<-bold.connectr(input.data = to_download,
                                  param = 'processid',
                                  param.index = 1,
                                  api_key = api.key)
knitr::kable(head(result,5))
```

| processid | record_id        | insdc_acs | sampleid  | specimenid | taxid | short_note | identification_method | museumid | fieldid   | collection_code | processid_minted_date | inst               | specimendetails.verbatim_depository | funding_src | sex | life_stage | reproduction | habitat | collectors | site_code | specimen_linkout | collection_event_id | sampling_protocol | tissue_type | collection_date_start | specimendetails.verbatim_collectiondate | collection_time | collection_date_accuracy | specimendetails.verbatim_collectiondate_precision | associated_taxa | associated_specimens | voucher_type | notes | taxonomy_notes | collection_notes | specimendetails.verbatim_kingdom | specimendetails.verbatim_phylum | specimendetails.verbatim_class | specimendetails.verbatim_order | specimendetails.verbatim_family | specimendetails.verbatim_subfamily | specimendetails.verbatim_tribe | specimendetails.verbatim_genus | specimendetails.verbatim_species | specimendetails.verbatim_subspecies | specimendetails.verbatim_species_reference | specimendetails.verbatim_identifier | geoid | location.verbatim_country | location.verbatim_province | location.verbatim_country_iso_alpha3 | marker_code | kingdom  | phylum   | class          | order        | family    | subfamily           | tribe | genus       | species               | subspecies | identification        | identification_rank | tax_rank.numerical_posit | species_reference | identified_by | specimendetails\_\_identifier.person.email | sequence_run_site  | nuc                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | nuc_basecount | sequence_upload_date | bin_uri      | bin_created_date | elev | location.verbatim_elev | depth | location.verbatim_depth | lat | lon | location.verbatim_coord | coord_source | coord_accuracy | location.verbatim_gps_accuracy | elev_accuracy | location.verbatim_elev_accuracy | depth_accuracy | location.verbatim_depth_accuracy | realm | biome | ecoregion | region | sector | site | country_iso | country.ocean | province.state | bold_recordset_code_arr                        | geopol_denorm.country_iso3 | collection_date_end |
|:----------|:-----------------|:----------|:----------|-----------:|------:|:-----------|:----------------------|:---------|:----------|:----------------|:----------------------|:-------------------|:------------------------------------|:------------|:----|:-----------|:-------------|:--------|:-----------|:----------|:-----------------|:--------------------|:------------------|:------------|:----------------------|:----------------------------------------|:----------------|:-------------------------|:--------------------------------------------------|:----------------|:---------------------|:-------------|:------|:---------------|:-----------------|:---------------------------------|:--------------------------------|:-------------------------------|:-------------------------------|:--------------------------------|:-----------------------------------|:-------------------------------|:-------------------------------|:---------------------------------|:------------------------------------|:-------------------------------------------|:------------------------------------|------:|:--------------------------|:---------------------------|:-------------------------------------|:------------|:---------|:---------|:---------------|:-------------|:----------|:--------------------|:------|:------------|:----------------------|:-----------|:----------------------|:--------------------|-------------------------:|:------------------|:--------------|:-------------------------------------------|:-------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------:|:---------------------|:-------------|:-----------------|-----:|:-----------------------|------:|:------------------------|----:|----:|:------------------------|:-------------|---------------:|:-------------------------------|--------------:|:--------------------------------|---------------:|:---------------------------------|:------|:------|:----------|:-------|:-------|:-----|:------------|:--------------|:---------------|:-----------------------------------------------|:---------------------------|:--------------------|
| AJS024-19 | AJS024-19.COI-5P |           | S-08-C-FB |   10597390 | 52768 | NA         | NA                    |          | S-08-C-FB |                 | 2019-08-08            | Chapman University | NA                                  | NA          | NA  | NA         | NA           | NA      |            | NA        | NA               | NA                  | NA                | NA          | NA                    | NA                                      | NA              | NA                       | NA                                                | NA              | NA                   | NA           | NA    | NA             | NA               | NA                               | NA                              | NA                             | NA                             | NA                              | NA                                 | NA                             | NA                             | NA                               | NA                                  | NA                                         | NA                                  |   238 | NA                        | NA                         | NA                                   | COI-5P      | Animalia | Chordata | Actinopterygii | Cichliformes | Cichlidae | Pseudocrenilabrinae | NA    | Oreochromis | Oreochromis niloticus | NA         | Oreochromis niloticus | species             |                       17 | Linnaeus, 1758    | NA            | NA                                         | Chapman University | —-GGCACCCTCTATCTAGTATTTGGTGCTTGAGCCGGAATAGTAGGAACTGCACTAAGCCTCCTAATTCGGGCAGAACTAAGCCAGCCCGGCTCTCTTCTCGGAGACGACCAAATCTATAATGTAATTGTTACAGCACATGCTTTCGTAATAATTTTCTTTATAGTAATACCAATTATGATTGGAGGCTTTGGAAACTGACTAGTACCCCTCATGATTGGTGCACCAGACATGGCCTTCCCTCGAATAAATAACATGAGCTTTTGACTTCTCCCCCCCTCATTTCTTCTTCTTCTCGCCTCATCTGGAGTCGAAGCAGGTGCCGGCACAGGATGGACTGTTTATCCCCCGCTCGCAGGCAATCTTGCCCACGCTGGACCTTCTGTTGACTTAACCATCTTCTCCCTCCACTTGGCCGGAGTGTCATCTATTTTAGGTGCAATTAATTTTATCACAACCATTATTAACATGAAACCCCCTGCCATCTCCCAATATCAAACACCCCTATTTGTGTGATCCGTCCTAATTACCGCAGTACTACTCCTTCTATCCCTGCCCGTTCTTGCCGCCGGCATCACAATACTTCTAACAGACCGAAACCTAAACACAACCTTCTTTGACCCTGCCGGAGGAGGAGACCCCATCCTATACCAACACTTATTCTGATT— |           665 | 2019-08-08           | BOLD:AAC9904 | 2010-07-15       |   NA | NA                     |    NA | NA                      |  NA |  NA | NA                      | NA           |             NA | NA                             |            NA | NA                              |             NA | NA                               | NA    | NA    | NA        | NA     | NA     | NA   | US          | United States |                | AJS,DS-OREOSA,DS-OREOSARO,DS-TANGQIAN,DS-CICHI | USA                        | NA                  |
| AJS078-19 | AJS078-19.COI-5P |           | S-11-C-MB |   10597444 | 52768 | NA         | NA                    |          | S-11-C-MB |                 | 2019-08-08            | Chapman University | NA                                  | NA          | NA  | NA         | NA           | NA      |            | NA        | NA               | NA                  | NA                | NA          | NA                    | NA                                      | NA              | NA                       | NA                                                | NA              | NA                   | NA           | NA    | NA             | NA               | NA                               | NA                              | NA                             | NA                             | NA                              | NA                                 | NA                             | NA                             | NA                               | NA                                  | NA                                         | NA                                  |   238 | NA                        | NA                         | NA                                   | COI-5P      | Animalia | Chordata | Actinopterygii | Cichliformes | Cichlidae | Pseudocrenilabrinae | NA    | Oreochromis | Oreochromis niloticus | NA         | Oreochromis niloticus | species             |                       17 | Linnaeus, 1758    | NA            | NA                                         | Chapman University | TCTAGTATTTGGTGCTTGAGCCGGAATAGTAGGAACTGCACTAAGCCTCCTAATTCGGGCAGAACTAAGCCAGCCCGGCTCTCTTCTCGGAGACGACCAAATYTATAATGTAATTGTTACAGCACATGCTTTCGTAATAATTTTCTTTATAGTAATACCAATTATGATTGGAGGCTTTGGAAACTGACTAGTACCCCTCATGATTGGTGCACCAGACATGGCCTT                                                                                                                                                                                                                                                                                                                                                                                                                                                            |           224 | 2019-08-08           | NA           | NA               |   NA | NA                     |    NA | NA                      |  NA |  NA | NA                      | NA           |             NA | NA                             |            NA | NA                              |             NA | NA                               | NA    | NA    | NA        | NA     | NA     | NA   | US          | United States |                | AJS,DS-OREOSA,DS-OREOSARO                      | USA                        | NA                  |
| AJS008-19 | AJS008-19.COI-5P |           | S-03-B-FB |   10597374 | 52768 | NA         | NA                    |          | S-03-B-FB |                 | 2019-08-08            | Chapman University | NA                                  | NA          | NA  | NA         | NA           | NA      |            | NA        | NA               | NA                  | NA                | NA          | NA                    | NA                                      | NA              | NA                       | NA                                                | NA              | NA                   | NA           | NA    | NA             | NA               | NA                               | NA                              | NA                             | NA                             | NA                              | NA                                 | NA                             | NA                             | NA                               | NA                                  | NA                                         | NA                                  |   238 | NA                        | NA                         | NA                                   | COI-5P      | Animalia | Chordata | Actinopterygii | Cichliformes | Cichlidae | Pseudocrenilabrinae | NA    | Oreochromis | Oreochromis niloticus | NA         | Oreochromis niloticus | species             |                       17 | Linnaeus, 1758    | NA            | NA                                         | Chapman University | TATTGGCACCCTCTATCTAGTATTTGGTGCTTGAGCCGGAATAGTAGGAACTGCACTAAGCCTCCTAATTCGGGCAGAACTAAGCCAGCCCGGCTCTCTTCTCGGAGACGACCAAATYTATAATGTAATTGTTACAGCACATGCTTTCGTAATAATTTTCTTTATAGTAATACCAATTATGATTGGAGGCTTTGGAAACTGACTAGTACCCCTCATGATTGGTGCACCAGACATGGCYTTCCCTCGAATAAATAACATRAGCTTTTGACTTCTCCCCCCCTCWTTTCTKCTTCTTYTCGCCTCATCTGGAGTCGAAGCAGGTGCCGGMACAGGATGRACTGTTTATCCCCCGYTCGCAGGCAATCTTGCCCACGCTGGACCTTCTGTTGACTTAACCATCTTCTCCCTCCACTTGGCCGGARTGTCATCTATTTTAGGTGCAATTAATTTTATCACAACCATTATTAACATGAAACCCCCTGCCATCTCCCAATATCAAACACCCCTATTTGTGTGATCCGTCCTAATTACCGCAKTACTACTCCTTCTATCCCTGCCCGTTCTTGCCGCCGGCATCACAATACTTCTAA———————————————————————————–                                                   |           579 | 2019-08-08           | NA           | NA               |   NA | NA                     |    NA | NA                      |  NA |  NA | NA                      | NA           |             NA | NA                             |            NA | NA                              |             NA | NA                               | NA    | NA    | NA        | NA     | NA     | NA   | US          | United States |                | AJS,DS-OREOSA,DS-OREOSARO,DS-TANGQIAN,DS-CICHI | USA                        | NA                  |
| AJS002-19 | AJS002-19.COI-5P |           | S-01-B-FB |   10597368 | 52768 | NA         | NA                    |          | S-01-B-FB |                 | 2019-08-08            | Chapman University | NA                                  | NA          | NA  | NA         | NA           | NA      |            | NA        | NA               | NA                  | NA                | NA          | NA                    | NA                                      | NA              | NA                       | NA                                                | NA              | NA                   | NA           | NA    | NA             | NA               | NA                               | NA                              | NA                             | NA                             | NA                              | NA                                 | NA                             | NA                             | NA                               | NA                                  | NA                                         | NA                                  |   238 | NA                        | NA                         | NA                                   | COI-5P      | Animalia | Chordata | Actinopterygii | Cichliformes | Cichlidae | Pseudocrenilabrinae | NA    | Oreochromis | Oreochromis niloticus | NA         | Oreochromis niloticus | species             |                       17 | Linnaeus, 1758    | NA            | NA                                         | Chapman University | TATTGGCACCCTCTATCTAGTATTTGGTGCTTGAGCCGGAATAGTAGGAACTGCACTAAGCCTCCTAATTCGGGCAGAACTAAGCCAGCCCGGCTCTCTTCTCGGAGACGACCAAATCTATAATGTAATTGTTACAGCACATGCTTTCGTAATAATTTTCTTTATAGTAATACCAATTATGATTGGAGGCTTTGGAAACTGACTAGTACCCCTCATGATTGGTGCACCAGACATGGCCTTCCCTCGAATAAATAACATGAGCTTTTGACTTCTCCCCCCCTCATTTCTTCTTCTTCTCGCCTCATCTGGAGTCGAAGCAGGTGCCGGCACAGGATGGACTGTTTATCCCCCGCTCGCAGGCAATCTTGCCCACGCTGGACCTTCTGTTGACTTAACCATCTTCTCCCTCCACTTGGCCGGAGTGTCATCTATTTTAGGTGCAATTAATTTTATCACAACCATTATTAACATGAAACCCCCTGCCATCTCCCAATATCAAACACCCCTATTTGTGTGATCCGTCCTAATTACCGCAGTACTACTCCTTCTATCCCTGCCCGTTCTTGCCGCCGGCATCACAATACTTCTAACAGACCGAAA————————————————————————                                             |           600 | 2019-08-08           | BOLD:AAC9904 | 2010-07-15       |   NA | NA                     |    NA | NA                      |  NA |  NA | NA                      | NA           |             NA | NA                             |            NA | NA                              |             NA | NA                               | NA    | NA    | NA        | NA     | NA     | NA   | US          | United States |                | AJS,DS-OREOSA,DS-OREOSARO,DS-TANGQIAN,DS-CICHI | USA                        | NA                  |
| AJS032-19 | AJS032-19.COI-5P |           | S-11-B-FB |   10597398 | 52768 | NA         | NA                    |          | S-11-B-FB |                 | 2019-08-08            | Chapman University | NA                                  | NA          | NA  | NA         | NA           | NA      |            | NA        | NA               | NA                  | NA                | NA          | NA                    | NA                                      | NA              | NA                       | NA                                                | NA              | NA                   | NA           | NA    | NA             | NA               | NA                               | NA                              | NA                             | NA                             | NA                              | NA                                 | NA                             | NA                             | NA                               | NA                                  | NA                                         | NA                                  |   238 | NA                        | NA                         | NA                                   | COI-5P      | Animalia | Chordata | Actinopterygii | Cichliformes | Cichlidae | Pseudocrenilabrinae | NA    | Oreochromis | Oreochromis niloticus | NA         | Oreochromis niloticus | species             |                       17 | Linnaeus, 1758    | NA            | NA                                         | Chapman University | —-GGCACCCTCTATCTAGTATTTGGTGCTTGAGCCGGAATAGTAGGAACTGCACTAAGCCTCCTAATTCGGGCAGAACTAAGCCAGCCCGGCTCTCTTCTCGGAGACGACCAAATCTATAATGTAATTGTTACAGCACATGCTTTCGTAATAATTTTCTTTATAGTAATACCAATTATGATTGGAGGCTTTGGAAACTGACTAGTACCCCTCATGATTGGTGCACCAGACATGGCCTTCCCTCGAATAAATAACATGAGCTTTTGACTTCTCCCCCCCTCATTTCTTCTTCTTCTCGCCTCATCTGGAGTCGAAGCAGGTGCCGGCACAGGATGGACTGTTTATCCCCCGCTCGCAGGCAATCTTGCCCACGCTGGACCTTCTGTTGACTTAACCATCTTCTCCCTCCACTTGGCCGGAGTGTCATCTATTTTAGGTGCAATTAATTTTATCACAACCATTATTAACATGAAACCCCCTGCCATCTCCCAATATCAAACACCCCTATTTGTGTGATCCGTCCTAATTACCGCAGTACTACTCCTTCTATCCCTGCCCGTTCTTGCCGCCGGCATCACAATACTTCTAACAGACCGAAACCTAAACACAACCTTCTTTGACCCTGCCGGAGGAGGAGACCCCATCCTATACCAACACTTATTCTGATT— |           665 | 2019-08-08           | BOLD:AAC9904 | 2010-07-15       |   NA | NA                     |    NA | NA                      |  NA |  NA | NA                      | NA           |             NA | NA                             |            NA | NA                              |             NA | NA                               | NA    | NA    | NA        | NA     | NA     | NA   | US          | United States |                | AJS,DS-OREOSA,DS-OREOSARO,DS-TANGQIAN,DS-CICHI | USA                        | NA                  |

### 2b.Institutes Filter

Data is downloaded followed by the ‘institute’ filter applied on it to
fetch only the relevant ‘institute’ (here South African Institute for
Aquatic Biodiversity) data.

``` r
api.key <- Sys.getenv('api_key')
# A small subset of the data used for data retrieval
result_institutes<-bold.connectr(input.data = to_download,
                                  param = 'processid',
                                  param.index = 1,
                                  api_key = api.key,
                      institutes = "South African Institute for Aquatic Biodiversity",
                      fields = c("bin_uri","processid","inst"))

knitr::kable(head(result_institutes,5))
```

| processid  | sampleid | bin_uri      | inst                                             |
|:-----------|:---------|:-------------|:-------------------------------------------------|
| ACAM001-13 | AC13A01  | BOLD:AAA8511 | South African Institute for Aquatic Biodiversity |
| ACAM027-13 | AC13A72  | BOLD:AAA8511 | South African Institute for Aquatic Biodiversity |
| ACAM073-13 | AC13A103 | BOLD:AAA8511 | South African Institute for Aquatic Biodiversity |
| ACAM008-13 | AC13A14  | BOLD:ACE5030 | South African Institute for Aquatic Biodiversity |
| ACAM015-13 | AC13A32  | BOLD:AAA8511 | South African Institute for Aquatic Biodiversity |

### 2c.Geographic location filter

Data is downloaded followed by the ‘geography’ filter applied on it to
fetch only the relevant locations (here United States) data.

``` r
api.key <- Sys.getenv('api_key')

to_download=test.data[1:100,]
result_geography<-bold.connectr(input.data = to_download,
                                  param = 'processid',
                                  param.index = 1,
                                  api_key = api.key,
                                 geography=c("United States"),
                                fields = c("bin_uri","processid","province.state"))
 
knitr::kable(head(result_geography,5))                 
```

| processid | sampleid    | bin_uri      | province.state |
|:----------|:------------|:-------------|:---------------|
| AJS105-19 | S-03-A-FBC5 | BOLD:AAC9904 |                |
| AJS052-19 | S-03-A-MB   | NA           |                |
| AJS071-19 | S-09-B-MB   | NA           |                |
| AJS107-19 | S-03-A-FBC7 | BOLD:AAC9904 |                |
| AJS012-19 | S-04-C-FB   | BOLD:AAC9904 |                |

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

knitr::kable(head(result_altitude,5))                    
```

| processid  | sampleid | bin_uri      | family    | elev |
|:-----------|:---------|:-------------|:----------|-----:|
| ACAM001-13 | AC13A01  | BOLD:AAA8511 | Cichlidae |  532 |
| ACAM030-13 | AC13A78  | BOLD:AAA8511 | Cichlidae |  286 |
| ACAM008-13 | AC13A14  | BOLD:ACE5030 | Cichlidae |  501 |
| ACAM027-13 | AC13A72  | BOLD:AAA8511 | Cichlidae |  496 |
| ACAM015-13 | AC13A32  | BOLD:AAA8511 | Cichlidae |  526 |

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

knitr::kable(head(result_collection.per,5))
```

| processid     | sampleid | bin_uri      | collection_date_start | collection_date_end |
|:--------------|:---------|:-------------|:----------------------|:--------------------|
| GBGCA11620-15 | KJ669572 | BOLD:AAA8511 | 2009-07-15            | 2010-01-13          |
| GBGCA11628-15 | KJ669573 | BOLD:AAA6537 | 2009-07-15            | 2010-01-13          |

### 3.bold.connectr.public

This function retrieves all the public available data based on the
query. NO `api key` is required for this function. It also differs from
`bold.connectr` with respect to the way the data is fetched. Search can
be based on Taxonomic names, geographical locations in addition to ids
(processid and sampleid) and BINs (BIN numbers). All the other filters
can then be used on the downloaded data to refine the result. *The
search parameters of `bold.connectr.public` should be used carefully if
a filtered result (like above) is expected. Wrong combination of
parameters might not retrieve any data.*

### 3a.All data retrieved based on taxonomy

``` r

result.public<-bold.connectr.public(taxonomy = c("Panthera leo"),fields = c("bin_uri","processid","genus","species"))

knitr::kable(head(result.public,10))                    
```

| processid    | sampleid     | bin_uri      | genus    | species      |
|:-------------|:-------------|:-------------|:---------|:-------------|
| ABRMM002-06  | ROM PM13004  | BOLD:AAD6819 | Panthera | Panthera leo |
| ABRMM043-06  | ROM 101200   | BOLD:AAD6819 | Panthera | Panthera leo |
| CAR055-11    | Ple153       |              | Panthera | Panthera leo |
| CAR055-11    | Ple153       |              | Panthera | Panthera leo |
| CAR056-11    | Ple185       |              | Panthera | Panthera leo |
| CAR056-11    | Ple185       |              | Panthera | Panthera leo |
| GBCHO2596-23 | XR_006196888 |              | Panthera | Panthera leo |
| GBCHO2597-23 | XR_006196890 |              | Panthera | Panthera leo |
| GBCHO2598-23 | XR_006196891 |              | Panthera | Panthera leo |
| GBCHO2599-23 | XR_006196892 |              | Panthera | Panthera leo |

### 3b.All data retrieved based on taxonomy and geography

``` r
result.public.geo<-bold.connectr.public(taxonomy = c("Panthera leo"),geography = "India",fields = c("bin_uri","processid","country.ocean","genus","species"))

knitr::kable(head(result.public.geo,5))                    
```

| processid  | sampleid        | bin_uri      | country.ocean | genus    | species      |
|:-----------|:----------------|:-------------|:--------------|:---------|:-------------|
| CAR056-11  | Ple185          |              | India         | Panthera | Panthera leo |
| CAR056-11  | Ple185          |              | India         | Panthera | Panthera leo |
| GENG056-12 | BIOMTWL-BLE-017 | BOLD:AAD6819 | India         | Panthera | Panthera leo |
| GENG057-12 | BIOMTWL-BLE-063 |              | India         | Panthera | Panthera leo |
| GENG105-12 | BIOMTWL-BLE-043 |              | India         | Panthera | Panthera leo |

### 3c.All data retrieved based on taxonomy, geography and BIN id

``` r
result.public.geo.bin<-bold.connectr.public(taxonomy = c("Panthera leo"),geography = "India",bins = 'BOLD:AAD6819',fields = c("bin_uri","country.ocean","genus","species"))
 
knitr::kable(head(result.public.geo.bin))                   
```

| processid  | sampleid        | bin_uri      | country.ocean | genus    | species      |
|:-----------|:----------------|:-------------|:--------------|:---------|:-------------|
| GENG056-12 | BIOMTWL-BLE-017 | BOLD:AAD6819 | India         | Panthera | Panthera leo |

### 4.data.summary

`data.summary` provides a detailed profile of the data downloaded
through `bold.connectr` or `bold.connectr.public`. This profile is
further broken by data types wherein each type of data get some unique
measures (Ex.mean,mode for numeric data). Profile can also be created
for specific columns using the `columns` argument. The function also
prints the number of rows and columns in the console by default.

``` r
result.public.geo.bin<-bold.connectr.public(taxonomy = c("Mus musculus"),fields = c("bin_uri","country.ocean","genus","species"))
                    
data.summ.res<-data.summary(result.public.geo.bin)
#> The total number of rows in the dataset is: 625 
#> The total number of columns in the dataset is: 6

# Data summary
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

### 5.gen.comm.mat

`gen.comm.mat`transforms the `bold.connectr()` or
`bold.connectr.public()` downloaded data into a **site X species** like
matrix. Instead of species counts (or abundances) though, values in each
cell are the counts (or abundances) BINs from the site category
(*site.cat*) or a *grid*. These counts can be generated at any taxonomic
hierarchical level for a single or multiple taxa (This can also be done
for ‘bin_uri’; the difference being that the numbers in each cell would
be the number of times that respective BIN is found at a particular
*site.cat* or *grid*). *site.cat* can be any of the geography fields
(Meta data on fields can be checked using the `bold.fields.info()`).
Alternatively, `grids` = TRUE will generate grids based on the BIN
occurrence data (latitude, longitude) with the size of the grid
determined by the user (in sq.m.). For grids generation, rows with no
latitude and longitude data are removed (even if a corresponding
*site.cat* information is available) while NULL entries for *site.cat*
are allowed if they have a latitude and longitude value (This is done
because grids are drawn based on the bounding boxes which only use
latitude and longitude values).grids converts the Coordinate Reference
System (CRS) of the data to a **Mollweide** projection by which distance
based grid can be appropriately specified. A cell id is also given to
each grid with the smallest number assigned to the lowest latitudinal
point in the data. The cell ids can be changed as per the user by making
changes in the `grids_final` `sf` data frame stored in the output. The
grids can be visualized with `view.grids`=TRUE. The plot obtained is a
visualization of the grid centroids with their respective names. *Please
note that if the data has many closely located grids, visualization with
view.grids can get confusing*. The argument `pre.abs` will convert the
counts (or abundances) to 1 and 0. This data set can then directly be
used as the input data for functions from packages like vegan for
biodiversity analyses.

``` r

# Download data from BOLD
comm.mat.data<-bold.connectr.public(taxonomy = "Panthera")

# Generate the community matrix based on grids
comm.data.grid<-gen.comm.mat(comm.mat.data,taxon.rank="species",grids = TRUE,gridsize = 10000000)

grids_output<-comm.data.grid$grids

# Community matrix based on grids
knitr::kable(head(comm.data.grid$comm.matrix))
```

|        | Panthera.leo | Panthera.onca | Panthera.pardus | Panthera.tigris | Panthera.uncia |
|:-------|-------------:|--------------:|----------------:|----------------:|---------------:|
| cell_1 |            4 |            14 |              11 |               4 |              0 |
| cell_2 |           13 |             0 |              61 |              46 |              3 |
| cell_3 |            0 |             0 |               1 |               0 |              0 |
| cell_4 |            1 |             0 |               0 |               2 |              0 |
| cell_5 |            1 |             0 |               1 |               0 |              0 |

### 6.analyze.alphadiv

`analyze.alphadiv` estimates the richness and calculates the shannon
diversity indexes from BIN counts (and/or presence-absence) data at the
user-specified taxonomic level using the `comm.matrix` output of the
`gen.comm.mat` function. It acts as a wrapper function around
`BAT::alpha.accum()`, `vegan::prestondistr()` and `vegan::diversity()`
to create a biodiversity profile. Preston plots are created using the
data from the `prestondistr` results where cyan bars represent observed
species (or equivalent taxonomic group) and orange dots for expected the
counts. *Note that the results, including species counts, adapt based on
taxonomic rank used in `gen.comm.mat()` although the output label
remains ‘species’ in some instances (preston.res).*

``` r

# Download data from BOLD (removing species with blanks)
comm.mat.data<-bold.connectr.public(taxonomy = "Poecilia")

# Remove rows which have no species data
comm.mat.data<-comm.mat.data[!comm.mat.data$species=="",]

# Generate the community matrix based on grids
comm.data.grid<-gen.comm.mat(comm.mat.data,taxon.rank="species",site.cat='country.ocean')

# Community matrix (result assigned to a new variable)
grid.data<-comm.data.grid$comm.matrix

# Diversity results with estimation curve and without preston results
div.res1<-analyze.alphadiv(grid.data,plot.curve=TRUE,curve.index="Jack1ab",curve.xval = "Sampl",preston.res = TRUE,pres.plot.y.label = "species")
#>   |                                                                              |                                                                      |   0%  |                                                                              |=                                                                     |   1%  |                                                                              |=                                                                     |   2%  |                                                                              |==                                                                    |   3%  |                                                                              |===                                                                   |   4%  |                                                                              |====                                                                  |   5%  |                                                                              |====                                                                  |   6%  |                                                                              |=====                                                                 |   7%  |                                                                              |======                                                                |   8%  |                                                                              |======                                                                |   9%  |                                                                              |=======                                                               |  10%  |                                                                              |========                                                              |  11%  |                                                                              |========                                                              |  12%  |                                                                              |=========                                                             |  13%  |                                                                              |==========                                                            |  14%  |                                                                              |==========                                                            |  15%  |                                                                              |===========                                                           |  16%  |                                                                              |============                                                          |  17%  |                                                                              |=============                                                         |  18%  |                                                                              |=============                                                         |  19%  |                                                                              |==============                                                        |  20%  |                                                                              |===============                                                       |  21%  |                                                                              |===============                                                       |  22%  |                                                                              |================                                                      |  23%  |                                                                              |=================                                                     |  24%  |                                                                              |==================                                                    |  25%  |                                                                              |==================                                                    |  26%  |                                                                              |===================                                                   |  27%  |                                                                              |====================                                                  |  28%  |                                                                              |====================                                                  |  29%  |                                                                              |=====================                                                 |  30%  |                                                                              |======================                                                |  31%  |                                                                              |======================                                                |  32%  |                                                                              |=======================                                               |  33%  |                                                                              |========================                                              |  34%  |                                                                              |========================                                              |  35%  |                                                                              |=========================                                             |  36%  |                                                                              |==========================                                            |  37%  |                                                                              |===========================                                           |  38%  |                                                                              |===========================                                           |  39%  |                                                                              |============================                                          |  40%  |                                                                              |=============================                                         |  41%  |                                                                              |=============================                                         |  42%  |                                                                              |==============================                                        |  43%  |                                                                              |===============================                                       |  44%  |                                                                              |================================                                      |  45%  |                                                                              |================================                                      |  46%  |                                                                              |=================================                                     |  47%  |                                                                              |==================================                                    |  48%  |                                                                              |==================================                                    |  49%  |                                                                              |===================================                                   |  50%  |                                                                              |====================================                                  |  51%  |                                                                              |====================================                                  |  52%  |                                                                              |=====================================                                 |  53%  |                                                                              |======================================                                |  54%  |                                                                              |======================================                                |  55%  |                                                                              |=======================================                               |  56%  |                                                                              |========================================                              |  57%  |                                                                              |=========================================                             |  58%  |                                                                              |=========================================                             |  59%  |                                                                              |==========================================                            |  60%  |                                                                              |===========================================                           |  61%  |                                                                              |===========================================                           |  62%  |                                                                              |============================================                          |  63%  |                                                                              |=============================================                         |  64%  |                                                                              |==============================================                        |  65%  |                                                                              |==============================================                        |  66%  |                                                                              |===============================================                       |  67%  |                                                                              |================================================                      |  68%  |                                                                              |================================================                      |  69%  |                                                                              |=================================================                     |  70%  |                                                                              |==================================================                    |  71%  |                                                                              |==================================================                    |  72%  |                                                                              |===================================================                   |  73%  |                                                                              |====================================================                  |  74%  |                                                                              |====================================================                  |  75%  |                                                                              |=====================================================                 |  76%  |                                                                              |======================================================                |  77%  |                                                                              |=======================================================               |  78%  |                                                                              |=======================================================               |  79%  |                                                                              |========================================================              |  80%  |                                                                              |=========================================================             |  81%  |                                                                              |=========================================================             |  82%  |                                                                              |==========================================================            |  83%  |                                                                              |===========================================================           |  84%  |                                                                              |============================================================          |  85%  |                                                                              |============================================================          |  86%  |                                                                              |=============================================================         |  87%  |                                                                              |==============================================================        |  88%  |                                                                              |==============================================================        |  89%  |                                                                              |===============================================================       |  90%  |                                                                              |================================================================      |  91%  |                                                                              |================================================================      |  92%  |                                                                              |=================================================================     |  93%  |                                                                              |==================================================================    |  94%  |                                                                              |==================================================================    |  95%  |                                                                              |===================================================================   |  96%  |                                                                              |====================================================================  |  97%  |                                                                              |===================================================================== |  98%  |                                                                              |===================================================================== |  99%  |                                                                              |======================================================================| 100%

# Species richness plot
div.res1$richness_plot
```

<img src="man/figures/README-alphadiv-1.png" width="100%" style="display: block; margin: auto;" />

``` r

# Preston plot
div.res1$preston.plot
```

<img src="man/figures/README-alphadiv-2.png" width="100%" style="display: block; margin: auto;" />

### 7.analyze.betadiv

`analyze.betadiv` calculates beta dissimilarity based on either the
Sørensen or Jaccard indexes using the `comm.matrix` output of the
`gen.comm.mat` function. It also generates matrices of *species
replacement* and *richness difference* components of the total beta
diversity. These values are calculated using `BAT::beta()` function,
which partitions the data using the Podani & Schmera (2011)/Carvalho et
al. (2012) approach. Additionally, a corresponding heatmap can be
obtained when `heatmap`=TRUE. For grid-based heatmaps, grids are
arranged based on their centroid distances, placing nearest grids
closest together. For site categories, heatmap labels are arranged
alphabetically. *Note that grid- based heatmaps require `grids` = TRUE
and a spatial dataframe sf-object `grid.df` generated from the
`gen.comm.mat` function, to be provided.*

``` r

#Download data from BOLD (removing species with blanks)
comm.mat.data<-bold.connectr.public(taxonomy = "Poecilia")

#Generate the community matrix based on grids
comm.data.beta<-gen.comm.mat(comm.mat.data,taxon.rank="species",site.cat = "country.ocean")

#beta diversity with the heatmaps
beta.div.res2<-analyze.betadiv(comm.data.beta$comm.matrix,index="sorenson",heatmap = TRUE,component = "total")

# Total beta diversity matrix (10 rows)
knitr::kable(head(as.matrix(round(beta.div.res2$total.beta,2)),10))
```

|            |      | Argentina | Australia | Bangladesh | Belize | Brazil | Cape Verde | China | Colombia | Costa Rica | El Salvador | French Guiana | French Polynesia | Germany | Guatemala | Honduras | India | Indonesia | Iraq | Israel | Japan | Kenya | Libya | Madagascar | Malaysia | Mexico | Myanmar | Namibia | Nicaragua | Nigeria | Panama | Philippines | Puerto Rico | South Africa | Taiwan | Thailand | Trinidad and Tobago | Uganda | United States | Vietnam |
|:-----------|-----:|----------:|----------:|-----------:|-------:|-------:|-----------:|------:|---------:|-----------:|------------:|--------------:|-----------------:|--------:|----------:|---------:|------:|----------:|-----:|-------:|------:|------:|------:|-----------:|---------:|-------:|--------:|--------:|----------:|--------:|-------:|------------:|------------:|-------------:|-------:|---------:|--------------------:|-------:|--------------:|--------:|
|            | 0.00 |      0.83 |      0.57 |       0.83 |   0.83 |   0.60 |       0.83 |  0.83 |     0.77 |       0.85 |         1.0 |             1 |             0.83 |    0.83 |      0.83 |     0.62 |  0.38 |      0.69 | 0.83 |   0.69 |  0.67 |  0.83 |  0.83 |       0.83 |     0.83 |   0.52 |    0.83 |    0.83 |      0.73 |    0.83 |   0.76 |        0.83 |        0.69 |         0.57 |   0.69 |     0.83 |                0.85 |   0.83 |          0.57 |    0.83 |
| Argentina  | 0.83 |      0.00 |      0.50 |       0.00 |   1.00 |   0.60 |       0.00 |  0.00 |     0.88 |       1.00 |         1.0 |             1 |             0.00 |    0.00 |      1.00 |     1.00 |  0.67 |      0.33 | 1.00 |   1.00 |  0.75 |  0.00 |  1.00 |       0.00 |     0.00 |   1.00 |    0.00 |    1.00 |      1.00 |    0.00 |   0.71 |        1.00 |        0.33 |         0.50 |   1.00 |     0.00 |                0.33 |   0.00 |          0.50 |    0.00 |
| Australia  | 0.57 |      0.50 |      0.00 |       0.50 |   1.00 |   0.71 |       0.50 |  0.50 |     0.78 |       1.00 |         1.0 |             1 |             0.50 |    0.50 |      1.00 |     0.75 |  0.25 |      0.60 | 1.00 |   0.60 |  0.40 |  0.50 |  0.50 |       0.50 |     0.50 |   0.69 |    0.50 |    1.00 |      0.71 |    0.50 |   0.78 |        1.00 |        0.60 |         0.00 |   0.60 |     0.50 |                0.60 |   0.50 |          0.67 |    0.50 |
| Bangladesh | 0.83 |      0.00 |      0.50 |       0.00 |   1.00 |   0.60 |       0.00 |  0.00 |     0.88 |       1.00 |         1.0 |             1 |             0.00 |    0.00 |      1.00 |     1.00 |  0.67 |      0.33 | 1.00 |   1.00 |  0.75 |  0.00 |  1.00 |       0.00 |     0.00 |   1.00 |    0.00 |    1.00 |      1.00 |    0.00 |   0.71 |        1.00 |        0.33 |         0.50 |   1.00 |     0.00 |                0.33 |   0.00 |          0.50 |    0.00 |
| Belize     | 0.83 |      1.00 |      1.00 |       1.00 |   0.00 |   1.00 |       1.00 |  1.00 |     1.00 |       1.00 |         1.0 |             1 |             1.00 |    1.00 |      1.00 |     0.67 |  1.00 |      1.00 | 1.00 |   1.00 |  1.00 |  1.00 |  1.00 |       1.00 |     1.00 |   1.00 |    1.00 |    1.00 |      1.00 |    1.00 |   1.00 |        1.00 |        1.00 |         1.00 |   1.00 |     1.00 |                1.00 |   1.00 |          1.00 |    1.00 |
| Brazil     | 0.60 |      0.60 |      0.71 |       0.60 |   1.00 |   0.00 |       0.60 |  0.60 |     0.89 |       1.00 |         0.6 |             1 |             0.60 |    0.60 |      1.00 |     0.78 |  0.78 |      0.67 | 1.00 |   1.00 |  0.82 |  0.60 |  1.00 |       0.60 |     0.60 |   1.00 |    0.60 |    1.00 |      0.75 |    0.60 |   0.60 |        1.00 |        0.67 |         0.71 |   1.00 |     0.60 |                0.67 |   0.60 |          0.71 |    0.60 |
| Cape Verde | 0.83 |      0.00 |      0.50 |       0.00 |   1.00 |   0.60 |       0.00 |  0.00 |     0.88 |       1.00 |         1.0 |             1 |             0.00 |    0.00 |      1.00 |     1.00 |  0.67 |      0.33 | 1.00 |   1.00 |  0.75 |  0.00 |  1.00 |       0.00 |     0.00 |   1.00 |    0.00 |    1.00 |      1.00 |    0.00 |   0.71 |        1.00 |        0.33 |         0.50 |   1.00 |     0.00 |                0.33 |   0.00 |          0.50 |    0.00 |
| China      | 0.83 |      0.00 |      0.50 |       0.00 |   1.00 |   0.60 |       0.00 |  0.00 |     0.88 |       1.00 |         1.0 |             1 |             0.00 |    0.00 |      1.00 |     1.00 |  0.67 |      0.33 | 1.00 |   1.00 |  0.75 |  0.00 |  1.00 |       0.00 |     0.00 |   1.00 |    0.00 |    1.00 |      1.00 |    0.00 |   0.71 |        1.00 |        0.33 |         0.50 |   1.00 |     0.00 |                0.33 |   0.00 |          0.50 |    0.00 |
| Colombia   | 0.77 |      0.88 |      0.78 |       0.88 |   1.00 |   0.89 |       0.88 |  0.88 |     0.00 |       1.00 |         1.0 |             1 |             0.88 |    0.88 |      1.00 |     0.90 |  0.80 |      0.88 | 1.00 |   0.88 |  0.82 |  0.88 |  1.00 |       0.88 |     0.88 |   0.84 |    0.88 |    1.00 |      0.89 |    0.88 |   0.81 |        1.00 |        0.76 |         0.78 |   1.00 |     0.88 |                0.88 |   0.88 |          0.78 |    0.88 |
| Costa Rica | 0.85 |      1.00 |      1.00 |       1.00 |   1.00 |   1.00 |       1.00 |  1.00 |     1.00 |       0.00 |         1.0 |             1 |             1.00 |    1.00 |      0.33 |     0.71 |  0.71 |      1.00 | 1.00 |   1.00 |  1.00 |  1.00 |  1.00 |       1.00 |     1.00 |   0.83 |    1.00 |    1.00 |      0.33 |    1.00 |   0.50 |        0.33 |        1.00 |         1.00 |   1.00 |     1.00 |                1.00 |   1.00 |          1.00 |    1.00 |

``` r

# Heatmap visualization
beta.div.res2$heatmap.viz
```

<img src="man/figures/README-betadiv-1.png" width="100%" style="display: block; margin: auto;" />

### 8.visualize.geo

``` r

#Download data
geo.data<-bold.connectr.public(taxonomy = "Musca domestica")

# Map visualization
geo.viz<-visualize.geo(geo.data,export = FALSE)
```

<img src="man/figures/README-visualize.geo-1.png" width="100%" style="display: block; margin: auto;" />

``` r

#The `sf` dataframe of the downloaded data
knitr::kable(head(geo.viz$geo.df))
```

| processid    | bin_uri      |     lat |       lon | country.ocean | province.state | region                               | sector                         | site                         | geometry                |
|:-------------|:-------------|--------:|----------:|:--------------|:---------------|:-------------------------------------|:-------------------------------|:-----------------------------|:------------------------|
| AGIRI228-17  | BOLD:AAA6020 | 12.9716 |   77.5946 | India         |                | Bengaluru                            |                                |                              | POINT (77.5946 12.9716) |
| BBDIT1074-11 | BOLD:AAA6020 | 26.1870 |  -98.3790 | United States | Texas          | Bentsen-Rio Grande Valley State Park | visitors centre, nature centre | grass, rescata, short forest | POINT (-98.379 26.187)  |
| BBDIT1075-11 | BOLD:AAA6020 | 27.2640 |  -82.3080 | United States | Florida        | Sarasota County                      | Myakka River State Park        | Myakka River Upper Lake      | POINT (-82.308 27.264)  |
| BBDIT1076-11 | BOLD:AAA6020 | 29.2690 | -103.7550 | United States | Texas          |                                      | Big Bend Ranch State Park      | Grassy Bank by Rio Grande    | POINT (-103.755 29.269) |
| BBDIT1531-12 | BOLD:AAA6020 | 35.4940 |  -95.6710 | United States | Oklahoma       | Gentry Creek                         | campground                     | tall trees, grass            | POINT (-95.671 35.494)  |
| BBDIT1578-12 | BOLD:AAA6020 | 34.9450 | -101.6600 | United States | Texas          | Palo Duro Canyon State Park          | around Fortress Cliff          | dry scrub brush              | POINT (-101.66 34.945)  |

### *9.align.seq*

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

``` r

library(msa)

data.align<-bold.connectr.public(taxonomy = "Panthera leo")

data.seq.aligned<-BOLDconnectR:::align.seq(data.align,name.fields = c("bin_uri","species"))
#> using Gonnet

# A data.frame of the sequences and their respective names
knitr::kable(head(data.seq.aligned$seq.df,10))
```

| seq.name                   | sequence                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
|:---------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| BOLD:AAD6819\|Panthera leo | ACTCTTTACCTTCTATTTGGTGCCTGGGCTGGTATGGTGGGGACTGCTCTCAGTCTCNTAATCCGAGCCGAACTGGGTCAACCTGGCACACTACTAGGGGATGACCAAATTTATAATGTAGTCGTCACCGCCCATGCTTTTGTAATAATCTTCTTTATAGTAATACCTATCATGATTGGAGGATTCGGAAACTGATTGGTCCCATTAATAATTGGAGCCCCCGATATAGCATTCCCTCGAATGAATAATATAAGCTTCTGACTTCTTCCCCCATCTTTCCTACTTTTGCTTGCATCATCTATGGTAGAAGCTGGAGCAGGAACTGGGTGGACAGTATACCCGCCTCTAGCCGGCAACCTAGCTCACGCAGGAGCATCTGTAGATCTAACTATTTTTTCACTACACCTGGCAGGTGTCTCCTCAATCCTAGGTGCTATTAATTTTATTACTACTATTATTAATATAAAACCCCCTGCTATATCCCAATACCAAACACCTCTATTTGTCTGATCAGTTTTAATTACTGCTGTATTGCTACTCCTATCACTACCAGTTTTAGCAGCAGGCATCACTATGCTACTGACAGATCGAAATCTGAATACCACATTTTTTGACCCTGCCGGAGGAGGGGACCCTATCTTATANNNNNNNNNNNNN                                 |
| BOLD:AAD6819\|Panthera leo | ACTCTTTACCTTCTATTTGGTGCCTGGGCTGGTATGGTGGGGACTGCTCTCAGTCTCCTAATCCGAGCCGAACTGGGTCAACCTGGCACACTACTAGGGGATGACCAAATTTATAATGTAGTCGTCACCGCCCATGCTTTTGTAATAATCTTCTTTATAGTAATACCTATCATGATTGGAGGATTCGGAAACTGATTGGTCCCATTAATAATTGGAGCCCCCGATATAGCATTCCCTCGAATGAATAATATAAGCTTCTGACTTCTTCCCCCGTCTTTCCTACTTTTGCTTGCATCATCTATGGTAGAAGCTGGAGCAGGAACTGGGTGGACAGTATACCCGCCTCTAGCCGGCAACCTAGCTCACGCAGGAGCATCTGTAGATCTAACTATTTTTTCGCTACACCTGGCAGGTGTCTCCTCAATCCTAGGTGCTATTAATTTTATTACTACTATTATTAATATAAAACCCCCTGCTATATCCCAATACCAAACACCTCTATTTGTCTGATCGGTTTTAATCACTGCTGTATTGCTACTCCTATCACTGCCAGTTTTAGCAGCAGGCATCACTATGCTACTGACAGATCGAAATCTGAATACCACATTTTTTGACCCTGCCGGAGGAGGGGACCCTATCTTATACCAACATCTATTC                                 |
| \|Panthera leo             | CCCTGCTATATCCCAATATCAAACACCCCTATTTGTCTGATCGGTTTTAATCACTGCTGTATTGCTACTTCTATCACTGCCAGTTTTAGCAGCAGGCATCACTATGCTACTGACAGATCGAAATCTGAATACCACATTTTTTGACCCCGCCGGAGGAGGGGATCCTATCTTATATCAACATCTATTCNNNNNNNNNNNNNNNNNNNNNNNNNN                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| \|Panthera leo             | TTCANTACCCCAACAATAATAGGACTGCCTGTTGTCGTATTAATCATTATGTTCCCCAGCATTCTATTCCCCTCACCCANCCGACTAATTAATAACCGCCTAGTCTCACTCCAACAGTGATTAGTA                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| \|Panthera leo             | CCCTGCTATATCCCAATATCAAACACCCCTATTTGTCTGATCGGTTTTAATCACTGCTGTATTGCTACTNCTATCACTACCAGTTTTAGCAGCAGGCATCACTATNCTACTGACAGATCGAAATCTGAACACCACATTTTTTGACCCCGCCGGAGGAGGGGATCCTATCTTATATCAACACCTATTCNNNNNNNNNNNNNNNNNNNNNNNNNN                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| \|Panthera leo             | TTCACTACCCCAACAATAATAGGACTGCCTGTTGTCGTATTAATTATTATGTTCCCCAGCATTCTATTCCCCTCACCCAACCGACTAATTAATAACCGCCTAGTCTCACTCCAACAGTGATTAGTA                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| \|Panthera leo             | AACTGTGGTAATTCTAGAGCTAATACATGCAAACAGAGTCCCGACCAGAGATGGAAGGGGCGCTTTTATTAGATCAAAACCAATCGGTCGGCTCGTCCGGTCCGTTTGCCTTGGTGACTCTGAATAACTTTGGGCTGATCGCACGGTCCTCGTACCGGCGACGCATCTTTCAAATGTCTGCCTTATCAACTGTCGGTGGTAGGTTCTGCGCCTACCATGGTTGTAACGGGTAACGGGGAATCAGGGTTCGATTCCGGAGAGGGAGCCTGAGAAACGGCTACCACATCCAAGGAAGGCAGCAGGCGCGCAAATTACCCACTCCCGGCACGGGGAGGTAGTGACGAAAAATAACGATACGGGACTCATCCGAGGCCCCGTAATCGGAATGAGTACACTTTAAATCCTTTAACGAGTATCTATTGGAGGGCAAGTCTGGTGCCAGCAGCCGCGGTAATTCCAGCTCCAATAGCGTATATTAAAGTTGTTGCGGTTAAAAAGCTCGTAGTTGGATTTGTGTCCCACGCTGTTGGTTCACCGCCCGTCGGTGTTTAACTGGCATGTATCGTGGGACGTCCTGCCGGTGGGGCGAGCTGAAGGCGTGCGACGCGCCTCGTGCGTGCTCGTGCGTCCCGAGGCGGACCCCGTTGCAATCCTACCAGGGTGCTCTTGAGTGAGTGTCTCGGTGGGC  |
| \|Panthera leo             | ACTGTGGTAATTCTAGAGCTAATACATGCAAACAGAGTCCCGACCAGAGATGGAAGGGACGCTTTTATTAGATCAAAACCAATCGGTCGGCTCGTCCGGTCCGTTTGCCTTGGTGACTCTGAATAACTTTGGGCTGATCGCACGGTCCTCGTACCGGCGACGCATCTTTCAAATGTCTGCCTTATCAACTGTCGATGGTAGGTTCTGCGCCTACCATGGTTGTAACGGGTAACGGGGAATCAGGGTTCGATTCCGGAGAGGGAGCCTGAGAAACGGCTACCACATCCAAGGAAGGCAGCAGGCGCGCAAATTACCCACTCCCGGCACGGGGAGGTAGTGACGAAAAATAACGATACGGGACTCATCCGAGGCCCCGTAATCGGAATGAGTACACTTTAAATCCTTTAACGAGTATCTATTGGAGGGCAAGTCTGGTGCCAGCAGCCGCGGTAATTCCAGCTCCAATAGCATATATTAAAGTTGTTGCGGTTAAAAAGCTCGTAGTTGGATTTGTGTCCCACGCTGTTGGTTCACCGCCCGTCGGTGTTTAACTGGCATGTATCGTGGGACGTCCTGCCGGTGGGGCGAGCTGAAGGCGTGCGACGCGCCTCGTGCGTGCTCGTGCGTCCCGAGGCGGACCCCGTTGCAATCCTACCAGGGTGCTCTTGAGTGAGTGTCTCGGTGGGC   |
| \|Panthera leo             | AACTGTGGTAATTCTAGAGCTAATACATGCAAACAGAGTCCCGACCAGAGATGGAAGGGACGCTTTTATTAGATCAAAACCAATCGGTCGGCTCGTCCGGTCCGTTTGCCTTGGTGACTCTGAATAACTTTGGGCTGATCGCACGGTCCTCGTACCGGCGACGCATCTTTCAAATGTCTGCCTTATCAACTGTCGATGGTAGGTTCTGCGCCTACCATGGTTGTAACGGGTAACGGGGAATCAGGGTTCGATTCCGGAGAGGGAGCCTGAGAAACGGCTACCACATCCAAGGAAGGCAGCAGGCGCGCAAATTACCCACTCCCGGCACGGGGAGGTAGTGACGAAAAATAACGATACGGGACTCATCCGAGGCCCCGTAATCGGAATGAGTACACTTTAAATCCTTTAACGAGTATCTATTGGAGGGCAAGTCTGGTGCCAGCAGCCGCGGTAATTCCAGCTCCAATAGCGTATATTAAAGTTGTTGCGGTTAAAAAGCTCGTAGTTGGATTTGTGTCCCACGCTGTTGGTTCACCGCCCGTCGGTGTTTAACTGGCATGTATCGTGGGACGTCCTGCCGGTGGGGCGAGCTGAAGGCGTGCGACGCGCCTCGTGCGTGCTCGTGCGTCCCGAGGCGGACCCCGTTGCAATCCTACCAGGGTGCTCTTGAGTGAGTGTCTCGGTGGGC  |
| \|Panthera leo             | AACTGTGGTAATTCTAGAGCTAATACATGCAAACAGAGTCCCGACCAGAGATGGAAGGGACGCTTTTATTAGATCAAAACCAATCGGTCGGCTCGTCCGGTCCGTTTGCCTTGGTGACTCTGAATAACTTTGGGCTGATCGCACGGTCCTCGTACCGGCGACGCATCTTTCAAATGTCTGCCTTATCAACTGTCGATGGTAGGTTCTGCGCCTACCATGGTTGTAACGGGTAACGGGGAATCAGGGTTCGATTCCGGAGAGGGAGCCTGAGAAACGGCTACCACATCCAAGGAAGGCAGCAGGCGCGCAAATTACCCACTCCCGGCACGGGGAGGTAGTGACGAAAAATAACGATACGGGACTCATCCGAGGCCCCGTAATCGGAATGAGTACACTTTAAATCCTTTAACGAGTATCTATTGGAGGGCAAGTCTGGTGCCAGCAGCCGCGGTAATTCCAGCTCCAATAGCGTATATTAAAGTTGTTGCGGTTAAAAAGCTCGTAGTTGGATTTGTGTCCCACGCTGTTGGTTCACCGCCCGTCGGTGTTTAACTGGCATGTATCGTGGGACGTCCTGCCGGTGGGGCGAGCTGAAGGCGTGCGACGCGCCTCGTGCGTGCTCGTGCGTCCCGAGGCGGACCCCGTTGCAATCCTACCAGGGTGCTCTTGAGTGAGTGTCTCGGTGGGCC |

``` r

# ape DNAbin object
data.seq.aligned$ape_obj
#> 77 DNA sequences in binary format stored in a list.
#> 
#> Mean sequence length: 1024.325 
#>    Shortest sequence: 126 
#>     Longest sequence: 1818 
#> 
#> Labels:
#> BOLD:AAD6819|Panthera leo
#> BOLD:AAD6819|Panthera leo
#> |Panthera leo
#> |Panthera leo
#> |Panthera leo
#> |Panthera leo
#> ...
#> 
#> Base composition:
#>     a     c     g     t 
#> 0.270 0.247 0.178 0.304 
#> (Total: 78.87 kb)
```

### *10.analyze.seq*

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

``` r

data.align<-bold.connectr.public(taxonomy = "Eulimnadia")

data.seq.aligned<-BOLDconnectR:::align.seq(data.align,name.fields = c("bin_uri","species"))
#> using Gonnet

data.seq.analyze<-BOLDconnectR:::analyze.seq(data.seq.aligned$msa.result,
                                             dist.model = "K80",
                                             clus="njs",
                                             plot=TRUE,
                                             plot.type = "p")
```

<img src="man/figures/README-analyze.seq-1.png" width="100%" style="display: block; margin: auto;" />

``` r

# Distance matrix (top 5 rows)
knitr::kable(head(as.matrix(data.seq.analyze$dist_matrix),5))
```

|                                | BOLD:AAY3461\|Eulimnadia belki | BOLD:AAY3461\|Eulimnadia belki | BOLD:AAU6390\| | BOLD:AAU6390\| | BOLD:AAU6390\| | BOLD:AAU6390\| | BOLD:AAU6390\| | BOLD:AAU6390\| | BOLD:AAY3462\|Eulimnadia braueriana | BOLD:AAM4367\|Eulimnadia africana | BOLD:AAM4368\|Eulimnadia africana | BOLD:AAM4369\|Eulimnadia africana | BOLD:AAY3466\|Eulimnadia cylindrova | BOLD:AEG5287\|Eulimnadia sp. C MS-2015 | BOLD:AAM4366\|Eulimnadia sp. 2 WRH-2009 | BOLD:AAM4366\|Eulimnadia sp. 2 WRH-2009 | BOLD:AAM4366\|Eulimnadia sp. 2 WRH-2009 |
|:-------------------------------|-------------------------------:|-------------------------------:|---------------:|---------------:|---------------:|---------------:|---------------:|---------------:|------------------------------------:|----------------------------------:|----------------------------------:|----------------------------------:|------------------------------------:|---------------------------------------:|----------------------------------------:|----------------------------------------:|----------------------------------------:|
| BOLD:AAY3461\|Eulimnadia belki |                         0.0000 |                         0.0000 |         0.0302 |         0.0302 |         0.0302 |         0.0302 |         0.0302 |         0.0286 |                              0.2001 |                            0.1785 |                            0.1827 |                            0.1725 |                              0.2122 |                                 0.1982 |                                  0.1833 |                                  0.1857 |                                  0.1835 |
| BOLD:AAY3461\|Eulimnadia belki |                         0.0000 |                         0.0000 |         0.0302 |         0.0302 |         0.0302 |         0.0302 |         0.0302 |         0.0286 |                              0.2001 |                            0.1785 |                            0.1827 |                            0.1725 |                              0.2122 |                                 0.1982 |                                  0.1833 |                                  0.1857 |                                  0.1835 |
| BOLD:AAU6390\|                 |                         0.0302 |                         0.0302 |         0.0000 |         0.0000 |         0.0000 |         0.0000 |         0.0000 |         0.0016 |                              0.1938 |                            0.1766 |                            0.1893 |                            0.1706 |                              0.2041 |                                 0.1941 |                                  0.1793 |                                  0.1816 |                                  0.1837 |
| BOLD:AAU6390\|                 |                         0.0302 |                         0.0302 |         0.0000 |         0.0000 |         0.0000 |         0.0000 |         0.0000 |         0.0016 |                              0.1938 |                            0.1766 |                            0.1893 |                            0.1706 |                              0.2041 |                                 0.1941 |                                  0.1793 |                                  0.1816 |                                  0.1837 |
| BOLD:AAU6390\|                 |                         0.0302 |                         0.0302 |         0.0000 |         0.0000 |         0.0000 |         0.0000 |         0.0000 |         0.0016 |                              0.1938 |                            0.1766 |                            0.1893 |                            0.1706 |                              0.2041 |                                 0.1941 |                                  0.1793 |                                  0.1816 |                                  0.1837 |
