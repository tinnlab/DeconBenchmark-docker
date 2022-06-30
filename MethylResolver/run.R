args <- DeconUtils::getArgs(c("bulk", "signature"))

library(MethylResolver)


origCTNames <- colnames(args$signature)
colnames(args$signature) <- make.names(colnames(args$signature))

args$bulk <- log2(args$bulk + 1)
args$signature <- log2(args$signature + 1)

res <- MethylResolver(methylMix = args$bulk, methylSig = args$signature, absolute = FALSE)

P <- res[, colnames(args$signature)]
colnames(P) <- origCTNames

DeconUtils::writeH5(NULL, P, "MethylResolver")