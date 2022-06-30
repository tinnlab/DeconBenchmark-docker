structureMeasure <- function(s,
                             data,
                             cutoff) {
    residual.matrix <- residualMatrix(s,data,cutoff)
    residual.s <- svd(residual.matrix,nu=1,nv=1)
    nc <- ncol(residual.matrix)
    nr <- nrow(residual.matrix)
    alt.norms <- rep(NA,10)
    for (i in 1:10) {
        altered.matrix <- residual.matrix*matrix(sample(c(-1,1),
                                                        nc*nr,
                                                        replace=T),
                                                 ncol=nc)
        alt.s <- svd(altered.matrix,nu=1,nv=1)
        alt.norms[i] <- alt.s$d[1]
    }
    (residual.s$d[1]-mean(alt.norms))/sqrt(sum(residual.matrix^2))
}
