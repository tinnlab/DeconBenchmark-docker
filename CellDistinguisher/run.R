args <- DeconUtils::getArgs(c("bulk", "nCellTypes"))

library(CellDistinguisher)

bulk <- args$bulk

MyDistinguishers <- gecd_CellDistinguisher(bulk,
                                           genesymb=rownames(args$bulk),
                                           numCellClasses=args$nCellTypes)

MyDeconvolution <- gecd_DeconvolutionByDistinguishers(bulk, MyDistinguishers$bestDistinguishers)

P <- t(MyDeconvolution$sampleCompositions)
S <- MyDeconvolution$cellSubclassSignatures

DeconUtils::writeH5(S, P, "CellDistinguisher")