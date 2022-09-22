suppressMessages(
    suppressWarnings({
        library(dplyr)
        library(BisqueRNA)
        library(Biobase)
    })
)

args <- DeconUtils::getArgs(c("bulk", "singleCellExpr", "singleCellLabels", "singleCellSubjects"))

bulk.eset <- ExpressionSet(assayData=args$bulk)

if (length(unique(args$singleCellSubjects)) == 1) args$singleCellSubjects <- paste0("Subject", sample.int(3, length(args$singleCellSubjects), replace = TRUE))

sc.phenoData <- new("AnnotatedDataFrame", data = data.frame(row.names=colnames(args$singleCellExpr),
                                                            subjectID=args$singleCellSubjects,
                                                            cellType=args$singleCellLabels))
sc.eset <- ExpressionSet(assayData=args$singleCellExpr, phenoData=sc.phenoData)

P <- ReferenceBasedDecomposition(bulk.eset, sc.eset, markers=NULL, cell.types = "cellType", subject.names = "subjectID", use.overlap = F)$bulk.props

DeconUtils::writeH5(NULL, t(P), "BisqueRef")
