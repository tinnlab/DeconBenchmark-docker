#' Least angle regression for compressed sensing
#'
#' The function runs least angle regression to
#' train compression for a single gene
#'
#' @param need vector, numeric vector of gene that is needed
#' @param train matrix, numeric expression matrix of training data
#' @param seed numeric, random seed
#'
#' @return list with coefficients and predictive R2
#'
#' @importFrom lars cv.lars
#' @importFrom lars lars
#'
#' @export
lar <- function(need,
                train,
                seed = 1218){


    set.seed(seed)
    lar = lars::cv.lars(x = t(train),
                        y = need,
                        type = 'lar',
                        plot.it = F,
                        K = 5,
                        use.Gram = T)

    lar.reg = lars::lars(x = t(train),
                   y = need,
                   type = 'lar')
    lar.coef = as.numeric(coef(lar.reg,
                               s = lar$index[which.min(lar$cv)],
                               mode='step'))

    return(list(coef = lar.coef,
                r2 = abs(1 - min(lar$cv)/var(need))))

}
