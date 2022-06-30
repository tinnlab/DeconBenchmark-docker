args <- DeconUtils::getArgs(c("bulk", "signature"))

library(FARDEEP)


P <- fardeep(args$signature, args$bulk)$relative.beta

DeconUtils::writeH5(NULL, P, "FARDEEP")