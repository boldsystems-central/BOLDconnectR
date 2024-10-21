
<!-- README.md is generated from README.Rmd. Please edit that file -->

<img src="man/figures/boldconnectr_logo.png" width="25%" />

<!-- badges: start -->
<!-- badges: end -->

**BOLDconnectR** is a package designed for **retrieval**,
**transformation** and **analysis** of the data available in the
*Barcode Of Life Data Systems (BOLD)* database. This package provides
the functionality to obtain public and private user data available in
the database in the *Barcode Core Data Model (BCDM)* format. Data
include information on the
**taxonomy**,**geography**,**collection**,**identification** and **DNA
barcode sequence** of every submission. The manual is currently hosted
here
(<https://github.com/boldsystems-central/BOLDconnectR_examples/blob/main/BOLDconnectR_1.0.0.pdf>)

## Installation

The package can be installed using `devtools::install_github` function
from the `devtools` package in R (which needs to be installed before
installing BOLDConnectR).

``` r

devtools::install_github("https://github.com/boldsystems-central/BOLDconnectR")
```

``` r
library(BOLDconnectR)
```

## BOLDconnectR has 10 functions currently:

1.  bold.fields.info
2.  bold.apikey
3.  bold.fetch
4.  bold.public.search
5.  bold.data.summarize
6.  *bold.analyze.align*
7.  bold.analyze.tree
8.  bold.analyze.diversity
9.  bold.analyze.map
10. bold.export

*Function 6 requires the packages `msa` and `Biostrings` to be installed
and imported beforehand. Function 7 also uses the the output generated
from function 6.*

*NOTE* `msa` and `Biostrings` can be installed using using `BiocManager`
package.

``` r

if (!requireNamespace("BiocManager", quietly=TRUE))
install.packages("BiocManager")

BiocManager::install("msa")
BiocManager::install("Biostrings")

library(msa)
library(Biostrings)
```

### Note on API key

The function `bold.fetch` requires an `api key` internally in order to
access and download all public + private user data. API key can be
obtained by emailing the BOLD support (<support@boldsystems.org>). API
key can be saved in the R session using `bold.apikey()` function.

``` r
# bold_apikey(‘00000000-0000-0000-0000-000000000000’)
```

### A working example of basic BOLDConnectR functionality

API key function must be run prior to using the fetch function
(bold.apikey())

``` r

BCDM_data<-bold.fetch(get_by = "processid",
                      identifiers = test.data$processid)
#> [32mInitiating download[0m
#> [31m Downloading data in a single batch [0m 
#> [32mDownload complete & BCDM dataframe generated[0m

knitr::kable(head(BCDM_data,4))
```

| processid | record_id | insdc_acs | sampleid | specimenid | taxid | short_note | identification_method | museumid | fieldid | collection_code | processid_minted_date | inst | funding_src | sex | life_stage | reproduction | habitat | collectors | site_code | specimen_linkout | collection_event_id | sampling_protocol | tissue_type | collection_date_start | collection_time | associated_taxa | associated_specimens | voucher_type | notes | taxonomy_notes | collection_notes | geoid | marker_code | kingdom | phylum | class | order | family | subfamily | tribe | genus | species | subspecies | identification | identification_rank | species_reference | identified_by | sequence_run_site | nuc | nuc_basecount | sequence_upload_date | bin_uri | bin_created_date | elev | depth | coord | coord_source | coord_accuracy | elev_accuracy | depth_accuracy | realm | biome | ecoregion | region | sector | site | country_iso | country.ocean | province.state | bold_recordset_code_arr | collection_date_end |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|---:|:---|:---|:---|---:|---:|:---|:---|---:|---:|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| SSPAA9305-13 | SSPAA9305-13.COI-5P | KM839404 | BIOUG06347-H09 | 3391924 | 9199 | Prince Albert NP |  | BIOUG06347-H09 | L#12BIOBUS-0979 | BIOUG | 2013-06-13 | Centre for Biodiversity Genomics | iBOL:WG1.9 | NA | NA | NA | Wetland | BIOBus 2012 | BIOUG:PRINCEALB-NP:3 | NA | NA | Sweep Net | Whole Voucher | 2012-07-14 | NA | NA | NA | Vouchered:Registered Collection | NA | NA | 5 minute sweep x 4 collectors (3)\|mostly sunny with some cloud cover and haze\|25C\|tamarack and black spruce bog | 511 | COI-5P | Animalia | Arthropoda | Arachnida | Araneae | Salticidae | NA | NA | Eris | Eris militaris | NA | Eris militaris | species | Hentz, 1845 | Gergin A. Blagoev | Centre for Biodiversity Genomics | AACGTTATATTTAATTTTTGGAGCTTGATCAGCTATAGTTGGTACTGCTATAAGAGTATTAATTCGAATA—GAATTAGGACAAACTGGATCATTTTTA—GGTAATGATCATATATATAATGTAATTGTAACTGCTCATGCTTTTGTAATGATTTTTTTTATAGTAATACCAATTATAATTGGGGGATTTGGTAATTGATTAGTTCCTTTAATGTTAGGGGCTCCGGATATAGCTTTTCCTCGAATAAATAATTTAAGTTTTTGATTATTACCTCCTTCTTTATTTTTATTATTTATTTCTTCTATAGCTGAAATAGGAGTTGGAGCTGGATGAACAGTATATCCTCCTTTGGCATCTATTGTTGGACATAATGGTAGATCAGTAGATTTTGCTATTTTTTCTTTACATTTAGCTGGTGCTTCATCAATTATAGGAGCTATTAATTTTATTTCTACTATTATTAATATACGATCAGTAGGAATATCTTTAGATAAAATTCCTTTATTTGTTTGATCTGTAATAATTACTGCTGTATTATTATTGTTATCATTACCTGTTTTAGCAGGAGCTATTACTATATTATTAACTGATCGAAATTTTAATACTTCTTTTTTTG———————————————————— | 614 | 2014-08-07 | BOLD:AAA5654 | 2010-07-15 | 570 | NA | 53.90546,-106.02454 | GPSmap 60Cx | NA | NA | NA | Nearctic | NA | Mid-Canada_Boreal_Plains_forests | Prince Albert National Park | Boundary Bog Trail | NA | CA | Canada | Saskatchewan | SSPAA,DS-MOB112,DS-MOB113,DS-BICNP02,DS-SOC2014,DS-ARANCCYH,DATASET-BBPANP1,DS-SPCANADA,DS-JUMPGLOB,DS-SALTEST | NA |
| RBINA4896-13 | RBINA4896-13.COI-5P | KP657341 | BIOUG08040-G09 | 3755529 | 560524 | Rouge NP | NA | BIOUG08040-G09 | ON13-C0084 | BIOUG | 2013-09-20 | Centre for Biodiversity Genomics | iBOL:WG1.9 | NA | NA | NA | NA | BIO Team | NA | NA | NA | Sweep Net | Whole Voucher | 2013-09-15 | NA | NA | NA | Vouchered:Registered Collection | NA | CollectionsID | 5 min sweep | 528 | COI-5P | Animalia | Arthropoda | Arachnida | Araneae | Salticidae | NA | NA | Pelegrina | Pelegrina galathea | NA | Pelegrina galathea | species | Walckenaer, 1837 | NA | Biodiversity and Climate Research Centre, Germany | -ACTTTATATTTAATTTTTGGAGCTTGATCAGCTATAGTTGGAACTGCTATA—AGAGTATTAATTCGTATAGAATTAGGACAGACTGGTTCATTTTTAGGAAAT—GATCATATGTATAATGTAATTGTAACTGCACATGCTTTTGTTATAATTTTTTTTATGGTAATACCGATTTTAATTGGTGGATTTGGTAATTGATTAGTTCCTTTAATA—TTGGGAGCTCCTGATATAGCTTTTCCTCGTATAAATAATTTAAGATTTTGATTATTACCTCCTTCTTTATTTTTATTATTTATTTCTTCTATGGCTGAAATAGGAGTAGGGGCTGGATGAACTGTATATCCACCTTTAGCTTCTATTGTAGGACATAATGGAAGATCAGTAGACTTT—GCAATTTTTTCTTTACATTTAGCTGGTGCTTCATCAATCATAGGAGCTATTAATTTTATTTCTACTATTATTAATATACGATCTTTAGGAATATCTTTTGATAAGGTTCCTTTATTTGTTTGATCCGTTTTAATTACTGCTGTTTTGTTATTACTTTCGTTACCGGTTTTAGCAGGA——————————————————————— | 564 | 2013-10-04 | BOLD:AAB2930 | 2010-07-15 | 151 | NA | 43.816,-79.207 | GPS | NA | NA | NA | Nearctic | NA | Southern_Great_Lakes_forests | Rouge National Urban Park | NA | Sector 10 | CA | Canada | Ontario | RBINA,DS-RBSS,DS-RPB13,DS-MOB112,DS-MOB113,DS-SOC2014,DS-MYBCA,DS-JALPHA,DS-ROUGENP,DS-ARANCCYH,DS-BBRNUP1,DS-SPCANADA,DS-JUMPGLOB | NA |
| SPICA1741-11 | SPICA1741-11.COI-5P | JF885323 | BIOUG00520-D04 | 1806525 | 9199 | Elk Island NP |  | BIOUG00520-D04 | BIObus2010CA-053 | BIOUG | 2011-01-06 | Centre for Biodiversity Genomics | iBOL:WG1.9 | NA | I | S | Mixed habitat | BIObus 2010 | NA | NA | NA | UV Light Trap | NA | 2010-08-07 | NA | NA | NA | Vouchered:Registered Collection | NA | NA | \|Hot,sunny\|Aspen forest and sedge meadows | 533 | COI-5P | Animalia | Arthropoda | Arachnida | Araneae | Salticidae | NA | NA | Eris | Eris militaris | NA | Eris militaris | species | Hentz, 1845 | Gergin A. Blagoev | Centre for Biodiversity Genomics | AACGTTATATTTAATTTTTGGAGCTTGATCAGCTATAGTTGGTACTGCTATAAGAGTATTAATTCGAATAGAATTAGGACAAACTGGATCATTTTTAGGTAATGATCATATATATAATGTAATTGTAACTGCTCATGCTTTTGTAATGATTTTTTTTATAGTAATACCAATTATAATTGGGGGATTTGGTAATTGGTTAGTTCCTTTAATGTTAGGGGCTCCGGATATAGCTTTTCCTCGAATAAATAATTTAAGTTTTTGATTATTACCTCCTTCTTTATTTTTATTGTTTATTTCTTCTATAGCTGAAATAGGGGTTGGAGCTGGATGAACAGTATATCCTCCTTTGGCATCTATTGTTGGACATAATGGTAGATCAGTAGATTTTGCTATTTTTTCTTTACATTTAGCTGGTGCTTCATCAATTATAGGAGCTATTAATTTTATTTCTACTATTATTAATATACGATCAGTAGGAATATCTTTAGATAAAATTCCTTTATTTGTTTGATCTGTAATAATTACTGCTGTATTATTATTGTTATCATTACCTGTTTTAGCAGGAGCTATTACTATATTATTAACTGATCGAAATTTTAATACTTCTTTTTTTGATCCTGCAGGAGGAGGAGATCCAATTTTGTTTCAACATTTATTT | 658 | 2011-03-18 | BOLD:AAA5654 | 2010-07-15 | 733 | NA | 53.687,-112.813 | NA | NA | NA | NA | Nearctic | NA | Canadian_Aspen_forests_and_parklands | Elk Island NP | Beaver Pond Trail | NA | CA | Canada | Alberta | SPIBB,DS-MOB112,DS-MOB113,DS-BICNP02,DS-SOC2014,DS-ARANCCYH,DATASET-BBEINP1,DS-SPCANADA,DS-JUMPGLOB | NA |
| HPPPD1434-13 | HPPPD1434-13.COI-5P | KP654153 | BIOUG07077-G01 | 3525093 | 30494 | NA | NA | BIOUG07077-G01 | GMP#01736 | BIOUG | 2013-08-13 | Centre for Biodiversity Genomics | iBOL:WG1.9 | NA | NA | NA | NA | Tyler Zemlak | BIOUG:HALIFAX | NA | NA | Malaise Trap | NA | 2013-06-29 | NA | NA | NA | Vouchered:Registered Collection | Date range on label was Jun 22-29 but believe it to be mislabeled | CollectionsID | NA | 506 | COI-5P | Animalia | Arthropoda | Arachnida | Araneae | Salticidae | NA | NA | Naphrys | Naphrys pulex | NA | Naphrys pulex | species | Hentz, 1846 | NA | Centre for Biodiversity Genomics | AACATTATATTTGATTTTTGGTGCTTGATCAGCTATAGTAGGTACGGCTATAAGAGTTTTGATTCGAATAGAGTTGGGACAGACTGGTAATTTTTTGGGAAATGATCATTTATATAATGTTATTGTAACTGCTCATGCTTTTGTTATAATTTTTTTTATAGTAATACCTATTTTGATTGGTGGTTTTGGTAATTGATTAGTGCCATTAATATTAGGGGCTCCTGATATAGCTTTTCCTCGGATAAATAATCTGAGATTCTGGTTATTGCCTCCTTCATTAATACTTTTATTTATGTCTTCAATAGTGGAGATAGGAGTAGGAGCAGGGTGAACAGTATATCCCCCATTAGCTTCTGTTGTGGGTCATAGTGGTAGATCTGTTGATTTTGCTATTTTTTCTTTACATTTAGCAGGGGCTTCTTCTATTATAGGAGCAGTTAATTTTATTTCTACTATTATTAATATGCGTGTATTAGGCATAAGAATAGATAAGATTCCTTTGTTTGTTTGGTCAGTTGGAATTACTGCTGTATTATTGTTATTATCATTACCAGTGTTGGCTGGTGCTATTACAATATTGTTGACTGATCGTAATTTTAATACATCTTTTTTTGATCCTGCGGGAGGAGGGGATCCGGTTTTGTTTCAGCATTTATTT— | 658 | 2014-09-05 | BOLD:ACY0365 | 2015-11-16 | 30 | NA | 44.623,-63.569 | NA | NA | NA | NA | Nearctic | NA | NA | Halifax | Point Pleasant Park | NA | CA | Canada | Nova Scotia | HPPPD,DS-MOB112,DS-MOB113,DS-SOC2014,DS-MALCAN,DS-IDTEST,DS-ARANCCYH,DS-CDABRL,DS-SPCANADA,DS-GMPC1,DS-JUMPGLOB,DS-20GMP14,DS-VALARCA,DS-CANREF2,DS-CANREF22 | 2013-07-06 |

Downloaded data can then be summarized in differnt ways

``` r

BCDM_data_summary<-bold.data.summarize(bold_df = BCDM_data,
                               summarize_by = 'presets',
                               presets = "geography")
#> ── Data Summary ────────────────────────
#>                            Values    
#> Name                       Piped data
#> Number of rows             1336      
#> Number of columns          12        
#> _______________________              
#> Column type frequency:               
#>   character                11        
#>   numeric                  1         
#> ________________________             
#> Group variables            None
```

<img src="man/figures/README-summarize the data-1.png" width="100%" />

``` r

BCDM_data_summary$summary
```

|                                                  |            |
|:-------------------------------------------------|:-----------|
| Name                                             | Piped data |
| Number of rows                                   | 1336       |
| Number of columns                                | 12         |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_   |            |
| Column type frequency:                           |            |
| character                                        | 11         |
| numeric                                          | 1          |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ |            |
| Group variables                                  | None       |

Data summary

**Variable type: character**

| skim_variable  | n_missing | complete_rate | min | max | empty | n_unique | whitespace |
|:---------------|----------:|--------------:|----:|----:|------:|---------:|-----------:|
| processid      |         0 |          1.00 |  10 |  13 |     0 |     1336 |          0 |
| sampleid       |         0 |          1.00 |   8 |  15 |     0 |     1336 |          0 |
| country.ocean  |         0 |          1.00 |   6 |   6 |     0 |        1 |          0 |
| country_iso    |         0 |          1.00 |   2 |   2 |     0 |        1 |          0 |
| province.state |         0 |          1.00 |   6 |  25 |     0 |       12 |          0 |
| region         |       134 |          0.90 |   0 |  35 |    12 |       75 |          0 |
| sector         |       176 |          0.87 |   5 |  83 |     0 |      232 |          0 |
| site           |       568 |          0.57 |   0 | 106 |    16 |      179 |          0 |
| site_code      |      1047 |          0.22 |  12 |  20 |     0 |       37 |          0 |
| coord          |         0 |          1.00 |  11 |  19 |     0 |      302 |          0 |
| coord_source   |       461 |          0.65 |   0 |  28 |    91 |        8 |          0 |

**Variable type: numeric**

| skim_variable  | n_missing | complete_rate | mean |  sd |  p0 | p25 | p50 | p75 | p100 | hist  |
|:---------------|----------:|--------------:|-----:|----:|----:|----:|----:|----:|-----:|:------|
| coord_accuracy |      1335 |             0 |    5 |  NA |   5 |   5 |   5 |   5 |    5 | ▁▁▇▁▁ |

Downloaded data can also be exported to the local machine either as a
flat file or as a FASTA file for any third party sequence analysis
tools.The flat file contents can be modified as per user requirements
(entire data or specific presets or individual fields).

``` r
# bold.export(bold_df = BCDM_data,
#             export_type = "preset_df",
#             presets = 'taxonomy',
#             export_to = "file_path_with_intended_name")
```

The package also has analyses functions that provide sequence alignment,
NJ clustering, biodiversity analysis, occurrence mapping using the
downloaded BCDM data. Additionally, these functions also output objects
that are commonly used by other R packages (‘sf’ dataframe, occurrence
matrix).

*BOLDconnectR* is able to fetch public as well as private user data very
fast (~100k records in a minute on a fast wired connection) and also
offers functionality for data transformation and analysis.

*Citation:* Padhye SM, Agda TJA, Agda JRA, Ballesteros-Mejia CL,
Ratnasingham S. BOLDconnectR: An R package for interacting with the
Barcode of Life Data (BOLD) system.(MS in prep)
