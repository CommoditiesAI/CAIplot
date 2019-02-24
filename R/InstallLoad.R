#' Mutliple load of libraries.
#'
#' Install each package in turn, and load the libraries
#'
#' Function to load (if necessary) and install multiple packages at once
#' Sourced from https://www.listendata.com/2018/12/install-load-multiple-r-packages.html
#' Only works with CRAN packages. Dev packages need to be loaded seperately
#' @param packages One or more libraries to be loaded.
#' @return No return or comments, unless package doesn't exit.
#' @examples
#' packages <- c("extrafont", "scales")
#' InstallLoad(packages)
#' @export
#' @import utils

InstallLoad <- function(packages) {
  k <- packages[!(packages %in% installed.packages()[,"Package"])]
  if(length(k)) {
    install.packages(k, repos="https://cran.rstudio.com/")
    }

  for(package_name in packages) {
    library(package_name, character.only=TRUE, quietly = TRUE)}
  }
