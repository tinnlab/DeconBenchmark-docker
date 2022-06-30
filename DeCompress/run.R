args <- DeconUtils::getArgs(c("bulk", "cellTypeExpr", "sigGenes", "seed"))

suppressMessages(
    suppressWarnings({
        library(DeCompress)
    })
)

bulk <- args$bulk[args$sigGenes, ]

nCellTypes <- ncol(args$cellTypeExpr)

set.seed(args$seed)

reference_props <- apply(matrix(abs(rnorm(100*nCellTypes)),ncol=nCellTypes), 1, function(x) x/sum(x))
reference <- args$cellTypeExpr %*% reference_props

compSpec <- findInformSet(yref = reference,
                          method = 'variance',
                          n_genes = 1000,
                          n.types = nCellTypes)

csModel <- trainCS(yref = reference[args$sigGenes, ],
                   yref_need = compSpec,
                   seed = 1,
                   method = c('lasso', 'enet', 'ridge'), # each glm method takes like 40mins for 1 core, R1Magic methods are even slower, 'lar' cause errors with big number of genes
                   par = T,
                   n.cores = 8,
                   lambda = .1)

dcexp <- expandTarget(bulk, csModel$compression.matrix)

dcexp <- dcexp[rowSums(dcexp < 0) == 0, ] # They use rowSums directly on the data, which might leave some negative values => error

csModel <- bestDeconvolution(yref = dcexp,
                             n.types = as.integer(nCellTypes),
                             methods = c('TOAST',
                                         'linseed',
                                         'celldistinguisher'))

P <- csModel$prop
S <- csModel$sig

colnames(P) <- colnames(S) <- colnames(args$cellTypeExpr)

DeconUtils::writeH5(S, P, "DeCompress")
