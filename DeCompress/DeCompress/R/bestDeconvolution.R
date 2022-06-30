#' Find cell-type gene signatures and do deconvolution
#'
#' The function finds cell-type gene signatures and does deconvolution
#' using the TOAST framework with NMF
#'
#' @param yref matrix, numeric expression matrix
#' @param n.types integer, number of cell-types
#' @param scree character, method to estimate n.types if n.types is NULL
#' @param logTransform logical, T/F if yref is in log-scale
#' @param known.props matrix, known proportion matrix, NULL if not known
#' @param methods vector, character vector of deconv methods to use
#'
#' @return list with cell-type proportions and expression profiles
#'
#' @import NMF
#'
#' @importFrom CellDistinguisher gecd_CellDistinguisher
#'
#' @export
bestDeconvolution <- function(yref,
                              n.types = NULL,
                              scree = 'drop',
                              logTransform = F,
                              known.props = NULL,
                              methods = c('TOAST',
                                          'linseed',
                                          'celldistinguisher')){

    if (is(yref, "SummarizedExperiment")) {
        se <- yref
        yref <- assays(se)$counts
    } else if (!is(yref, "matrix")) {
        stop("Y_raw should be a matrix or a SummarizedExperiment object!")
    }

    if (logTransform){
        yref = log2(yref+1)
    }

    row.means = rowSums(yref)
    yref = yref[row.means > 0,]

    if (is.null(n.types)){
        n.types = findNumberCells(yref,scree = scree)
    }

    geneList = rownames(yref)
    all.res = list()

    ### TOAST + NMF
    if ('TOAST' %in% methods){
    toast.nmf <- csDeCompress(Y_raw = yref,
                              K = n.types,
                              nMarker = nrow(yref),
                              FUN = nmfOut,
                              TotalIter = 30)

    require(NMF)
    fin.nmf = nmf(x = yref[toast.nmf$finalsigs,],
                  rank = n.types)
    ppp = t(coef(fin.nmf))
    ppp = t(apply(ppp,1,function(c) c/sum(c)))
    nmf.res = list(prop = ppp,
                   sig = basis(fin.nmf))
    all.res = rlist::list.append(all.res,
                                 nmf.res)}


    ### LINSEED
    if ('linseed' %in% methods){
    linseed.rs = linCor(yref = yref,
                        iters = 100,
                        pval = .1,
                        n.types = n.types,
                        scree = 'drop',
                        logTransform = F)
    names(linseed.rs) = names(nmf.res)
    if (ncol(linseed.rs$prop) != n.types){
        linseed.rs$prop = t(linseed.rs$prop)
    }
    if (any(is.na(linseed.rs$sig))){
        all.res = rlist::list.append(all.res,
                                     nmf.res)
    } else {
        all.res = rlist::list.append(all.res,
                                     linseed.rs)
    }
    }

    ### CellDistinguisher
    if ('celldistinguisher' %in% methods){
    cd <- CellDistinguisher::gecd_CellDistinguisher(yref,
                                 genesymb=geneList,
                                 numCellClasses=n.types,
                                 minDistinguisherAlternatives=1,
                                 maxDistinguisherAlternatives=100,
                                 minAlternativesLengthsNormalized=0.5,
                                 expressionQuantileForFilter=0.999,
                                 expressionConcentrationRatio=0.333,
                                 verbose=0)
    CellDist.deconv <-
        tryCatch(CellDistinguisher::gecd_DeconvolutionByDistinguishers(
        as.matrix(yref),
        cd$bestDistinguishers,
        nonNegativeOnly = FALSE,
        convexSolution = FALSE,
        verbose = 0),
        error = function(e) return(list(sampleCompositions =
                                            matrix(rep(1/n.types,
                                                       n.types*ncol(yref)),
                                                   ncol=n.types))))
    if (length(CellDist.deconv) > 1){
        CellDist.rs = list(prop = t(CellDist.deconv$sampleCompositions),
                           sig = CellDist.deconv$cellSubclassSignatures)
    } else {CellDist.rs = nmf.res}

    all.res = rlist::list.append(all.res,
                                 CellDist.rs)
    }

    errors = vector(mode = 'numeric',
                    length = length(all.res))
    for (i in 1:length(errors)){
        errors[i] = calculateError(all.res[[i]]$prop,
                                   all.res[[i]]$sig,
                                   trueProp = known.props,
                                   yref = yref)
    }

    return(all.res[[which.min(errors)]])
}
