
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

*NOTE* One of the functions in the package requires `msa` and
`Biostrings` packages installed and imported beforehand. `msa` is
installed using `BiocManager` package (Details of the function given
below).

``` r

if (!requireNamespace("BiocManager", quietly=TRUE))
install.packages("BiocManager")

BiocManager::install("msa")
BiocManager::install("Biostrings")

library(msa)
library(Biostrings)
```

## BOLDconnectR has 9 functions currently:

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

#### *Test data*

Test data is a data frame having 2 columns and 2100 unique ids. First
column has ‘processids’ while second has ‘sampleids’. Either one can be
used to retrieve data from BOLD.

``` r

knitr::kable(head(test.data,5))
```

| processid    | sampleid       |
|:-------------|:---------------|
| BBCNP2962-14 | BIOUG12575-B05 |
| SPICA1995-11 | BIOUG00530-C10 |
| SPRMA665-10  | 10-SKBC-0665   |
| SPRMA693-10  | 10-SKBC-0693   |
| PPELE733-11  | BIOUG00619-G06 |

#### 2a.Default(all data retrieved)

The arguments provided below need to be specified by default for every
request. Default settings retrieve data for all available fields for
those ids.

``` r

# A small subset of the data used for data retrieval
trial.data=test.data[1:100,]

result<-bold.fetch(param.data = trial.data,
                   query.param = 'processid',
                   param.index = 1,
                   api_key = api.key)

# Results (First 5 rows)
knitr::kable(head(result,5))
```

| processid    | record_id           | insdc_acs | sampleid       | specimenid |   taxid | short_note | identification_method                         | museumid       | fieldid          | collection_code | processid_minted_date | inst                             | specimendetails.verbatim_depository | funding_src | sex | life_stage | reproduction | habitat | collectors                                       | site_code       | specimen_linkout | collection_event_id | sampling_protocol    | tissue_type   | collection_date_start | specimendetails.verbatim_collectiondate | collection_time | specimendetails.verbatim_collectiondate_precision | associated_taxa | associated_specimens | voucher_type                    | notes           | taxonomy_notes | collection_notes                                                                     | specimendetails.verbatim_kingdom | specimendetails.verbatim_phylum | specimendetails.verbatim_class | specimendetails.verbatim_order | specimendetails.verbatim_family | specimendetails.verbatim_subfamily | specimendetails.verbatim_tribe | specimendetails.verbatim_genus | specimendetails.verbatim_species | specimendetails.verbatim_subspecies | specimendetails.verbatim_species_reference | specimendetails.verbatim_identifier | geoid | location.verbatim_country | location.verbatim_province | location.verbatim_country_iso_alpha3 | marker_code | kingdom  | phylum     | class     | order   | family     | subfamily | tribe | genus     | species         | subspecies | identification  | identification_rank | tax_rank.numerical_posit | species_reference        | identified_by     | specimendetails\_\_identifier.person.email | sequence_run_site                                 | nuc                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | nuc_basecount | sequence_upload_date | bin_uri      | bin_created_date | elev | location.verbatim_elev | depth | location.verbatim_depth |     lat |      lon | location.verbatim_coord | coord_source | coord_accuracy | location.verbatim_gps_accuracy | elev_accuracy | location.verbatim_elev_accuracy | depth_accuracy | location.verbatim_depth_accuracy | realm    | biome | ecoregion                        | region                    | sector                   | site     | country_iso | country.ocean | province.state   | bold_recordset_code_arr                                                                                       | geopol_denorm.country_iso3 | collection_date_end |
|:-------------|:--------------------|:----------|:---------------|-----------:|--------:|:-----------|:----------------------------------------------|:---------------|:-----------------|:----------------|:----------------------|:---------------------------------|:------------------------------------|:------------|:----|:-----------|:-------------|:--------|:-------------------------------------------------|:----------------|:-----------------|:--------------------|:---------------------|:--------------|:----------------------|:----------------------------------------|:----------------|:--------------------------------------------------|:----------------|:---------------------|:--------------------------------|:----------------|:---------------|:-------------------------------------------------------------------------------------|:---------------------------------|:--------------------------------|:-------------------------------|:-------------------------------|:--------------------------------|:-----------------------------------|:-------------------------------|:-------------------------------|:---------------------------------|:------------------------------------|:-------------------------------------------|:------------------------------------|------:|:--------------------------|:---------------------------|:-------------------------------------|:------------|:---------|:-----------|:----------|:--------|:-----------|:----------|:------|:----------|:----------------|:-----------|:----------------|:--------------------|-------------------------:|:-------------------------|:------------------|:-------------------------------------------|:--------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------:|:---------------------|:-------------|:-----------------|-----:|:-----------------------|------:|:------------------------|--------:|---------:|:------------------------|:-------------|---------------:|:-------------------------------|--------------:|:--------------------------------|---------------:|:---------------------------------|:---------|:------|:---------------------------------|:--------------------------|:-------------------------|:---------|:------------|:--------------|:-----------------|:--------------------------------------------------------------------------------------------------------------|:---------------------------|:--------------------|
| SPITO100-11  | SPITO100-11.COI-5P  | KP651793  | BIOUG00633-H07 |    2035584 |    9162 | Female     | NA                                            | BIOUG00633-H07 | ZOO-023          |                 | 2011-06-21            | Centre for Biodiversity Genomics | NA                                  | iBOL:WG1.9  | F   | A          | S            | NA      | Tiffany, Tom Mason, Michael Morra, Gerry Blagoev | NA              | NA               | NA                  | Free Hand Collection |               | 2011-06-16            | NA                                      | NA              | NA                                                | NA              | NA                   | NA                              | hand collection | NA             | NA                                                                                   | NA                               | NA                              | NA                             | NA                             | NA                              | NA                                 | NA                             | NA                             | NA                               | NA                                  | NA                                         | NA                                  |   528 | NA                        | NA                         | NA                                   | COI-5P      | Animalia | Arthropoda | Arachnida | Araneae | Salticidae | NA        | NA    | Phidippus | Phidippus audax | NA         | Phidippus audax | species             |                       17 | Hentz, 1845              | Gergin A. Blagoev | <gblagoev@uoguelph.ca>                     | Centre for Biodiversity Genomics                  | AACATTATATTTGATTTTTGGAGCTTGGGCTGCAATAGTTGGTACTGCAATAAGTGTATTGATTCGAATAGAATTGGGTCAAACTGGATCATTTATAGGAAATGATCATATATATAATGTAATTGTGACTGCTCATGCTTTTGTTATAATTTTTTTTATAGTAATACCTATTATGATTGGAGGATTTGGAAACTGATTAGTTCCTTTAATATTAGGTGCTCCTGATATGGCTTTTCCTCGTATAAATAATTTGAGATTTTGATTATTACCCCCTTCTTTATTTTTATTATTTATTTCTTCCATAGCTGAGGTAGGTGTAGGGGCTGGTTGGACAGTTTATCCACCTTTGGCCTCTATTGTTGGGCATAATGGAAGATCAGTAGATTTTGCTATTTTTTCATTACATTTAGCTGGTGCTTCATCAATTATAGGAGCTATTAATTTTATTTCTACAATTATTAATATACGTTCTTTAGGAATGTCTTTAGATAAAATTCCTTTGTTTGTTTGATCTGTAATAATTACTGCAGTTTTGTTATTACTTTCTCTTCCTGTATTAGCTGGGGCTATTACTATATTGTTGACTGATCGTAATTTTAATACTTCTTTTTTTGATCCAGCAGGAGGAGGGGATCCTATTTTATTTCAGCATTTATTT  |           658 | 2011-09-16           | BOLD:AAC6891 | 2010-07-15       |  120 | NA                     |    NA | NA                      | 43.8230 |  -79.194 | NA                      | NA           |             NA | NA                             |            NA | NA                              |             NA | NA                               | Nearctic | NA    | Southern_Great_Lakes_forests     | NA                        | Toronto-Zoo              | NA       | CA          | Canada        | Ontario          | SPITO,DS-MOB112,DS-MOB113,DS-SOC2014,DS-ARANCCYH,DS-IDSPTEST,DS-TMPSRCH,DS-SPCANADA,DS-OLOCC2,DS-JUMPGLOB     | CAN                        | NA                  |
| SPITO182-12  | SPITO182-12.COI-5P  | KP655638  | BIOUG00889-A09 |    2541683 |    9162 |            | NA                                            | BIOUG00889-A09 | BIOUG00889-A09   |                 | 2012-04-30            | Royal Ontario Museum             | NA                                  | iBOL:WG1.9  |     |            | S            | NA      | Tiffany Yau, Tom Mason                           | NA              | NA               | NA                  | NA                   | NA            | 2011-07-19            | NA                                      | NA              | NA                                                | NA              | NA                   | NA                              | NA              | NA             | NA                                                                                   | NA                               | NA                              | NA                             | NA                             | NA                              | NA                                 | NA                             | NA                             | NA                               | NA                                  | NA                                         | NA                                  |   528 | NA                        | NA                         | NA                                   | COI-5P      | Animalia | Arthropoda | Arachnida | Araneae | Salticidae | NA        | NA    | Phidippus | Phidippus audax | NA         | Phidippus audax | species             |                       17 | Hentz, 1845              | Gergin A. Blagoev | <gblagoev@uoguelph.ca>                     | Centre for Biodiversity Genomics                  | AACATTATATTTGATTTTTGGAGCTTGGGCTGCAATAGTTGGTACTGCAATAAGTGTATTGATTCGAATAGAATTGGGTCAAACTGGATCATTTATAGGAAATGATCATATATATAATGTAATTGTGACTGCTCATGCTTTTGTTATAATTTTTTTTATAGTAATACCTATTATGATTGGAGGATTTGGAAACTGATTAGTTCCTTTAATATTAGGTGCTCCTGATATGGCTTTTCCTCGTATAAATAATTTGAGATTTTGATTATTACCCCCTTCTTTATTTTTATTATTTATTTCTTCCATAGCTGAGGTAGGTGTAGGGGCTGGTTGGACAGTTTATCCACCTTTGGCCTCTATTGTTGGGCATAATGGAAGATCAGTAGATTTTGCTATTTTTTCATTACATTTAGCTGGTGCTTCATCAATTATAGGAGCTATTAATTTTATTTCTACAATTATTAATATACGTTCTTTAGGAATGTCTTTAGATAAAATTCCTTTGTTTGTTTGATCTGTAATAATTACTGCAGTTTTGTTATTACTTTCTCTTCCTGTATTAGCTGGGGCTATTACTATATTGTTGACTGATCGTAATTTTAATACTTCTTTTTTTGATCCAGCAGGAGGAGGGGATCCTATTTTATTTCAGCATTTATTT  |           658 | 2012-05-10           | BOLD:AAC6891 | 2010-07-15       |  115 | NA                     |    NA | NA                      | 43.8150 |  -79.183 | NA                      | NA           |             NA | NA                             |            NA | NA                              |             NA | NA                               | Nearctic | NA    | Southern_Great_Lakes_forests     | Toronto-Zoo               | Rouge river              | NA       | CA          | Canada        | Ontario          | SPITO,DS-MOB112,DS-MOB113,DS-SOC2014,DS-ARANCCYH,DS-SPCANADA,DS-JUMPGLOB                                      | CAN                        | NA                  |
| SPICA048-10  | SPICA048-10.COI-5P  | JF884501  | BIOUG00164-D12 |    1710944 |   30505 | Yoho NP    | NA                                            | BIOUG00164-D12 | BIObus2010CA-002 | BIOUG           | 2010-10-28            | Centre for Biodiversity Genomics | NA                                  | iBOL:WG1.9  | NA  | I          | S            | Forest  | BIObus 2010                                      | NA              | NA               | NA                  | Free Hand            |               | 2010-07-20            | NA                                      | NA              | NA                                                | NA              | NA                   | Vouchered:Registered Collection | NA              | NA             | Free Hand\|Partly cloudy, Warm\|Forested campground                                  | NA                               | NA                              | NA                             | NA                             | NA                              | NA                                 | NA                             | NA                             | NA                               | NA                                  | NA                                         | NA                                  |   516 | NA                        | NA                         | NA                                   | COI-5P      | Animalia | Arthropoda | Arachnida | Araneae | Salticidae | NA        | NA    | Evarcha   | Evarcha hoyi    | NA         | Evarcha hoyi    | species             |                       17 | (Peckham, Peckham, 1883) | Gergin A. Blagoev | <gblagoev@uoguelph.ca>                     | Centre for Biodiversity Genomics                  | AACTTTATATTTAATTTTTGGAGCTTGGGCTGCTATAGTAGGTACTGCTATGAGAGTACTAATTCGGATGGAATTAGGACAGACTGGAAGATTTTTAGGAAATGAACATTTATATAATGTCATTGTTACGGCTCATGCGTTTGTTATAATTTTTTTTATAGTAATACCTATTATAATTGGTGGTTTTGGTAATTGATTGGTTCCGCTAATATTAGGGGCTCCAGATATAGCTTTTCCTCGTATGAATAATTTAAGATTTTGATTATTGCCTCCTTCTTTAATGTTATTATTTATTTCTTCTATAGCTGAAATAGGAGTGGGAGCTGGATGAACAGTGTATCCTCCCTTAGCTTCTATTGTAGGGCATAATGGAAGATCTGTAGATTTTGCTATTTTTTCTTTACATTTAGCCGGGGCTTCTTCTATTATAGGTGCTATTAATTTTATTTCGACTATTATTAATATACGTTCAGTAGGAATATCTATGGATAAAATTTCTTTATTTGTATGATCAGTTTTAATTACTGCTGTGTTATTATTATTGTCATTGCCAGTTTTAGCTGGGGCTATTACTATATTATTAACTGATCGAAATTTTAATACTTCTTTTTTTGATCCTGCGGGAGGAGGAGATCCAATTTTGTTTCAACATTTATTT  |           658 | 2011-02-14           | BOLD:AAC0343 | 2010-07-15       | 1317 | NA                     |    NA | NA                      | 51.4240 | -116.429 | NA                      | GPS WGS84    |             NA | NA                             |            NA | NA                              |             NA | NA                               | Nearctic | NA    | Northern_Rockies_conifer_forests | Yoho NP                   | Kicking Horse Campground | NA       | CA          | Canada        | British Columbia | SPIBB,DS-MOB112,DS-MOB113,DS-BICNP02,DS-SBC2014,DS-SOC2014,DS-ARANCCYH,DATASET-BBYNP1,DS-SPCANADA,DS-JUMPGLOB | CAN                        | NA                  |
| RBINA3286-13 | RBINA3286-13.COI-5P | KP648263  | BIOUG08023-D09 |    3749469 |    9162 | Rouge NP   | NA                                            | BIOUG08023-D09 | ON13-C1367       | BIOUG           | 2013-09-19            | Centre for Biodiversity Genomics | NA                                  | iBOL:WG1.9  | NA  | NA         | NA           | NA      | Arachnid Team                                    | NA              | NA               | NA                  | Free Hand            | Tissue        | 2013-09-14            | NA                                      | NA              | NA                                                | NA              | NA                   | Vouchered:Registered Collection | NA              | CollectionsID  | NA                                                                                   | NA                               | NA                              | NA                             | NA                             | NA                              | NA                                 | NA                             | NA                             | NA                               | NA                                  | NA                                         | NA                                  |   528 | NA                        | NA                         | NA                                   | COI-5P      | Animalia | Arthropoda | Arachnida | Araneae | Salticidae | NA        | NA    | Phidippus | Phidippus audax | NA         | Phidippus audax | species             |                       17 | Hentz, 1845              | NA                | NA                                         | Biodiversity and Climate Research Centre, Germany | -ACATTATATTTGATTTTTGGAGCTTGGGCTGCAATAGTTGGTACTGCAATA—AGTGTATTGATTCGAATAGAATTGGGTCAAACTGGATCATTTATAGGAAAT—GATCATATATATAATGTAATTGTGACTGCTCATGCTTTTGTTATAATTTTTTTTATAGTAATACCTATTATGATTGGAGGATTTGGAAACTGATTAGTTCCTTTAATA—TTAGGTGCTCCTGATATGGCTTTTCCTCGTATAAATAATTTGAGATTTTGATTATTACCCCCTTCTTTATTTTTATTATTTATTTCTTCCATAGCTGAGGTAGGTGTAGGGGCTGGTTGGACAGTTTATCCACCTTTGGCCTCTATTGTTGGGCATAATGGAAGATCAGTAGATTTT—GCTATTTTTTCATTACATTTAGCTGGTGCTTCATCAATTATAGGAGCTATTAATTTTATTTCTACAATTATTAATATACGTTCTTTAGGAATGTCTTTAGATAAAATTCCTTTGTTTGTTTGATCTGTAATAATTACTGCAGTTTTGTTATTACTTTCTCTTCCTGTATTAGCTGGG—GCTATTACTATA——————————————————                                                            |           576 | 2013-10-04           | BOLD:AAC6891 | 2010-07-15       |  156 | NA                     |    NA | NA                      | 43.8444 |  -79.197 | NA                      | GPS          |             NA | NA                             |            NA | NA                              |             NA | NA                               | Nearctic | NA    | Southern_Great_Lakes_forests     | Rouge National Urban Park | NA                       | Sector 6 | CA          | Canada        | Ontario          | RBINA,DS-RPB13,DS-SOC2014,DS-MYBCA,DS-JALPHA,DS-ARANCCYH,DS-BBRNUP1,DS-SPCANADA,DS-JUMPGLOB                   | CAN                        | NA                  |
| SSJAF5926-13 | SSJAF5926-13.COI-5P | KM825258  | BIOUG09295-H03 |    4046632 | 1061604 | Jasper NP  | Morphology and BIN Taxonomy Match (Jan, 2021) | BIOUG09295-H03 | L#12BIOBUS-1107  | BIOUG           | 2013-12-05            | Centre for Biodiversity Genomics | NA                                  | iBOL:WG1.9  | NA  | NA         | NA           | Forest  | BIOBus 2012                                      | BIOUG:JASP-NP:2 | NA               | NA                  | Pan Trap             | Whole Voucher | 2012-07-16            | NA                                      | NA              | NA                                                | NA              | NA                   | Vouchered:Registered Collection | NA              | NA             | 10 pan traps\|overcast\|16C\|birch and spruce forest on a slope, lots of fallen logs | NA                               | NA                              | NA                             | NA                             | NA                              | NA                                 | NA                             | NA                             | NA                               | NA                                  | NA                                         | NA                                  |   533 | NA                        | NA                         | NA                                   | COI-5P      | Animalia | Arthropoda | Arachnida | Araneae | Salticidae | NA        | NA    | Attulus   | Attulus finschi | NA         | Attulus finschi | species             |                       17 | NA                       | Gergin A. Blagoev | <gblagoev@uoguelph.ca>                     | Centre for Biodiversity Genomics                  | TACATTATATTTAATTTTTGGTGCTTGATCTGCTATAGTGGGGACGGCAATAAGAGTTTTAATTCGAATAGAATTAGGT—CAGACTGGAAATTTACTAGGAAATGATCATTTGTATAATGTGATTGTTACTGCTCATGCTTTTGTTATAATTTTTTTTATAGTTATACCTATCTTAATTGGAGGTTTTGGTAATTGATTAGTTCCTTTAATGCTAGGGGCTCCTGATATAGCTTTTCCTCGTATAAATAATTTGAGATTTTGGTTATTACCTCCTTCATTATTTTTATTATTTATCTCATCTATAGCTGAAATAGGAGTAGGGGCAGGTTGAACTGTATACCCTCCTTTAGCTTCTATTGTTGGGCACAATGGGAGTTCGGTAGATTTTGCAATTTTTTCTTTGCATTTAGCTGGAGCTTCTTCTATTATAGGTGCTATTAATTTTATTTCAACAATTATTAATATACGATCTATAGGAATATCTATAGATAAGATCCCTTTATTTGTTTGATCAGTTGTAATTACTGCTGTATTGTTACTATTGTCTTTACCAGTGTTAGCAGGTGCTATTACTATGTTGTTGACTGATCGAAATTTTAATACTTCTTTTTTTGATCCTGCCGGGGGAGGTGATCCTATTTTATTTCAACATTTATTT |           658 | 2016-03-18           | BOLD:AAW1184 | 2011-07-11       | 1131 | NA                     |    NA | NA                      | 53.1950 | -117.914 | NA                      | GPSmap 60Cx  |             NA | NA                             |            NA | NA                              |             NA | NA                               | Nearctic | NA    | Northern_Rockies_conifer_forests | Jasper National Park      | Pocahontas Campground    | Site C21 | CA          | Canada        | Alberta          | SSJAF,DS-MOB112,DS-MOB113,DS-BICNP02,DS-SOC2014,DS-ARANCCYH,DS-CDABRL,DATASET-BBJNP1,DS-SPCANADA,DS-JUMPGLOB  | CAN                        | 2012-07-21          |

#### 2b.Institutes Filter

Data is downloaded followed by the ‘institute’ filter applied on it to
fetch only the relevant ‘institute’ (here South African Institute for
Aquatic Biodiversity) data.

``` r

# A small subset of the data used for data retrieval
result_institutes<-bold.fetch(param.data = test.data,
                               query.param = 'processid',
                               param.index = 1,
                               api_key = api.key,
                               filt.institutes = c("Centre for Biodiversity Genomics"),
                              filt.fields = c("processid","sampleid","inst","nuc_basecount"))

# Results (first five rows)
knitr::kable(head(result_institutes,5))
```

| processid    | sampleid       | inst                             | nuc_basecount |
|:-------------|:---------------|:---------------------------------|--------------:|
| ARONW324-12  | BIOUG01965-D12 | Centre for Biodiversity Genomics |           658 |
| ARONT794-10  | CCDB-05292-G09 | Centre for Biodiversity Genomics |           657 |
| CNSLQ086-13  | BIOUG06960-E10 | Centre for Biodiversity Genomics |           576 |
| BBCAN648-09  | CCDB-05269-H05 | Centre for Biodiversity Genomics |           584 |
| SSWLE5678-13 | BIOUG08431-F04 | Centre for Biodiversity Genomics |           547 |

#### 2c.Geographic location filter

Data is downloaded followed by the ‘geography’ filter applied on it to
fetch only the relevant locations (here United States) data.

``` r

trial.data=test.data[1:100,]

result_geography<-bold.fetch(param.data = trial.data,
                               query.param = 'processid',
                               param.index = 1,
                               api_key = api.key,
                                filt.geography=c("Churchill"),
                                filt.fields = c("bin_uri","processid","region"))
# Result (First 5 rows) 
knitr::kable(head(result_geography,5))                 
```

| processid    | sampleid        | bin_uri      | region    |
|:-------------|:----------------|:-------------|:----------|
| SPIRU1032-11 | BIOUG00627-E12  | BOLD:AAB2929 | Churchill |
| SPIRU1321-11 | BIOUG00630-F04  | BOLD:AAC2061 | Churchill |
| SPIRU1160-11 | BIOUG00628-H09  | BOLD:AAJ6933 | Churchill |
| SPISH009-09  | 09PROBE-1645-01 | BOLD:AAI3798 | Churchill |

#### 2d.Altitude

Data is downloaded followed by the ‘Altitude’ filter applied on it to
fetch data only between the range of altitude specified (100 to 1500 m
a.s.l.) data.

``` r

trial.data=test.data[1:100,]

result_altitude<-bold.fetch(param.data = trial.data,
                               query.param = 'processid',
                               param.index = 1,
                               api_key = api.key,
                               filt.altitude = c(1000,1200),
                               filt.fields = c("bin_uri","processid","family","elev"))

# Result (First 5 rows)
knitr::kable(head(result_altitude,5))                    
```

| processid    | sampleid       | bin_uri      | family     | elev |
|:-------------|:---------------|:-------------|:-----------|-----:|
| BBCNP741-14  | BIOUG09534-G04 | BOLD:AAA5654 | Salticidae | 1015 |
| SSJAF9138-13 | BIOUG09624-B06 | BOLD:AAD6736 | Salticidae | 1131 |
| SSJAF5926-13 | BIOUG09295-H03 | BOLD:AAW1184 | Salticidae | 1131 |
| ARBCM2084-14 | BIOUG14299-H11 | BOLD:ACI8467 | Salticidae | 1125 |
| BBCNP727-14  | BIOUG09534-F02 | BOLD:ABW7238 | Salticidae | 1015 |

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

#### 3a.IDs retrieved based on taxonomy

``` r

result.public.ids<-bold.public.search(taxonomy = c("Panthera leo"))

# Result(First 5 rows)
knitr::kable(head(result.public.ids,5))                    
```

| processid   | sampleid    |
|:------------|:------------|
| ABRMM002-06 | ROM PM13004 |
| ABRMM043-06 | ROM 101200  |
| CAR055-11   | Ple153      |
| CAR055-11   | Ple153      |
| CAR056-11   | Ple185      |

#### 3b.IDs retrieved based on taxonomy and geography

``` r

result.public.geo.id<-bold.public.search(taxonomy = c("Panthera leo"),geography = "India",filt.marker = "COI-5P")

fetch.data.result.geo.id<-bold.fetch(param.data = result.public.geo.id,
                               query.param = 'processid',
                               param.index = 1,
                               api_key = api.key,
                               filt.fields = c("bin_uri","processid","family","elev"))

# Result(First 5 rows)
knitr::kable(head(fetch.data.result.geo.id,5)) 
```

| processid | sampleid | bin_uri | family  | elev |
|:----------|:---------|:--------|:--------|-----:|
| CAR056-11 | Ple185   | NA      | Felidae |   NA |
| CAR056-11 | Ple185   | NA      | Felidae |   NA |

#### 3c.IDs retrieved based on taxonomy, geography and BIN id

``` r
result.public.geo.bin<-bold.public.search(taxonomy = c("Panthera leo"),geography = "India",bins = 'BOLD:AAD6819')

# Result(First 5 rows) 
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

# Result: Data summary (character data)
data.summ.res$character
```

**Variable type: character**

| skim_variable | n_missing | complete_rate | min | max | empty | n_unique | whitespace |
|:--------------|----------:|--------------:|----:|----:|------:|---------:|-----------:|
| processid     |         0 |          1.00 |  10 |  12 |     0 |       99 |          0 |
| sampleid      |         0 |          1.00 |  10 |  15 |     0 |       99 |          0 |
| bin_uri       |         0 |          1.00 |  12 |  12 |     0 |       38 |          0 |
| species       |         0 |          1.00 |  10 |  28 |     0 |       33 |          0 |
| inst          |         1 |          0.99 |  20 |  34 |     0 |        5 |          0 |

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

data.seq.aligned<-BOLDconnectR:::bold.analyze.align(aligned.data.result,align.method = "ClustalOmega")
#> using Gonnet

# Subset of the BCDM data frame of the  aligned sequences and their respective names
 
final.res=subset(data.seq.aligned,select=c(aligned_seq,msa.seq.name))

# Result(First 5 rows)
knitr::kable(head(final.res))
```

| aligned_seq                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | msa.seq.name |
|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------------|
| –AACTCTTTATTTAATTTTTGGTGCTTGGTCCGGTATAGTAGGAACAGCACTTAGTCTTTTGATTCGAGTAGAATTGGGTCAACCTGGTTCTTTCATTGGAGACGATCAGATTTATAATGTAGTAGTAACTGCTCATGCTTTTATCATGATTTTCTTTATAGTTATACCTATCCTTATTGGAGGGTTTGGAAACTGACTTGTGCCACTAATATTAGGTGCACCTGACATGGCTTTTCCTCGTTTAAATAATATAAGTTTTTGACTTTTACCTCCTGCATTAATCTTATTGTTATCAGGCGCTGGAGTAGAAAGAGGAGCTGGTACAGGATGAACAGTTTATCCCCCTTTGTCGGCTGGGATTGCCCATGCTGGAGCTTCTGTTGATCTGAGAATTTTTTCTCTTCATCTAGCTGGGGTTTCTTCTATTTTAGGGGCTATTAATTTTATTACTACTATTATCAACATGCGAGTTCATGGAATAACTTTAGATCGAATTCCTCTTTTCGTTTGAGCTGTTGGGATTACTGCTTTATTATTACTCTTATCTTTACCTGTTCTTGCCGGAGCTATCACGATGTTACTGACTGATCGTAACTTAAATACTTCTTTTTTTGATCCAGCTGGAGGGGGAGATCCAATTTTGTATCAACATTTATTT——————————————————————————————————————————————————————————————————————————————————————————————-                                                                                                                                                                                              | BCRUA030-10  |
| GGGACTCTTTACTTAATTTTTGGTGCTTGATCTGGTATGGTAGGAACAGCCTTAAGCTTGTTAATTCGAGTTGAGTTAGGACAACCTGGCTCTTTTATTGGTGATGACCAGATTTATAATGTGGTAGTTACCGCCCATGCTTTCATCATAATTTTTTTTATGGTTATACCTATCTTGATTGGGGGGTTTGGGAATTGATTGGTCCCTTTAATATTAGGTGCCCCCGACATGGCTTTTCCTCGTTTAAATAATATGAGTTTTTGACTCTTGCCCCCTGCATTGATTTTATTGCTTTCAGGGGCTGGAGTAGAGAGAGGAGCGGGGACTGGTTGAACAGTTTATCCTCCTTTATCGGCCGGAATTGCTCACGCTGGGGCATCTGTTGATTTGAGAATTTTTTCTCTTCATCTAGCCGGGATTTCTTCAATCTTAGGAGCAATTAATTTTATTACCACTATTATTAATATGCGAGTCCAAGGTATAACTTTGGATCGAATTCCTCTCTTTGTGTGAGCGGTTGGAATTACTGCTTTGTTGTTGCTTTTATCTTTACCTGTACTCGCAGGAGCGATTACAATATTATTAACTGATCGTAACCTGAATACTTCTTTCTTTGACCCTGCTGGGGGAGGAGATCCTATTTTATATCAACATTTATTTTGATTTTTTGGCCATCCTGAGGTTTACATTTTAATTTTACCTGGGTTTGGTATGATTTCCCACATTATTAGCCAAGAGAGCGGTAAGAAGGAGTCCTTTGGGACTTTAGGAATGATTTACGCTATACTAGCCATTGGAATCTTAGGATTTGTGGTGTGAGCTCATCATATATTTACAGTTGGTATGGATGTCGATACTCGAGCCTATTTTACCGCAGCAACAATAATTATTGCTGTGCCTACTGGGATCAAGATTTTTAGATGGTTAGGGACTTTACATGGGA | GBCB911-10   |
| GGGACTCTTTACTTAATTTTTGGTGCTTGATCCGGGATAGTTGGAACAGCACTAAGTTTGTTAATCCGAGTGGAGTTAGGGCAACCGGGCTCTTTTATTGGGGATGATCAGATTTATAATGTGGTAGTAACTGCCCACGCTTTTATTATAATTTTTTTTATAGTTATGCCTATTTTGATTGGTGGGTTTGGAAATTGGCTTGTGCCTTTGATACTAGGTGCTCCCGATATAGCTTTTCCTCGTTTAAATAACATGAGTTTTTGACTCCTTCCTCCTGCATTAATCTTATTGCTTTCAGGGGCCGGAGTTGAAAGAGGGGCAGGAACTGGATGAACAGTATACCCACCTTTATCGGCTGGGATCGCTCACGCCGGAGCCTCTGTTGACTTGAGAATCTTTTCTCTTCATTTAGCTGGGATTTCTTCAATTTTAGGGGCTATTAATTTTATTACAACCATTATTAACATACGGGTTCAAGGCATAACTTTGGATCGAATTCCTCTGTTTGTATGAGCAGTTGGAATCACAGCTTTATTATTGCTCTTATCTTTACCTGTTCTTGCAGGAGCGATTACCATGTTATTAACTGATCGAAATCTAAACACTTCTTTTTTTGACCCTGCTGGAGGTGGAGACCCTATTTTATATCAACATCTATTTTGATTTTTCGGACACCCTGAAGTTTATATTTTAATTCTACCAGGCTTTGGTATAATTTCTCACATTATTAGTCAGGAAAGAGGTAAGAAGGAGTCTTTCGGTACCTTGGGGATGATTTATGCGATGCTAGCCATTGGGATTTTAGGATTTGTGGTATGGGCCCATCATATGTTTACAGTCGGTATGGATGTGGATACTCGAGCTTACTTTACTGCGGCAACAATGATTATTGCTGTTCCTACTGGAATTAAGATTTTTAGATGATTAGGGACCTTGCACGGAA | GBCB909-10   |
| ————TTATTTTTTGTTGCTTGGTCCGGTATAGTAGGAACAGCACTTAGTCTTTTGATTCGAGTAGAATTGGGCCAACCTGGTTCTTTCATTGGAGACGATCAGATTTATAATGTAGTAGTAACTGCTCATGCTTTTATCATGATTTTCTTTATAGTTATACCTATTCTTATTGGAGGGTTTGGAAACTGACTTGTGCCACTAATATTAGGTGCACCTGACATGGCTTTTCCTCGTTTAAATAATATAAGTTTTTGACTTCTACCTCCTGCATTAATCTTATTATTATCAGGCGCTGGAGTAGAAAGAGGAGCTGGCACAGGATGAACAGTCTACCCCCCTTTGTCGGCTGGGATTGCCCACGCTGGAGCTTCTGTTGATCTGAGAATTTTTTCTCTTCATCTAGCTGGGGTTTCTTCTATTTTAGGGGCTATTAATTTTATTACTACTATTATCAATATGCGAGTTCATGGAATAACTTTAGATCGAATTCCTCTTTTCGTCTGAGCCGTTGGGATTACTGCTTTGTTATTACTTTTATCTTTACCTGTTCTTGCCGGAGCAATTACGATGTTATTGACTGATCGTAACTTAAATACTTCTTTTTTTGATCCAGCTGGAGGGGGGGATCCAATTTTGTATCAACATTTATTT——————————————————————————————————————————————————————————————————————————————————————————————-                                                                                                                                                                                                     | GBCB2354-13  |
| –AACTCTTTATTTAATTTTTGGTGCTTGGTCCGGTATAGTAGGAACAGCACTTAGTCTTTTGATTCGAGTAGAATTGGGTCAACCTGGTTCTTTCATTGGAGACGATCAGATTTATAATGTAGTAGTAACTGCTCATGCTTTTATCATGATTTTCTTTATAGTTATACCTATCCTTATTGGAGGGTTTGGAAACTGACTTGTGCCACTAATATTAGGTGCACCTGACATGGCTTTTCCTCGTTTAAATAATATAAGTTTTTGACTTCTACCTCCTGCATTAATCTTATTGTTATCAGGCGCTGGAGTAGAAAGAGGAGCTGGTACAGGATGAACAGTTTATCCCCCTTTGTCGGCTGGGATTGCCCATGCTGGAGCTTCTGTTGATCTGAGAATTTTTTCTCTTCATCTAGCTGGGGTTTCTTCTATTTTAGGGGCTATTAATTTTATTACTACTATTATCAACATGCGAGTTCATGGAATAACTTTAGATCGAATTCCTCTTTTCGTTTGAGCTGTTGGGATTACTGCTTTATTATTACTCTTATCTTTACCTGTTCTTGCCGGAGCTATCACGATGTTACTGACTGATCGTAACTTAAATACTTCTTTTTTTGATCCAGCTGGAGGGGGAGATCCAATTTTGTATCAACATTTATTT——————————————————————————————————————————————————————————————————————————————————————————————-                                                                                                                                                                                              | BCRUA029-10  |
| GGGACTCTTTACTTAATTTTTGGTGCTTGGTCTGGAATAGTTGGGACAGCACTAAGTTTGTTAATTCGAGTGGAGCTAGGGCAACCGGGCTCTTTTATTGGGGACGATCAAATTTATAATGTGGTAGTAACTGCTCACGCTTTCATTATAATTTTCTTTATAGTTATGCCTATTTTGATTGGTGGATTTGGAAATTGGCTTGTGCCTTTGATATTAGGTGCTCCCGATATGGCTTTTCCTCGTTTAAATAATATGAGTTTTTGACTTCTTCCTCCTGCATTAATTTTATTACTCTCAGGAGCCGGAGTTGAAAGAGGGGCAGGAACCGGATGAACAGTATATCCGCCCCTATCAGCTGGGATCGCCCATGCTGGAGCCTCTGTTGACTTGAGAATCTTTTCTCTTCATTTAGCCGGGATTTCTTCAATTTTAGGGGCTATTAATTTTATTACAACCATTATTAATATACGGGTTCAAGGTATAACTTTGGATCGAATTCCTCTGTTCGTATGAGCAGTTGGAATTACAGCTTTATTATTGCTCTTATCTCTACCTGTTCTTGCAGGAGCGATTACTATGTTACTAACTGATCGAAATTTAAACACTTCTTTTTTTGATCCTGCTGGAGGTGGGGACCCAATTTTATATCAACACCTATTTTGATTTTTCGGACACCCTGAAGTTTACATTTTAATTCTACCAGGCTTTGGTATAATTTCTCATATTATTAGCCAAGAAAGAGGTAAGAAGGAGTCTTTTGGTACCCTGGGAATAATTTACGCAATGCTAGCCATCGGGATTTTAGGATTTGTAGTATGGGCCCATCATATGTTTACAGTTGGTATGGATGTGGATACTCGAGCTTACTTTACTGCGGCAACAATGATTATTGCTGTTCCTACTGGAATTAAGATTTTTAGATGATTAGGGACTTTGCATGGAA | GBCB914-10   |

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

data.seq.align<-BOLDconnectR:::bold.analyze.align(data.4.seqanalysis,seq.name.fields = c("bin_uri","species"),align.method = "ClustalOmega")
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

#### 7a. Richness results

``` r
# Fetch the data
BCDMdata<-bold.fetch(param.data = test.data,query.param = "processid",param.index = 1,api_key = api.key)

#1. Analyze richness data
res.rich<-bold.analyze.diversity(BCDMdata,taxon.rank="species",site.cat='region',richness.res=TRUE)
#>   |                                                                              |                                                                      |   0%  |                                                                              |=                                                                     |   1%  |                                                                              |=                                                                     |   2%  |                                                                              |==                                                                    |   3%  |                                                                              |===                                                                   |   4%  |                                                                              |====                                                                  |   5%  |                                                                              |====                                                                  |   6%  |                                                                              |=====                                                                 |   7%  |                                                                              |======                                                                |   8%  |                                                                              |======                                                                |   9%  |                                                                              |=======                                                               |  10%  |                                                                              |========                                                              |  11%  |                                                                              |========                                                              |  12%  |                                                                              |=========                                                             |  13%  |                                                                              |==========                                                            |  14%  |                                                                              |==========                                                            |  15%  |                                                                              |===========                                                           |  16%  |                                                                              |============                                                          |  17%  |                                                                              |=============                                                         |  18%  |                                                                              |=============                                                         |  19%  |                                                                              |==============                                                        |  20%  |                                                                              |===============                                                       |  21%  |                                                                              |===============                                                       |  22%  |                                                                              |================                                                      |  23%  |                                                                              |=================                                                     |  24%  |                                                                              |==================                                                    |  25%  |                                                                              |==================                                                    |  26%  |                                                                              |===================                                                   |  27%  |                                                                              |====================                                                  |  28%  |                                                                              |====================                                                  |  29%  |                                                                              |=====================                                                 |  30%  |                                                                              |======================                                                |  31%  |                                                                              |======================                                                |  32%  |                                                                              |=======================                                               |  33%  |                                                                              |========================                                              |  34%  |                                                                              |========================                                              |  35%  |                                                                              |=========================                                             |  36%  |                                                                              |==========================                                            |  37%  |                                                                              |===========================                                           |  38%  |                                                                              |===========================                                           |  39%  |                                                                              |============================                                          |  40%  |                                                                              |=============================                                         |  41%  |                                                                              |=============================                                         |  42%  |                                                                              |==============================                                        |  43%  |                                                                              |===============================                                       |  44%  |                                                                              |================================                                      |  45%  |                                                                              |================================                                      |  46%  |                                                                              |=================================                                     |  47%  |                                                                              |==================================                                    |  48%  |                                                                              |==================================                                    |  49%  |                                                                              |===================================                                   |  50%  |                                                                              |====================================                                  |  51%  |                                                                              |====================================                                  |  52%  |                                                                              |=====================================                                 |  53%  |                                                                              |======================================                                |  54%  |                                                                              |======================================                                |  55%  |                                                                              |=======================================                               |  56%  |                                                                              |========================================                              |  57%  |                                                                              |=========================================                             |  58%  |                                                                              |=========================================                             |  59%  |                                                                              |==========================================                            |  60%  |                                                                              |===========================================                           |  61%  |                                                                              |===========================================                           |  62%  |                                                                              |============================================                          |  63%  |                                                                              |=============================================                         |  64%  |                                                                              |==============================================                        |  65%  |                                                                              |==============================================                        |  66%  |                                                                              |===============================================                       |  67%  |                                                                              |================================================                      |  68%  |                                                                              |================================================                      |  69%  |                                                                              |=================================================                     |  70%  |                                                                              |==================================================                    |  71%  |                                                                              |==================================================                    |  72%  |                                                                              |===================================================                   |  73%  |                                                                              |====================================================                  |  74%  |                                                                              |====================================================                  |  75%  |                                                                              |=====================================================                 |  76%  |                                                                              |======================================================                |  77%  |                                                                              |=======================================================               |  78%  |                                                                              |=======================================================               |  79%  |                                                                              |========================================================              |  80%  |                                                                              |=========================================================             |  81%  |                                                                              |=========================================================             |  82%  |                                                                              |==========================================================            |  83%  |                                                                              |===========================================================           |  84%  |                                                                              |============================================================          |  85%  |                                                                              |============================================================          |  86%  |                                                                              |=============================================================         |  87%  |                                                                              |==============================================================        |  88%  |                                                                              |==============================================================        |  89%  |                                                                              |===============================================================       |  90%  |                                                                              |================================================================      |  91%  |                                                                              |================================================================      |  92%  |                                                                              |=================================================================     |  93%  |                                                                              |==================================================================    |  94%  |                                                                              |==================================================================    |  95%  |                                                                              |===================================================================   |  96%  |                                                                              |====================================================================  |  97%  |                                                                              |===================================================================== |  98%  |                                                                              |===================================================================== |  99%  |                                                                              |======================================================================| 100%

# Community matrix (BCDM data converted to community matrix)
knitr::kable(head(res.rich$comm.matrix,5))
```

|                                     | Admestina.tibialis | Attidops.youngi | Attinella.concolor | Attulus.ammophilus | Attulus.cutleri | Attulus.finschi | Attulus.floricola | Attulus.pubescens | Attulus.rupicola | Attulus.striatus | Chalcoscirtus.alpicola | Chinattus.parvulus | Dendryphantes.nigromaculatus | Eris.militaris | Eris.rufa | Euophrys.monadnock | Evarcha.hoyi | Evarcha.proszynskii | Ghelna.canadensis | Habronattus.agilis | Habronattus.borealis | Habronattus.calcaratus | Habronattus.decorus | Habronattus.sansoni | Habronattus.sp..3GAB | Hentzia.mitrata | Hentzia.palmarum | Maevia.inclemens | Marpissa.formosa | Marpissa.pikei | Myrmarachne.formicaria | Naphrys.pulex | Neon.nelli | Neon.reticulatus | Peckhamia.picata | Pelegrina.aeneola | Pelegrina.clemata | Pelegrina.flaviceps | Pelegrina.flavipes | Pelegrina.galathea | Pelegrina.insignis | Pelegrina.montana | Pelegrina.proterva | Pelegrina.sp..1GAB | Pellenes.ignifrons | Pellenes.lapponicus | Pellenes.sp..1GAB | Phanias.albeolus | Phidippus.audax | Phidippus.borealis | Phidippus.clarus | Phidippus.cryptus | Phidippus.princeps | Phidippus.purpuratus | Phlegra.hentzi | Platycryptus.undatus | Salticus.scenicus | Sassacus.cf..papenhoei | Sibianor.aemulus | Sittisax.ranieri | Synageles.noxiosus | Synageles.occidentalis | Synemosyna.formica | Talavera.minuta | Terralonus.mylothrus | Tutelina.elegans | Tutelina.harti | Tutelina.similis | Zygoballus.nervosus | Zygoballus.rufipes |
|:------------------------------------|-------------------:|----------------:|-------------------:|-------------------:|----------------:|----------------:|------------------:|------------------:|-----------------:|-----------------:|-----------------------:|-------------------:|-----------------------------:|---------------:|----------:|-------------------:|-------------:|--------------------:|------------------:|-------------------:|---------------------:|-----------------------:|--------------------:|--------------------:|---------------------:|----------------:|-----------------:|-----------------:|-----------------:|---------------:|-----------------------:|--------------:|-----------:|-----------------:|-----------------:|------------------:|------------------:|--------------------:|-------------------:|-------------------:|-------------------:|------------------:|-------------------:|-------------------:|-------------------:|--------------------:|------------------:|-----------------:|----------------:|-------------------:|-----------------:|------------------:|-------------------:|---------------------:|---------------:|---------------------:|------------------:|-----------------------:|-----------------:|-----------------:|-------------------:|-----------------------:|-------------------:|----------------:|---------------------:|-----------------:|---------------:|-----------------:|--------------------:|-------------------:|
|                                     |                  0 |               0 |                  0 |                  0 |               0 |               0 |                 0 |                 0 |                0 |                0 |                      0 |                  0 |                            0 |              0 |         0 |                  0 |            0 |                   0 |                 0 |                  0 |                    1 |                      0 |                   0 |                   0 |                    0 |               0 |                0 |                0 |                0 |              0 |                      0 |             0 |          0 |               10 |                0 |                 0 |                 0 |                   0 |                  0 |                  0 |                  0 |                 0 |                  0 |                  0 |                  0 |                   0 |                 0 |                0 |               1 |                  0 |                0 |                 0 |                  0 |                    0 |              0 |                    0 |                 0 |                      0 |                0 |                0 |                  0 |                      0 |                  0 |               0 |                    0 |                0 |              0 |                0 |                   0 |                  0 |
| 10 km W Kamloops                    |                  0 |               0 |                  0 |                  0 |               0 |               0 |                 0 |                 0 |                0 |                0 |                      0 |                  0 |                            0 |              0 |         0 |                  0 |            0 |                   0 |                 0 |                  0 |                    0 |                      0 |                   0 |                   0 |                    0 |               0 |                0 |                0 |                0 |              0 |                      0 |             0 |          0 |                0 |                0 |                 0 |                 1 |                   0 |                  0 |                  0 |                  0 |                 0 |                  0 |                  0 |                  0 |                   0 |                 0 |                0 |               0 |                  0 |                0 |                 2 |                  0 |                    1 |              0 |                    0 |                 0 |                      1 |                0 |                0 |                  0 |                      0 |                  0 |               0 |                    0 |                0 |              0 |                0 |                   0 |                  0 |
| Banff National Park                 |                  0 |               0 |                  0 |                  0 |               0 |               0 |                 0 |                 0 |                0 |                1 |                      0 |                  0 |                            7 |              0 |         0 |                  0 |            1 |                   0 |                 0 |                  0 |                    0 |                      0 |                   0 |                   0 |                    0 |               0 |                0 |                0 |                0 |              0 |                      0 |             0 |          0 |                0 |                0 |                 0 |                 0 |                   0 |                  5 |                  0 |                  0 |                16 |                  0 |                  0 |                  0 |                   1 |                 0 |                0 |               0 |                  0 |                0 |                 1 |                  0 |                    0 |              0 |                    0 |                 0 |                      0 |                0 |                0 |                  0 |                      0 |                  0 |               3 |                    0 |                0 |              0 |                0 |                   0 |                  0 |
| Banff NP                            |                  0 |               0 |                  0 |                  0 |               0 |               1 |                 0 |                 0 |                0 |                0 |                      0 |                  0 |                            0 |              0 |         0 |                  0 |            0 |                   0 |                 0 |                  0 |                    0 |                      0 |                   0 |                   0 |                    0 |               0 |                0 |                0 |                0 |              0 |                      0 |             0 |          0 |                0 |                0 |                 0 |                 0 |                   0 |                  3 |                  0 |                  0 |                 4 |                  0 |                  0 |                  0 |                   0 |                 0 |                0 |               0 |                  0 |                0 |                 2 |                  0 |                    0 |              0 |                    0 |                 0 |                      0 |                0 |                0 |                  0 |                      0 |                  0 |               0 |                    0 |                0 |              0 |                0 |                   0 |                  0 |
| Cape Breton Highlands National Park |                  0 |               0 |                  0 |                  0 |               0 |               1 |                 1 |                 0 |                0 |                0 |                      0 |                  0 |                            0 |              6 |         0 |                  0 |            0 |                   0 |                 0 |                  0 |                    0 |                      0 |                   0 |                   0 |                    0 |               0 |                0 |                0 |                0 |              0 |                      0 |             0 |          1 |                0 |                0 |                 0 |                 0 |                   0 |                  1 |                  0 |                  0 |                 0 |                  0 |                  0 |                  0 |                   0 |                 0 |                0 |               0 |                  0 |                0 |                 0 |                  0 |                    0 |              0 |                    0 |                 0 |                      0 |                0 |                0 |                  0 |                      0 |                  0 |               0 |                    0 |                0 |              0 |                0 |                   0 |                  0 |

``` r

# Richness results (top 10 rows)
knitr::kable(head(res.rich$richness,5))
```

| Sampl |   Ind |   Obs |   S1 |   S2 |    Q1 |   Q2 | Jack1ab | Jack1abP | Jack1in | Jack1inP | Jack2ab | Jack2abP | Jack2in | Jack2inP | Chao1 | Chao1P | Chao2 | Chao2P |
|------:|------:|------:|-----:|-----:|------:|-----:|--------:|---------:|--------:|---------:|--------:|---------:|--------:|---------:|------:|-------:|------:|-------:|
|     1 | 15.74 |  4.08 | 1.91 | 0.78 |  4.08 | 0.00 |    5.99 |     8.07 |    4.08 |     8.16 |    7.12 |     9.99 |   12.24 |    24.48 |  5.40 |   7.28 | 17.67 |  35.34 |
|     2 | 28.35 |  7.29 | 3.40 | 1.40 |  6.71 | 0.58 |   10.69 |    13.73 |   10.64 |    19.95 |   12.69 |    16.64 |   10.64 |    19.95 |  9.99 |  13.02 | 29.40 |  56.96 |
|     3 | 43.14 | 10.71 | 4.76 | 2.20 |  9.32 | 1.27 |   15.47 |    19.17 |   16.92 |    30.16 |   18.03 |    22.63 |   19.82 |    35.41 | 14.76 |  18.53 | 37.34 |  69.23 |
|     4 | 55.17 | 13.32 | 5.66 | 2.97 | 10.97 | 2.01 |   18.98 |    23.09 |   21.55 |    36.71 |   21.67 |    26.66 |   26.36 |    45.09 | 18.10 |  22.28 | 37.92 |  66.57 |
|     5 | 69.45 | 16.01 | 6.56 | 3.41 | 12.66 | 2.61 |   22.57 |    27.04 |   26.14 |    43.03 |   25.72 |    31.11 |   32.56 |    53.82 | 21.71 |  26.31 | 43.90 |  74.45 |

#### 7b. Shannon diversity

``` r
#2. Shannon diversity
res.shannon<-bold.analyze.diversity(BCDMdata,taxon.rank="species",site.cat='region',shannon.res = TRUE)

# Shannon diversity results (top 10 rows)
knitr::kable(head(res.shannon$Shannon_div,5))
```

|                                     | Shannon_values |
|:------------------------------------|---------------:|
|                                     |           0.57 |
| 10 km W Kamloops                    |           1.33 |
| Banff National Park                 |           1.57 |
| Banff NP                            |           1.28 |
| Cape Breton Highlands National Park |           1.23 |

#### 7c. Preston plot results

``` r

#3. Preston plots and results

pres.res<-bold.analyze.diversity(BCDMdata,taxon.rank="species",site.cat='region',preston.res=TRUE)

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
#> No. of species: 70 
#> 
#>      mode     width        S0 
#>  1.508057  2.774799 12.318892 
#> 
#> Frequencies by Octave
#>                 0        1       2        3         4         5       6
#> Observed 10.00000 15.00000  8.5000  8.50000 10.000000 11.000000 2.50000
#> Fitted   10.62752 12.11412 12.1268 10.66094  8.230739  5.580548 3.32284
#>                 7         8
#> Observed 3.500000 1.0000000
#> Fitted   1.737547 0.7979179
```

#### 7d. Beta diversity

``` r

#4. beta diversity
beta.res<-bold.analyze.diversity(BCDMdata,taxon.rank="species",site.cat='region',beta.res=TRUE,beta.index = "jaccard")

# # Total beta diversity matrix (10 rows)
knitr::kable(head(as.matrix(round(beta.res$total.beta,2)),5))
```

|                                     |     | 10 km W Kamloops | Banff National Park | Banff NP | Cape Breton Highlands National Park | Cape Breton Highlands NP | Churchill | Douglas | Durham Region | Edson | Elk Island National Park | Elk Island NP | Firth River | Fundy National Park | Fundy NP | Georgian Bay Islands National Park | Glacier NP | Grasslands National Park | Grasslands NP | Great Toronto Area | Grey County | Gros Morne NP | Guelph | Haida Gwaii | Haldimond-Dunn Townline | Halifax | Humber Watershed | Jasper National Park | Jasper NP | Kejimkujik | Kejimkujik National Park | Kejimkujik NP | Kootenay NP | Kouchibouguac National Park | Kouchibouguac NP | La Mauricie National Park | Lanark Co. | Leeds and Grenville | Mount Revelstoke NP | Near Winnipeg | Oshawa | Pacific Rim NP | Parry Sound distr. | Parry Sound Distr. | Point Pelee National Park | Point Pelee NP | Prince Albert National Park | Prince Albert NP | Prince Alberta NP | Prince Edward Island National Park | Prince Edward Island NP | Pukaskwa NP | Puslinch | Riding Mountain National Park | Riding Mountain NP | Rouge National Urban Park | Rouge Park | Saturna Island | St. Thomas | Stagleap Provincial Park | Terra Nova National Park | Terra Nova NP | Thousand Islands National Park | Toronto | Toronto-Zoo | Waterton Lakes National Park | Waterton Lakes NP | Wawa | Wellington Co. | Wellington County | Windsor, | Wood Buffalo National Park | Wood Buffalo NP | Yoho NP | York Co. |
|:------------------------------------|----:|-----------------:|--------------------:|---------:|------------------------------------:|-------------------------:|----------:|--------:|--------------:|------:|-------------------------:|--------------:|------------:|--------------------:|---------:|-----------------------------------:|-----------:|-------------------------:|--------------:|-------------------:|------------:|--------------:|-------:|------------:|------------------------:|--------:|-----------------:|---------------------:|----------:|-----------:|-------------------------:|--------------:|------------:|----------------------------:|-----------------:|--------------------------:|-----------:|--------------------:|--------------------:|--------------:|-------:|---------------:|-------------------:|-------------------:|--------------------------:|---------------:|----------------------------:|-----------------:|------------------:|-----------------------------------:|------------------------:|------------:|---------:|------------------------------:|-------------------:|--------------------------:|-----------:|---------------:|-----------:|-------------------------:|-------------------------:|--------------:|-------------------------------:|--------:|------------:|-----------------------------:|------------------:|-----:|---------------:|------------------:|---------:|---------------------------:|----------------:|--------:|---------:|
|                                     |   0 |             1.00 |                1.00 |     1.00 |                                1.00 |                     1.00 |      1.00 |       1 |             1 |  1.00 |                     1.00 |          0.92 |           1 |                1.00 |     1.00 |                               1.00 |          1 |                     1.00 |          1.00 |               0.83 |        1.00 |          1.00 |      1 |           1 |                     1.0 |    1.00 |             0.93 |                 1.00 |      1.00 |        1.0 |                        1 |          1.00 |        1.00 |                         1.0 |             1.00 |                      1.00 |       1.00 |                1.00 |                1.00 |           1.0 |      1 |            0.8 |               1.00 |               1.00 |                         1 |           0.95 |                        1.00 |             1.00 |              1.00 |                                1.0 |                     1.0 |        1.00 |        1 |                          1.00 |               1.00 |                      0.93 |       1.00 |           1.00 |          1 |                     1.00 |                     1.00 |          1.00 |                           1.00 |    0.67 |        0.91 |                         1.00 |              1.00 | 1.00 |           0.94 |                 1 |      0.9 |                       1.00 |            1.00 |    1.00 |     0.75 |
| 10 km W Kamloops                    |   1 |             0.00 |                0.91 |     0.86 |                                1.00 |                     1.00 |      1.00 |       1 |             1 |  1.00 |                     1.00 |          0.85 |           1 |                1.00 |     1.00 |                               1.00 |          1 |                     0.86 |          0.50 |               1.00 |        1.00 |          1.00 |      1 |           1 |                     1.0 |    1.00 |             1.00 |                 0.92 |      0.92 |        1.0 |                        1 |          1.00 |        0.83 |                         1.0 |             0.90 |                      1.00 |       1.00 |                1.00 |                1.00 |           1.0 |      1 |            1.0 |               0.89 |               0.83 |                         1 |           1.00 |                        1.00 |             0.86 |              1.00 |                                1.0 |                     1.0 |        1.00 |        1 |                          1.00 |               1.00 |                      1.00 |       1.00 |           0.80 |          1 |                     1.00 |                     1.00 |          1.00 |                           1.00 |    1.00 |        1.00 |                         0.78 |              0.91 | 1.00 |           1.00 |                 1 |      1.0 |                       1.00 |            0.93 |    1.00 |     1.00 |
| Banff National Park                 |   1 |             0.91 |                0.00 |     0.67 |                                0.92 |                     1.00 |      0.75 |       1 |             1 |  1.00 |                     0.89 |          0.81 |           1 |                0.83 |     0.89 |                               0.89 |          1 |                     1.00 |          0.82 |               1.00 |        1.00 |          0.82 |      1 |           1 |                     1.0 |    1.00 |             0.95 |                 0.71 |      0.58 |        1.0 |                        1 |          1.00 |        0.78 |                         1.0 |             0.93 |                      0.90 |       0.89 |                1.00 |                1.00 |           1.0 |      1 |            1.0 |               1.00 |               1.00 |                         1 |           1.00 |                        0.91 |             0.67 |              0.89 |                                1.0 |                     1.0 |        0.90 |        1 |                          0.89 |               0.73 |                      0.95 |       0.89 |           0.89 |          1 |                     0.88 |                     0.88 |          0.90 |                           1.00 |    1.00 |        1.00 |                         0.75 |              0.67 | 0.88 |           0.84 |                 1 |      1.0 |                       1.00 |            0.73 |    0.73 |     1.00 |
| Banff NP                            |   1 |             0.86 |                0.67 |     0.00 |                                0.71 |                     1.00 |      0.78 |       1 |             1 |  1.00 |                     1.00 |          0.85 |           1 |                0.89 |     1.00 |                               1.00 |          1 |                     1.00 |          0.88 |               1.00 |        1.00 |          0.88 |      1 |           1 |                     1.0 |    1.00 |             1.00 |                 0.60 |      0.56 |        1.0 |                        1 |          1.00 |        0.83 |                         1.0 |             1.00 |                      0.83 |       1.00 |                1.00 |                1.00 |           1.0 |      1 |            1.0 |               1.00 |               1.00 |                         1 |           1.00 |                        0.86 |             0.67 |              0.80 |                                1.0 |                     1.0 |        0.83 |        1 |                          0.80 |               0.75 |                      1.00 |       1.00 |           0.80 |          1 |                     1.00 |                     1.00 |          0.83 |                           1.00 |    1.00 |        1.00 |                         0.62 |              0.80 | 0.75 |           0.94 |                 1 |      1.0 |                       1.00 |            0.64 |    0.75 |     1.00 |
| Cape Breton Highlands National Park |   1 |             1.00 |                0.92 |     0.71 |                                0.00 |                     0.83 |      0.80 |       1 |             1 |  0.83 |                     0.83 |          0.77 |           1 |                0.78 |     0.83 |                               1.00 |          1 |                     0.88 |          1.00 |               1.00 |        0.86 |          0.89 |      1 |           1 |                     0.8 |    0.86 |             0.88 |                 0.50 |      0.73 |        0.8 |                        1 |          0.67 |        0.86 |                         0.8 |             0.80 |                      0.67 |       1.00 |                0.91 |                0.83 |           0.8 |      1 |            1.0 |               0.90 |               1.00 |                         1 |           0.96 |                        0.88 |             0.88 |              0.83 |                                0.8 |                     0.8 |        0.86 |        1 |                          1.00 |               0.78 |                      0.88 |       1.00 |           1.00 |          1 |                     1.00 |                     1.00 |          0.67 |                           0.86 |    1.00 |        1.00 |                         0.67 |              0.92 | 0.80 |           0.81 |                 1 |      1.0 |                       0.86 |            0.67 |    0.78 |     1.00 |

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

# Visualizing all occurrences
geo.viz<-bold.analyze.map(map.data)
```

<img src="man/figures/README-visualize.geo-1.png" width="100%" style="display: block; margin: auto;" />

``` r

# Visualizing occurrences in a specific country
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

## Note on the community matrix generated for `bold.analyze.diversity`

Each cell in the community matrix contains the counts (or abundances) of
the specimens for whose sequences have an assigned BIN, in a given a
site category (site.cat) or a grid (grids.cat). These counts can be
generated at any taxonomic hierarchical level, applicable to one or
multiple taxa including ’bin_uri’. The `site.cat` can refer to any
geographic field, and metadata on these fields can be checked using the
`bold.fields.info()`. If, `grids.cat` = TRUE, grids are generated based
on BIN occurrence data (latitude, longitude) with grid size determined
by the user in square meters using the gridsize argument. Rows lacking
latitude and longitude data are removed, while NULL entries for
`site.cat` are allowed if they have a latitude and longitude value. This
is because grids are drawn based on the bounding boxes which only use
latitude and longitude values.

#### *BOLDconnectR* is able to fetch public as well as private user data very fast (~100k records in a minute on a fast wired connection) and also offers functionality for data transformation and analysis.
