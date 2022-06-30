args <- DeconUtils::getArgs(c("bulk", "cellTypeExpr"))

suppressMessages(
  suppressWarnings({
      library(DESeq2)
    })
)


P <- unmix(args$bulk, args$cellTypeExpr, alpha = 0.01, quiet = T)

DeconUtils::writeH5(NULL, P, "DESeq2")
