#' Use NMF repeatedly with TOAST framework to find cell-type gene signatures
#' and do deconvolution
#'
#' The function finds cell-type gene signatures and does deconvolution
#' using the TOAST framework with NMF
#'
#' @param yref matrix, numeric expression matrix
#' @param iters numeric, number of interations
#' @param pval numeric, p-value cutoff
#' @param n.types integer, number of cell-types
#' @param scree character, method to estimate n.types if n.types is NULL
#' @param log logical, T/F if yref is in log-scale
#'
#' @return list with cell-type proportions and expression profiles
#'
#' @export
iterateSigs <- function(yref,
                        n.types = NULL,
                        n.markers = 1000,
                        n.iter = 30,
                        scree = c('drop','cumvar','residual'),
                        logTransform = F){


    if (all(class(yref) != c('matrix'))){
        stop("matrix not supplied in yref")
    }

    if (logTransform){
        yref = log2(yref+1)
    }

    row.means = rowSums(yref)
    yref = yref[row.means > 0,]

    if (is.null(n.types)){
        n.types = findNumberCells(yref,scree = scree)
        }

    geneList = rownames(yref)
    rownames(yref) = NULL
    outRF1 <- csDeCompress(Y_raw = yref,
                           K = n.types,
                           nMarker = n.markers,
                           FUN = nmfOut,
                           TotalIter = n.iter)
    return(list(estProp = outRF1$estProp,
                geneSig = geneList[outRF1$finalsigs]))
}
