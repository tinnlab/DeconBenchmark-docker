args <- DeconUtils::getArgs(c("bulk", "cellTypeExpr"))

suppressMessages(
  suppressWarnings({
      library("EMeth")
    })
)

P <- emeth(Y = args$bulk, eta = rep(0, ncol(args$bulk)), mu = args$cellTypeExpr, aber = F, V = 'c', nu = 0)$rho

rownames(P) <- colnames(args$bulk)
colnames(P) <- colnames(args$cellTypeExpr)

DeconUtils::writeH5(NULL, P, "EMeth")
