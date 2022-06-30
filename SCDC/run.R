args <- DeconUtils::getArgs(c("bulk", "singleCellExpr", "singleCellLabels"))

suppressMessages(
  suppressWarnings({
      library(SCDC)
      library(Biobase)
    })
)


bulk.eset <- ExpressionSet(assayData=args$bulk)

phenoData <- new("AnnotatedDataFrame", data = data.frame(row.names=colnames(args$singleCellExpr), sampleID=colnames(args$singleCellExpr), cellType=args$singleCellLabels, subject=rep("subject", ncol(args$singleCellExpr))))
sc.eset <- ExpressionSet(assayData=args$singleCellExpr, phenoData=phenoData)

res <- SCDC_prop_ONE(bulk.eset, sc.eset, ct.varname = "cellType", sample = "subject", ct.sub = unique(args$singleCellLabels))

P <- res$prop.est.mvw
S <- res$basis.mvw

DeconUtils::writeH5(S, P, "SCDC")
