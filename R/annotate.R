#' Annotate gene name to bed style dataframe
#'
#' @param df A data.frame. with bed style
#' @param seqnames Colname passed to seqnames.field
#' @param start Colname passed to start.field
#' @param end Colname passed to end.field
#' @param colname EctraColname to be printed
#' @importFrom rlang .data
#' @rdname annotate
#' @export


annotate = function(df, seqnames, start, end, colname = NULL) {
  gr = GenomicRanges::makeGRangesFromDataFrame(
    df,
    keep.extra.columns = TRUE,
    ignore.strand = TRUE,
    seqnames.field = seqnames,
    start.field = start,
    end.field = end
  )

  gff_path = system.file("extdata", "GRCg7b.gff", package = "myrrr")
  gff = rtracklayer::import(gff_path, format = "gff")

  df_merge = IRanges::mergeByOverlaps(
      gr,
      gff,
      maxgap = -1L,
      minoverlap = 0L,
      type = "any",
      select = "all"
    ) |> dplyr::as_tibble()

  if (is.null(colname)) {
    df_merge = dplyr::select(
      df_merge,
      .data$gr.seqnames,
      .data$gr.start,
      .data$gr.end,
      .data$gene
    ) |>
      dplyr::rename(
        seqnames = .data$gr.seqnames,
        start = .data$gr.start,
        end = .data$gr.end
    )
  } else {
    df_merge = dplyr::select(
      df_merge,
      .data$gr.seqnames,
      .data$gr.start,
      .data$gr.end,
      !!dplyr::sym(colname),
      .data$gene
    ) |>
      dplyr::rename(
        seqnames = .data$gr.seqnames,
        start = .data$gr.start,
        end = .data$gr.end
    )
  }

  return(df_merge)
}
