args <- DeconUtils::getArgs(c("bulk", "nCellTypes"))

library(linseed)


lo <- LinseedObject$new(args$bulk)
lo$calculatePairwiseLinearity()
lo$calculateSpearmanCorrelation()
lo$calculateSignificanceLevel()
lo$filterDatasetByPval(0.01)
lo$setCellTypeNumber(as.integer(args$nCellTypes))
lo$project("full")
lo$project("filtered")
lo$smartSearchCorners(dataset="filtered", error="norm")
lo$deconvolveByEndpoints()

P <- t(lo$proportions)

DeconUtils::writeH5(NULL, P, "Linseed")