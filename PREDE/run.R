args <- DeconUtils::getArgs(c("bulk", "cellTypeExpr"))

suppressMessages(
  suppressWarnings({
      library(PREDE)
    })
)


args$bulk <- log2(args$bulk + 1)
args$cellTypeExpr <- log2(args$cellTypeExpr + 1)

feat <- select_feature(mat = args$bulk, method = "cv",nmarker = min(1000, nrow(args$cellTypeExpr)), startn = 0)
pred <- PREDE(args$bulk[feat,], W1= args$cellTypeExpr[feat, ],type = "GE", K= ncol(args$cellTypeExpr), iters = 100, rssDiffStop=1e-5)

DeconUtils::writeH5(NULL, t(pred$H), "PREDE")
