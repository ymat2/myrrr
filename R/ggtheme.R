#' Custom theme for ggplot2
#'
#' @description
#' `theme_my()` slightly modifies [ggplot2::theme_bw()] or [ggplot2::theme_test()]
#' @param theme "bw" or "test". Specifies theme_*().
#' @param base_size base font size, given in pts.
#' @param base_family base font family
#' @param base_line_size base size for line elements
#' @param base_rect_size base size for rect elements
#' @rdname ggtheme
#' @export
theme_my = function(theme = "bw", base_size = 11, base_family = "",
                    base_line_size = base_size/22,
                    base_rect_size = base_size/22) {
  common_theme = function() {
    ggplot2::theme(
      panel.background = ggplot2::element_rect(fill = NA, color = NA),
      axis.title = ggplot2::element_text(colour = "#444444"),
      axis.text = ggplot2::element_text(colour = "#444444"),
      axis.line = ggplot2::element_line(colour = "#444444"),
      axis.ticks = ggplot2::element_line(colour = "#444444"),
      legend.title = ggplot2::element_text(colour = "#444444"),
      legend.text = ggplot2::element_text(colour = "#444444"),
      legend.background = ggplot2::element_rect(fill = NA),
      legend.key = ggplot2::element_rect(fill = NA)
    )
  }

  if (theme == "bw") {
    ggplot2::theme_bw(
      base_size = base_size,
      base_family = base_family,
      base_line_size = base_line_size,
      base_rect_size = base_rect_size
    ) +
      common_theme() +
      ggplot2::theme(panel.grid.minor = ggplot2::element_blank())
  } else if (theme == "test") {
    ggplot2::theme_test(
      base_size = base_size,
      base_family = base_family,
      base_line_size = base_line_size,
      base_rect_size = base_rect_size
    ) +
      common_theme()
  }
}
