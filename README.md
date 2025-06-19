
<!-- README.md is generated from README.Rmd. Please edit that file -->

<img src="man/figures/boldconnectr_logo.png" width="100" />

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
properly. The versions of dependent packages have also been set such
that they would work with **R \>= 4.0**. In addition, there are a few
suggested packages that are not mandatory for the package to download
and install properly, but, are essential for a couple of functions to
work. The names and exact versions of the dependencies/suggestions are
given here
(<https://github.com/boldsystems-central/BOLDconnectR/blob/main/DESCRIPTION>).
More details on *Suggested packages* provided below.

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

## BOLDconnectR has 11 functions currently:

1.  bold.fields.info
2.  bold.apikey
3.  bold.fetch
4.  bold.public.search
5.  bold.full.search
6.  *bold.data.summarize*
7.  *bold.analyze.align*
8.  bold.analyze.tree
9.  bold.analyze.diversity
10. bold.analyze.map
11. bold.export

**Note on Suggested packages** *Function 5*: *bold.data.summarize*
requires the packages `Biostrings` to be installed and imported in the R
session beforehand for generating the `barcode_summary`. `msa` and
`Biostrings` can be installed using using `BiocManager` package.
*Function 6*: *bold.analyze.align* requires the packages `msa` and
`Biostrings` to be installed and imported in the R session beforehand.
Function 7 also uses the the output generated from function 6. `msa` and
`Biostrings` can be installed using using `BiocManager` package.

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
| SSWLD6460-13 | SSWLD6460-13.COI-5P | KM825932 | BIOUG06662-C01 | 3435715 | 9199 | Waterton Lakes NP | BOLD ID Engine: top hits | BIOUG06662-C01 | L#12BIOBUS-1587 | BIOUG | 2013-07-04 | Centre for Biodiversity Genomics | iBOL:WG1.9 | NA | NA | NA | Forest | BIOBus 2012 | BIOUG:WATERTON-NP:2 | NA | NA | Sweep Net | Whole Voucher | 2012-08-08 | NA | NA | NA | Vouchered:Registered Collection | NA | NA | 5 min sweep x4 collectors (2)\|Sunny with slight haze, 23C\|montane forest, douglas fir and lodgepole pine stand with aspen and birch understory | 533 | COI-5P | Animalia | Arthropoda | Arachnida | Araneae | Salticidae | NA | NA | Eris | Eris militaris | NA | Eris militaris | species | (Hentz, 1845) | Monica R. Young | Centre for Biodiversity Genomics | AACGTTATATTTAATTTTTGGAGCTTGATCAGCTATAGTTGGTACTGCTATAAGAGTATTAATTCGAATAGAATTAGGACAAACT—GGATCATTTTTAGGT————AATGATCATATATATAATGTAATTGTAACTGCTCATGCTTTTGTAATGATTTTTTTTATAGTAATACCAATTATAATTGGGGGATTTGGTAATTGGTTAGTTCCTTTAATGTTAGGGGCTCCGGATATAGCTTTTCCTCGAATAAATAATTTAAGTTTTTGATTATTACCTCCTTCTTTATTTTTATTGTTTATTTCTTCTATAGCTGAAATAGGGGTT—GGAGCTGGATGAACAGTATATCCTCCTTTGGCATCTATTGTTGGACATAATGGTAGATCAGTAGATTTTGCTATTTTTTCTTTACATTTAGCTGGTGCTTCATCAATTATAGGAGCTATTAATTTTATTTCTACTATTATTAATATACGA—TCAGTAGGAATATCTTTAGATAAAATTCCTTTATTTGTTTGATCTGTAATAATTACTGCTGTATTATTATTGTTATCATTACCTGTTTTAGCAGGAGCTATTACTATATTATTAACTGAT——————— | 589 | 2013-09-16 | BOLD:AAA5654 | 2010-07-15 | 1562 | NA | 49.065,-113.778 | GPSmap 60Cx | NA | NA | NA | Nearctic | NA | Northern_Rockies_conifer_forests | Waterton Lakes National Park | East of 2 Flags Lookout | Highway 6 pulloff | CA | Canada | Alberta | SSWLD,DS-MOB113,DS-BICNP02,DS-SOC2014,DS-ARANCCYH,DATASET-BBWLNP1,DS-SPCANADA,DS-JUMPGLOB,DS-MOB112,DS-CANSS | NA |
| SPITO327-14 | SPITO327-14.COI-5P | KP654265 | BIOUG12602-G11 | 4610196 | 9162 | NA | NA | BIOUG12602-G11 | L#14BLITZ-001 | BIOUG | 2014-06-10 | Centre for Biodiversity Genomics | iBOL:WG1.9 | M | A | S | NA | Gergin Blagoev | NA | NA | NA | Free Hand Collection | NA | 2014-05-24 | NA | NA | NA | museum voucher | Collected May 24-14, as part of Humber Watershed BioBlitz | NA | NA | 528 | COI-5P | Animalia | Arthropoda | Arachnida | Araneae | Salticidae | NA | NA | Phidippus | Phidippus audax | NA | Phidippus audax | species | (Hentz, 1845) | Gergin A. Blagoev | Centre for Biodiversity Genomics | -ACATTATATTTGATTTTTGGAGCTTGGGCTGCAATAGTTGGTACTGCAATA—AGTGTATTGATTCGAATAGAATTGGGTCAAACTGGATCATTTATAGGAAAT—GATCATATATATAATGTAATTGTGACTGCTCATGCTTTTGTTATAATTTTTTTTATAGTAATACCTATTATGATTGGAGGATTTGGAAACTGATTAGTTCCTTTAATA—TTAGGTGCTCCTGATATGGCTTTTCCTCGTATAAATAATTTGAGATTTTGATTATTACCCCCTTCTTTATTTTTATTATTTATTTCTTCCATAGCTGAGGTAGGTGTAGGGGCTGGTTGGACAGTTTATCCACCTTTGGCCTCTATTGTTGGGCATAATGGAAGATCAGTAGATTTT—GCTATTTTTTCATTACATTTAGCTGGTGCTTCATCAATTATAGGAGCTATTAATTTTATTTCTACAATTATTAATATACGTTCTTTAGGAATGTCTTTAGATAAAATTCCTTTGTTTGTTTGATCTGTAATAATTACTGCAGTTTTGTTATTACTTTCTCTTCCTGTATTAGCTGGG—GCTATTACTATATTGTTGACTGAT——————————————————————————————————————————————————————————————————————————————————————- | 588 | 2014-06-27 | BOLD:AAC6891 | 2010-07-15 | 380 | NA | 43.933,-79.928 | NA | NA | NA | NA | Nearctic | NA | Eastern_Great_Lakes_lowland_forests | Humber Watershed | NA | Glen Haffy Conservation Area | CA | Canada | Ontario | SPITO,DS-SOC2014,DS-ARANCCYH,DS-TMPSRCH,DS-SPCANADA,DS-OLOCC2,DS-JUMPGLOB | NA |
| ARONT071-09 | ARONT071-09.COI-5P | GU682836 | 09ONTGAB-183 | 1229966 | 30494 | SPIOH09-1 F11 | NA | 09ONTGAB-183 | 090816FH | BIOUG | 2009-09-23 | Centre for Biodiversity Genomics | iBOL:WG1.9 | M | I | S | NA | G.A.Blagoev | NA | NA | NA | NA |  | 2009-08-16 | NA | NA | NA | NA |  | NA | NA | 528 | COI-5P | Animalia | Arthropoda | Arachnida | Araneae | Salticidae | NA | NA | Naphrys | Naphrys pulex | NA | Naphrys pulex | species | (Hentz, 1846) | Gergin A. Blagoev | Centre for Biodiversity Genomics | AACATTATATTTGATTTTTGGTGCTTGATCAGCTATAGTAGGTACGGCTATAAGAGTTTTGATTCGAATAGAGTTGGGACAGACTGGTAATTTTTTGGGAAATGATCATTTATATAATGTCATTGTAACTGCTCATGCTTTTGTTATGATTTTTTTTATAGTAATACCTATTTTGATTGGTGGTTTTGGTAATTGATTAGTGCCATTAATATTAGGGGCTCCTGATATAGCTTTTCCTCGGATGAATAATTTGAGATTTTGGTTATTACCCCCTTCATTAATACTCTTATTTATATCTTCAATAGTGGAGATAGGGGTAGGAGCAGGGTGAACAGTGTATCCCCCATTAGCTTCTGTTGTAGGTCATAATGGAAGATCTGTTGATTTTGCTATTTTTTCTTTACATTTAGCGGGGGCTTCTTCTATTATAGGAGCAGTTAATTTTATTTCTACTATTATTAATATACGTGTATTAGGAATGAGAATAGATAAGATTCCTTTGTTTGTTTGGTCAGTTGGGATTACTGCTGTATTATTATTATTATCACTACCAGTGTTGGCTGGTGCTATTACAATATTGTTGACTGATCGTAATTTTAATACCTCTTTTTTTGATCCTGCGGGAGGAGGGGATCCGGTTTTGTTTCAGCATTTATTT | 658 | 2009-10-29 | BOLD:AAC2433 | 2010-07-15 | 300 | NA | 43.691,-80.414 |  | NA | NA | NA | Nearctic | NA | Eastern_Great_Lakes_lowland_forests | Wellington Co. | Elora | Beach | CA | Canada | Ontario | ARONT,DS-MOB113,DS-SOC2014,DS-MYBCA,DS-ARANCCYH,DS-SPCANADA,DS-OLOCC1,DS-JUMPGLOB,DS-MOB112,DS-JALPHA | NA |
| SPIRU1237-11 | SPIRU1237-11.COI-5P | KF368796 | BIOUG00629-G03 | 1982513 | 842900 | ocean beach\|AP\|HC | NA | BIOUG00629-G03 | L#10PROBE-6510 | 10PROBE | 2011-05-16 | Centre for Biodiversity Genomics | iBOL:WG1.10 |  | I | S | NA | V. Junea | BIOUG:Churchill | NA | NA | NA | NA | 2010-07-30 | NA | NA | NA | whole specimen | NA | NA | NA | 531 | COI-5P | Animalia | Arthropoda | Arachnida | Araneae | Salticidae | NA | NA | Sittisax | Sittisax ranieri | NA | Sittisax ranieri | species | (G. W. Peckham & E. G. Peckham, 1909) | Gergin A. Blagoev | Centre for Biodiversity Genomics | TACGTTATATTTAGTTTTTGGAGCTTGGTCTGCTATAGTTGGTACGGCTATAAGAGTTTTAATTCGTATAGAATTAGGTCAAACTGGTCATTTTTTAGGAAATGATCATTTGTATAATGTAATTGTTACTGCACATGCATTTGTTATAATTTTTTTTATAGTAATACCTATTTTGATTGGAGGTTTTGGTAATTGATTAGTCCCTCTAATGTTAGGAGCTCCGGATATAGCTTTTCCTCGTATAAATAATTTAAGTTTTTGATTATTACCTCCTTCATTATTTTTATTATTTATTTCATCTATAGCTGAGATAGGAGTAGGGGCAGGGTGAACTGTTTATCCTCCATTAGCTTCTATTGTAGGTCATAATGGAAGTTCGGTAGATTTTGCTATTTTTTCTCTTCATTTGGCTGGGGCTTCATCAATTATAGGTGCTATTAATTTTATTTCAACTGTTATTAATATACGATCGGTGGGTATATCAATAGATAAGATTCCATTGTTTGTTTGGTCTGTTGTAATTACTGCTGTATTATTGTTATTGTCTTTACCTGTTTTAGCGGGTGCAATTACTATGCTATTGACTGATCGAAATTTTAATACGTCTTTTTTTGATCCTGCTGGAGGAGGGGATCCAATTTTATTTCAACATTTATTT | 658 | 2012-11-23 | BOLD:AAC2061 | 2010-07-15 | NA | NA | 58.772,-93.843 | GPS WGS84 | NA | NA | NA | Nearctic | NA | Southern_Hudson_Bay_taiga | Churchill | 16 km E Churchill, Bird Cove, Rock Bluff A | Beach | CA | Canada | Manitoba | CHSPI,DATASET-CHURCH12,DS-MOB113,DS-SOC2014,DS-ARANCCYH,DS-TMPSRCH,DS-SPCANADA,DS-ATBIB,DS-JUMPGLOB,DS-MOB112,DS-ARA43210 | NA |

Similarly, sampleids or dataset_codes or project_codes can also be used
to fetch data. The data can also be filtered on different parameters
such as Geography, Attributions and DNA Sequence information using the
`_filt` arguments available in the function

#### Summarize downloaded data

Downloaded data can then be summarized in different ways. Options
currently include a concise summary of all the data, detailed taxonomic
counts, data completeness and a barcode based summary

``` r
BCDM_data_summary<-bold.data.summarize(bold_df = BCDM_data,
                               summary_type = "concise_summary")

BCDM_data_summary$concise_summary
#>                        Category   Value
#> 1                 Total_records    1336
#> 2     Total_records_w_sequences    1336
#> 3                Unique_species      80
#> 4                   Unique_BINs     117
#> 5              Unique_countries       1
#> 6             Unique_institutes       6
#> 7          Unique_identified_by       7
#> 8  Unique_specimen_depositories       3
#> 9                Unique_markers  COI-5P
#> 10        Amplicon_length_range 508-658
```

A concise summary providing a high level overview of the data

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
#             cols_for_fas_names = NULL,
#             export = "file_path_with_intended_name.csv")

# Unaligned fasta file
# bold.export(bold_df = BCDM_data,
#             export_type = "fas",
#             cols_for_fas_names = c("bin_uri","genus","species"),
#             export = "file_path_with_intended_name.fas")
```

#### Other functions

The package also has analyses functions that provide sequence alignment,
NJ clustering, biodiversity analysis, occurrence mapping using the
downloaded BCDM data. Additionally, these functions also output objects
that are commonly used by other R packages (Ex. ‘sf’ dataframe,
occurrence matrix for ‘vegan’ and ‘betapart’). Please go through the
help manual (Link provided above) for detailed usage of all the
functions of BOLDConnectR with examples.

*BOLDconnectR* is able to retrieve data very fast (~100k records in a
minute on a fast wired connection).

*Citation:* Padhye SM, Ballesteros-Mejia CL,Agda TJA, Agda JRA,
Ratnasingham S. BOLDconnectR: An R package for streamlined retrieval,
transformation and analysis of BOLD DNA barcode data.(MS in prep)
