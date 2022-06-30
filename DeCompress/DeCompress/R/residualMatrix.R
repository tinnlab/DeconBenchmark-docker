residualMatrix <- function(s,data,cutoff) {
    if (cutoff > 1) {
        x <- s$u[,1:cutoff] %*%
            diag(s$d)[1:cutoff,1:cutoff] %*%
            t(s$v[,1:cutoff])
    } else if (cutoff == 1) {
        x <- s$d[1] * s$u[,1] %*%
            t(s$v[,1])
    }
    data-x
}
