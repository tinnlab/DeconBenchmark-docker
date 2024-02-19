suppressMessages(
    suppressWarnings({
        library(BayesPrism)
    })
)

args <- DeconUtils::getArgs(c("bulk", "singleCellExpr", "singleCellLabels"))

myPrism <- new.prism(
  reference=t(args$singleCellExpr),
  mixture=t(args$bulk),
  input.type="count.matrix",
  cell.type.labels = args$singleCellLabels,
  cell.state.labels = args$singleCellLabels,
  key=NULL,
  outlier.cut=0.01,
  outlier.fraction=0.1,
)

bp.res <- run.prism(prism = myPrism, n.cores=8)


P <- get.fraction(bp=bp.res,
                      which.theta="final",
                      state.or.type="state")

DeconUtils::writeH5(NULL, P, "BayesPrism")