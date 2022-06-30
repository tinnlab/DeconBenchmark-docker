#' Wrapper to train compression matrix
#'
#' The function runs trainCS_gene over the entire set of genes needed
#' for deconvolution from the reference dataset.
#'
#' @param yref matrix, numeric expression matrix for target genes
#' @param yref_need matrix, numeric expression matrix of needed genes
#' @param seed numeric, random seed
#' @param method vector, character vector of optimization methods
#' @param par logical, T/F for parallelization
#' @param n.cores numeric, number of cores
#' @param lambda numeric, penalty paramemter for non-linear optimization
#'
#' @return list with coefficients and predictive R2
#'
#' @importFrom future plan
#' @importFrom future multiprocess
#' @importFrom future.apply future_apply
#'
#' @export
trainCS <- function(yref,
                    yref_need,
                    seed = 1218,
                    method = c('lar',
                               'lasso',
                               'enet',
                               'ridge',
                               'l1',
                               'TV',
                               'l2'),
                    par = T,
                    n.cores,
                    lambda = .1){

    if (all(class(yref) != 'matrix')){
        stop("matrix not supplied in yref")
    }

    if (all(class(yref_need) != 'matrix')){
        stop("matrix not supplied in yref_need")
    }

    if (!par){

    compression = pbapply::pbapply(as.matrix(yref_need),
                        MARGIN = 1,
                        trainCS_gene,
                        train = yref,
                        seed=seed,
                        method = method,
                        lambda = lambda)


    }

    if (par){
        future::plan(future::multiprocess,workers = n.cores)
        compression = future.apply::future_apply(as.matrix(yref_need),
                                                 MARGIN = 1,
                                                 trainCS_gene,
                                                 train = yref,
                                                 method = method,
                                                 seed = seed,
                                                 lambda = lambda)
    }

    compression_mat = sapply(compression,function(x) x$coef)
    r2Vec = sapply(compression,function(x) x$r2)

    return(list(compression.matrix = compression_mat,
                r2 = r2Vec))

}
