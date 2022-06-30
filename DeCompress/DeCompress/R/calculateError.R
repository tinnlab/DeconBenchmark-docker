#' Find errors in estimated proportion matrix and signature
#'
#' The function finds the error in a DeCompress-esimated proportion
#' and signature matrix using either known cell-type proportions or
#' the total gene expression matrix
#'
#' @param estProp matrix, numeric expression matrix of compartment proportions
#' @param estSig matrix, numeric matrix of compartment gene signatures
#' @param trueProp matrix, known proportion matrix, NULL if not known
#' @param yref matrix, numeric matrix of original expression matrix
#'
#' @return reconstruction MSE
#'
#' @export
calculateError <- function(estProp,
                           estSig,
                           trueProp = NULL,
                           yref){

    if (!is.null(trueProp)){
        return(mseError(estProp,trueProp,rand=F))
    } else {
            yref = yref[rownames(estSig),]
            return(mseError(yref,estSig %*% t(estProp),rand=F))
        }

}
