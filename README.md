
<!-- README.md is generated from README.Rmd. Please edit that file -->

<img src="man/figures/boldconnectr_logo.png" alt="" width="80" />

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

The package can be installed either by `install.packages()` for the CRAN
version or using the `devtools::install_github` function from the
`devtools` package in R (which needs to be installed before installing
BOLDConnectR).

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

knitr::kable(head(BCDM_data,4))
```

| processid | record_id | insdc_acs | sampleid | specimenid | taxid | short_note | identification_method | museumid | fieldid | collection_code | processid_minted_date | inst | funding_src | sex | life_stage | reproduction | habitat | collectors | site_code | specimen_linkout | collection_event_id | sampling_protocol | tissue_type | collection_date_start | collection_time | associated_taxa | associated_specimens | voucher_type | notes | taxonomy_notes | collection_notes | geoid | marker_code | kingdom | phylum | class | order | family | subfamily | tribe | genus | species | subspecies | identification | identification_rank | species_reference | identified_by | sequence_run_site | nuc | nuc_basecount | sequence_upload_date | bin_uri | bin_created_date | elev | depth | coord | coord_source | coord_accuracy | elev_accuracy | depth_accuracy | realm | biome | ecoregion | region | sector | site | country_iso | country.ocean | province.state | bold_recordset_code_arr | collection_date_end |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|---:|:---|:---|:---|---:|---:|:---|:---|---:|---:|---:|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| HPPPD1432-13 | HPPPD1432-13.COI-5P | KP649884 | BIOUG07077-F11 | 3525091 | 30494 | NA | NA | BIOUG07077-F11 | GMP#01736 | BIOUG | 2013-08-13 | Centre for Biodiversity Genomics | iBOL:WG1.9 | NA | NA | NA | NA | Tyler Zemlak | CAN\|NE04_338\|PPleasan | NA | NA | Malaise Trap | NA | 2013-06-29 | NA | NA | NA | Vouchered:Registered Collection | Jun 29 - Jul 6 2013; date range on label was Jun 22-29 but believe it to be mislabeled | CollectionsID | NA | 506 | COI-5P | Animalia | Arthropoda | Arachnida | Araneae | Salticidae | NA | NA | Naphrys | Naphrys pulex | NA | Naphrys pulex | species | (Hentz, 1846) | NA | Centre for Biodiversity Genomics | AACATTATATTTGATTTTTGGTGCTTGATCAGCTATAGTAGGTACGGCTATAAGAGTTTTGATCCGAATAGAGTTGGGACAGACTGGTAATTTTTTGGGAAATGATCATTTATATAATGTTATTGTAACTGCTCATGCTTTTGTTATAATTTTTTTTATAGTAATACCTATTTTGATTGGTGGTTTTGGTAATTGATTAGTGCCATTAATATTAGGGGCTCCTGATATAGCTTTTCCTCGGATAAATAATCTGAGATTCTGGTTATTGCCTCCTTCATTAATACTTTTATTTATATCTTCAATAGTGGAGATAGGAGTAGGAGCAGGGTGAACAGTATATCCCCCATTAGCTTCTGTTGTGGGTCATAGTGGTAGATCTGTTGATTTTGCTATTTTTTCTTTACATTTAGCGGGGGCTTCTTCTATTATAGGAGCAGTTAATTTTATTTCTACTATTATTAATATGCGTGTATTAGGTATAAGAATAGATAAGATTCCTTTGTTTGTTTGGTCAGTTGGAATTACTGCTGTATTATTGTTATTATCATTACCAGTGTTGGCTGGTGCTATTACAATATTGTTGACTGATCGTAATTTTAATACATC——————————————————- | 606 | 2014-09-05 | BOLD:ACY0365 | 2015-11-16 | 30 | NA | 44.623,-63.5686 | NA | NA | NA | NA | Nearctic | NA | NA | Halifax | Point Pleasant Park | NA | CA | Canada | Nova Scotia | HPPPD,DS-MOB113,DS-SOC2014,DS-ARANCCYH,DS-SPCANADA,DS-GMPC1,DS-JUMPGLOB,DS-20GMP14,DS-MOB112 | 2013-07-06 |
| ARONT722-10 | ARONT722-10.COI-5P | HQ924577 | CCDB-05292-A09 | 1544690 | 560524 | NA | NA | CCDB-05292-A09 | BIOLOT#22290 | BIOUG | 2010-06-24 | Centre for Biodiversity Genomics | iBOL:WG1.9 | M | A | S | NA | V. Julea | NA | NA | NA | NA | Leg | 2010-06-01 | NA | NA | NA | Vouchered:Registered Collection | NA | NA | NA | 528 | COI-5P | Animalia | Arthropoda | Arachnida | Araneae | Salticidae | NA | NA | Pelegrina | Pelegrina galathea | NA | Pelegrina galathea | species | (Walckenaer, 1837) | Gergin A. Blagoev | Centre for Biodiversity Genomics | AACTTTATATTTAATTTTTGGAGCTTGATCAGCTATAGTTGGAACCGCTATAAGAGTATTAATTCGTATAGAATTAGGACAGACTGGTTCATTTTTAGGAAATGATCATATGTATAATGTAATTGTAACTGCACATGCTTTTGTTATAATTTTTTTTATAGTAATACCGATTTTAATTGGTGGATTTGGTAATTGATTAGTTCCTTTAATATTGGGAGCTCCTGATATAGCTTTTCCTCGTATAAATAATTTAAGATTTTGGTTATTACCTCCTTCTTTATTTTTATTATTTATTTCTTCTATGGCTGAAATAGGAGTAGGGGCTGGGTGAACTGTATATCCACCTTTAGCTTCTATTGTAGGACATAATGGGAGATCAGTAGACTTTGCAATTTTTTCTTTACATTTAGCTGGTGCTTCATCAATCATAGGAGCTATTAATTTTATTTCTACTATTATTAATATACGATCTTTAGGAATATCTTTTGATAAGGTTCCTTTATTTGTTTGATCCGTTTTAATTACTGCTGTTTTGTTATTACTTTCGTTACCGGTTTTAGCAGGAGCTATTACCATATTATTAACTGATCGAAATTTTAATACTTCTTTTTTTGATCCTGCAGGTGGAGGTGATCCTATTTTATTTCAACATTTATTT | 658 | 2010-09-20 | BOLD:AAB2930 | 2010-07-15 | 335 | NA | 43.535,-80.206 |  | NA | NA | NA | Nearctic | NA | Eastern_Great_Lakes_lowland_forests | Wellington Co. | Arboretum Park, Guelph | NA | CA | Canada | Ontario | ARONT,DS-MOB113,DS-SOC2014,DS-MYBCRED,DS-MYBCA,DS-ARANCCYH,DS-SPCANADA,DS-OLOCC1,DS-JUMPGLOB,DS-MOB112,DS-JALPHA,DS-ARA43210 | NA |
| SSJAC1235-13 | SSJAC1235-13.COI-5P | KM831898 | BIOUG06123-F06 | 3372074 | 32595 | Jasper NP | BIN based | BIOUG06123-F06 | L#12BIOBUS-0295 | BIOUG | 2013-06-03 | Centre for Biodiversity Genomics | iBOL:WG1.9 | NA | NA | NA | Forest | BIOBus 2012 | BIOUG:JASP-NP:2 | NA | NA | Pitfall Trap | Whole Voucher | 2012-06-08 | NA | NA | NA | Vouchered:Registered Collection | NA | NA | 10 pitfall traps\|birch and spruce forest on a slope, lots of fallen logs | 533 | COI-5P | Animalia | Arthropoda | Arachnida | Araneae | Salticidae | NA | NA | Neon | Neon nelli | NA | Neon nelli | species | G. W. Peckham & E. G. Peckham, 1888 | Monica R. Young | Centre for Biodiversity Genomics | CACTTTATATTTAATTTTTGGAGCTTGATCTGCTATAGTAGGTACAGCGATGAGAGTATTGATTCGAATAGAATTAGGACAAACTGGTCAT—TTTTTGGGT————AATGATCATTTATATAATGTAATTGTTACTTCTCATGCTTTTATTATGATTTTTTTTATAGTTATACCTATTATAATTGGAGGGTTTGGAAATTGGTTAGTTCCTTTAATGTTAGGGGCTCCTGATATAGCTTTTCCTCGAATGAATAATTTAAGATTTTGATTGTTACCTCCTTCTTTATTATTATTATTTGTATCATCTATAGTGGAAATAGGAGTTGGTGCAGGATGAACTGTTTATCCGCCTTTGGCTTCTGTTATTGGTCATAGAGGAGCATCGGTTGATTTTGCTATTTTTTCTTTACATTTGGCTGGAGCTTCTTCTATTATAGGGGCTATTAATTTTATTTCTACTATTATTAATATGCGTTCTGAAGGGATATTTTTAGATAAAATATCTTTGTTTGTGTGGTCGGTGATTATTACTGCTGTACTATTATTATTATCTTTACCTGTATTAGCAGGTGCTATTACTATATTGCTTACGGAC—————— | 589 | 2013-09-16 | BOLD:AAD9221 | 2010-07-15 | 1131 | NA | 53.195,-117.914 | GPSmap 60Cx | NA | NA | NA | Nearctic | NA | Northern_Rockies_conifer_forests | Jasper National Park | Pocahontas Campground | Site C21 | CA | Canada | Alberta | SSJAC,DS-MOB113,DS-BICNP02,DS-SOC2014,DS-ARANCCYH,DATASET-BBJNP1,DS-SPCANADA,DS-JUMPGLOB,DS-MOB112,DS-CANSS | 2012-06-14 |
| BBCNP2603-14 | BBCNP2603-14.COI-5P | KP647830 | BIOUG12571-D02 | 4468204 | 9199 | Prince Albert NP | NA | BIOUG12571-D02 | L#12BIOBUS-1007 | BIOUG | 2014-04-21 | Centre for Biodiversity Genomics | iBOL:WG1.9 | NA | I | S | NA | BIOBus 2012 | NA | NA | NA | Free Hand Collection | NA | 2012-07-13 | NA | NA | NA | museum voucher | hand collecting\|sunny with haze\|25C | CollectionsID | NA | 511 | COI-5P | Animalia | Arthropoda | Arachnida | Araneae | Salticidae | NA | NA | Eris | Eris militaris | NA | Eris militaris | species | (Hentz, 1845) | Gergin A. Blagoev | Centre for Biodiversity Genomics | ACGTTATATTTAATTTTTGGAGCTTGATCAGCTATAGTTGGTACTGCTATAAGAGTATTAATTCGAATAGAATTAGGACAAACTGGATCATTTTTAGGTAATGATCATATATATAATGTAATTGTAACTGCTCATGCTTTTGTAATGATTTTTTTTATAGTAATACCAATTATAATTGGGGGATTTGGTAATTGATTAGTTCCTTTAATGTTAGGGGCTCCGGATATAGCTTTTCCTCGAATAAATAATTTAAGTTTTTGATTATTACCTCCTTCTTTATTTTTATTATTTATTTCTTCTATAGCTGAAATAGGAGTTGGAGCTGGATGAACAGTATATCCTCCTTTGGCATCTATTGTTGGACATAATGGTAGATCAGTAGATTTTGCTATTTTTTCTTTACATTTAGCTGGTGCTTCATCAATTATAGGAGCTATTAATTTTATTTCTACTATTATTAATATACGATCAGTAGGAATATCTTTAGATAAAATTCCTTTATTTGTTTGATCTGTAATAATTACTGCTGTATTATTATTGTTATCATTACCTGTTTTAGCAGGA——————————————————————— | 564 | 2014-06-26 | BOLD:AAA5654 | 2010-07-15 | 549 | NA | 53.59,-106.278 | GPSmap 60Cx | NA | NA | NA | Nearctic | NA | Mid-Canada_Boreal_Plains_forests | Prince Albert NP | Hunters Lake Trail | predominately aspen forest | CA | Canada | Saskatchewan | BBCNP,DS-SOC2014,DS-ARANCCYH,DATASET-BBPANP1,DS-SPCANADA,DS-JUMPGLOB | NA |

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
#> 3                Unique_species      79
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

#### Sequence Alignment

Downloaded data be aligned by either *ClustalOmega* or *muscle*
algorithms with custom headers for the aligned sequences. The function
uses `msa`, `ape`, `muscle` and `Biostrings` internally for the sequence
alignment. The packages `muscle`, `msa` and `Biostrings` must be
imported prior to using the align function.

``` r

# bold.apikey('')
# 
# fetch.test.data.4.align<-bold.fetch(identifiers = "DS-IBOLR24",
#                                     get_by = "dataset_codes",
#                                     filt_taxonomy = "Manduca",
#                                     filt_basecount = c(600,670))
# 
# # Sequence is aligned using ClustalOmega with default settings
# align.test.data<-bold.analyze.align(bold_df = fetch.test.data.4.align,
#                                     marker = "COI-5P",
#                                     cols_for_seq_names = c("species","bin_uri"),
#                                     align_method = "ClustalOmega")
# # Confirm the result
# head(subset(align.test.data,select = c(aligned_seq,msa.seq.name)),5)
```

#### NJ tree visualization

The aligned sequences cane also be visualized as a Neighbour joining
tree. The function uses the `ape` `nj` function to help create the
visualization. All additional arguments available for the `nj` function
can be passed on to this function as well.

``` r

# bold.apikey('')
# 
# fetch.test.data.4.align<-bold.fetch(identifiers = "DS-IBOLR24",
#                                     get_by = "dataset_codes",
#                                     filt_taxonomy = "Manduca",
#                                     filt_basecount = c(600,670))
# 
# # Sequence is aligned using ClustalOmega with default settings
# align.test.data<-bold.analyze.align(bold_df = fetch.test.data.4.align,
#                                     marker = "COI-5P",
#                                     cols_for_seq_names = c("species","bin_uri"),
#                                     align_method = "ClustalOmega")


# NJ tree with basic settings
# test.tree<-bold.analyze.tree(bold_df=align.test.data,
#                                 dist_model = "K80",
#                                 clus_method = "njs",
#                                 tree_plot = TRUE,
#                                 tree_plot_type = 'p')
# 
# # The phylo object which can be used for further customization of the plot
# test.tree$data_for_plot
# 
# # base frequencies
# test.tree$base_freq
```

#### Biodiversity analysis

Basic biodiversity analyses (preston plots, taxa richness estimation,
shannon diversity and beta diversity) of the downloaded data can be
carried out at any level of taxonomic hierarchy and geographic category.
The function uses `vegan`, `BAT` and `betapart` internally. The result
also provides an `occurrence matrix` that can be used for other
ecological analyses.

``` r

# bold.apikey('')
# fetch.test.data<-bold.fetch(identifiers = "DS-IBOLR24",
#                                get_by = "dataset_codes")
# 
# test.richness.diversity<-bold.analyze.diversity(bold_df=fetch.test.data,
#                                                    taxon_rank = "genus",
#                                                     site_type = "locations",
#                                                    location_type = "country.ocean",
#                                                    diversity_profile = "richness")
# 
# # View the richness estimator results
# View(test.richness.diversity$richness)
# 
# # Occurrence matrix (site X species)
# test.richness.diversity$comm.matrix
```

#### Occurrence map

The package also offers functionality to generate occurrence maps of the
downloaded data at different scales (Complete geographic extent of the
downloaded data, country specific occurrence and a bounding box based
occurrenc map). The result also provides an `sf` object that can be used
for other spatial analyses.

``` r

# bold.apikey('')
# fetch.test.data<-bold.fetch(identifiers = "DS-IBOLR24",
#                                get_by = "dataset_codes")

# All occurrences
# test.map<-bold.analyze.map(fetch.test.data)

# Specific country
# test.map.brazil=bold.analyze.map(fetch.test.data,country = "Australia")
```

*BOLDconnectR* is able to retrieve data very fast (~100k records in a
minute on a fast wired connection).

#### Funding

This work was funded by the [New Frontiers in Research Fund (NFRF) -
Transformation
2020](https://sshrc-crsh.canada.ca/funding-financement/nfrf-fnfr/transformation/transformation-eng.aspx)

#### Citation

Padhye SM, Ballesteros-Mejia CL,Agda TJA, Agda JRA, Ratnasingham S.
BOLDconnectR: An R package for streamlined retrieval, transformation and
analysis of BOLD DNA barcode data.(Submitted to *Plos ONE*)
