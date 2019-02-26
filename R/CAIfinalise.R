#' Arrange alignment and save CAI ggplot chart.
#'
#' Function for finalising a graphic - resize, add logo and source, then save.
#'
#' Running this function will save your plot with the correct guidelines for publication for a CAI graphic.
#' It will left align your title, subtitle and source, add the CAI logo at the bottom right and save it to your specified location.
#' @param plot_name The variable name of the plot you have created that you want to format and save
#' @param source The text you want to come after the text 'Source:' in the bottom left hand side of your side
#' @param filename Exact name of file that you want to save to
#' @param filepath Exact path to the directory you want to save to
#' @param size Specify the size - "full", "half", "long", or "manual", which references height and width
#' @param width Width in pixels that you want to save your chart to - defaults to 640
#' @param height Height in pixels that you want to save your chart to - defaults to 450
#' @param logo_path File path for the logo image you want to use in the right hand side of your chart,
#'  which needs to be a PNG file - defaults to CAI blocks image that sits within the data folder of your package
#' @return (Invisibly) an updated ggplot object.
#' @source BBCplot (function) reworked.
#' @keywords finalise_plot
#' @examples
#' data(mtcars)
#' mtcars$cyl <- as.factor(mtcars$cyl)
#'
#' mtcar <- ggplot(data = mtcars) +
#'   geom_point(aes(x = hp, y = mpg, colour = cyl)) +
#'   labs(title = "Power versus efficiency", x = "Power (HP)", y = "Efficiency (MPG)")
#'
#' mtcar
#'
#' CAIfinalise()
#' CAIfinalise(plot_name = "mtcar")
#' CAIfinalise(plot_name = "mtcar", filename = "mtcar.png")
#' @export
#' @import dplyr ggplot2 ggpubr jpeg png rsvg stringr


CAIfinalise <- function(plot_name = last_plot(),
                          source = "CA&I  \xA9",
                          filename = "unnamed_plot.png",
                          filepath = getwd(),
                          size = "full",
                          width = 640,
                          height = 450,
                          logo_path = "http://commoditiesanalysis.co.uk/wp-content/uploads/2018/07/cropped-CAI-logo-4.png") {

  options(warn=-1)

  # Needed to cope with plot_name being passed with or without quotes
    if(class(plot_name) == "character") {plot_name <- get(plot_name)}

  # Check that the filename ends in .png, .jpg, or .gif.  If not, add ".png" to the end of the filename
    filename <- ifelse(sum(endsWith(filename, c(".png", ".jpg", ".gif")) == 1), filename, paste0(filename, ".png"))
    filename <- ifelse(filename == "unnamed_plot.png", paste0("UnnamedPlot_", format(Sys.time(), "%b%d_%H%M"), ".png"), filename)   # Time stamp filename, if not given
    save_file <- paste0(filepath, "/", filename)   # Create the file name for saving

  # Case of size, to give width and height
    size <- stringr::str_to_lower(size)
    height <- dplyr::case_when(
      size == "full" ~ 450, # Full page graphic
      size == "half" ~ 450, # Half page graphic, e.g. Powerpoint
      size == "long" ~ 220, # Long graphic across page, e.g. up and over
      size == "manual" ~ height, # User chosen
      TRUE ~ 450) # Standard if not specified

    width <- dplyr::case_when(
      size == "full" ~ 650,
      size == "half" ~ 315,
      size == "long" ~ 650,
      size == "manual" ~ width,
      TRUE ~ 650)

# if logo is specificed, use it, otherwise use default
    link <- logo_path

# Check if file exists, if not, download it from the website
    if(file.exists(basename(link)) == FALSE) {
      utils::download.file(link, destfile =  basename(link), mode = 'wb')
  }

# Convert files to PNG
    # If file is .svg
      if(tools::file_ext(link) == "svg") {
        old.link <- link
        link <- paste0(strsplit(basename(link), "\\.")[[1]][1], ".png") # Renames link to the PNG file
        rsvg::rsvg_png(basename(old.link), link)
      }

# If file is .jpg
      if(tools::file_ext(link) == "jpg") {
        old.link <- link
        link <- paste0(strsplit(basename(link), "\\.")[[1]][1], ".png") # Renames link to the PNG file
        img <- jpeg::readJPEG(basename(old.link))
        png::writePNG(img, link)
      }

logo <- png::readPNG(basename(link))
footer <- create_footer(source = source, logo_path = paste0(getwd(), "/", basename(link)))

# Draw left-aligned grid
plot_left_aligned <- left_align(plot_name, c("subtitle", "title", "caption"))
plot_grid <- ggpubr::ggarrange(plot_left_aligned, footer,
                                 ncol = 1, nrow = 2,
                                 heights = c(1, 0.065/(height/450))) # Changes the size of logo


print(paste("Saving to", save_file))
save_plot(plot_grid, width, height, save_file)

## Return (invisibly) a copy of the graph. Can be assigned to a variable or ignored
invisible(plot_grid)
}

# Save the plot as a grid
save_plot <- function(plot_grid, width, height, save_file) {
      grid::grid.draw(plot_grid)
      ggplot2::ggsave(filename = save_file, device = "png",
                  plot=plot_grid, width=(width/72), height=(height/72),  bg="white")
  }

# Left align text
left_align <- function(plot_name, pieces){
      grob <- ggplot2::ggplotGrob(plot_name)
      n <- length(pieces)
      grob$layout$l[grob$layout$name %in% pieces] <- 2
      return(grob)
  }

# Make the footer
create_footer <- function (source, logo_path) {
      footer_text <- paste0("Source: ", source)
      footer <- grid::grobTree(grid::linesGrob(x = grid::unit(c(0, 1), "npc"), y = grid::unit(1.2, "npc")), # Height of line
                               grid::textGrob(footer_text,
                                              x = 0.004, hjust = 0, gp = grid::gpar(fontsize=10)), # Size of text
                               grid::rasterGrob(png::readPNG(logo_path), x = 0.99, just = "right")) # Position of logo
options(warn=0)

return(footer)
}
