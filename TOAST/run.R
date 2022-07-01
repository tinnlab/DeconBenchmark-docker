args <- DeconUtils::getArgs(c("bulk", 'markers'))

suppressMessages(
  suppressWarnings({
    library(TOAST)
  })
)

estProp_RF <- MDeconv(args$bulk, args$markers,
        epsilon = 1e-3, verbose = FALSE)$H
estProp_RF <- t(estProp_RF)

DeconUtils::writeH5(NULL, estProp_RF, "TOAST")