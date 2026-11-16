#' Utilities for ggplot2
#'
#' @description
#' Label numbers in scientific notation
#' @param digits passed to `format()`.
#' a positive integer indicating how many significant digits are to be used for numeric and complex
#' @param ... further arguments passed to `format()`.
#' @rdname ggutils
#' @export
label_exp = function(digits = 2, ...) {
  function(x) {
    x = format(x, digits = digits, scientific = TRUE, ...) |>
      stringr::str_replace_all("^(.*)e", "'\\1'e") |>
      stringr::str_replace_all("e", "%*%10^") |>
      stringr::str_replace_all("\\+", "")
    parse_safe(text = x)
  }
}

# Parse takes a vector of n lines and returns m expressions.
# See https://github.com/tidyverse/ggplot2/issues/2864 for discussion.
#
# parse(text = c("alpha", "", "gamma"))
# #> expression(alpha, gamma)
#
# parse_safe(text = c("alpha", "", "gamma"))
# #> expression(alpha, NA, gamma)
#
parse_safe = function(text) {
  check_character(text)
  out = vector("expression", length(text))
  for (i in seq_along(text)) {
    expr = parse(text = text[[i]])
    out[[i]] = if (length(expr) == 0) NA else expr[[1]]
  }
  out
}
