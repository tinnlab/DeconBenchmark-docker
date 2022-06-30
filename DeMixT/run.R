args <- DeconUtils::getArgs(c("bulk", "singleCellExpr", "singleCellLabels"))

suppressMessages(
  suppressWarnings({
      library(DeMixT)
      library(SummarizedExperiment)
    })
)

bulk <- args$bulk
singleCellExpr <- args$singleCellExpr

data.Y <- SummarizedExperiment(assays=list(counts=bulk))

N1 <- unique(args$singleCellLabels)[1]
N2 <- unique(args$singleCellLabels)[2]

data.N1 <- SummarizedExperiment(assays=list(counts=singleCellExpr[, args$singleCellLabels == N1]))
data.N2 <- NULL
if (!is.na(N2)) {
  data.N2 <- SummarizedExperiment(assays=list(counts=singleCellExpr[, args$singleCellLabels == N2]))
}

res.GS <- DeMixT_GS(data.Y = data.Y, data.N1 = data.N1, data.N2 =  data.N2)

DeconUtils::writeH5(NULL, t(res.GS$pi), "DeMixT")