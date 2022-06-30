args <- DeconUtils::getArgs(c("bulk", "signature"))

suppressMessages(
  suppressWarnings({
      source("/code/MIXTURE.R")
    })
)


P <- MIXTURE(expressionMatrix = args$bulk[rownames(args$signature), ],          #N x ncol(signatureMatrix) gene expresion matrix to evaluate
                    ##rownames(M) should be the GeneSymbols
                    signatureMatrix = args$signature,                 #the gene signature matrix (W) such that M = W*betas'
                    #(i.e the LM22 from Newman et al)
                    # iter = 100,                            #iterations for the statistical test (null distribution)
                    functionMixture = nu.svm.robust.RFE,    #cibersort, nu.svm.robust.rfe, ls.rfe.abbas,
                    useCores = 1L,                         #cores for parallel processing/ if using windows set to 1
                    verbose = F,                         #TRUE or FALSE messages
                    nullDist = "none"           #"none" or "PopulationBased" if the statistical test should
)$Subjects$MIXabs

DeconUtils::writeH5(NULL, P, "MIXTURE")
