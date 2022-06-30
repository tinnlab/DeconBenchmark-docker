args <- DeconUtils::getArgs(c("bulk", "nCellTypes"))

result <- deconf::deconfounding(args$bulk, args$nCellTypes)

S <- result$S$Matrix
P <- result$C$Matrix

rownames(S) <- rownames(args$bulk)
colnames(S) <- paste0("cell.type.", seq(1, ncol(S)))
rownames(P) <- paste0("cell.type.", seq(1, ncol(S)))
colnames(P) <- colnames(args$bulk)

DeconUtils::writeH5(S, t(P), "deconf")