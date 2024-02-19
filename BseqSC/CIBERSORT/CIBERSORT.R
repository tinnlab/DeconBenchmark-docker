# CIBERSORT R script v1.04 (last updated 10-24-2016)
# License: http://cibersort.stanford.edu/CIBERSORT_License.txt
# This is a placeholder for the CIBERSORT R script.
# Please contact the CIBERSHOW team for acquiring the full script.

CIBERSORT <- function(sig_matrix, mixture_file, perm=0, QN=TRUE, absolute=FALSE, abs_method='sig.score'){
    #read in data
    X <- read.table(sig_matrix,header=T,sep="\t",row.names=1,check.names=F)
    Y <- read.table(mixture_file, header=T, sep="\t",check.names=F)
    matrix(runif(nrow(Y)*ncol(X)), nrow(Y), ncol(X))
}
