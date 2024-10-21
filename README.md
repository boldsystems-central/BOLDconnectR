
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
sequence** of every submission.

## Installation

The package can be installed using `devtools::install_github` function
from the `devtools` package in R (which needs to be installed before
installing BOLDConnectR).

``` r

devtools::install_github("https://github.com/boldsystems-central/BOLDconnectR/tree/v0.0.1-beta")
#> glue       (1.7.0   -> 1.8.0 ) [CRAN]
#> digest     (0.6.36  -> 0.6.37) [CRAN]
#> jsonlite   (1.8.8   -> 1.8.9 ) [CRAN]
#> xfun       (0.47    -> 0.48  ) [CRAN]
#> evaluate   (1.0.0   -> 1.0.1 ) [CRAN]
#> wk         (0.9.2   -> 0.9.4 ) [CRAN]
#> e1071      (1.7-14  -> 1.7-16) [CRAN]
#> sys        (3.4.2   -> 3.4.3 ) [CRAN]
#> askpass    (1.2.0   -> 1.2.1 ) [CRAN]
#> curl       (5.2.1   -> 5.2.3 ) [CRAN]
#> igraph     (2.0.3   -> 2.1.1 ) [CRAN]
#> phangorn   (2.11.1  -> 2.12.1) [CRAN]
#> terra      (1.7-78  -> 1.7-83) [CRAN]
#> data.table (1.15.4  -> 1.16.2) [CRAN]
#> mvtnorm    (1.2-6   -> 1.3-1 ) [CRAN]
#> ks         (1.14.2  -> 1.14.3) [CRAN]
#> geometry   (0.4.7   -> 0.5.0 ) [CRAN]
#> raster     (3.6-26  -> 3.6-30) [CRAN]
#> sf         (1.0-16  -> 1.0-18) [CRAN]
#> vegan      (2.6-6.1 -> 2.6-8 ) [CRAN]
#> package 'glue' successfully unpacked and MD5 sums checked
#> package 'digest' successfully unpacked and MD5 sums checked
#> package 'jsonlite' successfully unpacked and MD5 sums checked
#> package 'xfun' successfully unpacked and MD5 sums checked
#> package 'evaluate' successfully unpacked and MD5 sums checked
#> package 'wk' successfully unpacked and MD5 sums checked
#> package 'e1071' successfully unpacked and MD5 sums checked
#> package 'sys' successfully unpacked and MD5 sums checked
#> package 'askpass' successfully unpacked and MD5 sums checked
#> package 'curl' successfully unpacked and MD5 sums checked
#> package 'igraph' successfully unpacked and MD5 sums checked
#> package 'phangorn' successfully unpacked and MD5 sums checked
#> package 'terra' successfully unpacked and MD5 sums checked
#> package 'data.table' successfully unpacked and MD5 sums checked
#> package 'mvtnorm' successfully unpacked and MD5 sums checked
#> package 'ks' successfully unpacked and MD5 sums checked
#> package 'geometry' successfully unpacked and MD5 sums checked
#> package 'raster' successfully unpacked and MD5 sums checked
#> package 'sf' successfully unpacked and MD5 sums checked
#> package 'vegan' successfully unpacked and MD5 sums checked
#> 
#> The downloaded binary packages are in
#>  C:\Users\samee\AppData\Local\Temp\RtmpWYE8px\downloaded_packages
#> ── R CMD build ─────────────────────────────────────────────────────────────────
#>       ✔  checking for file 'C:\Users\samee\AppData\Local\Temp\RtmpWYE8px\remotes61b446e01699\boldsystems-central-BOLDconnectR-6115602/DESCRIPTION'
#>       ─  preparing 'BOLDconnectR': (612ms)
#>    checking DESCRIPTION meta-information ...     checking DESCRIPTION meta-information ...   ✔  checking DESCRIPTION meta-information
#>       ─  checking for LF line-endings in source and make files and shell scripts
#>   ─  checking for empty or unneeded directories
#>   ─  building 'BOLDconnectR_1.0.0.tar.gz'
#>      
#> 
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

*Function 5 requires the packages `msa` and `Biostrings` to be installed
and imported beforehand.*

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

*BOLDconnectR* is able to fetch public as well as private user data very
fast (~100k records in a minute on a fast wired connection) and also
offers functionality for data transformation and analysis.

*Citation:* Padhye SM, Agda TJA, Agda JRA, Ballesteros-Mejia CL,
Ratnasingham S. BOLDconnectR: An R package for interacting with the
Barcode of Life Data (BOLD) system.(MS in prep)
