args <- DeconUtils::getArgs(c("bulk", "markers"))
library(DSA)


# Documentation: https://github.com/zhandong/DSA/blob/master/Package/version_1.0/DSA.pdf

mix <- args$bulk
estimated_weight <- EstimateWeight(mix, args$markers, method="LM")

deconv <- as.matrix(Deconvolution(mix, t(estimated_weight$weight)))
rownames(deconv) <- rownames(mix)
colnames(deconv) <- names(args$markers)

DeconUtils::writeH5(deconv, t(estimated_weight$weight), "DSA")