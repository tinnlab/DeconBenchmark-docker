args <- DeconUtils::getArgs(c("bulk", "signature"))

suppressMessages(
  suppressWarnings({
      # library(tidyr)
      library(LinDeconSeq)
    })
)


# phenotype <- data.frame(
#     sample = colnames(args$singleCellExpr),
#     cellType = args$singleCellLabels,
#     value = 1
# ) %>% spread(sample, value)
#
# phenotype[is.na(phenotype)] <- 2
# rownames(phenotype) <- phenotype$cellType
# phenotype <- phenotype[,-1]
#
#
# markerRes <- findMarkers(args$singleCellExpr, phenotype, norm.method = 'NONE', data.type = 'MA')
# fractions <- deconSeq(args$bulk, markerRes$sigMatrix$sig.mat, verbose = F)

#Failed to find marker sometimes, change to use signature
fractions <- deconSeq(args$bulk, args$signature, verbose = F)

DeconUtils::writeH5(NULL, fractions, "LinDeconSeq")