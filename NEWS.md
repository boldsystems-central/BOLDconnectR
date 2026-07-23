# BOLDconnectR 1.0.1

## New features

* Added a new BOLDconnectR workflow vignette.
* Updated `bold.analyze.tree` to include the `ape::DNAbin` object in the returned results.
* Added a Barcode Core Data Model (BCDM) test data set named `test.data2` 

## Improvements

* Improved error messages in `bold.public.search`, including clearer handling of the 1M-record limit.
* Enhanced `tryCatch` handling across all steps in `bold.public.search`.
* Optimized `bold.fetch` by ensuring `bold.bcdm.fields` is called only once per run.
* Replaced `dcast()` with `pivot_wider()` in `gen.comm.mat`.
* Reformatted code using `styler`.

## Bug fixes

* Added support for the `taxon.name` argument in `bold.analyze.diversity`.
* Added error handling for empty data frames in `bold.analyze.diversity`.
* Updated the start and end date error message in `bold.full.search`
* Fixed sequence alignment output conversion to improve compatibility with updated Bioconductor packages.

## Miscellaneous

* Updated author list.
* Introduced `NEWS.md` to document versioned package changes.
