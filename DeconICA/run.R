args <- DeconUtils::getArgs(c("bulk", "nCellTypes"))

suppressMessages(
    suppressWarnings({
        library(deconica)
    })
)

ica <- run_fastica (
    args$bulk,
    isLog = FALSE,
    overdecompose = F,
    gene.names = row.names(args$bulk),
    samples = colnames(args$bulk),
    n.comp = as.integer(args$nCellTypes),
    R = T
)

P <- t(ica$A)
S <- (ica$S)

DeconUtils::writeH5(S, P, "DeconICA")
