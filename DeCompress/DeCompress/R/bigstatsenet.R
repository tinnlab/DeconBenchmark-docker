#' Elastic-net for compressed sensing using bigstatsr
#'
#' The function runs elastic net to train compression for a single gene
#'
#' @param need vector, numeric vector of gene that is needed
#' @param train matrix, numeric expression matrix of training data
#' @param seed numeric, random seed
#' @param alpha numeric, between 0 and 1
#'
#' @return list with coefficients and predictive R2
#'
#' @importFrom bigstatsr FBM
#' @importFrom bigstatsr big_spLinReg
#'
#' @export
bigstatsenet <- function(need,
                 train,
                 seed = 1218,
                 alpha){

    if (alpha < 0 | alpha > 1){
        stop('alpha is not between 0 and 1')
    }


    X = bigstatsr::FBM(nrow = nrow(train),
            ncol = ncol(train),
            init = as.vector(train),
            backing = tempfile())

    set.seed(seed)
    lar = bigstatsr::big_spLinReg(X,
                                  y = need,
                                  alpha = alpha,
                                  K = 5)

    return(list(coef = unlist(summary(lar)$beta),
                r2 = 1 - (summary(lar)$validation_loss/var(need))))

}
