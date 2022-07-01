args <- DeconUtils::getArgs(c("bulk", "nCellTypes"))

source("/code/ReFACTor.R")

#P is relative
P <- refactor(args$bulk, args$nCellTypes)$refactor_components

rownames(P) <- colnames(args$bulk)

DeconUtils::writeH5(NULL, P, "ReFACTor")