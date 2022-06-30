args <- DeconUtils::getArgs(c("bulk", "markers"))

library(MCPcounter)


args$bulk <- log2(args$bulk + 1)

P <- MCPcounter.estimate(args$bulk, args$markers)

DeconUtils::writeH5(NULL, t(P), "MCPcounter")
