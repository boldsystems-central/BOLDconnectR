#' msa biostrings installation
#' @importFrom utils install.packages
#' @importFrom BiocManager install
#' @keywords internal
onLoad <- function(libname, pkgname) {
  # Check if BiocManager is installed
  if (!requireNamespace("BiocManager", quietly = TRUE)) {
    stop("BiocManager is required but not installed. Please install BiocManager first.")
  }

  # List of required Bioconductor packages
  required_packages <- c("Biostrings", "msa")

  # Install missing packages
  for (pkg in required_packages) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      BiocManager::install(pkg)
    }
  }
}
