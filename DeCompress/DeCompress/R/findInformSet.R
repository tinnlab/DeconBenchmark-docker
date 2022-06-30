#' Select the compartment specific genes
#'
#' The function feature selects the compartment specific genes
#' from the reference expression matrix
#'
#' @param yref matrix, numeric expression matrix
#' @param method character, variance/linearity for TOAST or LINSEED
#' @param n_genes integer, number of CTS genes needed
#' @param n.types integer, number of compartments
#' @param scree character, method to estimate n.types
#'
#' @return numeric matrix of n_genes CTS genes
#'
#' @export
findInformSet <- function(yref,
                          method = c('variance','linearity'),
                          n_genes = 1000,
                          n.types = NULL,
                          scree = 'cumvar'){


    if (all(class(yref) != c('matrix'))){
        stop("matrix not supplied in yref")
    }


    if (method == 'linearity'){
        yref_need = yref[rownames(linCor(yref,
                                         pval = .25,
                                         n.types = n.types,
                                         scree = scree,
                                         logTransform = F)$sig),]
    }

    if (method == 'variance'){
        yref_need = vardecomp(yref[complete.cases(yref),],
                              n_genes,
                              n.types = n.types)
    }

    return(yref_need)


}
