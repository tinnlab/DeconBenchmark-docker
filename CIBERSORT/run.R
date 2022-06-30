args <- DeconUtils::getArgs(c("bulk", "signature"))

suppressMessages(
    suppressWarnings({
        source("/code/CIBERSORT.R")
    })
)

res <- CIBERSORT(args$bulk, args$signature, perm=0, QN=F, absolute=F)

P <- res[, colnames(args$signature)]

DeconUtils::writeH5(NULL, P, "CIBERSORT")