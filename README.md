
<!-- README.md is generated from README.Rmd. Please edit that file -->

<img src="man/figures/boldconnectr_logo.png" width="35%" />

<!-- badges: start -->
<!-- badges: end -->

**BOLDconnectR** is a package designed for **retrieval**,
**transformation** and **analysis** of the data available in the
*Barcode Of Life Data Systems (BOLD)* database. This package provides
the functionality to obtain public and private user data available in
the database in the *Barcode Core Data Model (BCDM)* format. Data
include information on the
**taxonomy**,**geography**,**collection**,**identification** and **DNA
sequence** of every submission.

## Installation

The package can be installed using `devtools::install_github` function
from the `devtools` package in R (which needs to be installed before
installing BOLDConnectR).

``` r

devtools::install_github("https://github.com/boldsystems-central/BOLDconnectR/tree/v0.0.1-beta")
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

*Function 5 requires the packages `msa` and ‘Biostrings’ to be installed
and imported beforehand.*

### Note on API key

The function `bold.fetch` requires an `api key` internally in order to
access and download all public + private user data. API key can be
obtained by emailing the BOLD support (<support@boldsystems.org>). API
key can be saved in the R session using `bold.apikey()` function.

``` r
# The key can be added in place of "api.key" 
# bold.apikey ("api.key")
```

*BOLDconnectR* is able to fetch public as well as private user data very
fast (~100k records in a minute on a fast wired connection) and also
offers functionality for data transformation and analysis.

*Citation:* Padhye SM, Agda TJA, Agda JRA, Ballesteros-Mejia CL,
Ratnasingham S. BOLDconnectR: An R package for interacting with the
Barcode of Life Data (BOLD) system.(MS in prep)
