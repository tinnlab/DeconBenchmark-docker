args <- DeconUtils::getArgs(c("bulk", "signature"))

suppressMessages(
  suppressWarnings({
      library(NITUMID)
    })
)


signature <- args$signature
row_mean <- rowMeans(signature)
signature <- round(signature/apply(signature, 1, max)*2)/2
signature <- 1 - signature

res <- NITUMID(Y=args$bulk[rownames(signature), ],
                           row_index=1:nrow(signature),
                           A = signature,
                           if.bulk = T,
                           num_cell = ncol(signature),
                           row_mean = row_mean)$result[[1]]

P <- t(res$H)
S <- res$W

DeconUtils::writeH5(S, P, "NITUMID")
