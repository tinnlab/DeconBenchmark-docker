args <- DeconUtils::getArgs(c("bulk", "singleCellExpr", "singleCellLabels"))

cellSpace <- Rtsne::Rtsne(t(args$singleCellExpr), partial_pca = TRUE)$Y
P <- scBio::CPM(SCData=args$singleCellExpr,SCLabels=args$singleCellLabels,BulkData=args$bulk,cellSpace=cellSpace,quantifyTypes=T,typeTransformation=T,no_cores=8)$cellTypePredictions

DeconUtils::writeH5(NULL, P, "CPM")