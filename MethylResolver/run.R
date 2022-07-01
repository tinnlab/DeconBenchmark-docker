args <- DeconUtils::getArgs(c("bulk", "signature"))

library(MethylResolver)


origCTNames <- colnames(args$signature)
colnames(args$signature) <- make.names(colnames(args$signature))

res <- MethylResolver(methylMix = args$bulk, methylSig = args$signature, doPar = TRUE, numCores = 8, absolute = FALSE)

P <- res[, colnames(args$signature)]
colnames(P) <- origCTNames

DeconUtils::writeH5(NULL, P, "MethylResolver")