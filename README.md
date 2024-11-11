
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

**BOLDconnectR** requires **R** version **4.0** or above to function
properly. The versions of dependent packages have also been set to
work with **R \>= 4.0**. In addition, there are a few
suggested packages that are not mandatory for BOLDconnectR to download
and install properly, but, are essential for a couple of functions to
work. The names and exact versions of the dependencies/suggestions are
given here ('Imports' and 'Suggests' section)
(<https://github.com/boldsystems-central/BOLDconnectR/blob/main/DESCRIPTION>).
More details on how to install the *Suggested packages* are provided below.

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
access and download all public + private user data. The API key needed
to retrieve BOLD records is found in the BOLD ‘Workbench’
<https://bench.boldsystems.org/index.php/Login/page?destination=MAS_Management_UserConsole>.
After logging in, navigate to ‘Your Name’ (located at the top left-hand
side of the window) and click ‘Edit User Preferences’. You can find the
API key in the ‘User Data’ section. Please note that to have an API key
available in the workbench, a user must have uploaded at least 10,000
records to BOLD. API key can be saved in the R session using
`bold.apikey()` function.

``` r
# Substitute ‘00000000-0000-0000-0000-000000000000’ with your key
# bold.apikey(‘00000000-0000-0000-0000-000000000000’)
```

### Basic usage of BOLDConnectR functionality

API key function must be run prior to using the fetch function (Please
see above).

#### Fetch data

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
| BBCNP1869-14 | BBCNP1869-14.COI-5P | KP653969 | BIOUG12563-F04 | 4467470 | 9199 | Wood Buffalo NP | NA | BIOUG12563-F04 | L#12BIOBUS-0140 | BIOUG | 2014-04-21 | Centre for Biodiversity Genomics | iBOL:WG1.9 | NA | I | S | NA | BIOBus 2012 | NA | NA | NA | Free Hand Collection | NA | 2012-06-03 | NA | NA | NA | museum voucher | hand collecting\|warm and sunny | CollectionsID | NA | 533 | COI-5P | Animalia | Arthropoda | Arachnida | Araneae | Salticidae | NA | NA | Eris | Eris militaris | NA | Eris militaris | species | Hentz, 1845 | Gergin A. Blagoev | Centre for Biodiversity Genomics | TTAATTTTTGGAGCTTGATCAGCTATAGTTGGTACTGCTATAAGAGTATTAATTCGAATAGAATTAGGACAAACTGGATCATTTTTAGGTAATGATCATATATATAATGTAATTGTAACTGCTCATGCTTTTGTAATGATTTTTTTTATAGTAATACCAATTATAATTGGGGGATTTGGTAATTGGTTAGTTCCTTTAATGTTAGGGGCTCCGGATATAGCTTTTCCTCGAATAAATAATTTAAGTTTTTGATTATTACCTCCTTCTTTATTTTTATTATTTATTTCTTCTATAGCTGAAATAGGGGTTGGAGCTGGATGAACAGTATATCCTCCTTTGGCATCTATTGTTGGACATAATGGTAGATCAGTAGATTTTGCTATTTTTTCTTTACATTTAGCTGGTGCCTCATCAATTATAGGAGCTATTAATTTTATTTCTACTATTATTAATATACGATCAGTAGGAATATCTTTAGATAAAATTCCTTTATTTGTTTGATCTGTAATAATTACTGCTGTATTATTATTGTTATCATTACCTGTTTTAGCA——————————————————————————— | 552 | 2014-06-26 | BOLD:AAA5654 | 2010-07-15 | 276 | NA | 59.536,-112.231 | GPSmap 60Cx | NA | NA | NA | Nearctic | NA | Muskwa-Slave_Lake_taiga | Wood Buffalo NP | Pine Lake Campground | mature forest, black spruce/aspen\|by the lake | CA | Canada | Alberta | BBCNP,DS-SOC2014,DS-ARANCCYH,DS-BBWBNP1,DS-SPCANADA,DS-JUMPGLOB | NA |
| CNWLG866-12 | CNWLG866-12.COI-5P | KM834791 | BIOUG04328-E12 | 3000805 | 9199 | Waterton Lakes NP | BOLD ID Engine: top hits | BIOUG04328-E12 | GMP#00286 | BIOUG | 2012-12-06 | Centre for Biodiversity Genomics | iBOL:WG1.9 | NA | NA | S | Forest | Emma Sylvester | BIOUG:WATERTON-NP:4 | NA | NA | Malaise Trap | Whole Voucher | 2012-08-14 | NA | NA | NA | Vouchered:Registered Collection | NA | NA | Aspen forest | 533 | COI-5P | Animalia | Arthropoda | Arachnida | Araneae | Salticidae | NA | NA | Eris | Eris militaris | NA | Eris militaris | species | Hentz, 1845 | Monica R. Young | Centre for Biodiversity Genomics | -ACGTTATATTTAATTTTTGGAGCTTGATCAGCTATAGTTGGTACTGCTATA—AGAGTATTAATTCGAATAGAATTAGGACAAACTGGATCATTTTTAGGTAAT—GATCATATATATAATGTAATTGTAACTGCTCATGCTTTTGTAATGATTTTTTTTATAGTAATACCAATTATAATTGGGGGATTTGGTAATTGGTTAGTTCCTTTAATG—TTAGGGGCTCCGGATATAGCTTTTCCTCGAATAAATAATTTAAGTTTTTGATTATTACCTCCTTCTTTATTTTTATTGTTTATTTCTTCTATAGCTGAAATAGGGGTTGGAGCTGGATGAACAGTATATCCTCCTTTGGCATCTATTGTTGGACATAATGGTAGATCAGTAGATTTT—GCTATTTTTTCTTTACATTTAGCTGGTGCTTCATCAATTATAGGAGCTATTAATTTTATTTCTACTATTATTAATATACGATCAGTAGGAATATCTTTAGATAAAATTCCTTTATTTGTTTGATCTGTAATAATTACTGCTGTATTATTATTGTTATCATTACCTGTTTTAGCAGGA————————————————————————————————— | 564 | 2013-06-27 | BOLD:AAA5654 | 2010-07-15 | 1338 | NA | 49.083,-113.876 | GPS | NA | NA | NA | Nearctic | NA | Northern_Rockies_conifer_forests | Waterton Lakes National Park | Hwy 6, just east of Hwy 5 | Foothills Parkland Region | CA | Canada | Alberta | CNWLG,DS-MOB112,DS-MOB113,DS-BICNP02,DS-SOC2014,DS-MYBCA,DS-JALPHA,DS-ARANCCYH,DATASET-BBWLNP1,DS-SPCANADA,DS-JUMPGLOB,DS-20GMP12 | 2012-08-21 |
| PPELE427-11 | PPELE427-11.COI-5P | JN308615 | BIOUG00625-G08 | 1913522 | 560524 | Point Pelee NP |  | BIOUG00625-G08 | L#10PCPP-0233 | BIOUG | 2011-03-14 | Centre for Biodiversity Genomics | iBOL:WG1.9 | M | A | S | Forest | T.F.Mitterboeck, C.Vandermeer, V.Junea, C.Sobel | NA | NA | NA | Sweep Net |  | 2010-06-23 | NA | NA | NA | Vouchered:Registered Collection | NA | NA | Sweep Net 38\|\|Mixed Carolinian forest with open sunny camp grounds and grasses | 528 | COI-5P | Animalia | Arthropoda | Arachnida | Araneae | Salticidae | NA | NA | Pelegrina | Pelegrina galathea | NA | Pelegrina galathea | species | Walckenaer, 1837 | Gergin A. Blagoev | Centre for Biodiversity Genomics | AACTTTATATTTAATTTTTGGAGCTTGATCAGCTATAGTTGGAACCGCTATAAGAGTATTAATTCGTATAGAATTAGGACAGACTGGTTCATTTTTAGGAAATGATCATATGTATAATGTAATTGTAACTGCACATGCTTTTGTTATAATTTTTTTTATGGTAATACCGATTTTAATTGGTGGATTTGGTAATTGATTAGTTCCTTTAATATTGGGAGCTCCTGATATAGCTTTTCCTCGTATAAATAATTTAAGATTTTGGCTATTACCTCCTTCTTTATTTTTATTATTTATTTCTTCTATGGCTGAAATAGGAGTAGGGGCTGGGTGAACTGTATATCCACCTTTAGCTTCTATTGTAGGACATAATGGAAGATCAGTAGACTTTGCAATTTTTTCTTTACATTTAGCTGGTGCTTCATCAATCATAGGAGCTATTAATTTTATTTCTACTATTATTAATATACGATCTTTAGGAATATCTTTTGATAAGGTTCCTTTATTTGTTTGATCCGTTTTAATTACTGCTGTTTTGTTATTACTTTCGTTACCGGTTTTAGCAGGAGCTATTACTATATTATTAACTGATCGAAATTTTAATACTTCTTTTTTTGATCCTGCAGGTGGAGGTGATCCTATTTTATTTCAACATTTATTT | 658 | 2011-04-27 | BOLD:AAB2930 | 2010-07-15 | 185 | NA | 41.936,-82.516 | NA | NA | NA | NA | Nearctic | NA | Southern_Great_Lakes_forests | Point Pelee NP | 15km SE of Leamington | Camp Henry, Big and Little Raccon Sites | CA | Canada | Ontario | PPELE,DATASET-BBPPNP1,DS-MOB112,DS-MOB113,DS-BICNP02,DS-SOC2014,DS-ARANCCYH,DS-SPCANADA,DS-JUMPGLOB,DS-VALARCA,DS-CANREF2,DS-CANREF22 | NA |
| RBINA825-13 | RBINA825-13.COI-5P | KP649596 | BIOUG07962-E01 | 3743082 | 560524 | Rouge NP | NA | BIOUG07962-E01 | ON13-C0022 | BIOUG | 2013-09-18 | Centre for Biodiversity Genomics | iBOL:WG1.9 | NA | A | NA | NA | BIO Team | NA | NA | NA | Sweep Net | Whole Voucher | 2013-09-15 | NA | NA | NA | Vouchered:Registered Collection | NA | CollectionsID | 5 min sweep | 528 | COI-5P | Animalia | Arthropoda | Arachnida | Araneae | Salticidae | NA | NA | Pelegrina | Pelegrina galathea | NA | Pelegrina galathea | species | Walckenaer, 1837 | NA | Biodiversity and Climate Research Centre, Germany | -ACTTTATATTTAATTTTTGGAGCTTGATCAGCTATAGTTGGAACCGCTATA—AGAGTATTAATTCGTATAGAATTAGGACAGACTGGTTCATTTTTAGGAAAT—GATCATATGTATAATGTAATTGTAACTGCACATGCTTTTGTTATAATTTTTTTTATAGTAATACCGATTTTAATTGGTGGATTTGGTAATTGATTAGTTCCTTTAATA—TTGGGAGCTCCTGATATAGCTTTTCCTCGTATAAATAATTTAAGATTTTGGTTATTACCTCCTTCTTTATTTTTATTATTTATTTCTTCTATGGCTGAAATAGGAGTAGGGGCTGGGTGAACTGTATATCCACCTTTAGCTTCTATTGTAGGACATAATGGGAGATCAGTAGACTTT—GCAATTTTTTCTTTACATTTAGCTGGTGCTTCATCAATCATAGGAGCTATTAATTTTATTTCTACTATTATTAATATACGATCTTTAGGAATATCTTTTGATAAGGTTCCTTTATTTGTTTGATCCGTTTTAATTACTGCTGTTTTGTTATTACTTTCGTTACCGGTTTTAGCAGGA——————————————————————— | 564 | 2013-10-04 | BOLD:AAB2930 | 2010-07-15 | 112 | NA | 43.8155,-79.167 | GPS | NA | NA | NA | Nearctic | NA | Southern_Great_Lakes_forests | Rouge National Urban Park | NA | Sector 3 | CA | Canada | Ontario | RBINA,DS-RBSS,DS-RPB13,DS-MOB112,DS-MOB113,DS-SOC2014,DS-MYBCA,DS-JALPHA,DS-ROUGENP,DS-ARANCCYH,DS-BBRNUP1,DS-SPCANADA,DS-JUMPGLOB | NA |

Similarly, sampleids or dataset_codes or project_codes can also be used
to fetch data. The data can also be filtered on different parameters
such as Geography, Attributions and DNA Sequence information using the
`_filt` arguments available in the function

#### Summarize downloaded data

Downloaded data can then be summarized in differnt ways. Summaries are
generated either on the whole dataset, specific presets (please check
the details section of `bold.export()` function in the package manual
for details) or specific columns.

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

A data summary profile containing aggregates and completeness
information is provided as a combination of tabular output and
visualization

#### Export the downloaded data

Downloaded data can also be exported to the local machine either as a
flat file or as a FASTA file for any third party sequence analysis
tools.The flat file contents can be modified as per user requirements
(entire data or specific presets or individual fields).

``` r
# Preset dataframe
# bold.export(bold_df = BCDM_data,
#             export_type = "preset_df",
#             presets = 'taxonomy',
#             export_to = "file_path_with_intended_name")

# Unaligned fasta file
# bold.export(bold_df = BCDM_data,
#             export_type = "fas",
#             cols_for_fas_names = c("bin_uri","genus","species"),
#             export_to = "file_path_with_intended_name")
```

#### Other functions

The package also has analyses functions that provide sequence alignment,
NJ clustering, biodiversity analysis, occurrence mapping using the
downloaded BCDM data. Additionally, these functions also output objects
that are commonly used by other R packages (‘sf’ dataframe, occurrence
matrix). Please go through the help manual (Link provided above) for
detailed usage of all the functions of BOLDConnectR with examples.

*BOLDconnectR* is able to retrieve data very fast (~100k records in a
minute on a fast wired connection).

*Citation:* Padhye SM, Agda TJA, Agda JRA, Ballesteros-Mejia CL,
Ratnasingham S. BOLDconnectR: An R package for interacting with the
Barcode of Life Data (BOLD) system.(MS in prep)
