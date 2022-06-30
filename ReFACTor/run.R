args <- DeconUtils::getArgs(c("bulk", "nCellTypes"))

source("/code/ReFACTor.R")


#P is relative
P <- refactor(log2(args$bulk + 1), args$nCellTypes)$refactor_components

rownames(P) <- colnames(args$bulk)

DeconUtils::writeH5(NULL, P, "ReFACTor")