#' Clean column names in strings or data.frames
#'
#' Rationalise each of the strings, removing spaces, changing symbols and removing duplication.
#'
#' Sourced from https://drdoane.com/clean-consistent-column-names/
#'
#' @param string Either a data.frame or string for cleaning.
#' @param unique If False (default), allows multiple occurences of each name.
#' @return No return or comments, unless package doesn't exit.
#' @export

CleanNames <- function(string, unique = FALSE) {
  n <- if (is.data.frame(string)) colnames(string) else string

  n <- gsub("%+", "_pct_", n)
  n <- gsub("\\$+", "_dollar_", n)
  n <- gsub("\\€+", "_euro_", n)
  n <- gsub("\\++", "_plus_", n)
  n <- gsub("-+", "_minus_", n)
  n <- gsub("\\*+", "_star_", n)
  n <- gsub("#+", "_cnt_", n)
  n <- gsub("&+", "_and_", n)
  n <- gsub("@+", "_at_", n)

  n <- gsub("[^a-zA-Z0-9_]+", "_", n)
  n <- gsub("([A-Z][a-z])", "_\\1", n)
  n <- tolower(trimws(n))

  n <- gsub("(^_+|_+$)", "", n)

  n <- gsub("_+", "_", n)

  if (unique) n <- make.unique(n, sep = "_")

  if (is.data.frame(string)) {
    colnames(string) <- n
    string
  } else {
    n
  }
}

