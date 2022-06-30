args <- DeconUtils::getArgs(c("bulk", "cellTypeExpr"))

suppressMessages(
  suppressWarnings({
      library("dtangle")
    })
)


args$bulk <- log2(args$bulk + 1)
args$cellTypeExpr <- log2(args$cellTypeExpr + 1)

P <- dtangle(Y=t(args$bulk), references = t(args$cellTypeExpr))$estimates

DeconUtils::writeH5(NULL, P, "dtangle")
