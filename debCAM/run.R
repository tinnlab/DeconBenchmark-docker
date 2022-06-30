args <- DeconUtils::getArgs(c("bulk", "nCellTypes"))

suppressMessages(
    suppressWarnings({
        library(debCAM)
    })
)

bulk <- args$bulk
K <- args$nCellTypes

rCAM <- CAM(bulk, K = K, dim.rdc = min(max(K + 5, 10), ncol(bulk)))

P <- Amat(rCAM, K)
S <- Smat(rCAM, K)

rownames(P) <- colnames(bulk)

DeconUtils::writeH5(S, P, "debCAM")
