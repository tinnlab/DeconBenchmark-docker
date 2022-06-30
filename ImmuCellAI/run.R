args <- DeconUtils::getArgs(c("bulk", "signature", "markers"))

suppressMessages(
  suppressWarnings({
          library(e1071)
          library(GSVA)
          library(pracma)
          library(quadprog)
          source("/code/ImmuCellAI.R")
    })
)


P <- Sample_abundance_calculation(args$bulk,args$markers,args$signature,"rnaSeq", 1)

DeconUtils::writeH5(NULL, P, "ImmuCellAI")
