#' Wrapper to train compression matrix
#'
#' The function estimates the best set of coefficients for a given
#' gene from the target genes.
#'
#' @param train matrix, numeric expression matrix for target genes
#' @param need vector, numeric expression vector for a needed gene
#' @param seed numeric, random seed
#' @param method vector, character vector of optimization methods
#' @param par logical, T/F for parallelization
#' @param n.cores numeric, number of cores
#' @param lambda numeric, penalty paramemter for non-linear optimization
#'
#' @return list with coefficients and predictive R2
#'
#' @export
trainCS_gene <- function(need,
                         train,
                         seed,
                         method = c('lar',
                                    'lasso',
                                    'enet',
                                    'ridge',
                                    'l1',
                                    'TV',
                                    'l2'),
                         n.cores,
                         lambda = .1){

    need = as.numeric(need)

    if (!class(need) %in% c('vector','numeric')){
        stop("provide a numeric vector for need")
    }

    if (all(class(train) != 'matrix')){
        stop("matrix not supplied for train")
    }

    if ('lar' %in% method){
        mod.lar = lar(need,
                      train,
                      seed)
        } else {mod.lar = list(r2 = -1)}

    if ('lasso' %in% method){
        mod.lasso = suppressWarnings(bigstatsenet(need,
                         t(train),
                         seed,
                         alpha = 1e-4))
        } else {mod.lasso = list(r2 = -1)}


    if ('enet' %in% method){
        mod.enet = suppressWarnings(bigstatsenet(need,
                        t(train),
                        seed,
                        alpha = .5))
        } else {mod.enet = list(r2 = -1)}

    if ('ridge' %in% method){
        mod.ridge = suppressWarnings(bigstatsenet(need,
                         t(train),
                         seed,
                         alpha = 1))
        } else {mod.ridge = list(r2 = -1)}

    if ('l1' %in% method){
        mod.l1 = l1Magic(need,
                         train,
                         seed,
                         lambda = lambda)
    } else {mod.l1 = list(r2 = -1)}

    if ('l2' %in% method){
        mod.l2 = l2Magic(need,
                         train,
                         seed,
                         lambda = lambda)
    } else {mod.l2 = list(r2 = -1)}

    if ('TV' %in% method){
        mod.TV = TVMagic(need,
                         train,
                         seed,
                         lambda = lambda)
    } else {mod.TV = list(r2 = -1)}

    tot = list(mod.lar,
               mod.lasso,
               mod.enet,
               mod.ridge,
               mod.l1,
               mod.l2,
               mod.TV)

    r2Tot = sapply(tot,function(x) x$r2)
    return(list(coef = tot[[which.max(r2Tot)]]$coef,
                r2 = max(r2Tot)))

}
