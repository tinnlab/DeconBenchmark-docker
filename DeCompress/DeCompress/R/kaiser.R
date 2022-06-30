#' Kaiser method to determine number of important SVs
#'
#' The function estimates the SV for the elbow in a scree plot
#' from the vector of singular values
#'
#' @param varpc vector, singular values of a matrix
#' @param low numeric, lower bound of cumulative var explained
#' @param max.pc numeric, upper bound of cumulative var explained
#'
#' @return number of cell types
#'
#' @export
kaiser <- function(varpc,
                   low=.08,
                   max.pc=.9) {
    ee <- varpc/sum(varpc) # ensure sums to 1
    #print(round(log(ee),3))
    while(low>=max(ee)) { low <- low/2 } # when no big components, then adjust 'low'
    lowie <- (ee<low) ; highie <- ee>low/8
    low.ones <- which(lowie & highie)
    others <- length(which(!lowie))
    if(length(low.ones)>0) {
        if(length(low.ones)==1) {
            elbow <- low.ones
        } else {
            set <- ee[low.ones]
            pc.drops <- abs(diff(set))/(set[1:(length(set)-1)])
            infz <- is.infinite(pc.drops)
            #print(pc.drops)
            elbow <- which(pc.drops==max(pc.drops[!infz],na.rm=T))[1]+others
        }
    } else {
        # if somehow there are no small eigenvalues, just choose the elbow as the second last
        cat("no eigenvalues were significantly smaller than the previous\n")
        elbow <- length(ee)
    }
    if(tail(cumsum(ee[1:elbow]),1)>max.pc) {
        elbow <- which(cumsum(ee)>max.pc)[1]-1
    }
    if(elbow<1) {
        warning("elbow calculation failed, return zero")
        return(0)
    }
    names(elbow) <- NULL
    return(elbow)
}
