args <- DeconUtils::getArgs(c("bulk", "nCellTypes", 'markers'))

suppressMessages(
  suppressWarnings({
    library(TOAST)
  })
)


# refinx <- findRefinx(args$bulk, nmarker = min(1000, nrow(args$bulk)), sortBy = "cv")
# Y <- args$bulk[refinx,]
# K <- args$nCellTypes
# outT <- myRefFreeCellMix(Y, mu0=myRefFreeCellMixInitialize(Y, K = K))
# estProp_RF <- outT$Omega
# S <- outT$Mu
# colnames(S) <- paste0("cellType", 1:args$nCellTypes)

estProp_RF <- MDeconv(args$bulk, args$markers,
        epsilon = 1e-3, verbose = FALSE)$H
estProp_RF <- t(estProp_RF)

DeconUtils::writeH5(NULL, estProp_RF, "TOAST")