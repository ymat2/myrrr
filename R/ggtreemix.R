#' A light-weighted handler of TreeMix result for ggplot2
#' These functions are slightly modified version of `treemix`
#' from `andrewparkermorgan/popcorn`
#'
#' @param stem filename stem (`-o` from command-line) for TreeMix output
#' @rdname ggtreemix
#'
#' @importFrom stats var
#' @importFrom utils read.table
#' @export
read_treemix = function(stem, ...) {

  suffix = c("cov.gz", "modelcov.gz", "treeout.gz", "vertices.gz", "edges.gz", "llik")
  ff = sapply(suffix, function(f) paste0(stem, ".", f))
  if (!all(sapply(ff, file.exists))) {
    stop(stringr::str_c("Can't find all outputs from TreeMix run with prefix '", stem, "'"))
  }

  cov = as.matrix(read.table(gzfile(ff[1]), as.is = TRUE, header = TRUE, quote = "", comment.char = ""))
  mod = as.matrix(read.table(gzfile(ff[2]), as.is = TRUE, header = TRUE, quote = "", comment.char = ""))
  resid = mod - cov
  i = upper.tri(resid, diag = FALSE)
  sse = sum((resid[i] - mean(resid[i]))^2)
  ssm = sum((mod[i] - mean(mod[i]))^2)
  r2 = 1 - sse/ssm

  llik.raw = readLines(ff[6], n = 2)[2]
  llik.matched = stringr::str_match(llik.raw, "with (.+) migration events: (.+)\\s+")
  llik = as.double(llik.matched[,3])
  m = as.integer(llik.matched[,2])

  d = stringr::str_c(stem, ".vertices.gz")
  d = read.table(gzfile(d), as.is = TRUE, comment.char = "", quote = "")
  e = stringr::str_c(stem, ".edges.gz")
  e = read.table(gzfile(e), as.is = TRUE, comment.char = "", quote = "")

  e[,3] = e[,3]*e[,4]

  tree = ape::read.tree(text = readLines(gzfile(ff[3]), n = 1))

  obj = list(cov = cov, cov.est = mod, resid = resid,
             sse = sse, ssm = ssm, r2 = r2, llik = llik, m = m,
             tree = tree, vertices = d, edges = e)
  obj = .prep.layout(obj)

  return(obj)

}


.prep.layout = function(obj, o = NA, flip = vector(), ...) {

  d = obj$vertices
  e = obj$edges

  for(i in seq_along(flip)) {
    d = .flip.node(d, flip[i])
  }
  d$x = NA
  d$y = NA
  d$ymin = NA
  d$ymax = NA

  d = .set.y.coords(d)
  d = .set.x.coords(d, e)
  d = .set.mig.coords(d, e)

  #print(e)
  stuff = .layout.treemix(d, e, o = o)

  return(list(layout = stuff, vertices = d, edges = e))

}

#' Plot treemix result using `ggplot2`
#'
#' @param obj treemix result parsed by `read_treemix()`
#' @param plot.nodes Whether to plot nodes
#' @param plot.migration Whether to plot migration edges
#' @param branch.colour Color of tree branch
#' @param branch.width Linewidth of tree branch
#' @param arrow.width Linewidth of migration edges
#' @param label Whether to show tip names
#' @rdname ggtreemix
#'
#' @export
plot_treemix = function(
    obj,
    plot.nodes = FALSE,
    plot.migration = TRUE,
    branch.colour = "#333333",
    branch.width = 0.5,
    arrow.width = 0.5,
    label = TRUE,
    ...
  ) {

  stuff = obj$layout
  d = obj$vertices
  e = obj$edges

  tdepth = max(stuff$tips$x, na.rm = TRUE)
  d$xo = d$x + 0.01*tdepth
  stuff$tips$xo = stuff$tips$x + 0.01*tdepth
  p = ggplot2::ggplot(stuff$tips) +
    ggplot2::geom_segment(
      data = subset(stuff$edges, type == "NOT_MIG"),
      ggplot2::aes(x = from.x, y = from.y, xend = to.x, yend = to.y),
      colour = branch.colour,
      linewidth = branch.width
    ) +
    ggplot2::scale_x_continuous() +
    ggplot2::xlab("\ndrift parameter")

  if (plot.migration && nrow(subset(stuff$edges, type == "MIG"))) {
    p = p +
      ggplot2::geom_curve(
        data = subset(stuff$edges, type == "MIG"),
        ggplot2::aes(x = from.x, y = from.y, xend = to.x, yend = to.y, colour = weight),
        curvature = 0, linewidth = arrow.width,
        arrow = grid::arrow(length = grid::unit(6, "points"), type = "open"),
        alpha = 0.5
      ) +
      # ggplot2::geom_point(
      #   data = subset(stuff$edges, type == "MIG"),
      #   ggplot2::aes(x = from.x, y = from.y, colour = weight)
      # ) +
      ggplot2::scale_colour_gradient(
        "Migration weight",
        high = "#ff3100",
        low = "#ffdc00"
      )
  }

  if (label)
    p = p + ggplot2::geom_text(ggplot2::aes(x = xo, y = y, label = pop), hjust = 0)

  if (plot.nodes)
    p = p + ggplot2::geom_point(data = d, ggplot2::aes(x = x, y = y))

  attr(p, "tips") = tibble::as_tibble(stuff$tips)
  attr(p, "edges") = tibble::as_tibble(stuff$edges)

  return(p)

}

#' Original treemix like plot theme
#'
#' @rdname ggtreemix
#' @param ... passed to [ggplot2::theme_bw()].
#'
#' @export
theme_treemix = function(...) {
  ggplot2::theme_bw(...) +
    ggplot2::theme(
      axis.line.y = ggplot2::element_blank(),
      axis.ticks.y = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_blank(),
      axis.title.y = ggplot2::element_blank(),
      axis.line.x = ggplot2::element_line(),
      panel.grid = ggplot2::element_blank(),
      panel.border = ggplot2::element_blank()
    )
}

## modified from TreeMix source

.set.y.coords = function(d) {

  i = which(d[,3]=="ROOT")
  y = d[i,8]/ (d[i,8]+d[i,10])
  d[i,]$y = 1-y
  d[i,]$ymin = 0
  d[i,]$ymax = 1
  c1 = d[i,7]
  c2 = d[i,9]
  ni = which(d[,1]==c1)
  ny = d[ni,8]/ (d[ni,8]+d[ni,10])
  d[ni,]$ymin = 1-y
  d[ni,]$ymax = 1
  d[ni,]$y = 1- ny*(y)

  ni = which(d[,1]==c2)
  ny = d[ni,8]/ (d[ni,8]+d[ni,10])
  d[ni,]$ymin = 0
  d[ni,]$ymax = 1-y
  d[ni,]$y = (1-y)-ny*(1-y)

  for (j in 1:nrow(d)){
    d = .set.y.coord(d, j)
  }
  return(d)
}

.set.y.coord = function(d, i) {

  index = d[i,1]
  parent = d[i,6]
  if (!is.na(d[i,]$y)){
    return(d)
  }
  tmp = d[d[,1] == parent,]
  if ( is.na(tmp[1,]$y)){
    d = .set.y.coord(d, which(d[,1]==parent))
    tmp = d[d[,1]== parent,]
  }
  py = tmp[1,]$y
  pymin = tmp[1,]$ymin
  pymax = tmp[1,]$ymax
  f = d[i,8]/( d[i,8]+d[i,10])
  #print (paste(i, index, py, pymin, pymax, f))
  if (tmp[1,7] == index){
    d[i,]$ymin = py
    d[i,]$ymax = pymax
    d[i,]$y = pymax-f*(pymax-py)
    if (d[i,5]== "TIP"){
      d[i,]$y = (py+pymax)/2
    }
  }
  else{
    d[i,]$ymin = pymin
    d[i,]$ymax = py
    d[i,]$y = py-f*(py-pymin)
    if (d[i,5]== "TIP"){
      d[i,]$y = (pymin+py)/2
    }

  }
  return(d)
}


.set.x.coords = function(d, e) {

  i = which(d[,3]=="ROOT")
  index = d[i,1]
  d[i,]$x = 0
  c1 = d[i,7]
  c2 = d[i,9]
  ni = which(d[,1]==c1)
  tmpx =  e[e[,1]==index & e[,2] == c1,3]
  if (length(tmpx) == 0){
    tmp = e[e[,1] == index,]
    tmpc1 = tmp[1,2]
    if ( d[d[,1]==tmpc1,4] != "MIG"){
      tmpc1 = tmp[2,2]
    }
    tmpx = .get.dist.to.nmig(d, e, index, tmpc1)
  }
  if(tmpx < 0){
    tmpx = 0
  }
  d[ni,]$x = tmpx

  ni = which(d[,1]==c2)
  tmpx =  e[e[,1]==index & e[,2] == c2,3]
  if (length(tmpx) == 0){
    tmp = e[e[,1] == index,]
    tmpc2 = tmp[2,2]
    if ( d[d[,1]==tmpc2,4] != "MIG"){
      tmpc2 = tmp[1,2]
    }
    tmpx = .get.dist.to.nmig(d, e, index, tmpc2)
  }
  if(tmpx < 0){
    tmpx = 0
  }
  d[ni,]$x = tmpx

  for (j in 1:nrow(d)){
    d = .set.x.coord(d, e, j)
  }
  return(d)

}


.set.x.coord = function(d, e, i) {

  index = d[i,1]
  parent = d[i,6]
  if (!is.na(d[i,]$x)){
    return(d)
  }
  tmp = d[d[,1] == parent,]
  if ( is.na(tmp[1,]$x)){
    d = .set.x.coord(d, e, which(d[,1]==parent))
    tmp = d[d[,1]== parent,]
  }
  #print (paste(parent, index))
  tmpx = e[e[,1]==parent & e[,2] == index,3]
  if (length(tmpx) == 0){
    tmp2 = e[e[,1] == parent,]
    tmpc2 = tmp2[2,2]
    #print
    if ( d[d[,1]==tmpc2,4] != "MIG"){
      tmpc2 = tmp2[1,2]
    }
    tmpx = .get.dist.to.nmig(d, e, parent, tmpc2)
  }
  if(tmpx < 0){
    tmpx = 0
  }
  d[i,]$x = tmp[1,]$x+ tmpx
  return(d)

}

.layout.treemix = function(d, e, o = NA, ...) {

  ## containers for return values
  ne = nrow(e)
  from.x = numeric(ne)
  from.y = numeric(ne)
  to.x = numeric(ne)
  to.y = numeric(ne)
  etype = character(ne)
  weight = numeric(ne)

  ## loop over edges
  for(i in 1:nrow(e)) {
    v1 = d[d[,1] == e[i,1],]
    v2 = d[d[,1] == e[i,2],]
    from.x[i] = v1[1,]$x
    from.y[i] = v1[1,]$y
    to.x[i] = v2[1,]$x
    to.y[i] = v2[1,]$y
    etype[i] = e[i,5]
    weight[i] = e[i,4]
  }

  edges = data.frame(from.x = from.x, from.y = from.y, to.x = to.x, to.y = to.y,
                      type = factor(etype), weight = weight)

  tmp = d[d[,5] == "TIP",]
  tips = with(tmp, data.frame(x = x, y = y, pop = V2))

  return( list(edges = edges, tips = tips) )

}

.set.mig.coords = function(d, e) {

  for (j in 1:nrow(d)){
    if (d[j,4] == "MIG"){
      p = d[d[,1] == d[j,6],]
      c = d[d[,1] == d[j,7],]
      tmpe = e[e[,1] == d[j,1],]
      y1 = p[1,]$y
      y2 = c[1,]$y
      x1 = p[1,]$x
      x2 = c[1,]$x

      mf = tmpe[1,6]
      if (is.nan(mf)){
        mf = 0
      }
      #d[j,]$y = (y1+y2)* mf
      #d[j,]$x = (x1+x2) *mf
      d[j,]$y = y1+(y2-y1)* mf
      #print(paste(mf, x1, x2))
      d[j,]$x = x1+(x2-x1) *mf
    }

  }

  return(d)

}

.get.f = function(stem){
  d = paste(stem, ".cov.gz", sep = "")
  d2 = paste(stem, ".modelcov.gz", sep = "")
  d = read.table(gzfile(d), as.is = T, comment.char = "", quote = "")
  d2 = read.table(gzfile(d2), as.is = T, comment.char = "", quote = "")
  d = d[order(names(d)), order(names(d))]
  d2 = d2[order(names(d2)), order(names(d2))]
  tmpcf = vector()
  tmpmcf = vector()
  for (j in 1:nrow(d)){
    for (k in (j+1):nrow(d)){
      tmpcf = append(tmpcf, d[j,k])
      tmpmcf = append(tmpmcf, d[j,k] - d2[j,k])
    }
  }
  tmpv = var(tmpmcf)/var(tmpcf)
  return(1-tmpv)

}

.get.dist.to.nmig = function(d, e, n1, n2) {
  toreturn = e[e[,1] == n1 & e[,2] == n2,3]
  #print(toreturn)
  while ( d[d[,1] == n2,4] == "MIG"){
    tmp = e[e[,1] == n2 & e[,5] == "NOT_MIG",]
    toreturn = toreturn+tmp[1,3]
    n2 = tmp[1,2]
  }
  return(toreturn)
}

.flip.node = function(d, n){

  i = which(d[,1] == n)
  t1 = d[i,7]
  t2 = d[i,8]
  d[i,7] = d[i,9]
  d[i,8] = d[i,10]
  d[i,9] = t1
  d[i,10] = t2
  return(d)

}
