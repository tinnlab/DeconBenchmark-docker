args <- DeconUtils::getArgs(c("bulk", "singleCellExpr", "singleCellLabels"))

suppressMessages(
  suppressWarnings({
        source("/code/DWLS.R")
        library(Giotto)
    })
)


S <- buildSignatureMatrixMAST(scdata=args$singleCellExpr, id=make.names(args$singleCellLabels), path="/tmp")

giottoObject <- Giotto::createGiottoObject(raw_exprs = args$bulk)
giottoObject <- Giotto::normalizeGiotto(gobject = giottoObject)
giottoObject <- Giotto::runPCA(gobject = giottoObject, ncp = 15)
giottoObject <- Giotto::createNearestNetwork(gobject = giottoObject)
giottoObject <- Giotto::doLeidenCluster(giottoObject, name = 'leiden_clus')
P <- Giotto::runDWLSDeconv(giottoObject, sign_matrix = S, return_gobject = FALSE)
P <- data.frame(P)
rownames(P) <- P[,1]
P <- P[,-1]

DeconUtils::writeH5(S, P, "spatialDWLS")