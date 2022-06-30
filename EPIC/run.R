args <- DeconUtils::getArgs(c("bulk", "cellTypeExpr", "sigGenes"))

reference <- list(
    refProfiles = args$cellTypeExpr,
    sigGenes = args$sigGenes
)

P <- EPIC::EPIC(args$bulk, reference)$mRNAProportions

DeconUtils::writeH5(NULL, P, "EPIC")