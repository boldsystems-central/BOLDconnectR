
<!-- README.md is generated from README.Rmd. Please edit that file -->

# BOLDconnectR

<!-- badges: start -->
<!-- badges: end -->

BOLDconnectR is a package designed for retrieval, transformation and
analysis of the data available in the Barcode Of Life Data Systems
(BOLD) database. This package provides the functionality to obtain
public and private user data available in the database. Its currently
available as a devtools installation and can be downloaded with a
‘auth_token’.

## Installing BOLDConnectR

``` r

devtools::install_github("https://github.com/sameerpadhye/BOLDconnectR.git",
                         auth_token = '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')
#> Skipping install of 'BOLDconnectR' from a github remote, the SHA1 (23a6368e) has not changed since last install.
#>   Use `force = TRUE` to force installation

library(BOLDconnectR)
```

## Obtaining all the information on the different data fields currently available for BOLD data

`bold.fields.info` provides all the metadata related to the various
fields (columns) currently available for download from BOLD. The
function gives the name, definition and the data type of each field.

``` r

bold.field.info<-bold.fields.info(print.output = FALSE)

#DT::datatable(bold.field.info,class = 'cell-border stripe')
```

### Note on API key

The function `bold.connectr` requires an `api key` in order to access
and download all public + private user data. API key can be obtained by
emailing the BOLD support (<support@boldsystems.org>). API key is needed
only for the data retrieval and can be added directly within the
function. Alternatively, it can be set up as an environmental variable
using the ‘Sys.setenv’ function.

``` r

# The key can be added in place of "api.key" 
Sys.setenv ("api_key"="api.key")
```

It can then be retrieved using ‘Sys.getenv’ function directly or by
storing it as another variable.

``` r

api.key <- Sys.getenv('api_key')
```

## bold.connectr

This function retrieves public and private user data on BOLD using
the`api key`

### Test data

Test data is a data frame having 2 columns and 2100 unique ids. First
column has ‘processids’ while second has ‘sampleids’. Either one can be
used to retrieve data from BOLD

``` r

data("test.data")

#DT::datatable(test.data,class = 'cell-border stripe')
```

### default (all data retrieved)

The arguments provided below need to be specified by default for every
request. Default settings retrieve data for all available fields for
those ids. Certain ids might not have information for certain fields in
which case the number of columns could be different

    #> Warning in bold.connectr(input.data = to_download, param = "processid", :
    #> Incorrect api key format. Please re-check the API key
    #> [1] FALSE

## using some filters

The downloaded data can also be filtered using the various filter
arguments available (all arguments after the `api_key`). The filtering
happens locally after the data is downloaded. Care has to be taken to
select the filters properly. If wrong/too many filters are applied, it
can result in an empty result. The `fields` argument in the function
helps in selecting only the fields needed by the user.

### Institutes

Data is downloaded followed by a ‘institute’ filter applied on it to
fetch only the relevant ‘institute’ (here South African Institute for
Aquatic Biodiversity) data.

``` r

to_download=test.data[1:100,]

result_institutes<-bold.connectr(input.data = to_download,
                                  param = 'processid',
                                  param.index = 1,
                                  api_key = api.key,
                      institutes = "South African Institute for Aquatic Biodiversity",
                      fields = c("bin_uri","processid","inst"))
#> Warning in bold.connectr(input.data = to_download, param = "processid", :
#> Incorrect api key format. Please re-check the API key

# Output showing the first 10 columns

#DT::datatable(result_institutes,class = 'cell-border stripe')
```

### Geographic location

Data is downloaded followed by a ‘geography’ filter applied on it to
fetch only the relevant locations (here Ciudad de Mexico,Antioquia
Colorado) data.

``` r

to_download=test.data[1:100,]

result_geography<-bold.connectr(input.data = to_download,
                                  param = 'processid',
                                  param.index = 1,
                                  api_key = api.key,
                                 geography=c("United States"),
                                fields = c("bin_uri","processid","province.state"))
#> Warning in bold.connectr(input.data = to_download, param = "processid", :
#> Incorrect api key format. Please re-check the API key
                    

# Output showing the first 10 columns

#DT::datatable(result_geography,class = 'cell-border stripe')
```

### Altitude

Data is downloaded followed by a’Altitude’ filter applied on it to fetch
data only between the range of altitude specified (100 to 1500 m a.s.l.)
data.

``` r


result_altitude<-bold.connectr(input.data = test.data,
                                  param = 'processid',
                                  param.index = 1,
                                  api_key = api.key,
                                 altitude = c(100,1500),
                               fields = c("bin_uri","processid","family","elev"))
#> Warning in bold.connectr(input.data = test.data, param = "processid",
#> param.index = 1, : Incorrect api key format. Please re-check the API key
                    

# Output showing the first 10 columns

#DT::datatable(result_altitude,class = 'cell-border stripe')
```

### Collection period

Data is downloaded followed by a ‘Collection period’ filter applied on
it to fetch data only between the range of dates specified (2009-2010)
data.

``` r

result_collection.per<-bold.connectr(input.data = test.data,
                                  param = 'processid',
                                  param.index = 1,
                                  api_key = api.key,
                                 collection.period = c( "1995-05-26","2010-01-13"),
                                 fields=c("bin_uri","processid","collection_date_start","collection_date_end"))
#> Warning in bold.connectr(input.data = test.data, param = "processid",
#> param.index = 1, : Incorrect api key format. Please re-check the API key
                    

# Output showing the first 10 columns

#DT::datatable(result_collection.per,class = 'cell-border stripe')
```

## bold.connectr.public

This function retrieves all the public available data based on the
query. NO `api key` is required for this function. It also differs from
`bold.connectr` with respect to the way the data is fetched. Search can
be based on Taxonomic names, geographical locations in addition to ids
(processid and sampleid) and BINs (BIN numbers). All the other filters
can then be used on the downloaded data to refine the result.

### All data retrieved based on taxonomy

``` r

result.public<-bold.connectr.public(taxonomy = c("Panthera leo"),fields = c("bin_uri","processid","genus","species"))
#> Warning in bold.connectr.public(taxonomy = c("Panthera leo"), fields =
#> c("bin_uri", : The combination of any of the taxonomy, geography, bins, ids and
#> datasets inputs should be logical otherwise output obtained might either be
#> empty or not correct
                    

# Output showing the first 10 columns

#DT::datatable(result.public,class = 'cell-border stripe')
```

## All data retrieved based on geography

``` r

result.public.geo<-bold.connectr.public(taxonomy = c("Panthera leo"),geography = "India",fields = c("bin_uri","processid","country.ocean","genus","species"))
#> Warning in bold.connectr.public(taxonomy = c("Panthera leo"), geography =
#> "India", : The combination of any of the taxonomy, geography, bins, ids and
#> datasets inputs should be logical otherwise output obtained might either be
#> empty or not correct
                    

# Output showing the first 10 columns

#DT::datatable(result.public.geo,class = 'cell-border stripe')
```

## All data retrieved based on geography and BINs

``` r

result.public.geo.bin<-bold.connectr.public(taxonomy = c("Panthera leo"),geography = "India",bins = 'BOLD:AAD6819',fields = c("bin_uri","country.ocean","genus","species"))
#> Warning in bold.connectr.public(taxonomy = c("Panthera leo"), geography =
#> "India", : The combination of any of the taxonomy, geography, bins, ids and
#> datasets inputs should be logical otherwise output obtained might either be
#> empty or not correct
                    

# Output showing the first 10 columns

#DT::datatable(result.public.geo.bin,class = 'cell-border stripe')
```

The search parameters of `bold.connectr.public` should be used carefully
if a filtered result (like above) is expected. Wrong combination of
parameters might not retrieve any data.

## data.summary

`data.summary` provides a detailed profile of the data downloaded
through `bold.connectr` or `bold.connectr.public`. This profile is
further broken by data types wherein each type of data get some unique
measures (Ex.mean,mode for numeric data). Profile can also be created
for specific columns using the `columns` argument. The function also
prints the number of rows and columns in the console by default.

## align.seq

This function is currently an internal function of the package (with
documentation). This function acts as a wrapper around the `msa` and
`Biostrings` package functions for users of `BOLDconnectR` by which they
can carry out multiple sequence alignment on the downloaded data by
`bold.connectr` and `bold.connectr.public` functions. In order to use
this function following notation needs to be used
`BOLDconnectR:::align.seq`. In addition, the users need to install and
load `msa` and `Biostrings` separately before using this function to
avoid any errors. A function performs alignment using the ‘ClustalOmega’
algorithm by default, though, more refined alignments can be done by
passing additional arguments of the `msa` function to `align.seq`.

    #> using Gonnet

## analyze.seq

This function along with `align.seq` is an internal function of the
package (with documentation). This function acts as a wrapper around the
`dist.dna` and `plot.phylo` functions from `ape` for users of
`BOLDconnectR`. The users can analyse the multiple sequence alignment
output from the `align.seq` to generate a distance matrix, a Neighbor
Joining (NJ) tree visualization and a newick tree output. In order to
use this function following notation needs to be used
`BOLDconnectR:::analyze.seq`. In addition, the users need to install and
load `msa` and `Biostrings` separately before using this function to
avoid any errors. Additional arguments of `dist.dna` can be passed to
`analyze.seq` for more robust analysis.

    #> using Gonnet

<img src="man/figures/README-analyze.seq-1.png" width="100%" style="display: block; margin: auto;" />

## gen.comm.mat

The function transforms the bold.connectr() or bold.connectr.public()
downloaded data into a site X species like matrix. Instead of species
counts (or abundances) though, values in each cell are the counts (or
abundances) of a specific BIN from a site.cat site category or a ‘grid’.
These counts can be generated at any taxonomic hierarchical level for a
single or multiple taxa (This can also be done for ‘bin_uri’; the
difference being that the numbers in each cell would be the number of
times that respective BIN is found at a particular site.cat or ‘grid’).
site.cat can be any of the geography fields (Meta data on fields can be
checked using the bold.fields.info()). Alternatively, grids = TRUE will
generate grids based on the BIN occurrence data (latitude, longitude)
with the size of the grid determined by the user (in sq.m.). For grids
generation, rows with no latitude and longitude data are removed (even
if a corresponding site.cat information is available) while NULL entries
for site.cat are allowed if they have a latitude and longitude value
(This is done because grids are drawn based on the bounding boxes which
only use latitude and longitude values).grids converts the Coordinate
Reference System (CRS) of the data to a ‘Mollweide’ projection by which
distance based grid can be correctly specified. A cell id is also given
to each grid with the lowest number assigned to the lowest latitudinal
point in the dataset. The cellids can be changed as per the user by
making changes in the grids_final sf data frame stored in the output.
The grids can be visualized with view.grids=TRUE. The plot obtained is a
visualization of the grid centroids with their respective names. Please
note that a) if the data has many closely located grids, visualization
with view.grids can get confusing. The argument pre.abs will convert the
counts (or abundances) to 1 and 0. This dataset can then directly be
used as the input data for functions from packages like vegan for
biodiversity analyses.

### community matrix based on grids

<div class="datatables html-widget html-fill-item" id="htmlwidget-c31cbec5518812500836" style="width:100%;height:auto;"></div>
<script type="application/json" data-for="htmlwidget-c31cbec5518812500836">{"x":{"filter":"none","vertical":false,"data":[["1","2","3","4","5"],["cell_1","cell_2","cell_3","cell_4","cell_5"],[{"type":"Polygon","coordinates":[[[-8356271.956325835,-3474087.126149462],[1643728.043674165,-3474087.126149462],[1643728.043674165,6525912.873850537],[-8356271.956325835,6525912.873850537],[-8356271.956325835,-3474087.126149462]]]},{"type":"Polygon","coordinates":[[[1643728.043674165,-3474087.126149462],[11643728.04367417,-3474087.126149462],[11643728.04367417,6525912.873850537],[1643728.043674165,6525912.873850537],[1643728.043674165,-3474087.126149462]]]},{"type":"Polygon","coordinates":[[[11643728.04367417,-3474087.126149462],[21643728.04367416,-3474087.126149462],[21643728.04367416,6525912.873850537],[11643728.04367417,6525912.873850537],[11643728.04367417,-3474087.126149462]]]},{"type":"Polygon","coordinates":[[[-8356271.956325835,6525912.873850537],[1643728.043674165,6525912.873850537],[1643728.043674165,16525912.87385054],[-8356271.956325835,16525912.87385054],[-8356271.956325835,6525912.873850537]]]},{"type":"Polygon","coordinates":[[[1643728.043674165,6525912.873850537],[11643728.04367417,6525912.873850537],[11643728.04367417,16525912.87385054],[1643728.043674165,16525912.87385054],[1643728.043674165,6525912.873850537]]]}]],"container":"<table class=\"cell-border stripe\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>cell.id<\/th>\n      <th>geometry<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"columnDefs":[{"orderable":false,"targets":0},{"name":" ","targets":0},{"name":"cell.id","targets":1},{"name":"geometry","targets":2}],"order":[],"autoWidth":false,"orderClasses":false},"selection":{"mode":"multiple","selected":null,"target":"row","selectable":null}},"evals":[],"jsHooks":[]}</script>

## analyze.alphadiv

    #>   |                                                                              |                                                                      |   0%  |                                                                              |=                                                                     |   1%  |                                                                              |=                                                                     |   2%  |                                                                              |==                                                                    |   3%  |                                                                              |===                                                                   |   4%  |                                                                              |====                                                                  |   5%  |                                                                              |====                                                                  |   6%  |                                                                              |=====                                                                 |   7%  |                                                                              |======                                                                |   8%  |                                                                              |======                                                                |   9%  |                                                                              |=======                                                               |  10%  |                                                                              |========                                                              |  11%  |                                                                              |========                                                              |  12%  |                                                                              |=========                                                             |  13%  |                                                                              |==========                                                            |  14%  |                                                                              |==========                                                            |  15%  |                                                                              |===========                                                           |  16%  |                                                                              |============                                                          |  17%  |                                                                              |=============                                                         |  18%  |                                                                              |=============                                                         |  19%  |                                                                              |==============                                                        |  20%  |                                                                              |===============                                                       |  21%  |                                                                              |===============                                                       |  22%  |                                                                              |================                                                      |  23%  |                                                                              |=================                                                     |  24%  |                                                                              |==================                                                    |  25%  |                                                                              |==================                                                    |  26%  |                                                                              |===================                                                   |  27%  |                                                                              |====================                                                  |  28%  |                                                                              |====================                                                  |  29%  |                                                                              |=====================                                                 |  30%  |                                                                              |======================                                                |  31%  |                                                                              |======================                                                |  32%  |                                                                              |=======================                                               |  33%  |                                                                              |========================                                              |  34%  |                                                                              |========================                                              |  35%  |                                                                              |=========================                                             |  36%  |                                                                              |==========================                                            |  37%  |                                                                              |===========================                                           |  38%  |                                                                              |===========================                                           |  39%  |                                                                              |============================                                          |  40%  |                                                                              |=============================                                         |  41%  |                                                                              |=============================                                         |  42%  |                                                                              |==============================                                        |  43%  |                                                                              |===============================                                       |  44%  |                                                                              |================================                                      |  45%  |                                                                              |================================                                      |  46%  |                                                                              |=================================                                     |  47%  |                                                                              |==================================                                    |  48%  |                                                                              |==================================                                    |  49%  |                                                                              |===================================                                   |  50%  |                                                                              |====================================                                  |  51%  |                                                                              |====================================                                  |  52%  |                                                                              |=====================================                                 |  53%  |                                                                              |======================================                                |  54%  |                                                                              |======================================                                |  55%  |                                                                              |=======================================                               |  56%  |                                                                              |========================================                              |  57%  |                                                                              |=========================================                             |  58%  |                                                                              |=========================================                             |  59%  |                                                                              |==========================================                            |  60%  |                                                                              |===========================================                           |  61%  |                                                                              |===========================================                           |  62%  |                                                                              |============================================                          |  63%  |                                                                              |=============================================                         |  64%  |                                                                              |==============================================                        |  65%  |                                                                              |==============================================                        |  66%  |                                                                              |===============================================                       |  67%  |                                                                              |================================================                      |  68%  |                                                                              |================================================                      |  69%  |                                                                              |=================================================                     |  70%  |                                                                              |==================================================                    |  71%  |                                                                              |==================================================                    |  72%  |                                                                              |===================================================                   |  73%  |                                                                              |====================================================                  |  74%  |                                                                              |====================================================                  |  75%  |                                                                              |=====================================================                 |  76%  |                                                                              |======================================================                |  77%  |                                                                              |=======================================================               |  78%  |                                                                              |=======================================================               |  79%  |                                                                              |========================================================              |  80%  |                                                                              |=========================================================             |  81%  |                                                                              |=========================================================             |  82%  |                                                                              |==========================================================            |  83%  |                                                                              |===========================================================           |  84%  |                                                                              |============================================================          |  85%  |                                                                              |============================================================          |  86%  |                                                                              |=============================================================         |  87%  |                                                                              |==============================================================        |  88%  |                                                                              |==============================================================        |  89%  |                                                                              |===============================================================       |  90%  |                                                                              |================================================================      |  91%  |                                                                              |================================================================      |  92%  |                                                                              |=================================================================     |  93%  |                                                                              |==================================================================    |  94%  |                                                                              |==================================================================    |  95%  |                                                                              |===================================================================   |  96%  |                                                                              |====================================================================  |  97%  |                                                                              |===================================================================== |  98%  |                                                                              |===================================================================== |  99%  |                                                                              |======================================================================| 100%

<img src="man/figures/README-alphadiv-1.png" width="100%" style="display: block; margin: auto;" /><img src="man/figures/README-alphadiv-2.png" width="100%" style="display: block; margin: auto;" />

## analyze.betadiv

<img src="man/figures/README-betadiv-1.png" width="100%" style="display: block; margin: auto;" />

## visualize.geo

<img src="man/figures/README-gen.comm.mat-1.png" width="100%" style="display: block; margin: auto;" />
