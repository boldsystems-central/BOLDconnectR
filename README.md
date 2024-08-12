
<!-- README.md is generated from README.Rmd. Please edit that file -->

# BOLDconnectR

<!-- badges: start -->
<!-- badges: end -->

BOLDconnectR is a package designed for retrieval, transformation and
analysis of the data available in the Barcode Of Life Data Systems
(BOLD) database. This package provides the functionality to obtain
public as well as private user data available in the database.

## Installation

You can install the development version of BOLDconnectR from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("sameerpadhye/BOLDconnectR")
```

## Note on API key

API key can be obtained by emailing the BOLD support
(<support@boldsystems.org>). API key is needed only for the data
retrieval and can be added directly within the function. Alternatively,
it can be set up as an environmental variable using the ‘Sys.setenv’
function.

``` r

Sys.setenv ("api_key"="api.key")
```

It can then be retrieved using ‘Sys.getenv’ function directly or by
storing it as another variable.

``` r

api.key <- Sys.getenv('api_key')
```

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
