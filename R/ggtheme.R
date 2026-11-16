#' Custom theme for ggplot2
#'
#' @description
#' `theme_test2()` slightly modifies [ggplot2::theme_test()].
#' Same fontsize for all text,
#' centered titles,
#' no strip color,
#' and thinner left margin in legend texts.
#' @param base_size base font size, given in pts.
#' @param base_family base font family
#' @param header_family font family for titles and headers.
#' The default, NULL, uses theme inheritance to set the font.
#' This setting affects axis titles, legend titles, the plot title and tag text.
#' @param base_line_size base size for line elements
#' @param base_rect_size base size for rect elements
#' @param ink,paper,accent colour for foreground, background, and accented elements respectively.
#' @rdname ggtheme
#' @export
theme_test2 = function(
    base_size = 11,
    base_family = "",
    header_family = NULL,
    base_line_size = base_size / 22,
    base_rect_size = base_size / 22,
    ink = "black",
    paper = "white",
    accent = "#3366FF"
) {
  half_line = base_size / 2

  t = ggplot2::theme(
    line = ggplot2::element_line(
      colour = ink,
      linewidth = base_line_size,
      linetype = 1,
      lineend = "butt",
      linejoin = "round"
    ),
    rect = ggplot2::element_rect(
      fill = paper,
      colour = ink,
      linewidth = base_rect_size,
      linetype = 1,
      linejoin = "round"
    ),
    text = ggplot2::element_text(
      family = base_family,
      face = "plain",
      colour = ink,
      size = base_size,
      lineheight = 0.9,
      hjust = 0.5,
      vjust = 0.5,
      angle = 0,
      margin = ggplot2::margin(),
      debug = FALSE
    ),
    point = ggplot2::element_point(
      colour = ink,
      shape = 19,
      fill = paper,
      size = (base_size / 11) * 1.5,
      stroke = base_line_size
    ),
    polygon = ggplot2::element_polygon(
      fill = paper,
      colour = ink,
      linewidth = base_rect_size,
      linetype = 1,
      linejoin = "round"
    ),
    title = ggplot2::element_text(family = header_family),
    spacing = ggplot2::unit(half_line, "pt"),
    margins = ggplot2::margin_auto(half_line),
    geom = ggplot2::element_geom(
      ink = ink,
      paper = paper,
      accent = accent,
      linewidth = base_line_size,
      borderwidth = base_line_size,
      family = base_family,
      fontsize = base_size,
      linetype = 1L,
      pointsize = (base_size / 11) * 1.5,
      pointshape = 19
    ),

    axis.line = ggplot2::element_blank(),
    axis.line.x = NULL,
    axis.line.y = NULL,
    axis.text = ggplot2::element_text(
      size = ggplot2::rel(1),
      colour = scales::col_mix(ink, paper, 0.302)
    ),
    axis.text.x = ggplot2::element_text(
      margin = ggplot2::margin(t = 0.8 * half_line / 2),
      vjust = 1
    ),
    axis.text.x.top = ggplot2::element_text(
      margin = ggplot2::margin(b = 0.8 * half_line / 2),
      vjust = 0
    ),
    axis.text.y = ggplot2::element_text(
      margin = ggplot2::margin(r = 0.8 * half_line / 2),
      hjust = 1
    ),
    axis.text.y.right = ggplot2::element_text(
      margin = ggplot2::margin(l = 0.8 * half_line / 2),
      hjust = 0
    ),
    axis.ticks = ggplot2::element_line(
      linewidth = ggplot2::rel(.5),
      colour = scales::col_mix(ink, paper, 0.2)
    ),
    axis.ticks.length = ggplot2::rel(0.5),
    axis.ticks.length.x = NULL,
    axis.ticks.length.x.top = NULL,
    axis.ticks.length.x.bottom = NULL,
    axis.ticks.length.y = NULL,
    axis.ticks.length.y.left = NULL,
    axis.ticks.length.y.right = NULL,
    axis.minor.ticks.length = ggplot2::rel(0.75),
    axis.title.x = ggplot2::element_text(
      margin = ggplot2::margin(t = half_line / 2),
      vjust = 1
    ),
    axis.title.x.top = ggplot2::element_text(
      margin = ggplot2::margin(b = half_line / 2),
      vjust = 0
    ),
    axis.title.y = ggplot2::element_text(
      angle = 90,
      margin = ggplot2::margin(r = half_line / 2),
      vjust = 1
    ),
    axis.title.y.right = ggplot2::element_text(
      angle = -90,
      margin = ggplot2::margin(l = half_line / 2),
      vjust = 1
    ),

    legend.background = ggplot2::element_rect(colour = NA),
    legend.spacing = ggplot2::rel(2),
    legend.spacing.x = NULL,
    legend.spacing.y = NULL,
    legend.margin = ggplot2::margin_auto(0, unit = "cm"),
    legend.key = NULL,
    legend.key.size = ggplot2::unit(1.2, "lines"),
    legend.key.height = NULL,
    legend.key.width = NULL,
    legend.key.spacing = NULL,
    legend.key.spacing.x = NULL,
    legend.key.spacing.y = NULL,
    legend.text = ggplot2::element_text(
      size = ggplot2::rel(1),
      margin = ggplot2::margin(l = 0)
    ),
    legend.title = ggplot2::element_text(hjust = 0),
    legend.ticks.length = ggplot2::rel(0.2),
    legend.position = "right",
    legend.direction = NULL,
    legend.justification = "center",
    legend.box = NULL,
    legend.box.margin = ggplot2::margin_auto(0, unit = "cm"),
    legend.box.background = ggplot2::element_blank(),
    legend.box.spacing = ggplot2::rel(2),

    panel.background = ggplot2::element_rect(fill = paper, colour = NA),
    panel.border = ggplot2::element_rect(colour = scales::col_mix(ink, paper, 0.2)),
    panel.grid.major = ggplot2::element_blank(),
    panel.grid.minor = ggplot2::element_blank(),
    panel.spacing = NULL,
    panel.spacing.x = NULL,
    panel.spacing.y = NULL,
    panel.ontop = FALSE,

    strip.background = ggplot2::element_rect(
      fill = scales::col_mix(ink, paper, 0.85),
      colour = NA),
    strip.clip = "on",
    strip.text = ggplot2::element_text(
      colour = scales::col_mix(ink, paper, 0.1),
      size = ggplot2::rel(1),
      margin = ggplot2::margin_auto(0.8 * half_line)
    ),
    strip.text.x = NULL,
    strip.text.y = ggplot2::element_text(angle = -90),
    strip.text.y.left = ggplot2::element_text(angle = 90),
    strip.placement = "inside",
    strip.placement.x = NULL,
    strip.placement.y = NULL,
    strip.switch.pad.grid = ggplot2::rel(0.5),
    strip.switch.pad.wrap = ggplot2::rel(0.5),

    plot.background = ggplot2::element_rect(colour = paper),
    plot.title = ggplot2::element_text(
      size = ggplot2::rel(1),
      hjust = .5,
      vjust = 1,
      margin = ggplot2::margin(b = half_line)
    ),
    plot.title.position = "panel",
    plot.subtitle = ggplot2::element_text(
      hjust = .5,
      vjust = 1,
      margin = ggplot2::margin(b = half_line)
    ),
    plot.caption = ggplot2::element_text(
      size = ggplot2::rel(1),
      hjust = 1,
      vjust = 1,
      margin = ggplot2::margin(t = half_line)
    ),
    plot.caption.position = "panel",
    plot.tag = ggplot2::element_text(
      size = ggplot2::rel(1.2),
      hjust = 0.5,
      vjust = 0.5
    ),
    plot.tag.position = 'topleft',
    plot.margin = NULL,

    complete = TRUE
  )
}

#' @importFrom ggplot2 %+replace%
NULL
#' @export
#' @rdname ggtheme
theme_classic2 = function(
    base_size = 11,
    base_family = "",
    header_family = NULL,
    base_line_size = base_size / 22,
    base_rect_size = base_size / 22,
    ink = "black",
    paper = "white",
    accent = "#3366FF"
) {
  theme_test2(
    base_size = base_size,
    base_family = base_family,
    header_family = header_family,
    base_line_size = base_line_size,
    base_rect_size = base_rect_size,
    ink = ink,
    paper = paper,
    accent = accent
  ) %+replace%
    ggplot2::theme(
      # no background and no grid
      panel.border = ggplot2::element_blank(),

      # show axes
      axis.line = ggplot2::element_line(
        lineend = "square",
        linewidth = ggplot2::rel(.5)
      ),

      complete = TRUE
    )
}
