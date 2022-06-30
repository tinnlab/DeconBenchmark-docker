#' Use mutual linearity to find cell-type gene signatures and do deconvolution
#'
#' The function finds cell-type gene signatures and does deconvolution
#' using the linseed pacakge
#'
#' @param yref matrix, numeric expression matrix
#' @param iters numeric, number of interations
#' @param pval numeric, p-value cutoff
#' @param n.types integer, number of cell-types
#' @param scree character, method to estimate n.types if n.types is NULL
#' @param logTransform logical, T/F if yref is in log-scale
#'
#' @return list with cell-type proportions and expression
#'
#' @export
linCor <- function(yref,
                   iters = 100,
                   pval = .01,
                   n.types = NULL,
                   scree = 'cumvar',
                   logTransform = F){

    if (all(class(yref) != c('matrix'))){
        stop("matrix not supplied in yref")
    }

    if (logTransform){
        yref = log2(yref+1)
    }

    row.means = rowSums(yref)
    yref = yref[row.means != 0,]

    lo <- linseed::LinseedObject$new(yref)
    lo$calculatePairwiseLinearity()
    lo$calculateSpearmanCorrelation()
    lo$calculateSignificanceLevel(iters)
    lo$filterDatasetByPval(pval)

    if (all(lo$genes$pvals > pval)) {
        return(list(prop = matrix(rep(100,n.types * nrow(yref)),
                                  ncol = n.types),
                    sigs = NA))
    }

    if (is.null(n.types)){
        n.types = findNumberCells(yref,scree = scree)
        }

    lo$setCellTypeNumber(n.types)
    lo$project("full")
    lo$project("filtered")
    lo$smartSearchCorners(dataset="filtered", error="norm")
    lo$deconvolveByEndpoints()


    return(list(prop = lo$proportions,
                sig = lo$signatures))

}
