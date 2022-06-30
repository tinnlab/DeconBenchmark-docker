#' @title Bayesian Inference of BayCount
#' @description Bayesian Inference of BayCount: model selection and posterior computation
#' @param Y observed count matrix
#' @param B number of burn-in iterations
#' @param nmc number of post-burn-in iterations
#' @param hyper hyperparameters for the
#' @param K_range the range for the number of subclones
#' @param lab_switch.check logical variable indicating whether label switching phenomenon is checked
#' @return A model selection object with log-likelihood and Delta^2 log-likelihood
#' @examples
#' # Let us consider a synthetic example.
#' # In particular, we consider the synthetic_data dataset
#' # This dataset is used in Section 3.1 in the manuscript
#' # loading required packages
#' library(Rcpp)
#' library(combinat)
#' library(RColorBrewer)
#' library(gplots)
#' # Let us initialize the hyperparameters
#' hyper=NULL
#' hyper$eta = 0.1
#' hyper$a0 = 0.01
#' hyper$b0 = 0.01
#' hyper$e0 = 1
#' hyper$f0 = 1
#' hyper$g0 = 1
#' hyper$h0 = 1
#' hyper$u0 = hyper$v0 = 100
#' B = 1000
#' nmc = 1000
#' K_range = 1:10
#' sample_ind = (B + 1):(B + nmc)
#'
#' ###############################################################
#' # Run the BayCount model selection to determine K             #
#' ###############################################################
#' attach(synthetic_data)
#' G = dim(Y)[1]
#' S = dim(Y)[2]
#' K0 = dim(Phi)[2]
#' BayCount_model = BayCount(Y, B, nmc, hyper, K_range)
#' detach(synthetic_data)
#' K = BayCount_model$K
#' BayCount_inference = BayCount_model$model
#' BayCount_inference = BayCount_match_lable(BayCount_inference, simu_truth = synthetic_data)
#' Phi_hat = apply(BayCount_inference$Phi[, , sample_ind], c(1, 2), mean)
#' Theta_hat_norm = apply(BayCount_inference$Theta_norm[, , sample_ind], c(1, 2), mean)
#'
#' ###############################################################
#' # Compare subclonal proportions (Figure 2 in the manuscript)
#' ###############################################################
#' pdf("Figure_2.pdf", width = 10, height = 12)
#' par(mfrow=c(K, 1))
#' for (k in 1:K){
#'   theta_k_estimate = Theta_hat_norm[k, ]
#'   theta_k_CI_upper = apply(BayCount_inference$Theta_norm[k, , sample_ind], 1, quantile, 0.975)
#'   theta_k_CI_lower = apply(BayCount_inference$Theta_norm[k, , sample_ind], 1, quantile, 0.025)
#'   plot(1:S, type = "n", xlab = "Samples", ylab = "Proportions",
#'        ylim = c(min(theta_k_CI_lower), max(theta_k_CI_upper) + 0.4),
#'        main = paste("Subclone ",k, " Proportion", sep = ""), cex.main = 2, cex.axis = 1.5, cex.lab = 1.5)
#'   grid(nx = 10, ny = 5, lwd = 1)
#'   polygon(c(1:S, rev(1:S)), c(theta_k_CI_lower, rev(theta_k_CI_upper)),col = "grey80", border = T)
#'   points(1:S, theta_k_estimate, type="b", pch = 1, lwd = 3, col = "green", lty = 1)
#'   points(1:S, synthetic_data$Theta_norm[k, ], type = "b",pch = 2, col = "red", lwd = 3, lty = 1)
#'   legend("topleft", legend = c("Estimates","True Values"), lwd = c(3, 3),
#'          pch = c(1, 2), col = c("green","red"), cex = 1.5, bty = "n")
#' }
#' dev.off()
#'
#' ###############################################################
#' # Heatmaps of gene expression data (Figure 3 in the manuscript)
#' ###############################################################
#' sd_gene = apply(synthetic_data$Phi_norm, 1, sd)
#' tau_sd = 1/G
#' diff_exp_gene = which(sd_gene > tau_sd)
#' my_palette = brewer.pal(9, "Blues")
#' pdf("Figure_3a.pdf", width = 5, height = 9)
#' heatmap.2(synthetic_data$Phi[diff_exp_gene, ], trace = "none", Rowv = NULL, Colv = NULL,
#'           dendrogram = "none", col = my_palette, key = TRUE, margins = c(3, 0),
#'           key.par = list(mar = c(2, 0,3, 0)), denscol = "black", key.xlab = "", key.ylab = "",
#'           key.title = "", labRow = "", cexCol = 4, lhei = c(0.8, 5), lwid = c(0.2, 1.2, 0.2),
#'           lmat=rbind(c(5, 4, 2), c(6, 1, 3)))
#' dev.off()
#' pdf("Figure_3b.pdf", width = 5, height = 9)
#' heatmap.2(Phi_hat[diff_exp_gene, ], trace = "none", Rowv = NULL, Colv = NULL,
#'           dendrogram = "none", col = my_palette, key = TRUE, margins = c(3, 0),
#'           key.par = list(mar = c(2, 0,3, 0)), denscol = "black", key.xlab = "", key.ylab = "",
#'           key.title = "", labRow = "", cexCol = 4, lhei = c(0.8, 5), lwid = c(0.2, 1.2, 0.2),
#'           lmat=rbind(c(5, 4, 2), c(6, 1, 3)))
#' dev.off()

#' @export

BayCount = function(Y, B = 1000, nmc = 1000, hyper, K_range = 1:10, lab_switch.check = FALSE){
  loglik_NBFA_RF = matrix(NA,nrow = length(K_range), ncol = B+nmc)
  G = dim(Y)[1]
  S = dim(Y)[2]
  mcmc_NBFA_RF_models = vector(mode = "list", length = length(K_range))
  # Rcpp::sourceCpp('likelihood_NBFA_RF_cpp.cpp')
  # source("BayCount_MCMC.R")
  for (K_ind in 1:length(K_range)){
    ptm = proc.time()
    K_tmp = K_range[K_ind]
    Init = list(Phi=matrix(1/G,nrow=G,ncol=K_tmp),Theta=matrix(15,nrow=K_tmp,ncol=S))
    mcmc_NBFA_RF_models[[K_tmp]] = BayCount_MCMC(Y, Init, hyper, B, nmc, K_tmp, Print_Iter = FALSE, lab_switch.check)
    log_likelihood = rep(NA, B+nmc)
    for (iter in 1:(B+nmc)){
      PhiTheta = matrix(mcmc_NBFA_RF_models[[K_tmp]]$Phi[,,iter], ncol = K_tmp) %*%
        matrix(mcmc_NBFA_RF_models[[K_tmp]]$Theta[,,iter], nrow = K_tmp)
      # double log_likelihood_Y(NumericMatrix Y, NumericMatrix PhiTheta, NumericVector alpha, NumericVector p)
      log_L_Y = log_likelihood_Y(Y, PhiTheta, mcmc_NBFA_RF_models[[K_tmp]]$alpha[,iter], mcmc_NBFA_RF_models[[K_tmp]]$p[,iter], mcmc_NBFA_RF_models[[K_tmp]]$lambda[iter])
      loglik_NBFA_RF[K_ind,iter] = log_L_Y
    }
    runtime = (proc.time() - ptm)[3]
    colnames(runtime) = NULL
    print(paste("BayCount with K = ", K_tmp, "; Runtime: ", ceiling(runtime), "s.", sep = ""))
  }

  mcmc_NBFA_RF_models

  # sample_ind = (B + 1):(B + nmc)
  # loglik_mean = apply(loglik_NBFA_RF[, sample_ind, drop=F], 1, mean)
  # loglik_max = apply(loglik_NBFA_RF[, sample_ind, drop=F], 1, max)
  #
  # Delta2_loglik = 2 * loglik_mean[-c(1, length(K_range))] -
  #   loglik_mean[1:(length(K_range) - 2)] - loglik_mean[-c(1, 2)]
  # Delta2_maxloglik = 2 * loglik_max[-c(1, length(K_range))] -
  #   loglik_max[1:(length(K_range) - 2)] - loglik_max[-c(1, 2)]
  # # attach(BayCount_vs_K)
  # # plot(2:max(K_range - 1), Delta2_maxloglik,
  # #      type = "b", pch = 1, lwd = 5, col = "blue", xlab = "K",
  # #      ylab = "Delta-Squared log-likelihood", main = "Delta-Squared log-likelihood",
  # #      cex.main = 2, cex.axis = 1.5, cex.lab = 1.5)
  # # grid(nx = 7, ny = 5, col = "grey80", lwd = 3, lty = "dotdash")
  # # legend("topright", legend = c("Delta-squared log-likelihood"), col = "blue", lwd = 5, pch = 1,
  # #        cex = 1.5, bty = "n")
  # K = which.max(Delta2_maxloglik) + min(K_range)
  # # detach(BayCount_vs_K)
  # return(list(K = K, model = mcmc_NBFA_RF_models[[K]], loglik_NBFA = loglik_NBFA_RF,
  #             Delta2_loglik = Delta2_loglik, Delta2_maxloglik = Delta2_maxloglik))
}
