#' Select the number of cell types using SVD methods
#'
#' The function estimates the number of cell-types using one
#' of three SVD methods on the input expression matrix
#'
#' @param yref matrix, numeric expression matrix
#' @param scree character, method to estimate n.types
#'
#' @return number of cell types
#'
#' @export
findNumberCells <- function(yref,
                            scree = c('drop','cumvar','residual')){


    if (all(class(yref) != c('matrix'))){
        stop("matrix not supplied in yref")
    }

    if (!(scree %in% c('drop','cumvar','residual'))){
        stop('scree has to be either drop, cumvar, or residual')
    }

    if (is.null(n.types)){
        s = svd(yref)
        if (scree == 'residual'){
            p = 10
            y <- lapply(1:(p-1),function(i)
                try(structureMeasure(s,lo$exp$filtered$norm,i)))
            y2 <- unlist(y[sapply(y,
                                  function(x) !inherits(x, "try-error"))])
            y2.ind <- which(sapply(y,
                                   function(x) !inherits(x, "try-error")))
            n.types = y2.ind[which.min(y2)]
        }
        if (scree == 'cumvar'){
            dii = s$d^2
            cumvar = cumsum(dii/sum(dii))
            n.types = min(which(cumvar >= .8))
        }
        if (scree == 'drop'){
            n.types = kaiser(s$d^2)
        }
    }

    return(n.types)
}
