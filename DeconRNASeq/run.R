args <- DeconUtils::getArgs(c("bulk", "signature"))

suppressMessages(
    suppressWarnings({
        library(limSolve)
        library(pcaMethods)
        library(ggplot2)
    })
)


result <- DeconRNASeq::DeconRNASeq(data.frame(args$bulk), data.frame(args$signature), checksig=FALSE, known.prop = FALSE, use.scale = TRUE, fig = FALSE)

S <- NULL
P <- as.matrix(result$out.all)

rownames(P) <- colnames(args$bulk)

DeconUtils::writeH5(S, P, "DeconRNASeq")