#' TOAST-NMF deconvolution
#'
#' The function runs TOAST iteratively with NMF to find
#' compartment proportions and signatures
#'
#' @param Y_raw matrix, numeric expression matrix
#' @param K integer, number of cell-types
#' @param FUN function, defaults to nmfOut
#' @param nMarker integer, max number of genes for deconv, default 1000
#' @param InitMarker vector, initial marker vector smaller than nrow of Y_raw
#' @param bound_negative logical, T/F to bound negative params at 0
#'
#' @return list with cell-type proportions and expression profiles
#'
#' @import NMF
#'
#' @importFrom TOAST findRefinx
#' @importFrom TOAST DEVarSelect
#' @importFrom csSAM csfit
#'
#' @export
csDeCompress <- function(Y_raw,
                         K,
                         nMarker = 1000,
                         FUN = nmfOut,
                         InitMarker = NULL,
                         TotalIter = 30,
                         bound_negative = FALSE) {

    if (is(Y_raw, "SummarizedExperiment")) {
        se <- Y_raw
        Y_raw <- assays(se)$counts
    } else if (!is(Y_raw, "matrix")) {
        stop("Y_raw should be a matrix or a SummarizedExperiment object!")
    }

    if (is.null(rownames(Y_raw))) {
        row.names(Y_raw) <- seq(nrow(Y_raw))
    }
    if (is.null(InitMarker)) {
        if (nrow(Y_raw) < 2*nMarker) {
            InitMarker <- TOAST::findRefinx(Y_raw, nmarker = nMarker)
        } else {
            tmp <- TOAST::findRefinx(Y_raw, nmarker = nMarker*2)
            InitMarker <- tmp[nMarker+1:nMarker]
        }
    } else {
        if (sum(!(InitMarker %in% rownames(Y_raw))) > 0) {
            stop("Discrepancy between
                    InitMarker and the row names of Y_raw!")
        }
    }

    allProp <- list()
    allRMSE <- rep(0, TotalIter + 1)

    Y <- Y_raw[InitMarker, ]
    Prop0 <- FUN(Y, K)
    allProp[[1]] <- Prop0

    out_all <- csSAM::csfit(Prop0, t(Y_raw))
    prof <- t(out_all$ghat)
    tmpmat <- prof %*% t(Prop0)
    allRMSE[1] <- sqrt(mean((t(Y_raw) - t(tmpmat)) ^ 2))

    message("+========================================+")
    message("+======= Total iterations = ",
            TotalIter, " ==========+")

    for (i in seq_len(TotalIter)) {
        message("Current iter = ", i)

        updatedInx <- TOAST::DEVarSelect(Y_raw, Prop0,
                                         nMarker, bound_negative)
        Y <- Y_raw[updatedInx, ]
        Prop0 <- FUN(Y+1, K)
        allProp[[i + 1]] <- Prop0

        out_all <- csSAM::csfit(Prop0, t(Y_raw))
        prof <- t(out_all$ghat)
        tmpmat <- prof %*% t(Prop0)
        allRMSE[i + 1] <- sqrt(mean((t(Y_raw) - t(tmpmat)) ^ 2))
    }

    min_idx <- which.min(allRMSE)
    Prop0 <- allProp[[min_idx]]

    return(list(allRMSE = allRMSE,
                allProp = allProp,
                estProp = Prop0,
                finalsigs = updatedInx
                )
           )
}
