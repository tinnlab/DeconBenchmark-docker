args <- DeconUtils::getArgs(c("bulk", "signature"))

suppressMessages(
    suppressWarnings({
        source("/code/MySort.R")
    })
)

res <- SVR(args$signature, args$bulk)

P <- res[, colnames(args$signature)]

DeconUtils::writeH5(NULL, P, "MySort")