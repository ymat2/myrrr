#' Custom color schemes of tidyplots
#'
#' @examples
#' (energy %>%
#'    tidyplot(year, power, color = energy_source) %>%
#'    add_barstack_absolute() %>%
#'    adjust_colors(new_colors = colors_discrete_set1)
#' @rdname tidyplots_colors
#' @export

colors_discrete_r3 = tidyplots::new_color_scheme(
  palette.colors(palette = "R3"),
  name = "colors_discrete_r3"
)

colors_discrete_r4 = tidyplots::new_color_scheme(
  palette.colors(palette = "R4"),
  name = "colors_discrete_r4"
)

colors_discrete_accent = tidyplots::new_color_scheme(
  palette.colors(palette = "Accent"),
  name = "colors_discrete_accent"
)

colors_discrete_dark2 = tidyplots::new_color_scheme(
  palette.colors(palette = "Dark 2"),
  name = "colors_discrete_dark2"
)

colors_discrete_paired = tidyplots::new_color_scheme(
  palette.colors(palette = "Paired"),
  name = "colors_discrete_paired"
)

colors_discrete_set1 = tidyplots::new_color_scheme(
  palette.colors(palette = "Set 1"),
  name = "colors_discrete_set1"
)

colors_discrete_set2 = tidyplots::new_color_scheme(
  palette.colors(palette = "Set 2"),
  name = "colors_discrete_set2"
)

colors_discrete_set3 = tidyplots::new_color_scheme(
  palette.colors(palette = "Set 3"),
  name = "colors_discrete_set3"
)
