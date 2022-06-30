args <- DeconUtils::getArgs(c("bulk", "singleCellExpr", "singleCellLabels", "seed"))

suppressMessages(
  suppressWarnings({
      library(digitalDLSorteR)
      library(SingleCellExperiment)
      library(SummarizedExperiment)
      options(reticulate.conda_binary = "/r-miniconda/bin/conda");
    })
)

reticulate::use_condaenv("digitaldlsorter-env")
tensorflow::use_condaenv("digitaldlsorter-env")


set.seed(args$seed)

bulk <- SummarizedExperiment(assay = list(counts = args$bulk))

sce <- SingleCellExperiment(
  args$singleCellExpr,
  colData = data.frame(
    Cell_ID = colnames(args$singleCellExpr),
    Cell_Type = args$singleCellLabels
  ),
  rowData = data.frame(
    Gene_ID = rownames(args$singleCellExpr)
  )
)

DDLS <- loadSCProfiles(
  single.cell = sce,
  cell.ID.column = "Cell_ID",
  gene.ID.column = "Gene_ID",
  min.cells = 0,
  min.counts = 0,
  project = "Deconvolution"
)

DDLS <- estimateZinbwaveParams(
  object = DDLS,
  cell.ID.column = "Cell_ID",
  gene.ID.column = "Gene_ID",
  cell.type.column = "Cell_Type",
  subset.cells = min(length(args$singleCellLabels)-1, 500),
  threads = 8,
  verbose = TRUE
)

DDLS <- simSCProfiles(
  object = DDLS,
  cell.ID.column = "Cell_ID",
  cell.type.column = "Cell_Type",
  n.cells = 50,
  suffix.names = "_Simul",
  verbose = TRUE
)

uniqueCellType <- unique(args$singleCellLabels)
freq <- round(table(args$singleCellLabels)[uniqueCellType]/length(args$singleCellLabels)*100)

probMatrix <- data.frame(
  Cell_Type = uniqueCellType,
  from = sapply(freq, function(f) max(f - 20, 1)),
  to = sapply(freq, function(f) min(f + 20, 99))
)

DDLS <- generateBulkCellMatrix(
  object = DDLS,
  cell.ID.column = "Cell_ID",
  cell.type.column = "Cell_Type",
  prob.design = probMatrix,
  num.bulk.samples = 5000,
  n.cells = 100,
  verbose = TRUE
)

DDLS <- simBulkProfiles(
  object = DDLS, type.data = "both", pseudobulk.function = "MeanCPM"
)

DDLS <- trainDigitalDLSorterModel(object = DDLS, scaling = "standarize")


DDLS <- loadDeconvData(
  object = DDLS,
  data = bulk,
  name.data = "bulk"
)

DDLS <- deconvDigitalDLSorterObj(
  object = DDLS,
  name.data = "bulk",
  normalize = TRUE,
  scaling = "standarize",
  verbose = FALSE
)

P <- DDLS@deconv.results

DeconUtils::writeH5(NULL, P$bulk, "digitalDLSorter")
