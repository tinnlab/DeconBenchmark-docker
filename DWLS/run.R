args <- DeconUtils::getArgs(c("bulk", "singleCellExpr", "singleCellLabels"))

suppressMessages(
  suppressWarnings({
        source("/code/DWLS.R")
    })
)


Signature <- buildSignatureMatrixMAST(scdata=args$singleCellExpr, id=make.names(args$singleCellLabels), path="/tmp")

res <- apply(args$bulk, 2, function(b){
    tr <- trimData(Signature, b)
    solDWLS <- solveDampenedWLS(tr$sig, tr$bulk)
    gc()
    solDWLS
})

DeconUtils::writeH5(Signature, t(res), "DWLS")