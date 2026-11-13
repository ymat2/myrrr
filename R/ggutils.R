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
    ggplot2:::parse_safe(text = x)
  }
}
