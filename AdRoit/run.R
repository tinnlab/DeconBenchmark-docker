args <- DeconUtils::getArgs(c("bulk", "singleCellExpr", "singleCellLabels"))

suppressMessages(
    suppressWarnings({
        library(AdRoit)
    })
)

# count data
single.ref <- ref.build(args$singleCellExpr,
                        args$singleCellLabels,
                        rownames(args$singleCellExpr),
                        multi.sample.bulk = F,
                        multi.sample.single = F,
                        silent = T,
                        no_cores=8)

P <- t(AdRoit.est(args$bulk, single.ref, silent = T, no_cores=8))

DeconUtils::writeH5(single.ref$mus, P, "AdRoit")
