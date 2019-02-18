# Function for finalising a graphic - resize, add logo and source

  # Save the plot as a grid
    save_plot <- function(plot_grid, width, height, save_filepath) {
    grid::grid.draw(plot_grid)
    ggplot2::ggsave(filename = save_filepath, device = "png",
                    plot=plot_grid, width=(width/72), height=(height/72),  bg="white")
  }

  # Left align text
    left_align <- function(plot_name, pieces){
      grob <- ggplot2::ggplotGrob(plot_name)
      n <- length(pieces)
      grob$layout$l[grob$layout$name %in% pieces] <- 2
      return(grob)
    }

  #Make the footer
    create_footer <- function (source_name = "CA&I", logo_image_path = "../graphics/cropped-CAI-logo-4.png") {
      footer_text <- paste0("Source: ", source_name, " 	\xA9")  # Footer text parse(text='70^o*N')
      footer <- grid::grobTree(grid::linesGrob(x = grid::unit(c(0, 1), "npc"), y = grid::unit(1.2, "npc")), # Height of line
                               grid::textGrob(footer_text,
                                              x = 0.004, hjust = 0, gp = grid::gpar(fontsize=10)), # Size of text
                               grid::rasterGrob(png::readPNG(logo_image_path), x = 0.954))
      return(footer)
    }

  #' Arrange alignment and save CAI ggplot chart
  #'
  #' Running this function will save your plot with the correct guidelines for publication for a CAI graphic.
  #' It will left align your title, subtitle and source, add the CAI blocks at the bottom right and save it to your specified location.
  #' @param plot_name The variable name of the plot you have created that you want to format and save
  #' @param source_name The text you want to come after the text 'Source:' in the bottom left hand side of your side
  #' @param save_filepath Exact filepath that you want the plot to be saved to
  #' @param width_pixels Width in pixels that you want to save your chart to - defaults to 640
  #' @param height_pixels Height in pixels that you want to save your chart to - defaults to 450
  #' @param logo_image_path File path for the logo image you want to use in the right hand side of your chart,
  #'  which needs to be a PNG file - defaults to CAI blocks image that sits within the data folder of your package
  #' @return (Invisibly) an updated ggplot object.

  #' @keywords finalise_plot
  #' @examples
  #' finalise_plot(plot_name = myplot,
  #' source = "The source for my data",
  #' save_filepath = "filename_that_my_plot_should_be_saved_to-nc.png",
  #' width_pixels = 640,
  #' height_pixels = 450,
  #' logo_image_path = "logo_image_filepath.png"
  #' )
  #'
  #' @export

  finalise_plot <- function(plot_name = last_plot(),
                          source_name = "CA&I",
                          save_filepath = paste0(getwd(), "/my_stacked_bars.png"),
                          width_pixels = 640,
                          height_pixels = 450,
                          logo_image_path) {
    library(png)

    # CAI logo
      link <- "http://commoditiesanalysis.co.uk/wp-content/uploads/2018/07/cropped-CAI-logo-4.png"

    # Check if file exists, if not, download it from the website
      if(file.exists(basename(link)) == FALSE) {
        download.file(link, destfile =  basename(link), mode = 'wb')
      }

    logo <- readPNG(basename(link))

    footer <- create_footer(source_name = "CA&I", logo_image_path = "../graphics/cropped-CAI-logo-4.png")

    #Draw your left-aligned grid
      plot_left_aligned <- left_align(plot_name, c("subtitle", "title", "caption"))
      plot_grid <- ggpubr::ggarrange(plot_left_aligned, footer,
                                   ncol = 1, nrow = 2,
                                   heights = c(1, 0.065/(height_pixels/450))) # Size of logo
    #  print(paste("Saving to", save_filepath))
      save_plot(plot_grid, width_pixels, height_pixels, save_filepath)
    ## Return (invisibly) a copy of the graph. Can be assigned to a variable or silently ignored.
      invisible(plot_grid)
  }

  CAIstyle <- function () {
    font <- "Gill Sans MT"
    ggplot2::theme(plot.title = ggplot2::element_text(family = font,
                                                      size = 28, face = "bold", color = "#222222"), plot.subtitle = ggplot2::element_text(family = font,
                                                                                                                                          size = 22, margin = ggplot2::margin(9, 0, 9, 0)), plot.caption = ggplot2::element_blank(),
                   legend.position = "top", legend.text.align = 0, legend.background = ggplot2::element_blank(),
                   legend.title = ggplot2::element_blank(), legend.key = ggplot2::element_blank(),
                   legend.text = ggplot2::element_text(family = font, size = 18,
                                                       color = "#222222"), axis.title = ggplot2::element_blank(),
                   axis.text = ggplot2::element_text(family = font, size = 18,
                                                     color = "#222222"), axis.text.x = ggplot2::element_text(margin = ggplot2::margin(5,
                                                                                                                                      b = 10)), axis.ticks = ggplot2::element_blank(),
                   axis.line = ggplot2::element_blank(), panel.grid.minor = ggplot2::element_blank(),
                   panel.grid.major.y = ggplot2::element_line(color = "#cbcbcb"),
                   panel.grid.major.x = ggplot2::element_blank(), panel.background = ggplot2::element_blank(),
                   strip.background = ggplot2::element_rect(fill = "white"),
                   strip.text = ggplot2::element_text(size = 22, hjust = 0))
  }
