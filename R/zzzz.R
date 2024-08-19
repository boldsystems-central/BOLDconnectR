#' msa biostrings installation
#' @importFrom utils install.packages
#' @importFrom BiocManager install
#' @keywords internal
onLoad <- function(libname, pkgname) {
  # Check if BiocManager is installed, and install it if not
  if (!requireNamespace("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager")
  }

  # List of required Bioconductor packages
  required_packages <- c("Biostrings", "msa")

  # Install missing packages using BiocManager
  for (pkg in required_packages) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      BiocManager::install(pkg)
    }
  }
}
