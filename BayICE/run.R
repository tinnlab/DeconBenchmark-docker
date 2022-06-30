args <- DeconUtils::getArgs(c("bulk", "singleCellExpr", "singleCellLabels"))

suppressMessages(
    suppressWarnings({
        library(BayICE)
    })
)

#remove genes with all 0, otherwise the method will have error
singleCellExpr <- args$singleCellExpr[rowSums(args$singleCellExpr) > 0, ]
bulk <- args$bulk[rownames(singleCellExpr), ]

bulk <- bulk[rowSums(bulk) > 0, ]
singleCellExpr <- singleCellExpr[rownames(bulk), ]

singleCellExpr <- log2(singleCellExpr + 1)
bulk <- log2(bulk + 1)

res <- BayICE(ref.set=singleCellExpr, mix.set=bulk, ref.id=args$singleCellLabels, iter=1000)

P <- t(res$w)
colnames(P) <- c(unique(args$singleCellLabels), "Extra")

S <- res$mean

DeconUtils::writeH5(S, P, "BayICE")
