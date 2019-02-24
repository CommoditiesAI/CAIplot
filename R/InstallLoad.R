# load (if necessary) and install multiple packages at once
# https://www.listendata.com/2018/12/install-load-multiple-r-packages.html
# Only works with CRAN packages. Dev packages need to be loaded seperately

InstallLoad <- function(packages) {
  k <- packages[!(packages %in% installed.packages()[,"Package"])]
  if(length(k)) {
    install.packages(k, repos="https://cran.rstudio.com/")
    }

  for(package_name in packages) {
    library(package_name, character.only=TRUE, quietly = TRUE)}
  }
