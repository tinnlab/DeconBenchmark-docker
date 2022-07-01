args <- DeconUtils::getArgs(c("bulk", "nCellTypes"))

suppressMessages(
    suppressWarnings({
        library(debCAM)
    })
)

bulk <- args$bulk
K <- args$nCellTypes

rCAM <- CAM(bulk, K = K, dim.rdc = min(max(K + 5, 10), ncol(bulk)),
            thres.low = 0.3, thres.high = 0.95)

P <- Amat(rCAM, K)
S <- Smat(rCAM, K)

rownames(P) <- colnames(bulk)
colnames(P) <- paste0("CT", seq_len(K))

DeconUtils::writeH5(S, P, "debCAM")
