#' Run unmix from DESeq2
#'
#' The function estimates the compartment proportions from an estimated
#' signature matrix using unmix
#'
#' @param yref matrix, numeric expression matrix
#' @param sigs matrix, numeric expression compartment-specific sig matrix
#' @param shift.range vector, numeric vector for gene expression shifts
#' @param logTransform logical, T/F to logTransform data, defaults to F
#'
#' @return list with cell-type proportions and expression profiles
#'
#' @importFrom DESeq2 unmix
#'
#' @export
estimateUnmix <- function(yref,
                          sigs,
                          shift.range = 10^(1:10),
                          logTransform = F){


    if (all(class(yref) != c('matrix'))){
        stop("matrix not supplied in yref")
    }

    if (logTransform){
        yref = log2(yref+1)
    }

    row.means = rowSums(yref)
    yref = yref[row.means > 0,]

    geneList = rownames(yref)

    regBetweenRows <- function(shift,mat){
        expressions <- log(mat+shift+1)
        means <- rowMeans(expressions)
        sds <- apply(expressions,1,sd)
        return(as.numeric(abs(coef(lm(sds~means))[2])))
    }

    slope = sapply(shift.range,
                   regBetweenRows,
                   mat = yref)
    shift = shift.range[which.min(slope)]
    props = DESeq2::unmix(as.matrix(yref),
                          pure=as.matrix(sigs),
                          shift = shift)
    props = t(apply(props,1,function(v) v/sum(v)))

    return(list(prop = props,
                sig = sigs))
}
