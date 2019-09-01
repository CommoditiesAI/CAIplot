#' Mutliple load of libraries.
#'
#' Install each package in turn, and load the libraries
#'
#' Function to install packages (if necessary) and load them at once
#' Sourced from https://www.listendata.com/2018/12/install-load-multiple-r-packages.html
#' Only works with CRAN packages. Dev packages need to be loaded seperately
#'
#' @param packages One or more libraries to be loaded.
#' @param supress If TRUE (default), package startup messages will be suppressed.
#' @param default If TRUE (default) loads a default set of libraries,
#'                i.e. Tidyverse, CAIplot, grid, extrafont, scales
#' @return No return or comments, unless package doesn't exit.
#' @export
#' @import utils

InstallLoad <- function(packages = NULL, supress = TRUE, default = TRUE) {

# Add defaults
  if(default != FALSE) {
    packages <- append(packages, c("tidyverse", "CAIplot", "grid", "extrafont", "scales"))
  }

  for(package in packages) {
    # if package is installed locally, load
      if(package %in% rownames(installed.packages()))
        try(do.call(library, list(package))) # Source 2

    # if package is not installed locally, download and then load
      else {
          install.packages(package, repos = c("http://cran.ma.imperial.ac.uk/", "https://cloud.r-project.org"),
                         dependencies = NA, type = getOption("pkgType"))
          ifelse(supress == TRUE,
                 try(suppressPackageStartupMessages(do.call(library, list(package)))),
                 try(do.call(library, list(package))))
         }
    }
}

