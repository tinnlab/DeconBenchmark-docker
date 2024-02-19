suppressMessages(
    suppressWarnings({
        library(bseqsc)
    })
)

suppressMessages(
    suppressWarnings({
        bseqsc_config("/code/CIBERSORT/CIBERSORT.R")
    })
)

args <- DeconUtils::getArgs(c("bulk", "singleCellExpr", "markers", "singleCellLabels", "singleCellSubjects"))

S <- bseqsc_basis(
  x = args$singleCellExpr,
  markers = args$markers,
  clusters = args$singleCellLabels,
  samples = args$singleCellSubjects
)

res <- bseqsc_proportions(
  x = args$bulk,
  reference = S
)

P <- t(res[["coefficients"]])

# P <- res[, colnames(args$signature)]

DeconUtils::writeH5(NULL, P, "BseqSC")
