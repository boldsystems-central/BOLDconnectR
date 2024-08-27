
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
2.  bold.fetch
3.  bold.public.search
4.  bold.data.summarize
5.  *bold.analyze.align*
6.  bold.analyze.tree
7.  bold.analyze.diversity
8.  bold.analyze.map
9.  bold.export

*Function 5 is currently an internal function which requires external
dependencies not included in the package. For their specific usage,
please see the details provided below.*

### Note on API key

The function `bold.fetch` requires an `api key` in order to access and
download all public + private user data. API key can be obtained by
emailing the BOLD support (<support@boldsystems.org>). API key is needed
only for the data retrieval and can be added directly within the
function. Alternatively, it can be set up as an environmental variable
using the ‘Sys.setenv’ function.

``` r
# The key can be added in place of "api.key" 
# Sys.setenv ("api_key"="api.key")
```

It can then be retrieved using `Sys.getenv` function directly or by
storing it as another variable.

``` r
# api.key <- Sys.getenv('api_key')
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

### 2.bold.fetch:

This function retrieves public and private user data on BOLD using
the`api key`.The downloaded data can also be filtered using the various
filter arguments available (all `filt` arguments after the `api_key`).
The filtering happens locally after the data is downloaded. Care has to
be taken to select the filters properly. If wrong/too many filters are
applied, it can result in an empty result. The `filt.fields` argument in
the function helps in selecting only the fields needed by the user.

### **Test data**

Test data is a data frame having 2 columns and 2100 unique ids. First
column has ‘processids’ while second has ‘sampleids’. Either one can be
used to retrieve data from BOLD.

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

# A small subset of the data used for data retrieval
to_download=test.data[1:100,]

result<-bold.fetch(param.data = to_download,
                   query.param = 'processid',
                   param.index = 1,
                   api_key = api.key)

knitr::kable(head(result,5))
```

| processid | record_id        | insdc_acs | sampleid  | specimenid | taxid | short_note | identification_method | museumid | fieldid   | collection_code | processid_minted_date | inst               | specimendetails.verbatim_depository | funding_src | sex | life_stage | reproduction | habitat | collectors | site_code | specimen_linkout | collection_event_id | sampling_protocol | tissue_type | collection_date_start | specimendetails.verbatim_collectiondate | collection_time | collection_date_accuracy | specimendetails.verbatim_collectiondate_precision | associated_taxa | associated_specimens | voucher_type | notes | taxonomy_notes | collection_notes | specimendetails.verbatim_kingdom | specimendetails.verbatim_phylum | specimendetails.verbatim_class | specimendetails.verbatim_order | specimendetails.verbatim_family | specimendetails.verbatim_subfamily | specimendetails.verbatim_tribe | specimendetails.verbatim_genus | specimendetails.verbatim_species | specimendetails.verbatim_subspecies | specimendetails.verbatim_species_reference | specimendetails.verbatim_identifier | geoid | location.verbatim_country | location.verbatim_province | location.verbatim_country_iso_alpha3 | marker_code | kingdom  | phylum   | class          | order        | family    | subfamily           | tribe | genus       | species               | subspecies | identification        | identification_rank | tax_rank.numerical_posit | species_reference | identified_by | specimendetails\_\_identifier.person.email | sequence_run_site  | nuc                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | nuc_basecount | sequence_upload_date | bin_uri      | bin_created_date | elev | location.verbatim_elev | depth | location.verbatim_depth | lat | lon | location.verbatim_coord | coord_source | coord_accuracy | location.verbatim_gps_accuracy | elev_accuracy | location.verbatim_elev_accuracy | depth_accuracy | location.verbatim_depth_accuracy | realm | biome | ecoregion | region | sector | site | country_iso | country.ocean | province.state | bold_recordset_code_arr                        | geopol_denorm.country_iso3 | collection_date_end |
|:----------|:-----------------|:----------|:----------|-----------:|------:|:-----------|:----------------------|:---------|:----------|:----------------|:----------------------|:-------------------|:------------------------------------|:------------|:----|:-----------|:-------------|:--------|:-----------|:----------|:-----------------|:--------------------|:------------------|:------------|:----------------------|:----------------------------------------|:----------------|:-------------------------|:--------------------------------------------------|:----------------|:---------------------|:-------------|:------|:---------------|:-----------------|:---------------------------------|:--------------------------------|:-------------------------------|:-------------------------------|:--------------------------------|:-----------------------------------|:-------------------------------|:-------------------------------|:---------------------------------|:------------------------------------|:-------------------------------------------|:------------------------------------|------:|:--------------------------|:---------------------------|:-------------------------------------|:------------|:---------|:---------|:---------------|:-------------|:----------|:--------------------|:------|:------------|:----------------------|:-----------|:----------------------|:--------------------|-------------------------:|:------------------|:--------------|:-------------------------------------------|:-------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------:|:---------------------|:-------------|:-----------------|-----:|:-----------------------|------:|:------------------------|----:|----:|:------------------------|:-------------|---------------:|:-------------------------------|--------------:|:--------------------------------|---------------:|:---------------------------------|:------|:------|:----------|:-------|:-------|:-----|:------------|:--------------|:---------------|:-----------------------------------------------|:---------------------------|:--------------------|
| AJS049-19 | AJS049-19.COI-5P |           | S-02-A-MB |   10597415 | 52768 | NA         | NA                    |          | S-02-A-MB |                 | 2019-08-08            | Chapman University | NA                                  | NA          | NA  | NA         | NA           | NA      |            | NA        | NA               | NA                  | NA                | NA          | NA                    | NA                                      | NA              | NA                       | NA                                                | NA              | NA                   | NA           | NA    | NA             | NA               | NA                               | NA                              | NA                             | NA                             | NA                              | NA                                 | NA                             | NA                             | NA                               | NA                                  | NA                                         | NA                                  |   238 | NA                        | NA                         | NA                                   | COI-5P      | Animalia | Chordata | Actinopterygii | Cichliformes | Cichlidae | Pseudocrenilabrinae | NA    | Oreochromis | Oreochromis niloticus | NA         | Oreochromis niloticus | species             |                       17 | Linnaeus, 1758    | NA            | NA                                         | Chapman University | ATTGTTACAGCRCAYGCTTTCGTAATAATTTTCTTTATAGTAATACCAATWATRATTGGAGGCTTTGGAAACTGACTMRTWCCYCTCATGATYGGTGCMCC                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |            91 | 2019-08-08           | NA           | NA               |   NA | NA                     |    NA | NA                      |  NA |  NA | NA                      | NA           |             NA | NA                             |            NA | NA                              |             NA | NA                               | NA    | NA    | NA        | NA     | NA     | NA   | US          | United States |                | AJS,DS-OREOSA,DS-OREOSARO                      | USA                        | NA                  |
| AJS084-19 | AJS084-19.COI-5P |           | S-13-C-MB |   10597450 | 52768 | NA         | NA                    |          | S-13-C-MB |                 | 2019-08-08            | Chapman University | NA                                  | NA          | NA  | NA         | NA           | NA      |            | NA        | NA               | NA                  | NA                | NA          | NA                    | NA                                      | NA              | NA                       | NA                                                | NA              | NA                   | NA           | NA    | NA             | NA               | NA                               | NA                              | NA                             | NA                             | NA                              | NA                                 | NA                             | NA                             | NA                               | NA                                  | NA                                         | NA                                  |   238 | NA                        | NA                         | NA                                   | COI-5P      | Animalia | Chordata | Actinopterygii | Cichliformes | Cichlidae | Pseudocrenilabrinae | NA    | Oreochromis | Oreochromis niloticus | NA         | Oreochromis niloticus | species             |                       17 | Linnaeus, 1758    | NA            | NA                                         | Chapman University | CGACGTTGTAAAACGACACYAAGCAYAAAGAYATGGGCACCCTCTATCTAGTATTTGGTGCTTGAGCCGGAATAGTAGGAACTGCACTAAGCCTCCTAATTCGGGCAGAACTAAGCCAGCCCGGCTCTCTTCTCGGAGACGACCAAATCTATAATGTAATTGTTACAGCACATGCTTTCGTAATAATTTTCTTTATAGTAATACCAATTATGATTGGAGGCTTTGGAAACTGACTAGTACCCCTCATGATTGGTGCACCAGACATGGCCTT                                                                                                                                                                                                                                                                                                                                                                                                              |           268 | 2019-08-08           | NA           | NA               |   NA | NA                     |    NA | NA                      |  NA |  NA | NA                      | NA           |             NA | NA                             |            NA | NA                              |             NA | NA                               | NA    | NA    | NA        | NA     | NA     | NA   | US          | United States |                | AJS,DS-OREOSA,DS-OREOSARO                      | USA                        | NA                  |
| AJS019-19 | AJS019-19.COI-5P |           | S-07-A-FB |   10597385 | 52768 | NA         | NA                    |          | S-07-A-FB |                 | 2019-08-08            | Chapman University | NA                                  | NA          | NA  | NA         | NA           | NA      |            | NA        | NA               | NA                  | NA                | NA          | NA                    | NA                                      | NA              | NA                       | NA                                                | NA              | NA                   | NA           | NA    | NA             | NA               | NA                               | NA                              | NA                             | NA                             | NA                              | NA                                 | NA                             | NA                             | NA                               | NA                                  | NA                                         | NA                                  |   238 | NA                        | NA                         | NA                                   | COI-5P      | Animalia | Chordata | Actinopterygii | Cichliformes | Cichlidae | Pseudocrenilabrinae | NA    | Oreochromis | Oreochromis niloticus | NA         | Oreochromis niloticus | species             |                       17 | Linnaeus, 1758    | NA            | NA                                         | Chapman University | —-GGCACCCTCTATCTAGTATTTGGTGCTTGAGCCGGAATAGTAGGAACTGCACTAAGCCTCCTAATTCGGGCAGAACTAAGCCAGCCCGGCTCTCTTCTCGGAGACGACCAAATCTATAATGTAATTGTTACAGCACATGCTTTCGTAATAATTTTCTTTATAGTAATACCAATTATGATTGGAGGCTTTGGAAACTGACTAGTACCCCTCATGATTGGTGCACCAGACATGGCCTTCCCTCGAATAAATAACATGAGCTTTTGACTTCTCCCCCCCTCATTTCTTCTTCTTCTCGCCTCATCTGGAGTCGAAGCAGGTGCCGGCACAGGATGGACTGTTTATCCCCCGCTCGCAGGCAATCTTGCCCACGCTGGACCTTCTGTTGACTTAACCATCTTCTCCCTCCACTTGGCCGGAGTGTCATCTATTTTAGGTGCAATTAATTTTATCACAACCATTATTAACATGAAACCCCCTGCCATCTCCCAATATCAAACACCCCTATTTGTGTGATCCGTCCTAATTACCGCAGTACTACTCCTTCTATCCCTGCCCGTTCTTGCCGCCGGCATCACAATACTTCTAACAGACCGAAACCTAAACACAACCTTCTTTGACCCTGCCGGAGGAGGAGACCCCATCCTATACCAACACTTATTCTGATT— |           665 | 2019-08-08           | BOLD:AAC9904 | 2010-07-15       |   NA | NA                     |    NA | NA                      |  NA |  NA | NA                      | NA           |             NA | NA                             |            NA | NA                              |             NA | NA                               | NA    | NA    | NA        | NA     | NA     | NA   | US          | United States |                | AJS,DS-OREOSA,DS-OREOSARO,DS-TANGQIAN,DS-CICHI | USA                        | NA                  |
| AJS082-19 | AJS082-19.COI-5P |           | S-13-A-MB |   10597448 | 52768 | NA         | NA                    |          | S-13-A-MB |                 | 2019-08-08            | Chapman University | NA                                  | NA          | NA  | NA         | NA           | NA      |            | NA        | NA               | NA                  | NA                | NA          | NA                    | NA                                      | NA              | NA                       | NA                                                | NA              | NA                   | NA           | NA    | NA             | NA               | NA                               | NA                              | NA                             | NA                             | NA                              | NA                                 | NA                             | NA                             | NA                               | NA                                  | NA                                         | NA                                  |   238 | NA                        | NA                         | NA                                   | COI-5P      | Animalia | Chordata | Actinopterygii | Cichliformes | Cichlidae | Pseudocrenilabrinae | NA    | Oreochromis | Oreochromis niloticus | NA         | Oreochromis niloticus | species             |                       17 | Linnaeus, 1758    | NA            | NA                                         | Chapman University | ATGGGCACCCTCTATCTAGTATTTGGTGCTTGAGCCGGAATAGTAGGAACTGCACTAAGCCTCCTAATTCGGGCAGAACTAAGCCAGCCCGGCTCTCTTCTCGGAGACGACCAAATCTATAATGTAATTGTTACAGCACATGCTTTCGTAATAATTTTCTTTATAGTAATACCAATTATGATTGGAGGCTTTGGAAACTGACTAGTACCCCTCATGATTGGTGCACCAGACATGGCCTTYCCCGGCATAAA                                                                                                                                                                                                                                                                                                                                                                                                                                  |           250 | 2019-08-08           | NA           | NA               |   NA | NA                     |    NA | NA                      |  NA |  NA | NA                      | NA           |             NA | NA                             |            NA | NA                              |             NA | NA                               | NA    | NA    | NA        | NA     | NA     | NA   | US          | United States |                | AJS,DS-OREOSA,DS-OREOSARO                      | USA                        | NA                  |
| AJS034-19 | AJS034-19.COI-5P |           | S-12-A-FB |   10597400 | 52768 | NA         | NA                    |          | S-12-A-FB |                 | 2019-08-08            | Chapman University | NA                                  | NA          | NA  | NA         | NA           | NA      |            | NA        | NA               | NA                  | NA                | NA          | NA                    | NA                                      | NA              | NA                       | NA                                                | NA              | NA                   | NA           | NA    | NA             | NA               | NA                               | NA                              | NA                             | NA                             | NA                              | NA                                 | NA                             | NA                             | NA                               | NA                                  | NA                                         | NA                                  |   238 | NA                        | NA                         | NA                                   | COI-5P      | Animalia | Chordata | Actinopterygii | Cichliformes | Cichlidae | Pseudocrenilabrinae | NA    | Oreochromis | Oreochromis niloticus | NA         | Oreochromis niloticus | species             |                       17 | Linnaeus, 1758    | NA            | NA                                         | Chapman University | —-GGCACCCTCTATCTAGTATTTGGTGCTTGAGCCGGAATAGTAGGAACTGCACTAAGCCTCCTAATTCGGGCAGAACTAAGCCAGCCCGGCTCTCTTCTCGGAGACGACCAAATCTATAATGTAATTGTTACAGCACATGCTTTCGTAATAATTTTCTTTATAGTAATACCAATTATGATTGGAGGCTTTGGAAACTGACTAGTACCCCTCATGATTGGTGCACCAGACATGGCCTTCCCTCGAATAAATAACATGAGCTTTTGACTTCTCCCCCCCTCATTTCTTCTTCTTCTCGCCTCATCTGGAGTCGAAGCAGGTGCCGGCACAGGATGGACTGTTTATCCCCCGCTCGCAGGCAATCTTGCCCACGCTGGACCTTCTGTTGACTTAACCATCTTCTCCCTCCACTTGGCCGGAGTGTCATCTATTTTAGGTGCAATTAATTTTATCACAACCATTATTAACATGAAACCCCCTGCCATCTCCCAATATCAAACACCCCTATTTGTGTGATCCGTCCTAATTACCGCAGTACTACTCCTTCTATCCCTGCCCGTTCTTGCCGCCGGCATCACAATACTTCTAACAGACCGAAACCTAAACACAACCTTCTTTGACCCTGCCGGAGGAGGAGACCCCATCCTATACCAACACTTAT———-     |           658 | 2019-08-08           | BOLD:AAC9904 | 2010-07-15       |   NA | NA                     |    NA | NA                      |  NA |  NA | NA                      | NA           |             NA | NA                             |            NA | NA                              |             NA | NA                               | NA    | NA    | NA        | NA     | NA     | NA   | US          | United States |                | AJS,DS-OREOSA,DS-OREOSARO,DS-TANGQIAN,DS-CICHI | USA                        | NA                  |

### 2b.Institutes Filter

Data is downloaded followed by the ‘institute’ filter applied on it to
fetch only the relevant ‘institute’ (here South African Institute for
Aquatic Biodiversity) data.

``` r

# A small subset of the data used for data retrieval
result_institutes<-bold.fetch(param.data = test.data,
                               query.param = 'processid',
                               param.index = 1,
                               api_key = api.key,
                               filt.institutes = c("Universiti Sains Malaysia","Museum of Southwestern Biology, Division of Parasitology"))

knitr::kable(head(result_institutes,5))
```

| processid   | record_id          | insdc_acs | sampleid                      | specimenid | taxid | short_note | identification_method | museumid         | fieldid                       | collection_code | processid_minted_date | inst                                                     | specimendetails.verbatim_depository | funding_src | sex | life_stage | reproduction | habitat | collectors | site_code | specimen_linkout | collection_event_id | sampling_protocol | tissue_type | collection_date_start | specimendetails.verbatim_collectiondate | collection_time | collection_date_accuracy | specimendetails.verbatim_collectiondate_precision | associated_taxa                              | associated_specimens | voucher_type                    | notes | taxonomy_notes | collection_notes | specimendetails.verbatim_kingdom | specimendetails.verbatim_phylum | specimendetails.verbatim_class | specimendetails.verbatim_order | specimendetails.verbatim_family | specimendetails.verbatim_subfamily | specimendetails.verbatim_tribe | specimendetails.verbatim_genus | specimendetails.verbatim_species | specimendetails.verbatim_subspecies | specimendetails.verbatim_species_reference | specimendetails.verbatim_identifier | geoid | location.verbatim_country | location.verbatim_province | location.verbatim_country_iso_alpha3 | marker_code | kingdom  | phylum   | class          | order        | family    | subfamily           | tribe | genus       | species                 | subspecies | identification          | identification_rank | tax_rank.numerical_posit | species_reference | identified_by    | specimendetails\_\_identifier.person.email | sequence_run_site                                        | nuc                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | nuc_basecount | sequence_upload_date | bin_uri      | bin_created_date | elev | location.verbatim_elev | depth | location.verbatim_depth |       lat |      lon | location.verbatim_coord | coord_source | coord_accuracy | location.verbatim_gps_accuracy | elev_accuracy | location.verbatim_elev_accuracy | depth_accuracy | location.verbatim_depth_accuracy | realm       | biome                                           | ecoregion                         | region   | sector | site                         | country_iso | country.ocean | province.state | bold_recordset_code_arr | geopol_denorm.country_iso3 | collection_date_end |
|:------------|:-------------------|:----------|:------------------------------|-----------:|------:|:-----------|:----------------------|:-----------------|:------------------------------|:----------------|:----------------------|:---------------------------------------------------------|:------------------------------------|:------------|:----|:-----------|:-------------|:--------|:-----------|:----------|:-----------------|:--------------------|:------------------|:------------|:----------------------|:----------------------------------------|:----------------|:-------------------------|:--------------------------------------------------|:---------------------------------------------|:---------------------|:--------------------------------|:------|:---------------|:-----------------|:---------------------------------|:--------------------------------|:-------------------------------|:-------------------------------|:--------------------------------|:-----------------------------------|:-------------------------------|:-------------------------------|:---------------------------------|:------------------------------------|:-------------------------------------------|:------------------------------------|------:|:--------------------------|:---------------------------|:-------------------------------------|:------------|:---------|:---------|:---------------|:-------------|:----------|:--------------------|:------|:------------|:------------------------|:-----------|:------------------------|:--------------------|-------------------------:|:------------------|:-----------------|:-------------------------------------------|:---------------------------------------------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------:|:---------------------|:-------------|:-----------------|-----:|:-----------------------|------:|:------------------------|----------:|---------:|:------------------------|:-------------|---------------:|:-------------------------------|--------------:|:--------------------------------|---------------:|:---------------------------------|:------------|:------------------------------------------------|:----------------------------------|:---------|:-------|:-----------------------------|:------------|:--------------|:---------------|:------------------------|:---------------------------|:--------------------|
| BIOPH052-20 | BIOPH052-20.COI-5P | MW591121  | BIOPH_BG31                    |   11441503 | 24807 | NA         | Morphology            | USMFC (47) 00007 | BIOPH_BG31                    | PS              | 2020-04-01            | Universiti Sains Malaysia                                | NA                                  | NA          | NA  | NA         | NA           | NA      | NA         | NA        | NA               | NA                  | NA                | Fin clip    | 2019-10-20            | NA                                      | NA              | NA                       | NA                                                | NA                                           | NA                   | Vouchered:Registered Collection | NA    | NA             | NA               | NA                               | NA                              | NA                             | NA                             | NA                              | NA                                 | NA                             | NA                             | NA                               | NA                                  | NA                                         | NA                                  |  5949 | NA                        | NA                         | NA                                   | COI-5P      | Animalia | Chordata | Actinopterygii | Cichliformes | Cichlidae | Pseudocrenilabrinae | NA    | Oreochromis | Oreochromis mossambicus | NA         | Oreochromis mossambicus | species             |                       17 | Peters, 1852      | Sebastien Lavoue | <microceb@hotmail.com>                     | Universiti Sains Malaysia, School of Biological Sciences | CCTCTATCTAGTATTTGGTGCTTGAGCCGGAATAGTAGGAACTGCATTAAGCCTCCTAATTCGGGCAGAACTAAGCCAGCCCGGCTCTCTCCTCGGAGACGACCAGATTTATAATGTAATTGTTACAGCACATGCTTTCGTAATAATTTTCTTTATAGTAATGCCAATTATAATTGGAGGTTTTGGAAACTGACTAGTGCCACTAATGATTGGTGCACCAGACATGGCCTTCCCTCGAATAAATAACATGAGTTTTTGACTCCTCCCCCCCTCATTTCTCCTTCTCCTCGCCTCATCCGGGGTCGAAGCAGGGGCCGGTACAGGATGGACTGTTTATCCCCCACTCGCAGGCAATCTCGCCCATGCTGGGCCTTCCGTTGACTTAACCATCTTCTCCCTCCACTTGGCCGGGGTGTCATCTATTTTAGGTGCAATTAATTTTATTACAACCATTATTAACATAAAACCCCCTGCCATCTCCCAATATCAAACACCCCTCTTTGTATGATCCGTTCTAATTACCGCAGTACTACTCCTACTATCCCTACCCGTTCTTGCCGCCGGCATCACAATACTTCTAACAGACCGAAACCTAAACACAACCTTCTTTGACCCTGCCGGAGGAGGAGACCCCATCCTTTACCAACACTTATTC |           655 | 2020-04-01           | BOLD:AAA8511 | 2010-07-15       |   NA | NA                     |    NA | NA                      |  5.435639 | 100.2936 | NA                      | NA           |             NA | NA                             |            NA | NA                              |             NA | NA                               | Indomalayan | Tropical\_&\_Subtropical_Moist_Broadleaf_Forest | Peninsular_Malaysian_rain_forests |          |        | Botanical Garden             | MY          | Malaysia      | Pulau Pinang   | BIOPH,DS-CICHI          | MYS                        | NA                  |
| BIOPH120-20 | BIOPH120-20.COI-5P | MW591120  | BIOPH_USM07                   |   11441571 | 24807 | NA         | Morphology            | USMFC (47) 00012 | BIOPH_USM07                   | PS              | 2020-04-01            | Universiti Sains Malaysia                                | NA                                  | NA          | NA  | NA         | NA           | NA      | NA         | NA        | NA               | NA                  | NA                | Fin clip    | 2020-01-10            | NA                                      | NA              | NA                       | NA                                                | NA                                           | NA                   | Vouchered:Registered Collection | NA    | NA             | NA               | NA                               | NA                              | NA                             | NA                             | NA                              | NA                                 | NA                             | NA                             | NA                               | NA                                  | NA                                         | NA                                  |  5949 | NA                        | NA                         | NA                                   | COI-5P      | Animalia | Chordata | Actinopterygii | Cichliformes | Cichlidae | Pseudocrenilabrinae | NA    | Oreochromis | Oreochromis mossambicus | NA         | Oreochromis mossambicus | species             |                       17 | Peters, 1852      | Sebastien Lavoue | <microceb@hotmail.com>                     | Universiti Sains Malaysia, School of Biological Sciences | CCTCTATCTAGTATTTGGTGCTTGAGCCGGAATAGTAGGAACTGCATTAAGCCTCCTAATTCGGGCAGAACTAAGCCAGCCCGGCTCTCTCCTCGGAGACGACCAGATTTATAATGTAATTGTTACAGCACATGCTTTCGTAATAATTTTCTTTATAGTAATGCCAATTATAATTGGAGGTTTTGGAAACTGACTAGTGCCACTAATGATTGGTGCACCAGACATGGCCTTCCCTCGAATAAATAACATGAGTTTTTGACTCCTCCCCCCCTCATTTCTCCTTCTCCTCGCCTCATCCGGGGTCGAAGCAGGGGCCGGTACAGGATGGACTGTTTATCCCCCACTCGCAGGCAATCTCGCCCATGCTGGGCCTTCCGTTGACTTAACCATCTTCTCCCTCCACTTGGCCGGGGTGTCATCTATTTTAGGTGCAATTAATTTTATTACAACCATTATTAACATAAAACCCCCTGCCATCTCCCAATATCAAACACCCCTCTTTGTATGATCCGTTCTAATTACCGCAGTACTACTCCTACTATCCCTACCCGTTCTTGCCGCCGGCATCACAATACTTCTAACAGACCGAAACCTAAACACAACCTTCTTTGACCCTGCCGGAGGAGGAGACCCCATCCTTTACCAACACTTATTC |           655 | 2020-04-01           | BOLD:AAA8511 | 2010-07-15       |   NA | NA                     |    NA | NA                      |  5.355111 | 100.2983 | NA                      | NA           |             NA | NA                             |            NA | NA                              |             NA | NA                               | Indomalayan | Tropical\_&\_Subtropical_Moist_Broadleaf_Forest | Peninsular_Malaysian_rain_forests |          |        | Sungai Dua                   | MY          | Malaysia      | Pulau Pinang   | BIOPH,DS-CICHI          | MYS                        | NA                  |
| BIOPH024-20 | BIOPH024-20.COI-5P | MW591124  | BIOPH_PS-0088                 |   11441475 | 52768 |            | Morphology            | USMFC (47) 00006 | BIOPH_PS-0088                 | PS              | 2020-04-01            | Universiti Sains Malaysia                                | NA                                  | NA          |     |            |              | NA      | NA         | NA        | NA               | NA                  | NA                | Fin clip    | 2019-04-27            | NA                                      | NA              | NA                       | NA                                                |                                              |                      | Vouchered:Registered Collection | NA    | NA             | NA               | NA                               | NA                              | NA                             | NA                             | NA                              | NA                                 | NA                             | NA                             | NA                               | NA                                  | NA                                         | NA                                  |  5949 | NA                        | NA                         | NA                                   | COI-5P      | Animalia | Chordata | Actinopterygii | Cichliformes | Cichlidae | Pseudocrenilabrinae | NA    | Oreochromis | Oreochromis niloticus   | NA         | Oreochromis niloticus   | species             |                       17 | Linnaeus, 1758    | Sebastien Lavoue | <microceb@hotmail.com>                     | Universiti Sains Malaysia, School of Biological Sciences | CCTCTATCTAGTATTTGGTGCTTGAGCCGGAATAGTAGGAACTGCACTAAGCCTCCTAATTCGGGCAGAACTAAGCCAGCCCGGCTCTCTTCTCGGAGACGACCAAATCTATAATGTAATTGTTACAGCACATGCTTTCGTAATAATTTTCTTTATAGTAATACCAATTATGATTGGAGGCTTTGGAAACTGACTAGTACCCCTCATGATTGGTGCACCAGACATGGCCTTCCCTCGAATAAATAACATGAGCTTTTGACTTCTCCCCCCCTCATTTCTTCTTCTTCTCGCCTCATCTGGAGTCGAAGCAGGTGCCGGCACAGGATGGACTGTTTATCCCCCGCTCGCAGGCAATCTTGCCCACGCTGGACCTTCTGTTGACTTAACCATCTTCTCCCTCCACTTGGCCGGAGTGTCATCTATTTTAGGTGCAATTAATTTTATCACAACCATTATTAACATGAAACCCCCTGCCATCTCCCAATATCAAACACCCCTATTTGTGTGATCCGTCCTAATTACCGCAGTACTACTCCTTCTATCCCTGCCCGTTCTTGCCGCCGGCATCACAATACTTCTAACAGACCGAAACCTAAACACAACCTTCTTTGACCCTGCCGGAGGAGGAGACCCCATCCTATACCAACACTTATTC |           655 | 2020-04-01           | BOLD:AAC9904 | 2010-07-15       |   NA | NA                     |    NA | NA                      |  5.353000 | 100.2260 | NA                      | NA           |             NA | NA                             |            NA | NA                              |             NA | NA                               | Indomalayan | Tropical\_&\_Subtropical_Moist_Broadleaf_Forest | Peninsular_Malaysian_rain_forests | NA       | NA     | Titi Teras                   | MY          | Malaysia      | Pulau Pinang   | BIOPH,DS-CICHI          | MYS                        | NA                  |
| BIOPH132-20 | BIOPH132-20.COI-5P | MW591125  | BIOPH_PS324                   |   11441583 | 52768 |            | Morphology            | USMFC (47) 00014 | BIOPH_PS324                   | PS              | 2020-04-01            | Universiti Sains Malaysia                                | NA                                  | NA          |     |            |              | NA      | NA         | NA        | NA               | NA                  | NA                | Fin clip    | 2020-01-19            | NA                                      | NA              | NA                       | NA                                                |                                              |                      | Vouchered:Registered Collection | NA    | NA             | NA               | NA                               | NA                              | NA                             | NA                             | NA                              | NA                                 | NA                             | NA                             | NA                               | NA                                  | NA                                         | NA                                  |  5949 | NA                        | NA                         | NA                                   | COI-5P      | Animalia | Chordata | Actinopterygii | Cichliformes | Cichlidae | Pseudocrenilabrinae | NA    | Oreochromis | Oreochromis niloticus   | NA         | Oreochromis niloticus   | species             |                       17 | Linnaeus, 1758    | Sebastien Lavoue | <microceb@hotmail.com>                     | Universiti Sains Malaysia, School of Biological Sciences | CCTCTATCTAGTATTTGGTGCTTGAGCCGGAATAGTAGGAACTGCACTAAGCCTCCTAATTCGGGCAGAACTAAGCCAGCCCGGCTCTCTTCTCGGAGACGACCAAATCTATAATGTAATTGTTACAGCACATGCTTTCGTAATAATTTTCTTTATAGTAATACCAATTATGATTGGAGGCTTTGGAAACTGACTAGTACCCCTCATGATTGGTGCACCAGACATGGCCTTCCCTCGAATAAATAACATGAGCTTTTGACTTCTCCCCCCCTCATTTCTTCTTCTTCTCGCCTCATCTGGAGTCGAAGCAGGTGCCGGCACAGGATGGACTGTTTATCCCCCGCTCGCAGGCAATCTTGCCCACGCTGGACCTTCTGTTGACTTAACCATCTTCTCCCTCCACTTGGCCGGAGTGTCATCTATTTTAGGTGCAATTAATTTTATCACAACCATTATTAACATGAAACCCCCTGCCATCTCCCAATATCAAACACCCCTATTTGTGTGATCCGTCCTAATTACCGCAGTACTACTCCTTCTATCCCTGCCCGTTCTTGCCGCCGGCATCACAATACTTCTAACAGACCGAAACCTAAACACAACCTTCTTTGACCCTGCCGGAGGAGGAGACCCCATCCTATACCAACACTTATTC |           655 | 2020-04-01           | BOLD:AAC9904 | 2010-07-15       |   NA | NA                     |    NA | NA                      |  5.324000 | 100.2670 | NA                      | NA           |             NA | NA                             |            NA | NA                              |             NA | NA                               | Indomalayan | Tropical\_&\_Subtropical_Moist_Broadleaf_Forest | Peninsular_Malaysian_rain_forests | NA       | NA     | Sungai Ara                   | MY          | Malaysia      | Pulau Pinang   | BIOPH,DS-CICHI          | MYS                        | NA                  |
| TRVSO005-22 | TRVSO005-22.COI-5P |           | Cichlid_experimental_infetion |   15537258 | 24806 |            | NA                    | MSB:Host:24823   | Cichlid_experimental_infetion |                 | 2022-06-24            | Museum of Southwestern Biology, Division of Parasitology | NA                                  | NA          |     | juvenile   | S            | NA      |            | NA        | NA               | NA                  | NA                |             | 2022-04-27            | NA                                      | NA              | NA                       | NA                                                | experimental host:Transversotrema paliatense | NA                   |                                 | NA    | NA             | NA               | NA                               | NA                              | NA                             | NA                             | NA                              | NA                                 | NA                             | NA                             | NA                               | NA                                  | NA                                         | NA                                  |   101 | NA                        | NA                         | NA                                   | COI-5P      | Animalia | Chordata | Actinopterygii | Cichliformes | Cichlidae | Pseudocrenilabrinae | NA    | Oreochromis | NA                      | NA         | Oreochromis             | genus               |                       14 | NA                | Sean A. Locke    | <sean.locke@upr.edu>                       | Genewiz                                                  | GGAACCGCGCTAAGCCTCCTAATTCGGGCAGAACTAAGCCAGCCCGGCTCTCTCCTCGGAGACGACCAGATTTATAATGTAATTGTTACAGCACATGCTTTTGTAATAATTTTCTTTATAGTAATGCCAATTATGATTGGAGGCTTTGGAAACTGACTAGTACCACTCATGATTGGTGCCCCAGATATGGCCTTCCCTCGAATGAACAACATGAGTTTCTGACTCCTCCCTCCCTCATTCCTCCTCCTCCTCGCCTCATCTGGAGTCGAAGCAGGTGCCGGCACAGGGTGAACTGTTTACCCCCCGCTCGCAGGCAATCTTGCCCATGCTGGGCCTTCTGTCGACTTAACCATCTTCTCCCTCCACTTGGCCGGGGTGTCATCTATTCTAGGCGCAATTAATTTCATTACAACAATCATTAACATGAAACCCCCCGCCATCTCTCAATATCAAACACCCCTATTTGTATGGTCCGTTCTAATTACCGCAGTATTACTTCTTCTATCCCTACCCGTTCTTGCCGCCGGCATCACAATACTTCTCACAGACCGAAACCTAAACACAACCTTCTTTGATCCTGCCGGAGGAG                                                                   |           589 | 2022-06-24           | BOLD:AAA6537 | 2010-07-15       |   NA | NA                     |    NA | NA                      | 18.212500 | -67.1437 | NA                      |              |             NA | NA                             |            NA | NA                              |             NA | NA                               | Neotropic   | Tropical\_&\_Subtropical_Moist_Broadleaf_Forest | Puerto_Rican_moist_forests        | Mayaguez | NA     | Quebrada de Oro, UPRM campus | PR          | Puerto Rico   |                | TRVSO,DS-CICHI          | PRI                        | NA                  |

### 2c.Geographic location filter

Data is downloaded followed by the ‘geography’ filter applied on it to
fetch only the relevant locations (here United States) data.

``` r

to_download=test.data[1:100,]

result_geography<-bold.fetch(param.data = to_download,
                               query.param = 'processid',
                               param.index = 1,
                               api_key = api.key,
                                filt.geography=c("United States"),
                                filt.fields = c("bin_uri","processid","country.ocean"))
 
knitr::kable(head(result_geography,5))                 
```

| processid | sampleid    | bin_uri      | country.ocean |
|:----------|:------------|:-------------|:--------------|
| AJS096-19 | S-02-A-FBC6 | BOLD:AAC9904 | United States |
| AJS093-19 | S-02-A-FBC3 | BOLD:AAC9904 | United States |
| AJS026-19 | S-09-B-FB   | BOLD:AAC9904 | United States |
| AJS001-19 | S-01-A-FB   | BOLD:AAC9904 | United States |
| AJS020-19 | S-07-B-FB   | BOLD:AAC9904 | United States |

### 2d.Altitude

Data is downloaded followed by the ‘Altitude’ filter applied on it to
fetch data only between the range of altitude specified (100 to 1500 m
a.s.l.) data.

``` r
to_download=test.data[1:100,]

result_altitude<-bold.fetch(param.data = to_download,
                               query.param = 'processid',
                               param.index = 1,
                               api_key = api.key,
                               filt.altitude = c(100,1500),
                               filt.fields = c("bin_uri","processid","family","elev"))

knitr::kable(head(result_altitude,5))                    
```

| processid  | sampleid | bin_uri      | family    | elev |
|:-----------|:---------|:-------------|:----------|-----:|
| ACAM008-13 | AC13A14  | BOLD:ACE5030 | Cichlidae |  501 |
| ACAM015-13 | AC13A32  | BOLD:AAA8511 | Cichlidae |  526 |
| ACAM001-13 | AC13A01  | BOLD:AAA8511 | Cichlidae |  532 |
| ACAM030-13 | AC13A78  | BOLD:AAA8511 | Cichlidae |  286 |
| ACAM027-13 | AC13A72  | BOLD:AAA8511 | Cichlidae |  496 |

### 3.bold.search.public

This function retrieves the ids (process and sample id) of all publicly
available data based on a search query. NO `api key` is required for
this function. `bold.fetch` can then download all the relevant data for
these ids. This two step process ensures that user has an idea on the
scope of the data (i.e. number of records) based on the ids downloaded.
Search can be based on taxonomic names, geographical locations, BIN ids
(BIN numbers). All the other filters can then be used on the downloaded
data to refine the result further. *The search parameters of this
function should be used carefully. Wrong combination of parameters might
not retrieve any data.*

### 3a.IDs retrieved based on taxonomy

``` r

result.public.ids<-bold.public.search(taxonomy = c("Panthera leo"))

knitr::kable(head(result.public.ids,10))                    
```

| processid    | sampleid     |
|:-------------|:-------------|
| ABRMM002-06  | ROM PM13004  |
| ABRMM043-06  | ROM 101200   |
| CAR055-11    | Ple153       |
| CAR055-11    | Ple153       |
| CAR056-11    | Ple185       |
| CAR056-11    | Ple185       |
| GBCHO2596-23 | XR_006196888 |
| GBCHO2597-23 | XR_006196890 |
| GBCHO2598-23 | XR_006196891 |
| GBCHO2599-23 | XR_006196892 |

### 3b.IDs retrieved based on taxonomy and geography

``` r

result.public.geo.id<-bold.public.search(taxonomy = c("Panthera leo"),geography = "India",filt.marker = "COI-5P")

fetch.data.result.geo.id<-bold.fetch(param.data = result.public.geo.id,
                               query.param = 'processid',
                               param.index = 1,
                               api_key = api.key,
                               filt.fields = c("bin_uri","processid","family","elev"))

knitr::kable(head(fetch.data.result.geo.id,5)) 
```

| processid | sampleid | bin_uri | family  | elev |
|:----------|:---------|:--------|:--------|-----:|
| CAR056-11 | Ple185   | NA      | Felidae |   NA |
| CAR056-11 | Ple185   | NA      | Felidae |   NA |

### 3c.IDs retrieved based on taxonomy, geography and BIN id

``` r
result.public.geo.bin<-bold.public.search(taxonomy = c("Panthera leo"),geography = "India",bins = 'BOLD:AAD6819')
 
knitr::kable(head(result.public.geo.bin))                   
```

| processid  | sampleid        |
|:-----------|:----------------|
| GENG056-12 | BIOMTWL-BLE-017 |

### 4.bold.data.summarize

`bold.data.summarize` provides a detailed profile of the data downloaded
through `bold.fetch`. This profile is further broken by data types
wherein each type of data get some unique measures (Ex.mean,mode for
numeric data). Profile can also be created for specific columns using
the `columns` argument. The function also prints the number of rows and
columns in the console by default.

``` r
to_download=test.data[1:100,]

fetch.data.result.summ<-bold.fetch(param.data = to_download,
                               query.param = 'processid',
                               param.index = 1,
                               api_key = api.key)

data.summ.res<-bold.data.summarize(fetch.data.result.summ)
#> The total number of rows in the dataset is: 99 
#> The total number of columns in the dataset is: 101

# # Data summary (character data)
# data.summ.res$character
```

### *5.bold.analyze.align*

This function is currently an internal function of the package (with
documentation). This function acts as a wrapper around the `msa` and
`Biostrings` package functions for users of `BOLDconnectR` by which they
can carry out multiple sequence alignment on the downloaded data by
`bold.fetch` functions. In order to use this function following notation
needs to be used `BOLDconnectR:::align.seq`. In addition, the users need
to install and load `msa` and `Biostrings` separately before using this
function to avoid any errors. A function performs alignment using the
‘ClustalOmega’ algorithm by default, though, more refined alignments can
be done by passing additional arguments of the `msa` function to the
function. The function outputs a modified BOLD BCDM dataset with two
additional columns, one being the aligned sequence and the other being
the name of the sequence as per the user specifications.

``` r
api.key <- Sys.getenv('api_key')

data.4.alignment.ids<-bold.public.search(taxonomy = "Eulimnadia")

aligned.data.result<-bold.fetch(param.data = data.4.alignment.ids,
                               query.param = 'processid',
                               param.index = 1,
                               api_key = api.key,
                               filt.marker = "COI-5P")

#data.seq.aligned<-BOLDconnectR:::bold.analyze.align(aligned.data.result)


# A data.frame of the sequences and their respective names
#final.res=subset(data.seq.aligned,select=c(aligned_seq,msa.seq.name))
```

### 6.bold.analyze.tree

This function uses the modified BCDM dataframe obtained from the
`bold.analyze.align` to generate a distance matrix, a Neighbor Joining
(NJ) tree visualization and a newick tree output. This function acts as
a wrapper around the `dist.dna` and `plot.phylo` functions from `ape`.
Additional arguments can be passed to the `dist.dna` function using the
`...` argument. Newick trees can be exported optionally.

``` r

library(msa)

api.key <- Sys.getenv('api_key')

# data.4.analysis.ids<-bold.public.search(taxonomy = "Eulimnadia")
# 
# data.4.seqanalysis<-bold.fetch(param.data = data.4.analysis.ids,
#                                query.param = 'processid',
#                                param.index = 1,
#                                api_key = api.key,
#                                filt.marker = "COI-5P")
# 
# 
# data.seq.align<-BOLDconnectR:::bold.analyze.align(data.4.seqanalysis,seq.name.fields = c("bin_uri","species"))
# 
# data.seq.analyze<-bold.analyze.tree(data.seq.align,
#                                              dist.model = "K80",
#                                              dist.matrix = TRUE,
#                                              clus.method="njs",
#                                              tree.plot=TRUE,
#                                              tree.plot.type = "p")
```

### 7. bold.analyze.diversity

`bold.analyze.diversity` generates a biodiversity profile of the BOLD
BCDM downloaded data using the `bold.fetch` function. Results include,
richness estimations, shannon diversity, preston plots and beta
diversity. Function converts the data into a `site X species` like
matrix (for more information, please scroll till the end) having either
BIN counts (or presence-absence) data at the user-specified taxonomic
level. This function acts as a wrapper function around
`BAT::alpha.accum()`, `vegan::prestondistr()` and `vegan::diversity()`
to calculate the results. Preston plots are created using the data from
the `prestondistr` results where cyan bars represent observed species
(or equivalent taxonomic group) and orange dots for expected the counts.
Beta diversity is based on either the Sørensen or Jaccard indexes. It
also generates matrices of *species replacement* and *richness
difference* components of the total beta diversity. These values are
calculated using `BAT::beta()` function, which partitions the data using
the Podani & Schmera (2011)/Carvalho et al. (2012) approach. *Note that
the results, including species counts, adapt based on taxonomic rank
used in `gen.comm.mat()` although the output label remains ‘species’ in
some instances (preston.res).*

### 7a. Richness results

``` r
# api.key <- Sys.getenv('api_key')
# 
# # Fetch the data
# BCDMdata<-bold.fetch(param.data = test.data,query.param = "processid",param.index = 1,api_key = api.key)
# 
# #1. Analyze richness data
# res.rich<-bold.analyze.diversity(BCDMdata,taxon.rank="species",site.cat='country.ocean',richness.res=TRUE)
# 
# # Community matrix (BCDM data converted to community matrix)
# res.rich$comm.matrix
# 
# # richness results
# knitr::kable(res.rich$richness)
```

### 7b. Shannon diversity

``` r
# api.key <- Sys.getenv('api_key')
# 
# #2. Shannon diversity
# res.shannon<-bold.analyze.diversity(BCDMdata,taxon.rank="species",site.cat='country.ocean',shannon.res = TRUE)
# 
# # Shannon diversity results
# knitr::kable(res.shannon)
```

### 7c. Preston plot results

``` r
# api.key <- Sys.getenv('api_key')
# #3. Preston plots and results
# 
# pres.res<-bold.analyze.diversity(BCDMdata,taxon.rank="species",site.cat='country.ocean',preston.res=TRUE)
# 
# # Preston plot
# pres.res$preston.plot
# 
# # Preston plot data
# pres.res$preston.res
```

### 7d. Beta diversity

``` r
api.key <- Sys.getenv('api_key')
# #4. beta diversity
# beta.res<-bold.analyze.diversity(BCDMdata,taxon.rank="species",site.cat='country.ocean',beta.res=TRUE,beta.index = "jaccard")
# 
# # Total beta diversity matrix (10 rows)
# knitr::kable(head(as.matrix(round(beta.res$total.beta,2)),10))

#Replacement
# beta.res$replace

#Richness difference
# beta.res$richnessd
```

### 8.bold.analyze.map

``` r
api.key <- Sys.getenv('api_key')
#Download the ids for the data
# map.data.ids<-bold.public.search(taxonomy = "Musca domestica")
# 
# # Fetch the data using the ids
# map.data<-bold.fetch(param.data = map.data.ids,query.param = "processid",param.index = 1,api_key = api.key)
# 
# geo.viz<-bold.analyze.map(map.data)
# 
# geo.viz.country<-bold.analyze.map(map.data,country = "China")

#The `sf` dataframe of the downloaded data
# geo.viz$geo.df

# Visualization
# geo.viz$plot
```

### 9.bold.export

`bold.export` provides an export option for some of the sequence based
outputs obtained by functions from *BOLDconnectR*. Sequence information
downloaded using the `bold.fetch` or the aligned sequences obtained
using `bold.analyze.align` can be exported as a fasta file for third
party tool use (`export`=‘fas’ or ‘msa.fas’). Data downloaded by the
`bold.fetch` can be directly used to export the unaligned fasta file
while the modified dataframe obtained after using the
`bold.analyze.align` is needed for exporting the multiple sequence
alignment. Name for individual sequences in the unaligned fasta file
output can be customized by using the fas.seq.name.fields argument. If
more than one field is specified, the name will follow the sequence of
the fields given in the vector. The multiple sequence aligned fasta file
uses the same name given by the user in the bold.analyze.align function.
In addition, the function also allows user edited data (in
taxonomy,geography etc.) to be exported as a csv/tsv file while
retaining its BCDM format. This functionality is added keeping in the
mind the possibility of uploading data to BOLD using the package in the
near future.The edits done to the BCDM data could be from any other R
packages so long as it maintains the BCDM format.

``` r

#Download the ids for the data
# data.for.export.ids<-bold.public.search(taxonomy = "Poecilia reticulata",filt.basecount = c(500,600),filt.marker = "COI-5P")

# Fetch the data using the ids
# data.for.export<-bold.fetch(param.data = data.for.export.ids,query.param = "processid",param.index = 1,api_key = apikey)

# Align the data (using species", bin_uri & country.ocean as a composite name for each sequence)
# seq.align<-BOLDconnectR:::bold.analyze.align(data.for.export, seq.name.fields = c("processid","bin_uri"))

# Export the fasta file (unaligned) (Please note the input data here is the original BCDM data retrieved using bold.fetch)
# bold.export(data.for.export,export = "fas",fas.seq.name.fields = c("species","bin_uri","processid"),export.file.path = "file_path",export.file.name = "file_name")

# Export the multiple sequence alignment (Please note the input data here is the modified BCDM data after using bold.analyze.align)
# bold.export(seq.align,export = "msa.fas",fas.seq.name.fields = ("species","bin_uri","processid"),,export.file.path = "file_path",export.file.name = "file_name")

# Additionally, if the user modifies any content in the BCDM data using any other R function, that modified dataframe can also be exported using bold.fetch. This option has been provided considering a future option of uploading data directly to BOLD
```

### Note on the community matrix generated for `bold.analyze.diversity`

The \*site X species** like matrix generated for
`bold.analyze.diversity` calculates the counts (or abundances) or
presence-absence data of the BINs for the given site category
(*site.cat*) or a *grid.cat*. These counts can be generated at any
taxonomic hierarchical level for a single or multiple taxa (This can
also be done for ‘bin_uri’; the difference being that the numbers in
each cell would be the number of times that respective BIN is found at a
particular *site.cat* or *grid.cat*). *site.cat* can be any of the
geography fields (Meta data on fields can be checked using the
`bold.fields.info()`). Alternatively, `grid.cat` = TRUE will generate
grids based on the BIN occurrence data (latitude, longitude) with the
size of the grid determined by the user (in sq.m.). For grids
generation, rows with no latitude and longitude data are removed (even
if a corresponding *site.cat* information is available) while NULL
entries for *site.cat* are allowed if they have a latitude and longitude
value (This is done because grids are drawn based on the bounding boxes
which only use latitude and longitude values).`grids.cat` converts the
Coordinate Reference System (CRS) of the data to a **Mollweide\*\*
projection by which distance based grid can be appropriately specified.
A cell id is also given to each grid with the smallest number assigned
to the lowest latitudinal point in the data. A basic gridmap is also
stored in the output when `grids.cat`=TRUE. The plot obtained is a
visualization of the grid centroids with their respective names. *Please
note that if the data has many closely located grids, visualization with
view.grids can get confusing*. The argument `presence.absence` converts
the counts (or abundances) to 1 and 0. The community matrix is also
stored in the output as `comm.mat` and can also be used as the input
data for functions from packages like vegan for biodiversity analyses.

*BOLDconnectR* is able to fetch public as well as private user data very
fast (~100k records in just under a minute) and also offers
functionality for data transformation and analysis.
