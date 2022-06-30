args <- DeconUtils::getArgs(c("bulk", "singleCellExpr", "singleCellLabels", "sigGenes"))

suppressMessages(
    suppressWarnings({
        library("deconvSeq")
    })
)

CT <- as.factor(args$singleCellLabels)
design <- model.matrix(~-1+CT)
colnames(design) <- levels(CT)
rownames(design) <- colnames(args$singleCellExpr)

# need count matrix
dge.celltypes <- getdge(round(args$singleCellExpr), design, ncpm.min=1, nsamp.min=4)
b0.singlecell <- getb0.rnaseq(dge.celltypes, design, ncpm.min=1, nsamp.min=4, sigg=args$sigGenes)

dge_tissue.sc <- getdge(round(args$bulk), NULL, ncpm.min=1, nsamp.min=4)
P <- getx1.rnaseq(NB0="top_bonferroni", b0.singlecell, dge_tissue.sc)$x1

S <- b0.singlecell$b0

DeconUtils::writeH5(S, P, "deconvSeq")
