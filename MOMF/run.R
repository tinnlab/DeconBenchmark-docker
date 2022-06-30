args <- DeconUtils::getArgs(c("bulk", "singleCellExpr", "singleCellLabels"))

library(MOMF)

sc_counts <- args$singleCellExpr
bulk_counts <- args$bulk

priorU <- momf.computeRef(sc_counts, args$singleCellLabels)
GList <- list(X1 = t(sc_counts), X2 = t(bulk_counts))
momf_res <- momf.fit(DataX = GList, DataPriorU=priorU, method="KL", rho=2, num_iter=100)
cell_prop <- momf_res$cell.prop

S <- momf_res$cell.specifc

DeconUtils::writeH5(S, cell_prop, "MOMF")