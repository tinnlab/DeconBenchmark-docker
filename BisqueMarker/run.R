args <- DeconUtils::getArgs(c("bulk", "markers"))

suppressMessages(
    suppressWarnings({
        library(dplyr)
        library(BisqueRNA)
    })
)

bulk.eset <- Biobase::ExpressionSet(assayData = args$bulk)

if (is.null(names(args$markers))){
    names(args$markers) <- paste0("CellType", 1:length(args$markers))
}

markers <- lapply(names(args$markers), function(m) {
    data.frame(gene = args$markers[[m]], cluster = m)
}) %>% do.call(what = rbind)

P <- MarkerBasedDecomposition(bulk.eset, markers=markers, weighted=F)$bulk.props

DeconUtils::writeH5(NULL, t(P), "BisqueMarker")
