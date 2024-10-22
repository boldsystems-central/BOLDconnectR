
<!-- README.md is generated from README.Rmd. Please edit that file -->

<img src="man/figures/boldconnectr_logo.png" width="100%" />

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
# Substitute ‘00000000-0000-0000-0000-000000000000’ with your key
# bold_apikey(‘00000000-0000-0000-0000-000000000000’)
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
| ARBCM1844-14 | ARBCM1844-14.COI-5P | KP656379 | BIOUG14297-D09 | 4831128 | 30505 |  | NA | ENT013-011089 | L#RBCM14-341 |  | 2014-08-05 | Royal British Columbia Museum | iBOL:WG1.9 | F | A | S | NA | C. Copley, D. Copley, J. Heron, H. Gartner | NA | NA | NA | NA |  | 2013-06-19 | NA | NA | NA | NA | NA | NA | NA | 516 | COI-5P | Animalia | Arthropoda | Arachnida | Araneae | Salticidae | NA | NA | Evarcha | Evarcha hoyi | NA | Evarcha hoyi | species | (Peckham, Peckham, 1883) | Gergin A. Blagoev | Centre for Biodiversity Genomics | AACTTTATATTTAATTTTTGGAGCTTGAGCTGCTATAGTAGGAACTGCTATGAGAGTATTAATTCGGATAGAATTAGGACAGACTGGAAGATTTTTAGGAAATGAACATTTATATAATGTTATTGTCACGGCTCATGCATTTGTTATAATTTTTTTTATAGTAATACCTATTATAATCGGTGGTTTTGGTAATTGATTGGTCCCGCTAATATTAGGAGCTCCAGATATAGCTTTTCCTCGTATGAATAATTTAAGATTTTGATTATTACCCCCTTCTTTAATGTTATTATTTATTTCTTCTATAGCTGAAATAGGAGTGGGGGCTGGGTGAACAGTATATCCTCCTTTAGCTTCTATTGTAGGACATAATGGAAGATCTGTAGATTTTGCTATTTTTTCTTTACATTTAGCTGGGGCTTCTTCTATTATAGGTGCTATTAATTTTATTTCGACTATTATTAATATGCGTTCAGTAGGTATATCTATGGATAAAATTTCTTTATTTGTATGATCAGTTTTAATTACTGCTGTATTATTATTATTATCATTGCCAGTTTTAGCTGGGGCTATTACTATATTGTTAACTGATCGAAATTTTAATACTTCTTTTTTTGATCCTGCGGGAGGAGGAGATCCAATTTTGTTTCAACATTTATTT | 658 | 2014-08-14 | BOLD:ACR6376 | 2015-01-06 | 477 | NA | 51.353,-116.362 | GPS WGS84 | NA | NA | NA | Nearctic | NA | Northern_Rockies_conifer_forests | NA | Fort St. John, roadside rocky area | NA | CA | Canada | British Columbia | ARBCM,DS-SBC2014,DS-SOC2014,DS-ARANCCYH,DS-SPCANADA,DS-JUMPGLOB,DS-RBCMI | NA |
| SSFDA2336-14 | SSFDA2336-14.COI-5P | KP648092 | BIOUG13503-G09 | 4616478 | 989113 | Fundy NP | NA | BIOUG13503-G09 | L#13BIOBUS-0043 | BIOUG | 2014-06-12 | Centre for Biodiversity Genomics | iBOL:WG1.9 | NA | NA | NA | Mixed habitat | BIObus 2013 | NA | NA | NA | Pitfall Trap | Tissue | 2013-05-22 | NA | NA | NA | Vouchered:Registered Collection | May 25, 30 - 2 pitfalls flooded | NA | 10 Pitfall Traps\|overcast and foggy\|mixed wood raised bog near pond | 521 | COI-5P | Animalia | Arthropoda | Arachnida | Araneae | Salticidae | NA | NA | Attulus | Attulus floricola | NA | Attulus floricola | species | NA | Gergin A. Blagoev | Centre for Biodiversity Genomics | ACTTTATATTTAATTTTTGGTGCTTGATCTGCTATAGTAGGTACGGCAATAAGAGTTTTAATTCGAATAGAGTTAGGTCAAACTGGTCATTTTTTAGGGAATGATCATTTGTATAATGTAATTGTTACTGCTCATGCTTTTGTAATAATTTTTTTTATAGTTATACCAATTTTAATTGGTGGTTTTGGAAATTGATTAGTTCCTTTAATATTAGGAGCTCCTGATATAGCTTTTCCCCGAATAAATAACTTAAGATTTTGATTATTACCCCCTTCATTATTTTTATTATTTATTTCATCTATAGCTGAAATAGGAGTAGGGGCAGGTTGAACTGTTTATCCTCCTTTGGCTTCTATTGTAGGTCATAATGGTAGTTCTGTGGATTTTGCTATTTTCTCTTTACATTTAGCTGGAGCTTCTTCTATTATAGGTGCTATTAATTTTATTTCAACTGTGATTAATATACGATCAGTGGGGATGTCTATAGATAAAATTTCCTTATTCGTATGATCTGTTATTATTACTGCTGTATTATTATTATTGTCTTTACCTGTTTTAGCAGGAGCTATTACTATATTATTAACTGAT———————————————— | 588 | 2014-09-09 | BOLD:AAE1303 | 2010-07-15 | 336 | NA | 45.625,-65.06 | GPSmap 60Cx | NA | NA | NA | Nearctic | NA | New_England-Acadian_forests | Fundy National Park | Caribou Plain Trail | NA | CA | Canada | New Brunswick | SSFDA,DS-SOC2014,DS-ARANCCYH,DATASET-BBFNP1,DS-SPCANADA,DS-JUMPGLOB | 2013-05-30 |
| ARONT767-10 | ARONT767-10.COI-5P | HQ924618 | CCDB-05292-E06 | 1544735 | 9165 |  | NA | CCDB-05292-E06 | 100617PT | BIOUG | 2010-06-24 | Centre for Biodiversity Genomics | iBOL:WG1.9 |  | I | S | NA | G.A.Blagoev | NA | NA | NA | NA |  | 2010-06-17 | NA | NA | NA | NA |  | NA | NA | 528 | COI-5P | Animalia | Arthropoda | Arachnida | Araneae | Salticidae | NA | NA | Phidippus | Phidippus clarus | NA | Phidippus clarus | species | Keyserling, 1884 \[1885\] | Gergin A. Blagoev | Centre for Biodiversity Genomics | AACATTATATTTAATTTTTGGAGCTTGGGCTGCAATAGTAGGTACTGCAATAAGAGTATTAATTCGAATAGAATTGGGTCAGACTGGATCATTTATAGGAAATGATCATATATATAATGTAATTGTAACTGCTCATGCTTTTGTTATAATTTTTTTTATAGTAATACCTATTATAATTGGAGGATTTGGAAATTGATTGGTTCCCTTAATATTGGGAGCTCCTGATATGGCTTTTCCTCGTATAAATAATTTAAGATTTTGATTACTTCCCCCTTCTTTATTTTTATTATTTATTTCTTCTATGGCTGAGATAGGTGTAGGGGCTGGTTGAACAGTATATCCTCCTTTGGCTTCAACTATTGGACATAATGGAAGATCGGTAGATTTTGCTATTTTTTCATTGCATTTAGCTGGTGCTTCTTCAATTATGGGGGCTATTAATTTTATTTCTACTATTATTAATATGCGTTCTGTAGGGATATCTTTAGATAAAATTCCTTTATTTGTATGATCTGTAATAATTACTGCAGTTTTATTGTTGCTTTCTCTTCCTGTTTTAGCAGGTGCTATTACTATATTATTAACTGATCGAAATTTTAATACTTCTTTTTTTGATCCAGCTGGAGGTGGGGATCCTATTTTATTTCAACATTTATTT | 658 | 2010-09-20 | BOLD:AAC8083 | 2010-07-15 | 335 | NA | 43.535,-80.206 |  | NA | NA | NA | Nearctic | NA | Eastern_Great_Lakes_lowland_forests | Wellington Co. | Arboretum Park, Guelph | G.A.Blagoev | CA | Canada | Ontario | ARONT,DS-MOB112,DS-MOB113,DS-SOC2014,DS-MYBCA,DS-JALPHA,DS-ARANCCYH,DS-SPCANADA,DS-OLOCC1,DS-JUMPGLOB | NA |
| SSWLE094-13 | SSWLE094-13.COI-5P | KM833977 | BIOUG06354-H10 | 3474156 | 593827 | Waterton Lakes NP | BOLD ID Engine: top hits | BIOUG06354-H10 | L#12BIOBUS-1619 | BIOUG | 2013-07-23 | Centre for Biodiversity Genomics | iBOL:WG1.9 | F | A | S | Grassland | BIOBus 2012 | BIOUG:WATERTON-NP:5 | NA | NA | Pan Trap | Tissue | 2012-08-06 | NA | NA | NA | Vouchered:Registered Collection | Aug 11, 2 pans found tipped over | NA | 10 Pan Traps\|Overcast, 19C\|Moraine grassland, well established | 533 | COI-5P | Animalia | Arthropoda | Arachnida | Araneae | Salticidae | NA | NA | Phidippus | Phidippus cryptus | NA | Phidippus cryptus | species | NA | Gergin A. Blagoev | Centre for Biodiversity Genomics | ——–ATTTGATTTTTGGTGCTTGGGCAGCAATAGTTGGTACTGCAATAAGTGTATTAATTCGAATAGAATTAGGTCAGACTGGATCA——TTTATAGGAAATGACCATATATATAATGTAATTGTAACTGCTCATGCTTTTGTTATGATTTTTTTTATAGTAATACCTATTATAATTGGAGGATTTGGTAATTGATTAGTACCCTTAATATTAGGGGCTCCTGATATAGCTTTTCCTCGTATAAATAATTTAAGATTTTGATTACTTCCACCTTCTTTATTTTTATTATTTATTTCTTCTATAGCTGAGATAGGTGTG—GGGGCTGGTTGAACAGTTTATCCGCCTTTGGCTTCTATTGTTGGACATAATGGAAGATCAGTAGATTTTGCCATCTTTTCATTACATTTAGCTGGTGCTTCATCAATTATAGGGGCTATTAATTTTATTTCTACAATTATTAATATGCGT—TCTGTGGGAATGTCT——————TTGGATAAAGTTCCTTTATTTGTTTGATCTGTCATAATCACTGCAGTTTTATTATTACTTTCTCTTCCTGTATTAGCTGGAGCTATTACTATATTGTTAACTGAT————————————————————- | 581 | 2013-09-26 | BOLD:AAI2832 | 2010-07-15 | 1328 | NA | 49.088,-113.883 | GPSmap 60Cx | NA | NA | NA | Nearctic | NA | Northern_Rockies_conifer_forests | Waterton Lakes National Park | Red Rock Parkway | NA | CA | Canada | Alberta | SSWLE,DS-MOB112,DS-MOB113,DS-BICNP02,DS-SOC2014,DS-ARANCCYH,DATASET-BBWLNP1,DS-SPCANADA,DS-JUMPGLOB | 2012-08-11 |

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
