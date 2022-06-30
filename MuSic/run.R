args <- DeconUtils::getArgs(c("bulk", "singleCellExpr", "singleCellLabels"))

suppressMessages(
  suppressWarnings({
      library(MuSiC)
      library(Biobase)
    })
)


bulk.eset <- ExpressionSet(assayData=args$bulk)
phenoData <- new("AnnotatedDataFrame", data = data.frame(row.names=colnames(args$singleCellExpr), sampleID=colnames(args$singleCellExpr), cellType=args$singleCellLabels))
sc.eset <- ExpressionSet(assayData=args$singleCellExpr, phenoData=phenoData)

P <- music_prop(bulk.eset, sc.eset, clusters='cellType', samples='sampleID')$Est.prop.weighted

DeconUtils::writeH5(NULL, P, "MuSic")