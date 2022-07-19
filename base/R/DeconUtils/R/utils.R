#' @title Get arguments from a HDF5 file
#'
#' @description This function read deconvolution input from a HDF5 file.
#' The h5 file should be created by `DeconBenchmark::.writeArgs`.
#'
#' @param params A string vector of parameters.
#' @return A list of inputs for deconvolution. See details for more information.
#'
#' @details
#' This function will read h5 file from the `INPUT_PATH` environment variable and return the values for the `params`.
#' When the `PARAMS_OUTPUT_PATH` is available, this function will only write the params to the `PARAMS_OUTPUT_PATH` file and exit R.
#' This is used to get the parameters of the method wrapper.
#'
#' @example
#'
#' DeconUtils::getArgs(c("bulk", "nCellTypes")) # list with 2 keys are bulk and nCellTypes
#'
#' @import rhdf5
#' @export
getArgs <- function(params) {
    if (Sys.getenv("PARAMS_OUTPUT_PATH") != ""){
        paramOutputPath <- Sys.getenv("PARAMS_OUTPUT_PATH")
        write.csv(data.frame(params = params), paramOutputPath, row.names = F)
        quit(save = "no", status = 999)
    }

    path <- Sys.getenv("INPUT_PATH")
    if (path == ""){
        stop("Environment variable INPUT_PATH is not set")
    }

    h5f <- H5Fopen(path)
    args <- list()

    for (param in unique(c(params, "seed"))){
        values <- try({
            h5read(h5f, paste0(param, "/values"))
        }, silent = T)

        if ("try-error" %in% class(values)) next()

        if ("matrix" %in% class(values)){
            rownames(values) <- as.character(h5read(h5f, paste0(param, "/rownames")))
            colnames(values) <- as.character(h5read(h5f, paste0(param, "/colnames")))
        } else if (any(c("array", "list") %in% class(values))){
            tryCatch({
                names(values) <- as.character(h5read(h5f, paste0(param, "/names")))
            }, error = function(e) {
                #Do nothing
            })
        }


        if (param == "seed"){
            set.seed(as.integer(values)[1])
        }

        args[[param]] <- values
    }

    args
}

#' @title Write deconvolution results to a HDF5 file
#'
#' @description This function write deconvolution results to a HDF5 file.
#' The path for the h5 file should be set in the `OUTPUT_PATH` environment variable.
#'
#' @param S Signature matrix.
#' @param P Proportion matrix.
#' @param method name of the method.
#' @param h5file Path of the HDF5 file.
#' @return Nothing.
#'
#' @import rhdf5
#' @export
writeH5 <- function(S, P, method="Unknown") {
    h5file <- Sys.getenv("OUTPUT_PATH")
    if (h5file == ""){
        stop("Environment variable OUTPUT_PATH is not set")
    }
    message(method, " Writing results to ", h5file)

    if (is.null(P)){
        stop("Proportion matrix is null")
    }

    unlink(h5file)
    h5createFile(h5file)

    h5createGroup(h5file,"P")
    h5write(P, h5file,"P/values")
    if (!is.null(rownames(P))){
        h5write(rownames(P), h5file,"P/rownames")
    }
    if (!is.null(colnames(P))){
        h5write(colnames(P), h5file,"P/colnames")
    }

    if (!is.null(S)){
        h5createGroup(h5file,"S")
        h5write(S, h5file,"S/values")
        if (!is.null(rownames(S))){
            h5write(rownames(S), h5file,"S/rownames")
        }
        if (!is.null(colnames(S))){
            h5write(colnames(S), h5file,"S/colnames")
        }
    }
}