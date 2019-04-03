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
#' @param default Loads a default set of libraries,
#'                I.e. Tidyverse, CAIplot, grid, extrafont, scales
#' @return No return or comments, unless package doesn't exit.
#' @examples
#' packages <- c("officer", "forecast")
#' InstallLoad(packages)
#' @export
#' @import utils

InstallLoad <- function(packages, supress = TRUE, default = TRUE, verbose = FALSE) {
  if(default == TRUE) (packages <- append(packages, c("tidyverse", "CAIplot", "grid", "extrafont", "scales"))) # Add defaults

# Do any of the packages need installing
  k <- packages[!(packages %in% installed.packages()[,"Package"])]
  if(length(k)) {
    ifelse(supress == TRUE,
           suppressPackageStartupMessages(install.packages(k, repos="https://cran.rstudio.com/")),
           install.packages(k, repos="https://cran.rstudio.com/"))
    }

  # Load the packages
  for(package_name in packages) {
    library(package_name, character.only=TRUE, quietly = TRUE)}

  }
