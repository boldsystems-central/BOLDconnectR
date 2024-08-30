
<!-- README.md is generated from README.Rmd. Please edit that file -->

<img src="man/figures/boldconnectr logo.jpg" width="100%" />

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
`Biostrings` packages are installed and imported beforehand. These packages can be
installed using the `BiocManager` package.

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

*BOLDconnectR* is able to fetch public as well as private user data very
fast (~100k records in a minute on a fast wired connection) and also
offers functionality for data transformation and analysis.

---

*Citation:* Padhye SM, Agda TJA, Agda JRA, Ballesteros-Mejia CL,
Ratnasingham S. BOLDconnectR: An R package for interacting with the
Barcode of Life Data (BOLD) system.(MS in prep)
