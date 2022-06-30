args <- DeconUtils::getArgs(c("bulk", "signature"))

suppressMessages(
  suppressWarnings({
      source("/code/DOCKER_codes.R")
    })
)


P <- quanTIseq(args$signature, args$bulk, scaling=rep(1, ncol(args$signature)), method="lsei")

DeconUtils::writeH5(NULL, P, "quanTIseq")
