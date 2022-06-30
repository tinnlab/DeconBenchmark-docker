args <- DeconUtils::getArgs(c("bulk", "nCellTypes"))
library(BayCount)

hyper <- NULL
hyper$eta <- 0.1
hyper$a0 <- 0.01
hyper$b0 <- 0.01
hyper$e0 <- 1
hyper$f0 <- 1
hyper$g0 <- 1
hyper$h0 <- 1
hyper$u0 <- 100
hyper$v0 <- 100

# bulk data is a count matrix
BayCount_model <- BayCount(args$bulk, B = 100, nmc = 100, hyper = hyper, K_range=args$nCellTypes)[[args$nCellTypes]]

P <- t(apply(BayCount_model$Theta_norm[, , ], c(1, 2), mean))
rownames(P) <- colnames(args$bulk)
colnames(P) <- paste0("cellType", 1:args$nCellTypes)

S <- apply(BayCount_model$Phi[, , ], c(1, 2), mean)
rownames(S) <- rownames(args$bulk)
colnames(S) <- paste0("cellType", 1:args$nCellTypes)

DeconUtils::writeH5(S, P, "BayCount")