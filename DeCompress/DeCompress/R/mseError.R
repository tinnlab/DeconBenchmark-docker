#' Select the number of cell types using SVD methods
#'
#' The function estimates the number of cell-types using one
#' of three SVD methods on the input expression matrix
#'
#' @param mat1 matrix, numeric matrix of proportions
#' @param mat2 matrix, numeric matrix of proportions
#' @param rand logical, T/F to shuffle columns of mat2
#'
#' @return number of cell types
#'
#' @importFrom gtools permutations
#'
#' @export
mseError <- function(mat1,mat2,rand=F,r2=F){



    if (ncol(mat1) > nrow(mat1)){
        mat1 = t(mat1)
    }

    if (ncol(mat2) > nrow(mat2)){
        mat2 = t(mat2)
    }

    if (nrow(mat1) != nrow(mat2)){
        stop('mat1 and mat2 have different numbers of rows')
    }

    mse.all = function(mat1,mat2,r2){
        if (!r2){
            return(mean(rowMeans((mat1-mat2)^2)))
        } else {
            return(cor(as.vector(mat1),as.vector(mat2))^2)
        }

    }

    if (rand == F){
        return(mse.all(mat1,mat2,r2=r2))
    }

    if (rand == T){
        p = gtools::permutations(n = ncol(mat1),
                         r = ncol(mat1),
                         v = 1:ncol(mat1),
                         repeats.allowed=F)
        error = 100
        r2o = -1
        for (j in 1:nrow(p)){
            if (!r2){
                error = min(error,mse.all(mat1,mat2[,p[j,]],r2=r2))
            } else {
                r2o = max(r2o,mse.all(mat1,mat2[,p[j,]],r2=r2))
            }
        }

        if (r2){ return(r2o)
            } else {
                return(error)
                }

    }

}
