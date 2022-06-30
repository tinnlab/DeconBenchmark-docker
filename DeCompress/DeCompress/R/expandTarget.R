#' Expand targetted panel to larger feature space
#'
#' The function multiplies the targetted panel with the compression
#' matrix for the larger feature space
#'
#' @param target matrix, numeric expression matrix from targetted panel
#' @param compression_mat matrix, compression matrix
#'
#' @return expanded expression matrix
#'
#' @export
expandTarget <- function(target,
                         compression_mat){

    if (all(class(target) != 'matrix')){
        stop("matrix not supplied in target")
    }

    if (all(class(compression_mat) != 'matrix')){
        stop("matrix not supplied in compression_mat")
    }

    if (nrow(compression_mat) == nrow(target)){
        return(t(compression_mat) %*% target)
    } else {return(compression_mat %*% target)}

}
