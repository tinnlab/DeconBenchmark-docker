args <- DeconUtils::getArgs(c("bulk", "singleCellExpr", "singleCellLabels"))

suppressMessages(
  suppressWarnings({
      library(DeMixT)
      library(SummarizedExperiment)
    })
)
setwd('/code/')
bulk <- args$bulk
singleCellExpr <- args$singleCellExpr

dataY <- SummarizedExperiment(assays=list(counts=bulk))

res <- matrix(0, ncol = length(unique(args$singleCellLabels)), nrow = ncol(bulk))
colnames(res) <- unique(args$singleCellLabels)
rownames(res) <- colnames(bulk)

for (cellType in unique(args$singleCellLabels)) {
  mat <- singleCellExpr[, args$singleCellLabels == cellType]
  dataN1 <- SummarizedExperiment(assays=list(counts=mat))
  resGS <- try(DeMixT(data.Y = dataY, data.N1 = dataN1, nthread = 10, niter = 10, nspikein = 0, if.filter = FALSE))
  if(is(resGS, "try-error")) {
    res[, cellType] <- 0
  } else {
    res[, cellType] <- t(resGS$pi["PiN1",])
  }
}

for (i in 1:nrow(res)) {
  res[i,] <- res[i,]/sum(res[i,])
}

DeconUtils::writeH5(NULL, res, "DeMixT")