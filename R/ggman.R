#' Manhattan plot based on ggplot2
#'
#' @param x A data.frame.
#' @param chr Chromosome for the horizontal axis
#' @param bp Base pair position
#' @param p Statistics for the vertical axis
#' @param col Vector of color codes of points
#' @param chrlabs Labels of chromosomes to be printed
#' @param sigline Numeric value for a significant line
#' @param logp Boolean to use log-scaled y-axis
#' @param xlab X-axis label
#' @param ylab Y-axis label
#' @param title Title of the plot
#' @param plot Boolean to show plot
#' @param ylim Ranges of y-axis
#' @param ... Other arguments passed on to [ggplot2::geom_point()]
#' @importFrom rlang .data
#' @rdname ggman
#' @export

ggman = function(
    x, chr = "CHR", bp = "POS", p = "P",
    col = c("#1f78b4", "#a6cee3"),
    chrlabs = c(1:10, 12, 14, 17, 20, 24, 36),
    sigline = NULL,
    logp = TRUE,
    xlab = "Chromosome",
    ylab = "P",
    title = NULL,
    plot = TRUE,
    ylim = NULL,
    ...
  ) {
  columns <- c(chr, bp, p)

  if (!all(columns %in% colnames(x))) {
    missing_columns <- columns[!columns %in% colnames(x)]
    stop(paste(
      "Error: The following columns are missing:",
      paste(missing_columns, collapse = ", ")
    ))
  }

  tbl = x |>
    dplyr::select(dplyr::all_of(columns)) |>
    dplyr::rename(chr = !!dplyr::sym(chr), bp = !!dplyr::sym(bp), p = !!dplyr::sym(p)) |>
    dplyr::as_tibble()

  data_cum = tbl |>
    dplyr::group_by(chr) |>
    dplyr::summarise(max_bp = max(bp)) |>
    dplyr::mutate(bp_add = dplyr::lag(cumsum(.data$max_bp), default = 0)) |>
    dplyr::select(chr, .data$bp_add)

  tbl4plot = tbl |>
    dplyr::inner_join(data_cum, by = "chr") |>
    dplyr::mutate(bp_cum = bp + .data$bp_add)

  axis_set = tbl4plot |>
    dplyr::group_by(chr) |>
    dplyr::summarize(center = mean(.data$bp_cum)) |>
    dplyr::mutate(chr = dplyr::if_else(chr %in% chrlabs, as.character(chr), ""))

  if (is.null(ylim)) {
    ymin = 0
    ymax = max(tbl4plot$p)*1.1
    ylim = c(ymin, ymax)
  }

  g = ggplot2::ggplot(tbl4plot) +
    ggplot2::aes(x = .data$bp_cum, y = p, color = forcats::as_factor(chr)) +
    ggplot2::geom_point(...) +
    ggplot2::scale_x_continuous(label = axis_set$chr, breaks = axis_set$center) +
    ggplot2::scale_y_continuous(expand = c(0, 0), limits = ylim) +
    ggplot2::scale_color_manual(values = rep(col, unique(length(axis_set$chr)))) +
    ggplot2::labs(x = xlab, y = ylab, title = title) +
    ggplot2::theme_classic(base_size = 16) +
    ggplot2::theme(
      legend.position = "none",
      panel.grid.major.y = ggplot2::element_line(colour = "#cccccc", linewidth = 1),
      axis.line.x = ggplot2::element_blank(),
      plot.title = ggplot2::element_text(hjust = 0.5)
    )

  if (!is.null(sigline)) {
    g = g + ggplot2::geom_hline(
      yintercept = sigline,
      color = "#8b0000",
      alpha = .75,
      linetype = "dotted",
      linewidth = 2
    )
  }

  if (plot) {
    print(g)
  } else {
    g
  }
}
