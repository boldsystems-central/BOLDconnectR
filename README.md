
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

| processid   | record_id          | insdc_acs | sampleid    | specimenid | taxid | short_note | identification_method | museumid         | fieldid     | collection_code | processid_minted_date | inst                      | specimendetails.verbatim_depository | funding_src | sex | life_stage | reproduction | habitat | collectors | site_code | specimen_linkout | collection_event_id | sampling_protocol | tissue_type | collection_date_start | specimendetails.verbatim_collectiondate | collection_time | collection_date_accuracy | specimendetails.verbatim_collectiondate_precision | associated_taxa | associated_specimens | voucher_type                    | notes | taxonomy_notes | collection_notes | specimendetails.verbatim_kingdom | specimendetails.verbatim_phylum | specimendetails.verbatim_class | specimendetails.verbatim_order | specimendetails.verbatim_family | specimendetails.verbatim_subfamily | specimendetails.verbatim_tribe | specimendetails.verbatim_genus | specimendetails.verbatim_species | specimendetails.verbatim_subspecies | specimendetails.verbatim_species_reference | specimendetails.verbatim_identifier | geoid | location.verbatim_country | location.verbatim_province | location.verbatim_country_iso_alpha3 | marker_code | kingdom  | phylum   | class          | order        | family    | subfamily           | tribe | genus       | species                 | subspecies | identification          | identification_rank | tax_rank.numerical_posit | species_reference | identified_by    | specimendetails\_\_identifier.person.email | sequence_run_site                                        | nuc                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | nuc_basecount | sequence_upload_date | bin_uri      | bin_created_date | elev | location.verbatim_elev | depth | location.verbatim_depth |      lat |      lon | location.verbatim_coord | coord_source | coord_accuracy | location.verbatim_gps_accuracy | elev_accuracy | location.verbatim_elev_accuracy | depth_accuracy | location.verbatim_depth_accuracy | realm       | biome                                           | ecoregion                         | region | sector | site             | country_iso | country.ocean | province.state | bold_recordset_code_arr | geopol_denorm.country_iso3 | collection_date_end |
|:------------|:-------------------|:----------|:------------|-----------:|------:|:-----------|:----------------------|:-----------------|:------------|:----------------|:----------------------|:--------------------------|:------------------------------------|:------------|:----|:-----------|:-------------|:--------|:-----------|:----------|:-----------------|:--------------------|:------------------|:------------|:----------------------|:----------------------------------------|:----------------|:-------------------------|:--------------------------------------------------|:----------------|:---------------------|:--------------------------------|:------|:---------------|:-----------------|:---------------------------------|:--------------------------------|:-------------------------------|:-------------------------------|:--------------------------------|:-----------------------------------|:-------------------------------|:-------------------------------|:---------------------------------|:------------------------------------|:-------------------------------------------|:------------------------------------|------:|:--------------------------|:---------------------------|:-------------------------------------|:------------|:---------|:---------|:---------------|:-------------|:----------|:--------------------|:------|:------------|:------------------------|:-----------|:------------------------|:--------------------|-------------------------:|:------------------|:-----------------|:-------------------------------------------|:---------------------------------------------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------:|:---------------------|:-------------|:-----------------|-----:|:-----------------------|------:|:------------------------|---------:|---------:|:------------------------|:-------------|---------------:|:-------------------------------|--------------:|:--------------------------------|---------------:|:---------------------------------|:------------|:------------------------------------------------|:----------------------------------|:-------|:-------|:-----------------|:------------|:--------------|:---------------|:------------------------|:---------------------------|:--------------------|
| BIOPH120-20 | BIOPH120-20.COI-5P | MW591120  | BIOPH_USM07 |   11441571 | 24807 | NA         | Morphology            | USMFC (47) 00012 | BIOPH_USM07 | PS              | 2020-04-01            | Universiti Sains Malaysia | NA                                  | NA          | NA  | NA         | NA           | NA      | NA         | NA        | NA               | NA                  | NA                | Fin clip    | 2020-01-10            | NA                                      | NA              | NA                       | NA                                                | NA              | NA                   | Vouchered:Registered Collection | NA    | NA             | NA               | NA                               | NA                              | NA                             | NA                             | NA                              | NA                                 | NA                             | NA                             | NA                               | NA                                  | NA                                         | NA                                  |  5949 | NA                        | NA                         | NA                                   | COI-5P      | Animalia | Chordata | Actinopterygii | Cichliformes | Cichlidae | Pseudocrenilabrinae | NA    | Oreochromis | Oreochromis mossambicus | NA         | Oreochromis mossambicus | species             |                       17 | Peters, 1852      | Sebastien Lavoue | <microceb@hotmail.com>                     | Universiti Sains Malaysia, School of Biological Sciences | CCTCTATCTAGTATTTGGTGCTTGAGCCGGAATAGTAGGAACTGCATTAAGCCTCCTAATTCGGGCAGAACTAAGCCAGCCCGGCTCTCTCCTCGGAGACGACCAGATTTATAATGTAATTGTTACAGCACATGCTTTCGTAATAATTTTCTTTATAGTAATGCCAATTATAATTGGAGGTTTTGGAAACTGACTAGTGCCACTAATGATTGGTGCACCAGACATGGCCTTCCCTCGAATAAATAACATGAGTTTTTGACTCCTCCCCCCCTCATTTCTCCTTCTCCTCGCCTCATCCGGGGTCGAAGCAGGGGCCGGTACAGGATGGACTGTTTATCCCCCACTCGCAGGCAATCTCGCCCATGCTGGGCCTTCCGTTGACTTAACCATCTTCTCCCTCCACTTGGCCGGGGTGTCATCTATTTTAGGTGCAATTAATTTTATTACAACCATTATTAACATAAAACCCCCTGCCATCTCCCAATATCAAACACCCCTCTTTGTATGATCCGTTCTAATTACCGCAGTACTACTCCTACTATCCCTACCCGTTCTTGCCGCCGGCATCACAATACTTCTAACAGACCGAAACCTAAACACAACCTTCTTTGACCCTGCCGGAGGAGGAGACCCCATCCTTTACCAACACTTATTC |           655 | 2020-04-01           | BOLD:AAA8511 | 2010-07-15       |   NA | NA                     |    NA | NA                      | 5.355111 | 100.2983 | NA                      | NA           |             NA | NA                             |            NA | NA                              |             NA | NA                               | Indomalayan | Tropical\_&\_Subtropical_Moist_Broadleaf_Forest | Peninsular_Malaysian_rain_forests |        |        | Sungai Dua       | MY          | Malaysia      | Pulau Pinang   | BIOPH,DS-CICHI          | MYS                        | NA                  |
| BIOPH084-20 | BIOPH084-20.COI-5P | MW591123  | BIOPH_PS213 |   11441535 | 24807 | NA         | Morphology            | USMFC (47) 00010 | BIOPH_PS213 | PS              | 2020-04-01            | Universiti Sains Malaysia | NA                                  | NA          | NA  | NA         | NA           | NA      | NA         | NA        | NA               | NA                  | NA                | Fin clip    | 2020-01-05            | NA                                      | NA              | NA                       | NA                                                | NA              | NA                   | Vouchered:Registered Collection | NA    | NA             | NA               | NA                               | NA                              | NA                             | NA                             | NA                              | NA                                 | NA                             | NA                             | NA                               | NA                                  | NA                                         | NA                                  |  5949 | NA                        | NA                         | NA                                   | COI-5P      | Animalia | Chordata | Actinopterygii | Cichliformes | Cichlidae | Pseudocrenilabrinae | NA    | Oreochromis | Oreochromis mossambicus | NA         | Oreochromis mossambicus | species             |                       17 | Peters, 1852      | Sebastien Lavoue | <microceb@hotmail.com>                     | Universiti Sains Malaysia, School of Biological Sciences | CCTCTATCTAGTATTTGGTGCTTGAGCCGGAATAGTAGGAACTGCATTAAGCCTCCTAATTCGGGCAGAACTAAGCCAGCCCGGCTCTCTCCTCGGAGACGACCAGATTTATAATGTAATTGTTACAGCACATGCTTTCGTAATAATTTTCTTTATAGTAATGCCAATTATAATTGGAGGTTTTGGAAACTGACTAGTGCCACTAATGATTGGTGCACCAGACATGGCCTTCCCTCGAATAAATAACATGAGTTTTTGACTCCTCCCCCCCTCATTTCTCCTTCTCCTCGCCTCATCCGGGGTCGAAGCAGGGGCCGGTACAGGATGGACTGTTTATCCCCCACTCGCAGGCAATCTCGCCCATGCTGGGCCTTCCGTTGACTTAACCATCTTCTCCCTCCACTTGGCCGGGGTGTCATCTATTTTAGGTGCAATTAATTTTATTACAACCATTATTAACATAAAACCCCCTGCCATCTCCCAATATCAAACACCCCTCTTTGTATGATCCGTTCTAATTACCGCAGTACTACTCCTACTATCCCTACCCGTTCTTGCCGCCGGCATCACAATACTTCTAACAGACCGAAACCTAAACACAACCTTCTTTGACCCTGCCGGAGGAGGAGACCCCATCCTTTACCAACACTTATTC |           655 | 2020-04-01           | BOLD:AAA8511 | 2010-07-15       |   NA | NA                     |    NA | NA                      | 5.349722 | 100.2149 | NA                      | NA           |             NA | NA                             |            NA | NA                              |             NA | NA                               | Indomalayan | NA                                              | Peninsular_Malaysian_rain_forests |        |        | Sungai Kongsi    | MY          | Malaysia      | Pulau Pinang   | BIOPH,DS-CICHI          | MYS                        | NA                  |
| BIOPH079-20 | BIOPH079-20.COI-5P | MW591122  | BIOPH_TB51  |   11441530 | 24807 | NA         | Morphology            | USMFC (47) 00009 | BIOPH_TB51  | PS              | 2020-04-01            | Universiti Sains Malaysia | NA                                  | NA          | NA  | NA         | NA           | NA      | NA         | NA        | NA               | NA                  | NA                | Fin clip    | 2019-11-24            | NA                                      | NA              | NA                       | NA                                                | NA              | NA                   | Vouchered:Registered Collection | NA    | NA             | NA               | NA                               | NA                              | NA                             | NA                             | NA                              | NA                                 | NA                             | NA                             | NA                               | NA                                  | NA                                         | NA                                  |  5949 | NA                        | NA                         | NA                                   | COI-5P      | Animalia | Chordata | Actinopterygii | Cichliformes | Cichlidae | Pseudocrenilabrinae | NA    | Oreochromis | Oreochromis mossambicus | NA         | Oreochromis mossambicus | species             |                       17 | Peters, 1852      | Sebastien Lavoue | <microceb@hotmail.com>                     | Universiti Sains Malaysia, School of Biological Sciences | CCTCTATCTAGTATTTGGTGCTTGAGCCGGAATAGTAGGAACTGCATTAAGCCTCCTAATTCGGGCAGAACTAAGCCAGCCCGGCTCTCTCCTCGGAGACGACCAGATTTATAATGTAATTGTTACAGCACATGCTTTCGTAATAATTTTCTTTATAGTAATGCCAATTATAATTGGAGGTTTTGGAAACTGACTAGTGCCACTAATGATTGGTGCACCAGACATGGCCTTCCCTCGAATAAATAACATGAGTTTTTGACTCCTCCCCCCCTCATTTCTCCTTCTCCTCGCCTCATCCGGGGTCGAAGCAGGGGCCGGTACAGGATGGACTGTTTATCCCCCACTCGCAGGCAATCTCGCCCATGCTGGGCCTTCCGTTGACTTAACCATCTTCTCCCTCCACTTGGCCGGGGTGTCATCTATTTTAGGTGCAATTAATTTTATTACAACCATTATTAACATAAAACCCCCTGCCATCTCCCAATATCAAACACCCCTCTTTGTATGATCCGTTCTAATTACCGCAGTACTACTCCTACTATCCCTACCCGTTCTTGCCGCCGGCATCACAATACTTCTAACAGACCGAAACCTAAACACAACCTTCTTTGACCCTGCCGGAGGAGGAGACCCCATCCTTTACCAACACTTATTC |           655 | 2020-04-01           | BOLD:AAA8511 | 2010-07-15       |   NA | NA                     |    NA | NA                      | 5.454278 | 100.2133 | NA                      | NA           |             NA | NA                             |            NA | NA                              |             NA | NA                               | Indomalayan | Tropical\_&\_Subtropical_Moist_Broadleaf_Forest | Peninsular_Malaysian_rain_forests |        |        | Teluk Bahang     | MY          | Malaysia      | Pulau Pinang   | BIOPH,DS-CICHI          | MYS                        | NA                  |
| BIOPH052-20 | BIOPH052-20.COI-5P | MW591121  | BIOPH_BG31  |   11441503 | 24807 | NA         | Morphology            | USMFC (47) 00007 | BIOPH_BG31  | PS              | 2020-04-01            | Universiti Sains Malaysia | NA                                  | NA          | NA  | NA         | NA           | NA      | NA         | NA        | NA               | NA                  | NA                | Fin clip    | 2019-10-20            | NA                                      | NA              | NA                       | NA                                                | NA              | NA                   | Vouchered:Registered Collection | NA    | NA             | NA               | NA                               | NA                              | NA                             | NA                             | NA                              | NA                                 | NA                             | NA                             | NA                               | NA                                  | NA                                         | NA                                  |  5949 | NA                        | NA                         | NA                                   | COI-5P      | Animalia | Chordata | Actinopterygii | Cichliformes | Cichlidae | Pseudocrenilabrinae | NA    | Oreochromis | Oreochromis mossambicus | NA         | Oreochromis mossambicus | species             |                       17 | Peters, 1852      | Sebastien Lavoue | <microceb@hotmail.com>                     | Universiti Sains Malaysia, School of Biological Sciences | CCTCTATCTAGTATTTGGTGCTTGAGCCGGAATAGTAGGAACTGCATTAAGCCTCCTAATTCGGGCAGAACTAAGCCAGCCCGGCTCTCTCCTCGGAGACGACCAGATTTATAATGTAATTGTTACAGCACATGCTTTCGTAATAATTTTCTTTATAGTAATGCCAATTATAATTGGAGGTTTTGGAAACTGACTAGTGCCACTAATGATTGGTGCACCAGACATGGCCTTCCCTCGAATAAATAACATGAGTTTTTGACTCCTCCCCCCCTCATTTCTCCTTCTCCTCGCCTCATCCGGGGTCGAAGCAGGGGCCGGTACAGGATGGACTGTTTATCCCCCACTCGCAGGCAATCTCGCCCATGCTGGGCCTTCCGTTGACTTAACCATCTTCTCCCTCCACTTGGCCGGGGTGTCATCTATTTTAGGTGCAATTAATTTTATTACAACCATTATTAACATAAAACCCCCTGCCATCTCCCAATATCAAACACCCCTCTTTGTATGATCCGTTCTAATTACCGCAGTACTACTCCTACTATCCCTACCCGTTCTTGCCGCCGGCATCACAATACTTCTAACAGACCGAAACCTAAACACAACCTTCTTTGACCCTGCCGGAGGAGGAGACCCCATCCTTTACCAACACTTATTC |           655 | 2020-04-01           | BOLD:AAA8511 | 2010-07-15       |   NA | NA                     |    NA | NA                      | 5.435639 | 100.2936 | NA                      | NA           |             NA | NA                             |            NA | NA                              |             NA | NA                               | Indomalayan | Tropical\_&\_Subtropical_Moist_Broadleaf_Forest | Peninsular_Malaysian_rain_forests |        |        | Botanical Garden | MY          | Malaysia      | Pulau Pinang   | BIOPH,DS-CICHI          | MYS                        | NA                  |
| BIOPH132-20 | BIOPH132-20.COI-5P | MW591125  | BIOPH_PS324 |   11441583 | 52768 |            | Morphology            | USMFC (47) 00014 | BIOPH_PS324 | PS              | 2020-04-01            | Universiti Sains Malaysia | NA                                  | NA          |     |            |              | NA      | NA         | NA        | NA               | NA                  | NA                | Fin clip    | 2020-01-19            | NA                                      | NA              | NA                       | NA                                                |                 |                      | Vouchered:Registered Collection | NA    | NA             | NA               | NA                               | NA                              | NA                             | NA                             | NA                              | NA                                 | NA                             | NA                             | NA                               | NA                                  | NA                                         | NA                                  |  5949 | NA                        | NA                         | NA                                   | COI-5P      | Animalia | Chordata | Actinopterygii | Cichliformes | Cichlidae | Pseudocrenilabrinae | NA    | Oreochromis | Oreochromis niloticus   | NA         | Oreochromis niloticus   | species             |                       17 | Linnaeus, 1758    | Sebastien Lavoue | <microceb@hotmail.com>                     | Universiti Sains Malaysia, School of Biological Sciences | CCTCTATCTAGTATTTGGTGCTTGAGCCGGAATAGTAGGAACTGCACTAAGCCTCCTAATTCGGGCAGAACTAAGCCAGCCCGGCTCTCTTCTCGGAGACGACCAAATCTATAATGTAATTGTTACAGCACATGCTTTCGTAATAATTTTCTTTATAGTAATACCAATTATGATTGGAGGCTTTGGAAACTGACTAGTACCCCTCATGATTGGTGCACCAGACATGGCCTTCCCTCGAATAAATAACATGAGCTTTTGACTTCTCCCCCCCTCATTTCTTCTTCTTCTCGCCTCATCTGGAGTCGAAGCAGGTGCCGGCACAGGATGGACTGTTTATCCCCCGCTCGCAGGCAATCTTGCCCACGCTGGACCTTCTGTTGACTTAACCATCTTCTCCCTCCACTTGGCCGGAGTGTCATCTATTTTAGGTGCAATTAATTTTATCACAACCATTATTAACATGAAACCCCCTGCCATCTCCCAATATCAAACACCCCTATTTGTGTGATCCGTCCTAATTACCGCAGTACTACTCCTTCTATCCCTGCCCGTTCTTGCCGCCGGCATCACAATACTTCTAACAGACCGAAACCTAAACACAACCTTCTTTGACCCTGCCGGAGGAGGAGACCCCATCCTATACCAACACTTATTC |           655 | 2020-04-01           | BOLD:AAC9904 | 2010-07-15       |   NA | NA                     |    NA | NA                      | 5.324000 | 100.2670 | NA                      | NA           |             NA | NA                             |            NA | NA                              |             NA | NA                               | Indomalayan | Tropical\_&\_Subtropical_Moist_Broadleaf_Forest | Peninsular_Malaysian_rain_forests | NA     | NA     | Sungai Ara       | MY          | Malaysia      | Pulau Pinang   | BIOPH,DS-CICHI          | MYS                        | NA                  |

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
| AJS062-19 | S-06-B-MB   | NA           | United States |
| AJS066-19 | S-07-C-MB   | NA           | United States |
| AJS005-19 | S-02-B-FB   | NA           | United States |
| AJS101-19 | S-03-A-FBC1 | BOLD:AAC9904 | United States |
| AJS008-19 | S-03-B-FB   | NA           | United States |

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
| ACAM015-13 | AC13A32  | BOLD:AAA8511 | Cichlidae |  526 |
| ACAM008-13 | AC13A14  | BOLD:ACE5030 | Cichlidae |  501 |
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
                               api_key = api.key,
                               filt.fields = c("bin_uri","elev","nuc_basecount","species","inst"))

data.summ.res<-bold.data.summarize(fetch.data.result.summ)
#> The total number of rows in the dataset is: 99 
#> The total number of columns in the dataset is: 7

# Data summary (character data)
data.summ.res$character
```

**Variable type: character**

| skim_variable | n_missing | complete_rate | min | max | empty | n_unique | whitespace |
|:--------------|----------:|--------------:|----:|----:|------:|---------:|-----------:|
| processid     |         0 |          1.00 |   9 |  10 |     0 |       99 |          0 |
| sampleid      |         0 |          1.00 |   7 |  12 |     0 |       99 |          0 |
| bin_uri       |        55 |          0.44 |  12 |  12 |     0 |        3 |          0 |
| species       |         0 |          1.00 |  20 |  23 |     0 |        3 |          0 |
| inst          |         0 |          1.00 |  18 |  48 |     0 |        2 |          0 |

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

data.4.alignment.ids<-bold.public.search(taxonomy = "Eulimnadia")

aligned.data.result<-bold.fetch(param.data = data.4.alignment.ids,
                               query.param = 'processid',
                               param.index = 1,
                               api_key = api.key,
                               filt.marker = "COI-5P")

data.seq.aligned<-BOLDconnectR:::bold.analyze.align(aligned.data.result)
#> using Gonnet

# A data.frame of the sequences and their respective names
final.res=subset(data.seq.aligned,select=c(aligned_seq,msa.seq.name))
knitr::kable(head(final.res))
```

| aligned_seq                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | msa.seq.name |
|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------------|
| GGGACTCTTTACTTAATTTTTGGTGCTTGATCTGGTATGGTAGGAACAGCCTTAAGCTTGTTAATTCGAGTTGAGTTAGGACAACCTGGCTCTTTTATTGGTGATGACCAGATTTATAATGTGGTAGTTACCGCCCATGCTTTCATCATAATTTTTTTTATGGTTATACCTATCTTGATTGGGGGGTTTGGGAATTGATTGGTCCCTTTAATATTAGGTGCCCCCGACATGGCTTTTCCTCGTTTAAATAATATGAGTTTTTGACTCTTGCCCCCTGCATTGATTTTATTGCTTTCAGGGGCTGGAGTAGAGAGAGGAGCGGGGACTGGTTGAACAGTCTATCCTCCTTTATCGGCCGGAATTGCTCACGCTGGGGCATCTGTTGATTTGAGAATTTTTTCTCTTCATCTAGCCGGGATTTCTTCAATCTTAGGAGCAATTAATTTTATTACCACTATTATTAATATGCGAGTCCAAGGTATAACTTTGGATCGAATTCCTCTCTTTGTGTGAGCGGTTGGAATTACTGCTTTGTTGTTGCTTTTATCTTTACCTGTACTCGCAGGAGCGATTACAATATTATTAACTGATCGTAACCTGAATACTTCTTTCTTTGACCCTGCTGGGGGAGGAGATCCTATTTTATATCAACATTTATTTTGATTTTTTGGCCATCCTGAGGTTTACATTTTAATTTTACCTGGGTTTGGTATGATTTCCCACATTATTAGCCAAGAGAGCGGTAAGAAGGAGTCCTTTGGGACTTTAGGAATGATTTACGCTATACTAGCCATTGGAATCTTAGGATTTGTGGTGTGAGCTCATCATATATTTACAGTTGGTATGGATGTCGATACTCGAGCCTATTTTACCGCAGCAACAATAATTATTGCTGTGCCTACTGGGATCAAGATTTTTAGATGGTTAGGGACTTTACATGGGA | GBCB912-10   |
| –AACTCTTTATTTAATTTTTGGTGCTTGGTCCGGTATAGTAGGAACAGCACTTAGTCTTTTGATTCGAGTAGAATTGGGTCAACCTGGTTCTTTCATTGGAGACGATCAGATTTATAATGTAGTAGTAACTGCTCATGCTTTTATCATGATTTTCTTTATAGTTATACCTATCCTTATTGGAGGGTTTGGAAACTGACTTGTGCCACTAATATTAGGTGCACCTGACATGGCTTTTCCTCGTTTAAATAATATAAGTTTTTGACTTTTACCTCCTGCATTAATCTTATTGTTATCAGGCGCTGGAGTAGAAAGAGGAGCTGGTACAGGATGAACAGTTTATCCCCCTTTGTCGGCTGGGATTGCCCATGCTGGAGCTTCTGTTGATCTGAGAATTTTTTCTCTTCATCTAGCTGGGGTTTCTTCTATTTTAGGGGCTATTAATTTTATTACTACTATTATCAACATGCGAGTTCATGGAATAACTTTAGATCGAATTCCTCTTTTCGTTTGAGCTGTTGGGATTACTGCTTTATTATTACTCTTATCTTTACCTGTTCTTGCCGGAGCTATCACGATGTTACTGACTGATCGTAACTTAAATACTTCTTTTTTTGATCCAGCTGGAGGGGGAGATCCAATTTTGTATCAACATTTATTT——————————————————————————————————————————————————————————————————————————————————————————————-                                                                                                                                                                                              | BCRUA025-10  |
| GGGACTCTTTACTTAATTTTTGGTGCTTGGTCTGGAATAGTTGGGACAGCACTAAGTTTGTTAATTCGAGTGGAGCTAGGGCAACCGGGCTCTTTTATTGGGGACGATCAAATTTATAATGTGGTAGTAACTGCTCACGCTTTCATTATAATTTTCTTTATAGTTATGCCTATTTTGATTGGTGGATTTGGAAATTGGCTTGTGCCTTTGATATTAGGTGCTCCCGATATGGCTTTTCCTCGTTTAAATAATATGAGTTTTTGACTTCTTCCTCCTGCATTAATTTTATTACTCTCAGGAGCCGGAGTTGAAAGAGGGGCAGGAACCGGATGAACAGTATATCCGCCCCTATCAGCTGGGATCGCCCATGCTGGAGCCTCTGTTGACTTGAGAATCTTTTCTCTTCATTTAGCCGGGATTTCTTCAATTTTAGGGGCTATTAATTTTATTACAACCATTATTAATATACGGGTTCAAGGTATAACTTTGGATCGAATTCCTCTGTTCGTATGAGCAGTTGGAATTACAGCTTTATTATTGCTCTTATCTCTACCTGTTCTTGCAGGAGCGATTACTATGTTACTAACTGATCGAAATTTAAACACTTCTTTTTTTGATCCTGCTGGAGGTGGGGACCCAATTTTATATCAACACCTATTTTGATTTTTCGGACACCCTGAAGTTTACATTTTAATTCTACCAGGCTTTGGTATAATTTCTCATATTATTAGCCAAGAAAGAGGTAAGAAGGAGTCTTTTGGTACCCTGGGAATAATTTACGCAATGCTAGCCATCGGGATTTTAGGATTTGTAGTATGGGCCCATCATATGTTTACAGTTGGTATGGATGTGGATACTCGAGCTTACTTTACTGCGGCAACAATGATTATTGCTGTTCCTACTGGAATTAAGATTTTTAGATGATTAGGGACTTTGCATGGAA | GBCB914-10   |
| GGGACTCTTTACTTAATTTTTGGTGCCTGGTCTGGAATAGTTGGAACTGCACTAAGCTTGTTAATTCGAGTGGAGCTAGGGCAACCGGGCTCTTTTATTGGGGATGACCAAATTTATAATGTGGTAGTAACTGCTCACGCTTTTATTATAATTTTTTTTATAGTTATGCCTATTTTGATTGGTGGTTTTGGGAACTGGCTTGTGCCTTTGATATTAGGTGCACCCGATATAGCTTTTCCTCGCTTAAATAATATGAGTTTTTGACTTCTTCCTCCCGCATTAATTTTATTACTTTCAGGAGCCGGAGTTGAAAGAGGGGCAGGAACTGGATGAACAGTATACCCACCTCTATCGGCCGGGATCGCTCACGCCGGAGCCTCTGTTGATTTGAGAATTTTTTCTCTTCATTTAGCTGGGATTTCTTCAATTTTAGGGGCCATTAATTTTATTACAACCATTATTAATATACGGGTTCAAGGTATAACTTTGGATCGAATTCCTCTGTTTGTATGAGCAGTCGGAATTACAGCTTTATTATTGCTCTTATCTCTACCTGTCCTTGCAGGAGCGATTACTATGTTATTAACTGATCGAAATTTAAACACTTCTTTTTTTGACCCTGCTGGAGGGGGAGATCCTATTTTATATCAACATCTATTTTGATTTTTCGGGCACCCTGAAGTTTATATTTTAATTTTGCCAGGCTTTGGTATAATTTCTCATATTATTAGCCAAGAAAGAGGTAAGAAGGAGTCTTTTGGTACCTTAGGAATAATTTATGCAATGCTAGCTATTGGGATTCTAGGATTTGTAGTATGGGCCCACCATATGTTTACAGTTGGTATGGATGTGGATACTCGAGCTTACTTCACTGCGGCAACAATGATTATTGCTGTTCCTACTGGAATTAAGATTTTCAGATGATTAGGGACTTTGCACGGAA | GBCB913-10   |
| GGGACTCTTTACTTAATTTTTGGTGCTTGATCTGGTATGGTTGGAACAGCCTTAAGCTTGTTAATTCGAGTTGAGTTAGGACAACCTGGCTCTTTTATTGGTGATGATCAGATTTATAATGTGGTAGTTACCGCCCATGCTTTCATCATAATTTTTTTTATGGTTATACCTATCTTGATTGGGGGGTTTGGGAATTGATTGGTCCCTTTAATATTAGGTGCCCCCGACATGGCTTTTCCTCGTTTAAATAATATGAGTTTTTGACTCTTGCCCCCTGCATTGATTTTATTGCTTTCAGGGGCTGGAGTAGAGAGAGGAGCGGGGACTGGTTGAACAGTTTATCCTCCTTTATCGGCCGGAATTGCTCACGCTGGGGCATCTGTTGATTTGAGAATTTTTTCTCTTCATCTAGCCGGGATTTCTTCAATCTTAGGAGCAATTAATTTTATTACCACTATTATTAATATGCGAGTCCAAGGTATAACTTTGGATCGAATTCCTCTCTTTGTGTGAGCGGTTGGGATTACTGCTTTGTTGTTGCTTTTATCTTTACCTGTACTCGCAGGAGCGATTACAATATTATTAACTGATCGTAACCTGAATACTTCTTTCTTTGACCCTGCTGGGGGAGGAGATCCTATTTTATATCAACATTTATTTTGATTTTTTGGCCATCCTGAGGTTTACATTTTAATTTTACCTGGGTTTGGTATGATTTCCCACATTATTAGCCAAGAGAGCGGTAAGAAGGAGTCCTTTGGGACTTTAGGAATGATTTACGCTATACTAGCCATTGGAATCTTAGGATTTGTGGTGTGAGCTCATCATATATTTACAGTTGGTATGGATGTCGATACTCGAGCCTATTTTACCGCAGCAACAATAATTATTGCTGTGCCTACTGGGATCAAGATTTTTAGATGGTTAGGGACTTTACATGGGA | GBCB910-10   |
| ————TTGATTTTTGGTGCCTGGTCCGGAATAGTTGGGACAGCATTGAGATTATTAATCCGAGTGGAGCTGGGACAACCTGGCTCTTTCATTGGCGATGATCAGATTTATAACGTAGTGGTTACTGCCCATGCCTTTATTATAATTTTTTTTATGGTCATGCCTATTTTGATTGGTGGATTTGGAAACTGACTCGTACCTTTAATGTTAGGTGCTCCTGACATGGCTTTCCCCCGTTTAAATAATATGAGCTTTTGACTTTTACCTCCTGCATTAATTTTATTGCTTTCGGGAGCTGGTGTTGAAAGAGGGGCAGGAACTGGTTGAACAGTTTACCCTCCTCTGTCAGCTGGTATTGCTCACGCCGGGGCTTCTGTCGATTTGAGCATTTTTTCTCTCCATTTAGCCGGGGTCTCTTCAATTTTAGGGGCTATTAATTTCATTACAACGATTATTAATATACGGGTTCAAGGTATGACTTTGGATCGAATTCCTCTATTTGTTTGAGCTGTGGGAATTACTGCTTTATTACTACTCTTGTCATTACCTGTTCTTGCCGGGGCAATTACAATGCTATTAACTGACCGTAATTTGAATACTTCCTTTTTTGATCCTGCTGGGGGAGGAGACCCTATTTTATATCAACATTTATTTTGATTCTTCGGACATCCCGAGGTTTACATTTTAATTCTGCCAGGGTTTGGTATGATTTCGCATATTATTAGTCAAGAAAGAGGTAAAAAGGAGTCTTTTGGAACTTTAGGGATAATTTATGCTATATTAGCTATTGGAATTCTAGGGTTTGTAGTC——————————————————————————————————————————-                                                                                             | GBCB265-07   |

### 6.bold.analyze.tree

This function uses the modified BCDM dataframe obtained from the
`bold.analyze.align` to generate a distance matrix, a Neighbor Joining
(NJ) tree visualization and a newick tree output. This function acts as
a wrapper around the `dist.dna` and `plot.phylo` functions from `ape`.
Additional arguments can be passed to the `dist.dna` function using the
`...` argument. Newick trees can be exported optionally.

``` r

data.4.analysis.ids<-bold.public.search(taxonomy = "Eulimnadia")
 
data.4.seqanalysis<-bold.fetch(param.data = data.4.analysis.ids,
                               query.param = 'processid',
                               param.index = 1,
                               api_key = api.key,
                               filt.marker = "COI-5P")

data.seq.align<-BOLDconnectR:::bold.analyze.align(data.4.seqanalysis,seq.name.fields = c("bin_uri","species"))
#> using Gonnet

data.seq.analyze<-bold.analyze.tree(data.seq.align,
                                             dist.model = "K80",
                                             dist.matrix = TRUE,
                                             clus.method="njs",
                                             tree.plot=TRUE,
                                             tree.plot.type = "p")
```

<img src="man/figures/README-analyze.seq-1.png" width="100%" style="display: block; margin: auto;" />

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
# Fetch the data
BCDMdata<-bold.fetch(param.data = test.data,query.param = "processid",param.index = 1,api_key = api.key)

#1. Analyze richness data
res.rich<-bold.analyze.diversity(BCDMdata,taxon.rank="species",site.cat='country.ocean',richness.res=TRUE)
#>   |                                                                              |                                                                      |   0%  |                                                                              |=                                                                     |   1%  |                                                                              |=                                                                     |   2%  |                                                                              |==                                                                    |   3%  |                                                                              |===                                                                   |   4%  |                                                                              |====                                                                  |   5%  |                                                                              |====                                                                  |   6%  |                                                                              |=====                                                                 |   7%  |                                                                              |======                                                                |   8%  |                                                                              |======                                                                |   9%  |                                                                              |=======                                                               |  10%  |                                                                              |========                                                              |  11%  |                                                                              |========                                                              |  12%  |                                                                              |=========                                                             |  13%  |                                                                              |==========                                                            |  14%  |                                                                              |==========                                                            |  15%  |                                                                              |===========                                                           |  16%  |                                                                              |============                                                          |  17%  |                                                                              |=============                                                         |  18%  |                                                                              |=============                                                         |  19%  |                                                                              |==============                                                        |  20%  |                                                                              |===============                                                       |  21%  |                                                                              |===============                                                       |  22%  |                                                                              |================                                                      |  23%  |                                                                              |=================                                                     |  24%  |                                                                              |==================                                                    |  25%  |                                                                              |==================                                                    |  26%  |                                                                              |===================                                                   |  27%  |                                                                              |====================                                                  |  28%  |                                                                              |====================                                                  |  29%  |                                                                              |=====================                                                 |  30%  |                                                                              |======================                                                |  31%  |                                                                              |======================                                                |  32%  |                                                                              |=======================                                               |  33%  |                                                                              |========================                                              |  34%  |                                                                              |========================                                              |  35%  |                                                                              |=========================                                             |  36%  |                                                                              |==========================                                            |  37%  |                                                                              |===========================                                           |  38%  |                                                                              |===========================                                           |  39%  |                                                                              |============================                                          |  40%  |                                                                              |=============================                                         |  41%  |                                                                              |=============================                                         |  42%  |                                                                              |==============================                                        |  43%  |                                                                              |===============================                                       |  44%  |                                                                              |================================                                      |  45%  |                                                                              |================================                                      |  46%  |                                                                              |=================================                                     |  47%  |                                                                              |==================================                                    |  48%  |                                                                              |==================================                                    |  49%  |                                                                              |===================================                                   |  50%  |                                                                              |====================================                                  |  51%  |                                                                              |====================================                                  |  52%  |                                                                              |=====================================                                 |  53%  |                                                                              |======================================                                |  54%  |                                                                              |======================================                                |  55%  |                                                                              |=======================================                               |  56%  |                                                                              |========================================                              |  57%  |                                                                              |=========================================                             |  58%  |                                                                              |=========================================                             |  59%  |                                                                              |==========================================                            |  60%  |                                                                              |===========================================                           |  61%  |                                                                              |===========================================                           |  62%  |                                                                              |============================================                          |  63%  |                                                                              |=============================================                         |  64%  |                                                                              |==============================================                        |  65%  |                                                                              |==============================================                        |  66%  |                                                                              |===============================================                       |  67%  |                                                                              |================================================                      |  68%  |                                                                              |================================================                      |  69%  |                                                                              |=================================================                     |  70%  |                                                                              |==================================================                    |  71%  |                                                                              |==================================================                    |  72%  |                                                                              |===================================================                   |  73%  |                                                                              |====================================================                  |  74%  |                                                                              |====================================================                  |  75%  |                                                                              |=====================================================                 |  76%  |                                                                              |======================================================                |  77%  |                                                                              |=======================================================               |  78%  |                                                                              |=======================================================               |  79%  |                                                                              |========================================================              |  80%  |                                                                              |=========================================================             |  81%  |                                                                              |=========================================================             |  82%  |                                                                              |==========================================================            |  83%  |                                                                              |===========================================================           |  84%  |                                                                              |============================================================          |  85%  |                                                                              |============================================================          |  86%  |                                                                              |=============================================================         |  87%  |                                                                              |==============================================================        |  88%  |                                                                              |==============================================================        |  89%  |                                                                              |===============================================================       |  90%  |                                                                              |================================================================      |  91%  |                                                                              |================================================================      |  92%  |                                                                              |=================================================================     |  93%  |                                                                              |==================================================================    |  94%  |                                                                              |==================================================================    |  95%  |                                                                              |===================================================================   |  96%  |                                                                              |====================================================================  |  97%  |                                                                              |===================================================================== |  98%  |                                                                              |===================================================================== |  99%  |                                                                              |======================================================================| 100%

# Community matrix (BCDM data converted to community matrix)
res.rich$comm.matrix
#>                                  Oreochromis.andersonii Oreochromis.angolensis
#> Angola                                                6                      4
#> Australia                                             0                      0
#> Bangladesh                                            0                      0
#> Botswana                                              3                      0
#> Brazil                                                0                      0
#> Canada                                                0                      0
#> China                                                 0                      0
#> Colombia                                              0                      0
#> Democratic Republic of the Congo                      0                      0
#> Egypt                                                 0                      0
#> Eswatini                                              0                      0
#> Exception - Zoological Park                           0                      0
#> French Polynesia                                      0                      0
#> Gabon                                                 0                      0
#> India                                                 0                      0
#> Indonesia                                             0                      0
#> Israel                                                0                      0
#> Italy                                                 0                      0
#> Kenya                                                 0                      0
#> Liberia                                               0                      0
#> Madagascar                                            0                      0
#> Malawi                                                0                      0
#> Malaysia                                              0                      0
#> Mexico                                                0                      0
#> Morocco                                               0                      0
#> Mozambique                                            0                      0
#> Myanmar                                               0                      0
#> Namibia                                               7                      0
#> Nigeria                                               0                      0
#> Pakistan                                              0                      0
#> Peru                                                  0                      0
#> Philippines                                           0                      0
#> Republic of the Congo                                 0                      0
#> Russia                                                0                      0
#> Singapore                                             0                      0
#> South Africa                                          0                      0
#> Sudan                                                 0                      0
#> Tanzania                                              0                      0
#> Thailand                                              0                      0
#> Uganda                                                0                      0
#> United Kingdom                                        0                      0
#> United States                                         0                      0
#> Vietnam                                               0                      0
#> Zambia                                                1                      0
#> Zimbabwe                                              0                      0
#>                                  Oreochromis.aureus Oreochromis.esculentus
#> Angola                                            0                      0
#> Australia                                         0                      0
#> Bangladesh                                        0                      0
#> Botswana                                          0                      0
#> Brazil                                            0                      0
#> Canada                                            0                      0
#> China                                             0                      0
#> Colombia                                          1                      0
#> Democratic Republic of the Congo                  0                      0
#> Egypt                                             3                      0
#> Eswatini                                          0                      0
#> Exception - Zoological Park                       0                      1
#> French Polynesia                                  0                      0
#> Gabon                                             0                      0
#> India                                             0                      0
#> Indonesia                                         1                      0
#> Israel                                           46                      0
#> Italy                                             0                      0
#> Kenya                                             0                      1
#> Liberia                                           0                      0
#> Madagascar                                        2                      0
#> Malawi                                            0                      0
#> Malaysia                                          0                      0
#> Mexico                                            3                      0
#> Morocco                                           2                      0
#> Mozambique                                        0                      0
#> Myanmar                                           0                      0
#> Namibia                                           0                      0
#> Nigeria                                           6                      0
#> Pakistan                                          2                      0
#> Peru                                              0                      0
#> Philippines                                       4                      0
#> Republic of the Congo                             0                      0
#> Russia                                            4                      0
#> Singapore                                         0                      0
#> South Africa                                     11                      0
#> Sudan                                             0                      0
#> Tanzania                                          0                      0
#> Thailand                                          0                      0
#> Uganda                                            0                      0
#> United Kingdom                                    0                      0
#> United States                                     1                      0
#> Vietnam                                           0                      0
#> Zambia                                            0                      0
#> Zimbabwe                                          0                      0
#>                                  Oreochromis.karongae Oreochromis.leucostictus
#> Angola                                              0                        0
#> Australia                                           0                        0
#> Bangladesh                                          0                        0
#> Botswana                                            0                        0
#> Brazil                                              0                        0
#> Canada                                              0                        0
#> China                                               0                        0
#> Colombia                                            0                        0
#> Democratic Republic of the Congo                    0                        1
#> Egypt                                               0                        0
#> Eswatini                                            0                        0
#> Exception - Zoological Park                         0                        0
#> French Polynesia                                    0                        0
#> Gabon                                               0                        0
#> India                                               0                        0
#> Indonesia                                           0                        0
#> Israel                                              0                        0
#> Italy                                               0                        0
#> Kenya                                               0                       23
#> Liberia                                             0                        0
#> Madagascar                                          0                        0
#> Malawi                                              0                        0
#> Malaysia                                            0                        0
#> Mexico                                              0                        0
#> Morocco                                             0                        0
#> Mozambique                                          1                        0
#> Myanmar                                             0                        0
#> Namibia                                             0                        0
#> Nigeria                                             0                        0
#> Pakistan                                            0                        0
#> Peru                                                0                        0
#> Philippines                                         0                        0
#> Republic of the Congo                               0                        0
#> Russia                                              0                        0
#> Singapore                                           0                        0
#> South Africa                                        0                        0
#> Sudan                                               0                        0
#> Tanzania                                            3                        0
#> Thailand                                            0                        0
#> Uganda                                              0                       98
#> United Kingdom                                      0                        0
#> United States                                       0                        0
#> Vietnam                                             0                        0
#> Zambia                                              0                        0
#> Zimbabwe                                            0                        0
#>                                  Oreochromis.macrochir Oreochromis.mortimeri
#> Angola                                               2                     0
#> Australia                                            0                     0
#> Bangladesh                                           0                     0
#> Botswana                                             0                     0
#> Brazil                                               0                     0
#> Canada                                               0                     0
#> China                                                0                     0
#> Colombia                                             0                     0
#> Democratic Republic of the Congo                     0                     1
#> Egypt                                                0                     0
#> Eswatini                                             5                     0
#> Exception - Zoological Park                          0                     0
#> French Polynesia                                     0                     0
#> Gabon                                                1                     0
#> India                                                0                     0
#> Indonesia                                            0                     0
#> Israel                                               0                     0
#> Italy                                                0                     0
#> Kenya                                                0                     0
#> Liberia                                              0                     0
#> Madagascar                                          37                     0
#> Malawi                                               0                     0
#> Malaysia                                             0                     0
#> Mexico                                               0                     0
#> Morocco                                              0                     0
#> Mozambique                                           0                     1
#> Myanmar                                              0                     0
#> Namibia                                             14                     0
#> Nigeria                                              0                     0
#> Pakistan                                             0                     0
#> Peru                                                 0                     0
#> Philippines                                          0                     0
#> Republic of the Congo                                0                     0
#> Russia                                               0                     0
#> Singapore                                            0                     0
#> South Africa                                         0                     0
#> Sudan                                                0                     0
#> Tanzania                                             0                     0
#> Thailand                                             0                     0
#> Uganda                                               0                     0
#> United Kingdom                                       0                     0
#> United States                                        0                     0
#> Vietnam                                              0                     0
#> Zambia                                               1                     2
#> Zimbabwe                                             0                     1
#>                                  Oreochromis.mossambicus
#> Angola                                                 0
#> Australia                                              8
#> Bangladesh                                             0
#> Botswana                                               1
#> Brazil                                                 0
#> Canada                                                 1
#> China                                                  2
#> Colombia                                               5
#> Democratic Republic of the Congo                       0
#> Egypt                                                  1
#> Eswatini                                               5
#> Exception - Zoological Park                            0
#> French Polynesia                                       2
#> Gabon                                                  0
#> India                                                 30
#> Indonesia                                             16
#> Israel                                                 0
#> Italy                                                  0
#> Kenya                                                  0
#> Liberia                                                0
#> Madagascar                                            15
#> Malawi                                                 0
#> Malaysia                                               5
#> Mexico                                                 2
#> Morocco                                                0
#> Mozambique                                            21
#> Myanmar                                                0
#> Namibia                                                4
#> Nigeria                                                0
#> Pakistan                                              10
#> Peru                                                   0
#> Philippines                                           18
#> Republic of the Congo                                  0
#> Russia                                                 0
#> Singapore                                              0
#> South Africa                                          48
#> Sudan                                                  0
#> Tanzania                                               0
#> Thailand                                               3
#> Uganda                                                 0
#> United Kingdom                                         0
#> United States                                          0
#> Vietnam                                                0
#> Zambia                                                 0
#> Zimbabwe                                               6
#>                                  Oreochromis.mossambicus.x.Oreochromis.niloticus
#> Angola                                                                         0
#> Australia                                                                      0
#> Bangladesh                                                                     0
#> Botswana                                                                       0
#> Brazil                                                                         0
#> Canada                                                                         0
#> China                                                                          0
#> Colombia                                                                       0
#> Democratic Republic of the Congo                                               0
#> Egypt                                                                          0
#> Eswatini                                                                       0
#> Exception - Zoological Park                                                    0
#> French Polynesia                                                               0
#> Gabon                                                                          0
#> India                                                                          0
#> Indonesia                                                                      0
#> Israel                                                                         0
#> Italy                                                                          0
#> Kenya                                                                          0
#> Liberia                                                                        0
#> Madagascar                                                                     0
#> Malawi                                                                         0
#> Malaysia                                                                       0
#> Mexico                                                                         0
#> Morocco                                                                        0
#> Mozambique                                                                     0
#> Myanmar                                                                        0
#> Namibia                                                                        0
#> Nigeria                                                                        0
#> Pakistan                                                                       0
#> Peru                                                                           0
#> Philippines                                                                    0
#> Republic of the Congo                                                          0
#> Russia                                                                         0
#> Singapore                                                                      0
#> South Africa                                                                   6
#> Sudan                                                                          0
#> Tanzania                                                                       0
#> Thailand                                                                       0
#> Uganda                                                                         0
#> United Kingdom                                                                 0
#> United States                                                                  0
#> Vietnam                                                                        0
#> Zambia                                                                         0
#> Zimbabwe                                                                       0
#>                                  Oreochromis.niloticus Oreochromis.placidus
#> Angola                                               0                    0
#> Australia                                            0                    0
#> Bangladesh                                           1                    0
#> Botswana                                             0                    0
#> Brazil                                              29                    0
#> Canada                                               5                    0
#> China                                                3                    0
#> Colombia                                            32                    0
#> Democratic Republic of the Congo                    13                    0
#> Egypt                                              138                    0
#> Eswatini                                             0                    0
#> Exception - Zoological Park                          0                    0
#> French Polynesia                                     0                    0
#> Gabon                                                0                    0
#> India                                               18                    0
#> Indonesia                                           16                    0
#> Israel                                              15                    0
#> Italy                                                2                    0
#> Kenya                                               38                    0
#> Liberia                                              3                    0
#> Madagascar                                         214                    0
#> Malawi                                               0                    0
#> Malaysia                                             2                    0
#> Mexico                                              27                    0
#> Morocco                                              0                    0
#> Mozambique                                           6                    6
#> Myanmar                                             19                    0
#> Namibia                                              1                    0
#> Nigeria                                             25                    0
#> Pakistan                                             0                    0
#> Peru                                                 0                    0
#> Philippines                                         51                    0
#> Republic of the Congo                                0                    0
#> Russia                                               0                    0
#> Singapore                                            5                    0
#> South Africa                                         7                    0
#> Sudan                                                6                    0
#> Tanzania                                             0                    0
#> Thailand                                            13                    0
#> Uganda                                              96                    0
#> United Kingdom                                       0                    0
#> United States                                       65                    0
#> Vietnam                                              1                    0
#> Zambia                                               4                    0
#> Zimbabwe                                             0                    0
#>                                  Oreochromis.schwebischi Oreochromis.shiranus
#> Angola                                                 0                    0
#> Australia                                              0                    0
#> Bangladesh                                             0                    0
#> Botswana                                               0                    0
#> Brazil                                                 0                    0
#> Canada                                                 0                    0
#> China                                                  0                    0
#> Colombia                                               0                    0
#> Democratic Republic of the Congo                       0                    0
#> Egypt                                                  0                    0
#> Eswatini                                               0                    0
#> Exception - Zoological Park                            0                    0
#> French Polynesia                                       0                    0
#> Gabon                                                  2                    0
#> India                                                  0                    0
#> Indonesia                                              0                    0
#> Israel                                                 0                    0
#> Italy                                                  0                    0
#> Kenya                                                  0                    0
#> Liberia                                                0                    0
#> Madagascar                                             0                    0
#> Malawi                                                 0                    3
#> Malaysia                                               0                    0
#> Mexico                                                 0                    0
#> Morocco                                                0                    0
#> Mozambique                                             0                    0
#> Myanmar                                                0                    0
#> Namibia                                                0                    0
#> Nigeria                                                0                    0
#> Pakistan                                               0                    0
#> Peru                                                   0                    0
#> Philippines                                            0                    0
#> Republic of the Congo                                  3                    0
#> Russia                                                 0                    0
#> Singapore                                              0                    0
#> South Africa                                           0                    0
#> Sudan                                                  0                    0
#> Tanzania                                               0                    0
#> Thailand                                               0                    0
#> Uganda                                                 0                    0
#> United Kingdom                                         0                    0
#> United States                                          0                    0
#> Vietnam                                                0                    0
#> Zambia                                                 0                    0
#> Zimbabwe                                               0                    0
#>                                  Oreochromis.sp. Oreochromis.sp..1.MV.2022
#> Angola                                         3                         0
#> Australia                                      2                         0
#> Bangladesh                                     0                         0
#> Botswana                                       0                         0
#> Brazil                                         0                         0
#> Canada                                         1                         0
#> China                                          1                         0
#> Colombia                                       0                         0
#> Democratic Republic of the Congo               0                         0
#> Egypt                                          0                         0
#> Eswatini                                       0                         0
#> Exception - Zoological Park                    0                         0
#> French Polynesia                               0                         0
#> Gabon                                          0                         0
#> India                                          0                         0
#> Indonesia                                      0                         0
#> Israel                                         0                         0
#> Italy                                          0                         0
#> Kenya                                          3                         0
#> Liberia                                        0                         0
#> Madagascar                                     0                        13
#> Malawi                                         0                         0
#> Malaysia                                       0                         0
#> Mexico                                         0                         0
#> Morocco                                        0                         0
#> Mozambique                                     2                         0
#> Myanmar                                        0                         0
#> Namibia                                        0                         0
#> Nigeria                                        0                         0
#> Pakistan                                       0                         0
#> Peru                                           0                         0
#> Philippines                                    0                         0
#> Republic of the Congo                          0                         0
#> Russia                                         0                         0
#> Singapore                                      0                         0
#> South Africa                                   0                         0
#> Sudan                                          0                         0
#> Tanzania                                       0                         0
#> Thailand                                       0                         0
#> Uganda                                         0                         0
#> United Kingdom                                 0                         0
#> United States                                  0                         0
#> Vietnam                                        0                         0
#> Zambia                                         0                         0
#> Zimbabwe                                       0                         0
#>                                  Oreochromis.sp..BM4 Oreochromis.sp..BM6
#> Angola                                             0                   0
#> Australia                                          0                   0
#> Bangladesh                                         0                   0
#> Botswana                                           0                   0
#> Brazil                                             0                   0
#> Canada                                             0                   0
#> China                                              0                   0
#> Colombia                                           0                   0
#> Democratic Republic of the Congo                   0                   0
#> Egypt                                              0                   0
#> Eswatini                                           0                   0
#> Exception - Zoological Park                        0                   0
#> French Polynesia                                   0                   0
#> Gabon                                              0                   0
#> India                                              0                   0
#> Indonesia                                          0                   0
#> Israel                                             0                   0
#> Italy                                              0                   0
#> Kenya                                              0                   0
#> Liberia                                            0                   0
#> Madagascar                                         0                   0
#> Malawi                                             0                   0
#> Malaysia                                           0                   0
#> Mexico                                             0                   0
#> Morocco                                            0                   0
#> Mozambique                                         0                   0
#> Myanmar                                            0                   0
#> Namibia                                            0                   0
#> Nigeria                                            0                   0
#> Pakistan                                           0                   0
#> Peru                                               0                   0
#> Philippines                                        0                   0
#> Republic of the Congo                              0                   0
#> Russia                                             0                   0
#> Singapore                                          0                   0
#> South Africa                                       0                   0
#> Sudan                                              0                   0
#> Tanzania                                           0                   0
#> Thailand                                           0                   0
#> Uganda                                             0                   0
#> United Kingdom                                     1                   1
#> United States                                      0                   0
#> Vietnam                                            0                   0
#> Zambia                                             0                   0
#> Zimbabwe                                           0                   0
#>                                  Oreochromis.sp..LMN.2018 Oreochromis.sp..MM14
#> Angola                                                  0                    0
#> Australia                                               0                    0
#> Bangladesh                                              0                    0
#> Botswana                                                0                    0
#> Brazil                                                  0                    0
#> Canada                                                  0                    0
#> China                                                   0                    0
#> Colombia                                                0                    0
#> Democratic Republic of the Congo                        0                    0
#> Egypt                                                   0                    0
#> Eswatini                                                0                    0
#> Exception - Zoological Park                             0                    0
#> French Polynesia                                        0                    0
#> Gabon                                                   0                    0
#> India                                                   0                    0
#> Indonesia                                               0                    0
#> Israel                                                  0                    0
#> Italy                                                   0                    0
#> Kenya                                                   0                    0
#> Liberia                                                 0                    0
#> Madagascar                                              0                    0
#> Malawi                                                  0                    0
#> Malaysia                                                0                    0
#> Mexico                                                  0                    0
#> Morocco                                                 0                    0
#> Mozambique                                              0                    0
#> Myanmar                                                 0                    0
#> Namibia                                                 0                    0
#> Nigeria                                                 3                    0
#> Pakistan                                                0                    0
#> Peru                                                    0                    0
#> Philippines                                             0                    0
#> Republic of the Congo                                   0                    0
#> Russia                                                  0                    0
#> Singapore                                               0                    0
#> South Africa                                            0                    0
#> Sudan                                                   0                    0
#> Tanzania                                                0                    0
#> Thailand                                                0                    0
#> Uganda                                                  0                    0
#> United Kingdom                                          0                    1
#> United States                                           0                    0
#> Vietnam                                                 0                    0
#> Zambia                                                  0                    0
#> Zimbabwe                                                0                    0
#>                                  Oreochromis.sp..MM3 Oreochromis.sp..MYS.shop.1
#> Angola                                             0                          0
#> Australia                                          0                          0
#> Bangladesh                                         0                          0
#> Botswana                                           0                          0
#> Brazil                                             0                          0
#> Canada                                             0                          0
#> China                                              0                          0
#> Colombia                                           0                          0
#> Democratic Republic of the Congo                   0                          0
#> Egypt                                              0                          0
#> Eswatini                                           0                          0
#> Exception - Zoological Park                        0                          0
#> French Polynesia                                   0                          0
#> Gabon                                              0                          0
#> India                                              0                          0
#> Indonesia                                          0                          0
#> Israel                                             0                          0
#> Italy                                              0                          0
#> Kenya                                              0                          0
#> Liberia                                            0                          0
#> Madagascar                                         0                          0
#> Malawi                                             0                          0
#> Malaysia                                           0                          0
#> Mexico                                             0                          0
#> Morocco                                            0                          0
#> Mozambique                                         0                          0
#> Myanmar                                            0                          0
#> Namibia                                            0                          0
#> Nigeria                                            0                          0
#> Pakistan                                           0                          0
#> Peru                                               0                          0
#> Philippines                                        0                          0
#> Republic of the Congo                              0                          0
#> Russia                                             0                          1
#> Singapore                                          0                          0
#> South Africa                                       0                          0
#> Sudan                                              0                          0
#> Tanzania                                           0                          0
#> Thailand                                           0                          0
#> Uganda                                             0                          0
#> United Kingdom                                     1                          0
#> United States                                      0                          0
#> Vietnam                                            0                          0
#> Zambia                                             0                          0
#> Zimbabwe                                           0                          0
#>                                  Oreochromis.sp..SAIAB.86542
#> Angola                                                     0
#> Australia                                                  0
#> Bangladesh                                                 0
#> Botswana                                                   0
#> Brazil                                                     0
#> Canada                                                     0
#> China                                                      0
#> Colombia                                                   0
#> Democratic Republic of the Congo                           0
#> Egypt                                                      0
#> Eswatini                                                   0
#> Exception - Zoological Park                                0
#> French Polynesia                                           0
#> Gabon                                                      0
#> India                                                      0
#> Indonesia                                                  0
#> Israel                                                     0
#> Italy                                                      0
#> Kenya                                                      0
#> Liberia                                                    0
#> Madagascar                                                 0
#> Malawi                                                     0
#> Malaysia                                                   0
#> Mexico                                                     0
#> Morocco                                                    0
#> Mozambique                                                 1
#> Myanmar                                                    0
#> Namibia                                                    0
#> Nigeria                                                    0
#> Pakistan                                                   0
#> Peru                                                       0
#> Philippines                                                0
#> Republic of the Congo                                      0
#> Russia                                                     0
#> Singapore                                                  0
#> South Africa                                               0
#> Sudan                                                      0
#> Tanzania                                                   0
#> Thailand                                                   0
#> Uganda                                                     0
#> United Kingdom                                             0
#> United States                                              0
#> Vietnam                                                    0
#> Zambia                                                     0
#> Zimbabwe                                                   0
#>                                  Oreochromis.sp..SAIAB.86900
#> Angola                                                     0
#> Australia                                                  0
#> Bangladesh                                                 0
#> Botswana                                                   0
#> Brazil                                                     0
#> Canada                                                     0
#> China                                                      0
#> Colombia                                                   0
#> Democratic Republic of the Congo                           0
#> Egypt                                                      0
#> Eswatini                                                   0
#> Exception - Zoological Park                                0
#> French Polynesia                                           0
#> Gabon                                                      0
#> India                                                      0
#> Indonesia                                                  0
#> Israel                                                     0
#> Italy                                                      0
#> Kenya                                                      0
#> Liberia                                                    0
#> Madagascar                                                 0
#> Malawi                                                     0
#> Malaysia                                                   0
#> Mexico                                                     0
#> Morocco                                                    0
#> Mozambique                                                 1
#> Myanmar                                                    0
#> Namibia                                                    0
#> Nigeria                                                    0
#> Pakistan                                                   0
#> Peru                                                       0
#> Philippines                                                0
#> Republic of the Congo                                      0
#> Russia                                                     0
#> Singapore                                                  0
#> South Africa                                               0
#> Sudan                                                      0
#> Tanzania                                                   0
#> Thailand                                                   0
#> Uganda                                                     0
#> United Kingdom                                             0
#> United States                                              0
#> Vietnam                                                    0
#> Zambia                                                     0
#> Zimbabwe                                                   0
#>                                  Oreochromis.sp..SAIAB.87154
#> Angola                                                     0
#> Australia                                                  0
#> Bangladesh                                                 0
#> Botswana                                                   0
#> Brazil                                                     0
#> Canada                                                     0
#> China                                                      0
#> Colombia                                                   0
#> Democratic Republic of the Congo                           0
#> Egypt                                                      0
#> Eswatini                                                   0
#> Exception - Zoological Park                                0
#> French Polynesia                                           0
#> Gabon                                                      0
#> India                                                      0
#> Indonesia                                                  0
#> Israel                                                     0
#> Italy                                                      0
#> Kenya                                                      0
#> Liberia                                                    0
#> Madagascar                                                 0
#> Malawi                                                     0
#> Malaysia                                                   0
#> Mexico                                                     0
#> Morocco                                                    0
#> Mozambique                                                 1
#> Myanmar                                                    0
#> Namibia                                                    0
#> Nigeria                                                    0
#> Pakistan                                                   0
#> Peru                                                       0
#> Philippines                                                0
#> Republic of the Congo                                      0
#> Russia                                                     0
#> Singapore                                                  0
#> South Africa                                               0
#> Sudan                                                      0
#> Tanzania                                                   0
#> Thailand                                                   0
#> Uganda                                                     0
#> United Kingdom                                             0
#> United States                                              0
#> Vietnam                                                    0
#> Zambia                                                     0
#> Zimbabwe                                                   0
#>                                  Oreochromis.sp..SF88 Oreochromis.sp..SF89
#> Angola                                              0                    0
#> Australia                                           0                    0
#> Bangladesh                                          0                    0
#> Botswana                                            0                    0
#> Brazil                                              0                    0
#> Canada                                              0                    0
#> China                                               0                    0
#> Colombia                                            0                    0
#> Democratic Republic of the Congo                    0                    0
#> Egypt                                               0                    0
#> Eswatini                                            0                    0
#> Exception - Zoological Park                         0                    0
#> French Polynesia                                    0                    0
#> Gabon                                               0                    0
#> India                                               0                    0
#> Indonesia                                           0                    0
#> Israel                                              0                    0
#> Italy                                               0                    0
#> Kenya                                               0                    0
#> Liberia                                             0                    0
#> Madagascar                                          0                    0
#> Malawi                                              0                    0
#> Malaysia                                            0                    0
#> Mexico                                              0                    0
#> Morocco                                             0                    0
#> Mozambique                                          0                    0
#> Myanmar                                             0                    0
#> Namibia                                             0                    0
#> Nigeria                                             0                    0
#> Pakistan                                            0                    0
#> Peru                                                1                    1
#> Philippines                                         0                    0
#> Republic of the Congo                               0                    0
#> Russia                                              0                    0
#> Singapore                                           0                    0
#> South Africa                                        0                    0
#> Sudan                                               0                    0
#> Tanzania                                            0                    0
#> Thailand                                            0                    0
#> Uganda                                              0                    0
#> United Kingdom                                      0                    0
#> United States                                       0                    0
#> Vietnam                                             0                    0
#> Zambia                                              0                    0
#> Zimbabwe                                            0                    0
#>                                  Oreochromis.sp..TP Oreochromis.sp..VM5
#> Angola                                            0                   0
#> Australia                                         1                   0
#> Bangladesh                                        0                   0
#> Botswana                                          0                   0
#> Brazil                                            0                   0
#> Canada                                            0                   0
#> China                                             0                   0
#> Colombia                                          0                   0
#> Democratic Republic of the Congo                  0                   0
#> Egypt                                             0                   0
#> Eswatini                                          0                   0
#> Exception - Zoological Park                       0                   0
#> French Polynesia                                  0                   0
#> Gabon                                             0                   0
#> India                                             0                   0
#> Indonesia                                         0                   0
#> Israel                                            0                   0
#> Italy                                             0                   0
#> Kenya                                             0                   0
#> Liberia                                           0                   0
#> Madagascar                                        0                   0
#> Malawi                                            0                   0
#> Malaysia                                          0                   0
#> Mexico                                            0                   0
#> Morocco                                           0                   0
#> Mozambique                                        0                   0
#> Myanmar                                           0                   0
#> Namibia                                           0                   0
#> Nigeria                                           0                   0
#> Pakistan                                          0                   0
#> Peru                                              0                   0
#> Philippines                                       0                   0
#> Republic of the Congo                             0                   0
#> Russia                                            0                   0
#> Singapore                                         0                   0
#> South Africa                                      0                   0
#> Sudan                                             0                   0
#> Tanzania                                          0                   0
#> Thailand                                          0                   0
#> Uganda                                            0                   0
#> United Kingdom                                    0                   1
#> United States                                     0                   0
#> Vietnam                                           0                   0
#> Zambia                                            0                   0
#> Zimbabwe                                          0                   0
#>                                  Oreochromis.spilurus Oreochromis.tanganicae
#> Angola                                              0                      0
#> Australia                                           0                      0
#> Bangladesh                                          0                      0
#> Botswana                                            0                      0
#> Brazil                                              0                      0
#> Canada                                              0                      0
#> China                                               0                      0
#> Colombia                                            0                      0
#> Democratic Republic of the Congo                    0                      0
#> Egypt                                               0                      0
#> Eswatini                                            0                      0
#> Exception - Zoological Park                         0                      0
#> French Polynesia                                    0                      0
#> Gabon                                               0                      0
#> India                                               0                      0
#> Indonesia                                           0                      0
#> Israel                                              0                      0
#> Italy                                               0                      0
#> Kenya                                              26                      0
#> Liberia                                             0                      0
#> Madagascar                                          0                      0
#> Malawi                                              0                      0
#> Malaysia                                            0                      0
#> Mexico                                              0                      0
#> Morocco                                             0                      0
#> Mozambique                                          0                      0
#> Myanmar                                             0                      0
#> Namibia                                             0                      0
#> Nigeria                                             0                      0
#> Pakistan                                            0                      0
#> Peru                                                0                      0
#> Philippines                                         0                      0
#> Republic of the Congo                               0                      0
#> Russia                                              0                      0
#> Singapore                                           0                      0
#> South Africa                                        0                      0
#> Sudan                                               0                      0
#> Tanzania                                            0                      1
#> Thailand                                            0                      0
#> Uganda                                              0                      0
#> United Kingdom                                      0                      0
#> United States                                       0                      0
#> Vietnam                                             0                      0
#> Zambia                                              0                      2
#> Zimbabwe                                            0                      0
#>                                  Oreochromis.urolepis Oreochromis.variabilis
#> Angola                                              0                      0
#> Australia                                           0                      0
#> Bangladesh                                          0                      0
#> Botswana                                            0                      0
#> Brazil                                              6                      0
#> Canada                                              0                      0
#> China                                               0                      0
#> Colombia                                            1                      0
#> Democratic Republic of the Congo                    0                      0
#> Egypt                                               0                      0
#> Eswatini                                            0                      0
#> Exception - Zoological Park                         0                      0
#> French Polynesia                                    0                      0
#> Gabon                                               0                      0
#> India                                               0                      0
#> Indonesia                                           0                      0
#> Israel                                              3                      0
#> Italy                                               0                      0
#> Kenya                                               0                      1
#> Liberia                                             0                      0
#> Madagascar                                          0                      0
#> Malawi                                              0                      0
#> Malaysia                                            0                      0
#> Mexico                                              1                      0
#> Morocco                                             0                      0
#> Mozambique                                          0                      0
#> Myanmar                                             0                      0
#> Namibia                                             0                      0
#> Nigeria                                             0                      0
#> Pakistan                                            0                      0
#> Peru                                                0                      0
#> Philippines                                         2                      0
#> Republic of the Congo                               0                      0
#> Russia                                              0                      0
#> Singapore                                           0                      0
#> South Africa                                        0                      0
#> Sudan                                               0                      0
#> Tanzania                                            0                      0
#> Thailand                                            0                      0
#> Uganda                                              0                      0
#> United Kingdom                                      0                      0
#> United States                                       0                      0
#> Vietnam                                             0                      0
#> Zambia                                              0                      0
#> Zimbabwe                                            0                      0

# richness results (top 10 rows)
knitr::kable(head(res.rich$richness,10))
```

| Sampl |    Ind |   Obs |   S1 |   S2 |   Q1 |   Q2 | Jack1ab | Jack1abP | Jack1in | Jack1inP | Jack2ab | Jack2abP | Jack2in | Jack2inP | Chao1 | Chao1P | Chao2 | Chao2P |
|------:|-------:|------:|-----:|-----:|-----:|-----:|--------:|---------:|--------:|---------:|--------:|---------:|--------:|---------:|------:|-------:|------:|-------:|
|     1 |  33.29 |  2.55 | 0.87 | 0.24 | 2.55 | 0.00 |    3.42 |     4.36 |    2.55 |     5.10 |    4.05 |     5.37 |    7.65 |    15.30 |  2.95 |   3.77 |  5.83 |  11.66 |
|     2 |  67.60 |  4.47 | 1.40 | 0.44 | 3.80 | 0.67 |    5.87 |     7.07 |    6.37 |    11.40 |    6.83 |     8.45 |    6.37 |    11.40 |  5.86 |   7.36 | 10.78 |  20.15 |
|     3 |  97.38 |  5.82 | 1.81 | 0.59 | 4.41 | 1.07 |    7.63 |     8.95 |    8.76 |    14.37 |    8.85 |    10.57 |   10.05 |    16.60 |  7.65 |   9.31 | 12.93 |  22.41 |
|     4 | 133.31 |  7.07 | 2.22 | 0.69 | 4.98 | 1.26 |    9.29 |    10.75 |   10.80 |    16.65 |   10.82 |    12.68 |   12.88 |    19.98 |  9.47 |  11.22 | 14.72 |  23.86 |
|     5 | 153.58 |  8.47 | 2.84 | 0.85 | 5.95 | 1.33 |   11.31 |    13.19 |   13.23 |    20.21 |   13.30 |    15.70 |   16.20 |    24.91 | 12.00 |  14.33 | 18.84 |  30.10 |
|     6 | 187.69 |  9.46 | 3.20 | 0.93 | 6.40 | 1.45 |   12.66 |    14.66 |   14.79 |    21.94 |   14.93 |    17.46 |   18.29 |    27.24 | 13.34 |  15.71 | 19.82 |  30.40 |
|     7 | 219.88 | 10.50 | 3.59 | 0.95 | 7.05 | 1.45 |   14.09 |    16.33 |   16.54 |    24.31 |   16.73 |    19.58 |   20.72 |    30.56 | 15.41 |  18.23 | 22.56 |  33.97 |
|     8 | 260.19 | 11.72 | 4.02 | 1.01 | 7.83 | 1.64 |   15.74 |    18.19 |   18.57 |    27.26 |   18.75 |    21.85 |   23.39 |    34.49 | 17.40 |  20.55 | 26.06 |  39.06 |
|     9 | 298.43 | 12.79 | 4.56 | 1.02 | 8.48 | 1.72 |   17.35 |    20.14 |   20.33 |    29.64 |   20.89 |    24.43 |   25.75 |    37.71 | 19.56 |  23.10 | 29.71 |  44.45 |
|    10 | 337.41 | 13.48 | 4.95 | 1.03 | 8.90 | 1.60 |   18.43 |    21.50 |   21.49 |    31.22 |   22.35 |    26.24 |   27.47 |    40.07 | 21.37 |  25.37 | 32.57 |  48.60 |

### 7b. Shannon diversity

``` r
#2. Shannon diversity
res.shannon<-bold.analyze.diversity(BCDMdata,taxon.rank="species",site.cat='country.ocean',shannon.res = TRUE)

# Shannon diversity results (top 10 rows)
knitr::kable(head(res.shannon,10))
```

<table class="kable_wrapper">
<tbody>
<tr>
<td>

|                                  | Oreochromis.andersonii | Oreochromis.angolensis | Oreochromis.aureus | Oreochromis.esculentus | Oreochromis.karongae | Oreochromis.leucostictus | Oreochromis.macrochir | Oreochromis.mortimeri | Oreochromis.mossambicus | Oreochromis.mossambicus.x.Oreochromis.niloticus | Oreochromis.niloticus | Oreochromis.placidus | Oreochromis.schwebischi | Oreochromis.shiranus | Oreochromis.sp. | Oreochromis.sp..1.MV.2022 | Oreochromis.sp..BM4 | Oreochromis.sp..BM6 | Oreochromis.sp..LMN.2018 | Oreochromis.sp..MM14 | Oreochromis.sp..MM3 | Oreochromis.sp..MYS.shop.1 | Oreochromis.sp..SAIAB.86542 | Oreochromis.sp..SAIAB.86900 | Oreochromis.sp..SAIAB.87154 | Oreochromis.sp..SF88 | Oreochromis.sp..SF89 | Oreochromis.sp..TP | Oreochromis.sp..VM5 | Oreochromis.spilurus | Oreochromis.tanganicae | Oreochromis.urolepis | Oreochromis.variabilis |
|:---------------------------------|-----------------------:|-----------------------:|-------------------:|-----------------------:|---------------------:|-------------------------:|----------------------:|----------------------:|------------------------:|------------------------------------------------:|----------------------:|---------------------:|------------------------:|---------------------:|----------------:|--------------------------:|--------------------:|--------------------:|-------------------------:|---------------------:|--------------------:|---------------------------:|----------------------------:|----------------------------:|----------------------------:|---------------------:|---------------------:|-------------------:|--------------------:|---------------------:|-----------------------:|---------------------:|-----------------------:|
| Angola                           |                      6 |                      4 |                  0 |                      0 |                    0 |                        0 |                     2 |                     0 |                       0 |                                               0 |                     0 |                    0 |                       0 |                    0 |               3 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    0 |                      0 |
| Australia                        |                      0 |                      0 |                  0 |                      0 |                    0 |                        0 |                     0 |                     0 |                       8 |                                               0 |                     0 |                    0 |                       0 |                    0 |               2 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  1 |                   0 |                    0 |                      0 |                    0 |                      0 |
| Bangladesh                       |                      0 |                      0 |                  0 |                      0 |                    0 |                        0 |                     0 |                     0 |                       0 |                                               0 |                     1 |                    0 |                       0 |                    0 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    0 |                      0 |
| Botswana                         |                      3 |                      0 |                  0 |                      0 |                    0 |                        0 |                     0 |                     0 |                       1 |                                               0 |                     0 |                    0 |                       0 |                    0 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    0 |                      0 |
| Brazil                           |                      0 |                      0 |                  0 |                      0 |                    0 |                        0 |                     0 |                     0 |                       0 |                                               0 |                    29 |                    0 |                       0 |                    0 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    6 |                      0 |
| Canada                           |                      0 |                      0 |                  0 |                      0 |                    0 |                        0 |                     0 |                     0 |                       1 |                                               0 |                     5 |                    0 |                       0 |                    0 |               1 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    0 |                      0 |
| China                            |                      0 |                      0 |                  0 |                      0 |                    0 |                        0 |                     0 |                     0 |                       2 |                                               0 |                     3 |                    0 |                       0 |                    0 |               1 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    0 |                      0 |
| Colombia                         |                      0 |                      0 |                  1 |                      0 |                    0 |                        0 |                     0 |                     0 |                       5 |                                               0 |                    32 |                    0 |                       0 |                    0 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    1 |                      0 |
| Democratic Republic of the Congo |                      0 |                      0 |                  0 |                      0 |                    0 |                        1 |                     0 |                     1 |                       0 |                                               0 |                    13 |                    0 |                       0 |                    0 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    0 |                      0 |
| Egypt                            |                      0 |                      0 |                  3 |                      0 |                    0 |                        0 |                     0 |                     0 |                       1 |                                               0 |                   138 |                    0 |                       0 |                    0 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    0 |                      0 |
| Eswatini                         |                      0 |                      0 |                  0 |                      0 |                    0 |                        0 |                     5 |                     0 |                       5 |                                               0 |                     0 |                    0 |                       0 |                    0 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    0 |                      0 |
| Exception - Zoological Park      |                      0 |                      0 |                  0 |                      1 |                    0 |                        0 |                     0 |                     0 |                       0 |                                               0 |                     0 |                    0 |                       0 |                    0 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    0 |                      0 |
| French Polynesia                 |                      0 |                      0 |                  0 |                      0 |                    0 |                        0 |                     0 |                     0 |                       2 |                                               0 |                     0 |                    0 |                       0 |                    0 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    0 |                      0 |
| Gabon                            |                      0 |                      0 |                  0 |                      0 |                    0 |                        0 |                     1 |                     0 |                       0 |                                               0 |                     0 |                    0 |                       2 |                    0 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    0 |                      0 |
| India                            |                      0 |                      0 |                  0 |                      0 |                    0 |                        0 |                     0 |                     0 |                      30 |                                               0 |                    18 |                    0 |                       0 |                    0 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    0 |                      0 |
| Indonesia                        |                      0 |                      0 |                  1 |                      0 |                    0 |                        0 |                     0 |                     0 |                      16 |                                               0 |                    16 |                    0 |                       0 |                    0 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    0 |                      0 |
| Israel                           |                      0 |                      0 |                 46 |                      0 |                    0 |                        0 |                     0 |                     0 |                       0 |                                               0 |                    15 |                    0 |                       0 |                    0 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    3 |                      0 |
| Italy                            |                      0 |                      0 |                  0 |                      0 |                    0 |                        0 |                     0 |                     0 |                       0 |                                               0 |                     2 |                    0 |                       0 |                    0 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    0 |                      0 |
| Kenya                            |                      0 |                      0 |                  0 |                      1 |                    0 |                       23 |                     0 |                     0 |                       0 |                                               0 |                    38 |                    0 |                       0 |                    0 |               3 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                   26 |                      0 |                    0 |                      1 |
| Liberia                          |                      0 |                      0 |                  0 |                      0 |                    0 |                        0 |                     0 |                     0 |                       0 |                                               0 |                     3 |                    0 |                       0 |                    0 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    0 |                      0 |
| Madagascar                       |                      0 |                      0 |                  2 |                      0 |                    0 |                        0 |                    37 |                     0 |                      15 |                                               0 |                   214 |                    0 |                       0 |                    0 |               0 |                        13 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    0 |                      0 |
| Malawi                           |                      0 |                      0 |                  0 |                      0 |                    0 |                        0 |                     0 |                     0 |                       0 |                                               0 |                     0 |                    0 |                       0 |                    3 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    0 |                      0 |
| Malaysia                         |                      0 |                      0 |                  0 |                      0 |                    0 |                        0 |                     0 |                     0 |                       5 |                                               0 |                     2 |                    0 |                       0 |                    0 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    0 |                      0 |
| Mexico                           |                      0 |                      0 |                  3 |                      0 |                    0 |                        0 |                     0 |                     0 |                       2 |                                               0 |                    27 |                    0 |                       0 |                    0 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    1 |                      0 |
| Morocco                          |                      0 |                      0 |                  2 |                      0 |                    0 |                        0 |                     0 |                     0 |                       0 |                                               0 |                     0 |                    0 |                       0 |                    0 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    0 |                      0 |
| Mozambique                       |                      0 |                      0 |                  0 |                      0 |                    1 |                        0 |                     0 |                     1 |                      21 |                                               0 |                     6 |                    6 |                       0 |                    0 |               2 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           1 |                           1 |                           1 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    0 |                      0 |
| Myanmar                          |                      0 |                      0 |                  0 |                      0 |                    0 |                        0 |                     0 |                     0 |                       0 |                                               0 |                    19 |                    0 |                       0 |                    0 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    0 |                      0 |
| Namibia                          |                      7 |                      0 |                  0 |                      0 |                    0 |                        0 |                    14 |                     0 |                       4 |                                               0 |                     1 |                    0 |                       0 |                    0 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    0 |                      0 |
| Nigeria                          |                      0 |                      0 |                  6 |                      0 |                    0 |                        0 |                     0 |                     0 |                       0 |                                               0 |                    25 |                    0 |                       0 |                    0 |               0 |                         0 |                   0 |                   0 |                        3 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    0 |                      0 |
| Pakistan                         |                      0 |                      0 |                  2 |                      0 |                    0 |                        0 |                     0 |                     0 |                      10 |                                               0 |                     0 |                    0 |                       0 |                    0 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    0 |                      0 |
| Peru                             |                      0 |                      0 |                  0 |                      0 |                    0 |                        0 |                     0 |                     0 |                       0 |                                               0 |                     0 |                    0 |                       0 |                    0 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    1 |                    1 |                  0 |                   0 |                    0 |                      0 |                    0 |                      0 |
| Philippines                      |                      0 |                      0 |                  4 |                      0 |                    0 |                        0 |                     0 |                     0 |                      18 |                                               0 |                    51 |                    0 |                       0 |                    0 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    2 |                      0 |
| Republic of the Congo            |                      0 |                      0 |                  0 |                      0 |                    0 |                        0 |                     0 |                     0 |                       0 |                                               0 |                     0 |                    0 |                       3 |                    0 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    0 |                      0 |
| Russia                           |                      0 |                      0 |                  4 |                      0 |                    0 |                        0 |                     0 |                     0 |                       0 |                                               0 |                     0 |                    0 |                       0 |                    0 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          1 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    0 |                      0 |
| Singapore                        |                      0 |                      0 |                  0 |                      0 |                    0 |                        0 |                     0 |                     0 |                       0 |                                               0 |                     5 |                    0 |                       0 |                    0 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    0 |                      0 |
| South Africa                     |                      0 |                      0 |                 11 |                      0 |                    0 |                        0 |                     0 |                     0 |                      48 |                                               6 |                     7 |                    0 |                       0 |                    0 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    0 |                      0 |
| Sudan                            |                      0 |                      0 |                  0 |                      0 |                    0 |                        0 |                     0 |                     0 |                       0 |                                               0 |                     6 |                    0 |                       0 |                    0 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    0 |                      0 |
| Tanzania                         |                      0 |                      0 |                  0 |                      0 |                    3 |                        0 |                     0 |                     0 |                       0 |                                               0 |                     0 |                    0 |                       0 |                    0 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      1 |                    0 |                      0 |
| Thailand                         |                      0 |                      0 |                  0 |                      0 |                    0 |                        0 |                     0 |                     0 |                       3 |                                               0 |                    13 |                    0 |                       0 |                    0 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    0 |                      0 |
| Uganda                           |                      0 |                      0 |                  0 |                      0 |                    0 |                       98 |                     0 |                     0 |                       0 |                                               0 |                    96 |                    0 |                       0 |                    0 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    0 |                      0 |
| United Kingdom                   |                      0 |                      0 |                  0 |                      0 |                    0 |                        0 |                     0 |                     0 |                       0 |                                               0 |                     0 |                    0 |                       0 |                    0 |               0 |                         0 |                   1 |                   1 |                        0 |                    1 |                   1 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   1 |                    0 |                      0 |                    0 |                      0 |
| United States                    |                      0 |                      0 |                  1 |                      0 |                    0 |                        0 |                     0 |                     0 |                       0 |                                               0 |                    65 |                    0 |                       0 |                    0 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    0 |                      0 |
| Vietnam                          |                      0 |                      0 |                  0 |                      0 |                    0 |                        0 |                     0 |                     0 |                       0 |                                               0 |                     1 |                    0 |                       0 |                    0 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    0 |                      0 |
| Zambia                           |                      1 |                      0 |                  0 |                      0 |                    0 |                        0 |                     1 |                     2 |                       0 |                                               0 |                     4 |                    0 |                       0 |                    0 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      2 |                    0 |                      0 |
| Zimbabwe                         |                      0 |                      0 |                  0 |                      0 |                    0 |                        0 |                     0 |                     1 |                       6 |                                               0 |                     0 |                    0 |                       0 |                    0 |               0 |                         0 |                   0 |                   0 |                        0 |                    0 |                   0 |                          0 |                           0 |                           0 |                           0 |                    0 |                    0 |                  0 |                   0 |                    0 |                      0 |                    0 |                      0 |

</td>
<td>

|                                  | Shannon_values |
|:---------------------------------|---------------:|
| Angola                           |           1.31 |
| Australia                        |           0.76 |
| Bangladesh                       |           0.00 |
| Botswana                         |           0.56 |
| Brazil                           |           0.46 |
| Canada                           |           0.80 |
| China                            |           1.01 |
| Colombia                         |           0.61 |
| Democratic Republic of the Congo |           0.49 |
| Egypt                            |           0.14 |
| Eswatini                         |           0.69 |
| Exception - Zoological Park      |           0.00 |
| French Polynesia                 |           0.00 |
| Gabon                            |           0.64 |
| India                            |           0.66 |
| Indonesia                        |           0.81 |
| Israel                           |           0.72 |
| Italy                            |           0.00 |
| Kenya                            |           1.28 |
| Liberia                          |           0.00 |
| Madagascar                       |           0.81 |
| Malawi                           |           0.00 |
| Malaysia                         |           0.60 |
| Mexico                           |           0.66 |
| Morocco                          |           0.00 |
| Mozambique                       |           1.52 |
| Myanmar                          |           0.00 |
| Namibia                          |           1.10 |
| Nigeria                          |           0.75 |
| Pakistan                         |           0.45 |
| Peru                             |           0.69 |
| Philippines                      |           0.86 |
| Republic of the Congo            |           0.00 |
| Russia                           |           0.50 |
| Singapore                        |           0.00 |
| South Africa                     |           0.99 |
| Sudan                            |           0.00 |
| Tanzania                         |           0.56 |
| Thailand                         |           0.48 |
| Uganda                           |           0.69 |
| United Kingdom                   |           1.61 |
| United States                    |           0.08 |
| Vietnam                          |           0.00 |
| Zambia                           |           1.47 |
| Zimbabwe                         |           0.41 |

</td>
</tr>
</tbody>
</table>

### 7c. Preston plot results

``` r

#3. Preston plots and results

pres.res<-bold.analyze.diversity(BCDMdata,taxon.rank="species",site.cat='country.ocean',preston.res=TRUE)

# Preston plot
pres.res$preston.plot
```

<img src="man/figures/README-alphadiv3-1.png" width="100%" style="display: block; margin: auto;" />

``` r

# Preston plot data
pres.res$preston.res
#> 
#> Preston lognormal model
#> Method: maximized likelihood to log2 abundances 
#> No. of species: 33 
#> 
#>      mode     width        S0 
#> -2.289343  4.680817  7.184358 
#> 
#> Frequencies by Octave
#>                 0       1        2        3        4        5        6        7
#> Observed 6.500000 7.00000 4.500000 5.000000 3.000000 2.000000 1.000000 2.000000
#> Fitted   6.374473 5.61248 4.721104 3.794116 2.913104 2.136878 1.497551 1.002679
#>                  8        10
#> Observed 1.0000000 1.0000000
#> Fitted   0.6413874 0.2288613
```

### 7d. Beta diversity

``` r

#4. beta diversity
beta.res<-bold.analyze.diversity(BCDMdata,taxon.rank="species",site.cat='country.ocean',beta.res=TRUE,beta.index = "jaccard")

# # Total beta diversity matrix (10 rows)
knitr::kable(head(as.matrix(round(beta.res$total.beta,2)),10))
```

|                                  | Angola | Australia | Bangladesh | Botswana | Brazil | Canada | China | Colombia | Democratic Republic of the Congo | Egypt | Eswatini | Exception - Zoological Park | French Polynesia | Gabon | India | Indonesia | Israel | Italy | Kenya | Liberia | Madagascar | Malawi | Malaysia | Mexico | Morocco | Mozambique | Myanmar | Namibia | Nigeria | Pakistan | Peru | Philippines | Republic of the Congo | Russia | Singapore | South Africa | Sudan | Tanzania | Thailand | Uganda | United Kingdom | United States | Vietnam | Zambia | Zimbabwe |
|:---------------------------------|-------:|----------:|-----------:|---------:|-------:|-------:|------:|---------:|---------------------------------:|------:|---------:|----------------------------:|-----------------:|------:|------:|----------:|-------:|------:|------:|--------:|-----------:|-------:|---------:|-------:|--------:|-----------:|--------:|--------:|--------:|---------:|-----:|------------:|----------------------:|-------:|----------:|-------------:|------:|---------:|---------:|-------:|---------------:|--------------:|--------:|-------:|---------:|
| Angola                           |   0.00 |      0.83 |       1.00 |     0.80 |   1.00 |   0.83 |  0.83 |     1.00 |                             1.00 |  1.00 |     0.80 |                           1 |             1.00 |   0.8 |  1.00 |      1.00 |   1.00 |  1.00 |  0.89 |    1.00 |       0.88 |      1 |     1.00 |   1.00 |    1.00 |       0.92 |    1.00 |    0.67 |    1.00 |     1.00 |    1 |        1.00 |                     1 |   1.00 |      1.00 |         1.00 |  1.00 |        1 |     1.00 |   1.00 |              1 |          1.00 |    1.00 |   0.71 |     1.00 |
| Australia                        |   0.83 |      0.00 |       1.00 |     0.75 |   1.00 |   0.50 |  0.50 |     0.83 |                             1.00 |  0.80 |     0.75 |                           1 |             0.67 |   1.0 |  0.75 |      0.80 |   1.00 |  1.00 |  0.88 |    1.00 |       0.86 |      1 |     0.75 |   0.83 |    1.00 |       0.80 |    1.00 |    0.83 |    1.00 |     0.75 |    1 |        0.83 |                     1 |   1.00 |      1.00 |         0.83 |  1.00 |        1 |     0.75 |   1.00 |              1 |          1.00 |    1.00 |   1.00 |     0.75 |
| Bangladesh                       |   1.00 |      1.00 |       0.00 |     1.00 |   0.50 |   0.67 |  0.67 |     0.75 |                             0.67 |  0.67 |     1.00 |                           1 |             1.00 |   1.0 |  0.50 |      0.67 |   0.67 |  0.00 |  0.83 |    0.00 |       0.80 |      1 |     0.50 |   0.75 |    1.00 |       0.89 |    0.00 |    0.75 |    0.67 |     1.00 |    1 |        0.75 |                     1 |   1.00 |      0.00 |         0.75 |  0.00 |        1 |     0.50 |   0.50 |              1 |          0.50 |    0.00 |   0.80 |     1.00 |
| Botswana                         |   0.80 |      0.75 |       1.00 |     0.00 |   1.00 |   0.75 |  0.75 |     0.80 |                             1.00 |  0.75 |     0.67 |                           1 |             0.50 |   1.0 |  0.67 |      0.75 |   1.00 |  1.00 |  1.00 |    1.00 |       0.83 |      1 |     0.67 |   0.80 |    1.00 |       0.90 |    1.00 |    0.50 |    1.00 |     0.67 |    1 |        0.80 |                     1 |   1.00 |      1.00 |         0.80 |  1.00 |        1 |     0.67 |   1.00 |              1 |          1.00 |    1.00 |   0.83 |     0.67 |
| Brazil                           |   1.00 |      1.00 |       0.50 |     1.00 |   0.00 |   0.75 |  0.75 |     0.50 |                             0.75 |  0.75 |     1.00 |                           1 |             1.00 |   1.0 |  0.67 |      0.75 |   0.33 |  0.50 |  0.86 |    0.50 |       0.83 |      1 |     0.67 |   0.50 |    1.00 |       0.90 |    0.50 |    0.80 |    0.75 |     1.00 |    1 |        0.50 |                     1 |   1.00 |      0.50 |         0.80 |  0.50 |        1 |     0.67 |   0.67 |              1 |          0.67 |    0.50 |   0.83 |     1.00 |
| Canada                           |   0.83 |      0.50 |       0.67 |     0.75 |   0.75 |   0.00 |  0.00 |     0.60 |                             0.80 |  0.50 |     0.75 |                           1 |             0.67 |   1.0 |  0.33 |      0.50 |   0.80 |  0.67 |  0.71 |    0.67 |       0.67 |      1 |     0.33 |   0.60 |    1.00 |       0.67 |    0.67 |    0.60 |    0.80 |     0.75 |    1 |        0.60 |                     1 |   1.00 |      0.67 |         0.60 |  0.67 |        1 |     0.33 |   0.75 |              1 |          0.75 |    0.67 |   0.86 |     0.75 |
| China                            |   0.83 |      0.50 |       0.67 |     0.75 |   0.75 |   0.00 |  0.00 |     0.60 |                             0.80 |  0.50 |     0.75 |                           1 |             0.67 |   1.0 |  0.33 |      0.50 |   0.80 |  0.67 |  0.71 |    0.67 |       0.67 |      1 |     0.33 |   0.60 |    1.00 |       0.67 |    0.67 |    0.60 |    0.80 |     0.75 |    1 |        0.60 |                     1 |   1.00 |      0.67 |         0.60 |  0.67 |        1 |     0.33 |   0.75 |              1 |          0.75 |    0.67 |   0.86 |     0.75 |
| Colombia                         |   1.00 |      0.83 |       0.75 |     0.80 |   0.50 |   0.60 |  0.60 |     0.00 |                             0.83 |  0.25 |     0.80 |                           1 |             0.75 |   1.0 |  0.50 |      0.25 |   0.25 |  0.75 |  0.89 |    0.75 |       0.50 |      1 |     0.50 |   0.00 |    0.75 |       0.82 |    0.75 |    0.67 |    0.60 |     0.50 |    1 |        0.00 |                     1 |   0.80 |      0.75 |         0.40 |  0.75 |        1 |     0.50 |   0.80 |              1 |          0.50 |    0.75 |   0.88 |     0.80 |
| Democratic Republic of the Congo |   1.00 |      1.00 |       0.67 |     1.00 |   0.75 |   0.80 |  0.80 |     0.83 |                             0.00 |  0.80 |     1.00 |                           1 |             1.00 |   1.0 |  0.75 |      0.80 |   0.80 |  0.67 |  0.71 |    0.67 |       0.86 |      1 |     0.75 |   0.83 |    1.00 |       0.80 |    0.67 |    0.83 |    0.80 |     1.00 |    1 |        0.83 |                     1 |   1.00 |      0.67 |         0.83 |  0.67 |        1 |     0.75 |   0.33 |              1 |          0.75 |    0.67 |   0.67 |     0.75 |
| Egypt                            |   1.00 |      0.80 |       0.67 |     0.75 |   0.75 |   0.50 |  0.50 |     0.25 |                             0.80 |  0.00 |     0.75 |                           1 |             0.67 |   1.0 |  0.33 |      0.00 |   0.50 |  0.67 |  0.88 |    0.67 |       0.40 |      1 |     0.33 |   0.25 |    0.67 |       0.80 |    0.67 |    0.60 |    0.50 |     0.33 |    1 |        0.25 |                     1 |   0.75 |      0.67 |         0.25 |  0.67 |        1 |     0.33 |   0.75 |              1 |          0.33 |    0.67 |   0.86 |     0.75 |

``` r

#Replacement
#beta.res$replace

#Richness difference
#beta.res$richnessd
```

### 8.bold.analyze.map

``` r
#Download the ids for the data
map.data.ids<-bold.public.search(taxonomy = "Musca domestica")

# Fetch the data using the ids
map.data<-bold.fetch(param.data = map.data.ids,query.param = "processid",param.index = 1,api_key = api.key)

geo.viz<-bold.analyze.map(map.data)
```

<img src="man/figures/README-visualize.geo-1.png" width="100%" style="display: block; margin: auto;" />

``` r

geo.viz.country<-bold.analyze.map(map.data,country = "China")
```

<img src="man/figures/README-visualize.geo-2.png" width="100%" style="display: block; margin: auto;" />

``` r

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
