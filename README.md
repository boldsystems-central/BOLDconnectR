
<!-- README.md is generated from README.Rmd. Please edit that file -->

<img src="man/figures/boldconnectr_logo.png" alt="" width="25" />

<!-- badges: start -->

<!-- badges: end -->

**BOLDconnectR** is a package designed for **retrieval**,
**transformation** and **analysis** of the data available in the
*Barcode Of Life Data Systems (BOLD)* database. This package provides
the functionality to obtain public and private user data available in
the database in the *Barcode Core Data Model (BCDM)* format. Data
include information on the
**taxonomy**,**geography**,**collection**,**identification** and **DNA
barcode sequence** of every submission.

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

# devtools::install_github("https://github.com/boldsystems-central/BOLDconnectR")
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
*Function 6*: *bold.analyze.align* requires the packages `msa`, `muscle`
and `Biostrings` to be installed and imported in the R session
beforehand. Function 7 also uses the the output generated from function
6. `msa`, `muscle` and `Biostrings` can be installed using using
`BiocManager` package.

``` r

if (!requireNamespace("BiocManager", quietly=TRUE))
install.packages("BiocManager")

BiocManager::install("msa")
BiocManager::install("Biostrings")
BiocManager::install("muscle")

library(msa)
library(Biostrings)
library(muscle)
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
| BBCNP2615-14 | BBCNP2615-14.COI-5P | KP654931 | BIOUG12571-E02 | 4468216 | 9199 | Prince Albert NP | NA | BIOUG12571-E02 | L#12BIOBUS-1007 | BIOUG | 2014-04-21 | Centre for Biodiversity Genomics | iBOL:WG1.9 | NA | I | S | NA | BIOBus 2012 | NA | NA | NA | Free Hand Collection | NA | 2012-07-13 | NA | NA | NA | museum voucher | hand collecting\|sunny with haze\|25C | CollectionsID | NA | 511 | COI-5P | Animalia | Arthropoda | Arachnida | Araneae | Salticidae | NA | NA | Eris | Eris militaris | NA | Eris militaris | species | (Hentz, 1845) | Gergin A. Blagoev | Centre for Biodiversity Genomics | ACGTTATATTTAATTTTTGGAGCTTGATCAGCTATAGTTGGTACTGCTATAAGAGTATTAATTCGAATAGAATTAGGACAAACTGGATCATTTTTAGGTAATGATCATATATATAATGTAATTGTAACTGCTCATGCTTTTGTAATGATTTTTTTTATAGTAATACCAATTATAATTGGGGGATTTGGTAATTGGTTAGTTCCTTTAATGTTAGGGGCTCCGGATATAGCTTTTCCTCGAATAAATAATTTAAGTTTTTGATTATTACCTCCTTCTTTATTTTTATTGTTTATTTCTTCTATAGCTGAAATAGGGGTTGGAGCTGGATGAACAGTATATCCTCCTTTGGCATCTATTGTTGGACATAATGGTAGATCAGTAGATTTTGCTATTTTTTCTTTACATTTAGCTGGTGCTTCATCAATTATAGGAGCTATTAATTTTATTTCTACTATTATTAATATACGATCAGTAGGAATATCTTTAGATAAAATTCCTTTATTTGTTTGATCTGTAATAATTACTGCTGTATTATTATTGTTATCATTACCTGTTTTAGCAGGA——————————————————————— | 564 | 2014-06-26 | BOLD:AAA5654 | 2010-07-15 | 549 | NA | 53.59,-106.278 | GPSmap 60Cx | NA | NA | NA | Nearctic | NA | Mid-Canada_Boreal_Plains_forests | Prince Albert NP | Hunters Lake Trail | predominately aspen forest | CA | Canada | Saskatchewan | BBCNP,DS-SOC2014,DS-ARANCCYH,DATASET-BBPANP1,DS-SPCANADA,DS-JUMPGLOB | NA |
| BBCAN226-09 | BBCAN226-09.COI-5P | GU683124 | CCDB-04550-C12 | 1274762 | 9199 | Kouchibouguac NP | BOLD ID Engine | CCDB-04550-C12 | L#09KC-053 | BIOUG | 2009-11-23 | Centre for Biodiversity Genomics | iBOL:WG1.9 | F | I | S | Wetland | BIObus 2009 | NA | NA | NA | Free Hand |  | 2009-08-17 | NA | NA | NA | Vouchered:Registered Collection | NA | NA | Free Hand\|Mixed sun and cloud after rain\|Boardwalk through a bog | 521 | COI-5P | Animalia | Arthropoda | Arachnida | Araneae | Salticidae | NA | NA | Eris | Eris militaris | NA | Eris militaris | species | (Hentz, 1845) | Gergin A. Blagoev | Centre for Biodiversity Genomics | GACGTTATATTTAATTTTTGGAGCTTGATCAGCTATAGTTGGTACTGCTATAAGAGTATTAATTCGAATAGAATTAGGACAAACTGGATCATTTTTAGGTAATGATCATATATATAATGTAATCGTAACTGCTCATGCTTTTGTAATGATTTTTTTTATAGTAATACCAATTATAATTGGGGGATTTGGTAATTGGTTAGTTCCTTTAATGTTAGGGGCTCCGGATATAGCTTTTCCTCGAATAAATAATTTAAGTTTTTGATTATTACCTCCTTCTTTATTTTTATTATTTATTTCTTCTATAGCTGAAATAGGGGTTGGAGCTGGATGAACAGTATATCCTCCTTTGGCATCTATTGTTGGACATAATGGCAGATCAGTAGATTTTGCTATTTTTTCTTTACATTTAGCTGGTGCTTCATCAATTATAGGAGCTATTAATTTTATTTCTACTATTATTAATATACGATCAGTAGGAATATCTTTAGATAAAATTCCTTTATTTGTTTGATCTGTAATAATTACTGCTGTATTATTATTGTTATCATTACCTGTTTTAGCAGGAGCTATTACTATATTATTAACTGATCGAAATTTTAATACTTCTTTTTTTGATCCTGCAGGAGGAGGAGATCCAATTTTGTTTCAACATTTATTT | 658 | 2011-03-25 | BOLD:AAA5654 | 2010-07-15 | 7 | NA | 46.816,-64.953 | NA | NA | NA | NA | Nearctic | NA | Gulf_of_St.\_Lawrence_lowland_forests | Kouchibouguac NP | The Bog Trail | NA | CA | Canada | New Brunswick | SPIBB,DATASET-BBKCNP1,DATASET-BBCNP1,DS-MOB113,DS-BICNP02,DS-SOC2014,DS-ARANCCYH,DS-DDSG,DS-SPCANADA,DS-JUMPGLOB,DS-MOB112 | NA |
| ARSO594-09 | ARSO594-09.COI-5P | KM826219 | 08BBARAC-0466 | 990633 | 9199 | Riding Mountain NP |  | 08BBARAC-0466 | L#08RIDMO-097 | BIOUG | NA | Centre for Biodiversity Genomics | NA | F | I | S | NA | BIObus 2008 | NA | NA | NA | Sweep Net | NA | 2009-08-19 | NA | NA | NA | Vouchered:Registered Collection | NA | NA | Sweep Net\|\|Hiking trail | 531 | COI-5P | Animalia | Arthropoda | Arachnida | Araneae | Salticidae | NA | NA | Eris | Eris militaris | NA | Eris militaris | species | (Hentz, 1845) | Gergin A. Blagoev | Centre for Biodiversity Genomics | AACGTTATATTTAATTTTTGGAGCTTGATCAGCTATAGTTGGTACTGCTATAAGAGTATTAATTCGAATAGAATTAGGACAAACTGGATCATTTTTAGGTAATGATCATATATATAATGTAATTGTAACTGCTCATGCTTTTGTAATGATTTTTTTTATAGTAATACCAATTATAATTGGGGGATTTGGTAATTGGTTAGTTCCTTTAATGTTAGGGGCTCCGGATATAGCTTTTCCTCGAATAAATAATTTAAGTTTTTGATTATTACCTCCTTCTTTATTTTTATTATTTATTTCTTCTATAGCTGAAATAGGGGTTGGAGCTGGATGAACAGTATATCCTCCTTTGGCATCTATTGTTGGACATAATGGTAGATCAGTAGATTTTGCTATTTTTTCTTTACATTTAGCTGGTGCTTCATCAATTATAGGAGCTATTAATTTTATTTCTACTATTATTAATATACGATCAGTAGGAATATCTTTAGATAAAATTCCTTTATTTGTTTGATCTGTAATAATTACTGCTGTATTATTATTGTTATCATTACCTGTTTTAGCAGGAGCTATTACTATATTATTAACTGATCGAAATTTTAATACTTCTTTTTTTGATCCTGCAGGAGGAGGAGATCCAATTTTGTTTCAACATTtaTTt | 658 | 2009-05-30 | BOLD:AAA5654 | 2010-07-15 | 662 | NA | 50.881,-100.056 | NA | NA | NA | NA | Nearctic | NA | Mid-Canada_Boreal_Plains_forests | Riding Mountain NP | Moon Lake | Hiking Trail | CA | Canada | Manitoba | SPIBB,DATASET-BBRMNP1,DS-MOB113,DS-BICNP02,DS-SOC2014,DS-ARANCCYH,DS-SPCANADA,DS-JUMPGLOB,DS-MOB112 | NA |
| BBCNP1308-14 | BBCNP1308-14.COI-5P | KP648859 | BIOUG09535-G01 | 4141099 | 9199 | Elk Island NP | NA | BIOUG09535-G01 | L#12BIOBUS-0772 | BIOUG | 2014-01-17 | Centre for Biodiversity Genomics | iBOL:WG1.9 | M | A | S | NA | BIOBus 2012 | NA | NA | NA | Free Hand Collection | NA | 2012-07-02 | NA | NA | NA | museum voucher | hand collecting\|mostly sunny\|24C | CollectionsID | NA | 533 | COI-5P | Animalia | Arthropoda | Arachnida | Araneae | Salticidae | NA | NA | Eris | Eris militaris | NA | Eris militaris | species | (Hentz, 1845) | Gergin A. Blagoev | Centre for Biodiversity Genomics | GAACGTTATATTTAATTTTTGGAGCTTGATCAGCTATAGTTGGTACTGCTATAAGAGTATTAATTCGAATAGAATTAGGACAAACTGGATCATTTTTAGGTAATGATCATATATATAATGTGATTGTAACTGCTCATGCTTTTGTAATGATTTTTTTTATAGTAATACCAATTATAATTGGGGGATTTGGTAATTGGTTAGTTCCTTTAATGTTAGGGGCTCCGGATATAGCTTTTCCTCGAATAAATAATTTAAGTTTTTGATTATTACCTCCTTCTTTATTTTTATTATTTATTTCTTCTATAGCTGAAATAGGGGTTGGAGCTGGATGAACAGTATATCCTCCTTTGGCATCTATTGTTGGACATAATGGTAGATCAGTAGATTTTGCTATTTTTTCTTTACATTTAGCTGGTGCTTCATCAATTATAGGAGCTATTAATTTTATTTCTACTATTATTAATATACGATCAGTAGGAATATCTTTAGATAAAATTCCTTTATTTGTTTGATCTGTAATAATTACTGCTGTATTATTATTGTTATCATTACCTGTTTTAGCAGGAGCTATTACTATATTATTAACTGATCGA | 593 | 2014-03-20 | BOLD:AAA5654 | 2010-07-15 | 721 | NA | 53.618,-112.875 | GPSmap 60Cx | NA | NA | NA | Nearctic | NA | Canadian_Aspen_forests_and_parklands | Elk Island NP | Tawayik Lake Trail | aspen, birch, rose bushes, adjacent to wetland/lake | CA | Canada | Alberta | BBCNP,DS-SOC2014,DS-ARANCCYH,DATASET-BBEINP1,DS-SPCANADA,DS-JUMPGLOB,DS-MOB112 | NA |

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

# fetch.test.data.4.align<-bold.fetch(identifiers = "DS-IBOLR24",
#                                     get_by = "dataset_codes",
#                                     filt_taxonomy = "Manduca",
#                                     filt_basecount = c(600,670))

# Sequence is aligned using ClustalOmega with default settings
# align.test.data<-bold.analyze.align(bold_df = fetch.test.data.4.align,
#                                     marker = "COI-5P",
#                                     cols_for_seq_names = c("species","bin_uri"),
#                                     align_method = "ClustalOmega")

# Confirm the result
# head(subset(align.test.data,select = c(aligned_seq,msa.seq.name)),5)
```

#### NJ tree visualization

The aligned sequences cane also be visualized as a Neighbour joining
tree. The function uses the `ape` `nj` function to help create the
visualization. All additional arguments available for the `nj` function
can be passed on to this function as well.

``` r

# bold.apikey('')

# fetch.test.data.4.align<-bold.fetch(identifiers = "DS-IBOLR24",
#                                     get_by = "dataset_codes",
#                                     filt_taxonomy = "Manduca",
#                                     filt_basecount = c(600,670))

# Sequence is aligned using ClustalOmega with default settings
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
# The phylo object which can be used for further customization of the plot
# test.tree$data_for_plot
# 
# base frequencies
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

# 1. Generic richness
# test.richness.diversity<-bold.analyze.diversity(bold_df=fetch.test.data,
#                                                    taxon_rank = "genus",
#                                                     site_type = "locations",
#                                                    location_type = "country.ocean",
#                                                    diversity_profile = "richness")

# View the richness estimator results
# View(test.richness.diversity$richness)

# Occurrence matrix (site X species)
# test.richness.diversity$comm.matrix

# 2. Preston plots
# test.richness.diversity2<-bold.analyze.diversity(bold_df=fetch.test.data,
#                                                  taxon_rank = "genus",
#                                                  site_type = "locations",
#                                                  location_type = "country.ocean",
#                                                  diversity_profile = "preston")
# View the preston plot
# test.richness.diversity2$preston.plot
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
