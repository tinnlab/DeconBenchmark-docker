#' @title Match labels
#' @description Match labelsbetween inference of BayCount and simulation truth
#' @param BayCount_model a list of BayCount MCMC results
#' @param simu_truth a list of simulation true parameters and observed count matrix
#' @param B number of burn-in iterations in the MCMC
#' @param nmc number of post-burn-in iterations in the MCMC
#' @return BayCount_model with the correct labeling order of subclones according to the simulation truth
#'
#' @examples
#' # Let us consider a medium scale synthetic example.
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

#' ###############################################################
#' # Run the BayCount model with known K                         #
#' ###############################################################
#' attach(synthetic_data)
#' G = dim(Y)[1]
#' S = dim(Y)[2]
#' K = dim(Phi)[2]
#' Init = list(Phi = matrix(1/G, nrow = G, ncol = K), Theta = matrix(15, nrow = K, ncol = S))
#' BayCount_inference = BayCount_MCMC(Y, Init, hyper, B, nmc, K, Print_Iter = TRUE)
#' BayCount_inference = BayCount_match_lable(BayCount_inference, simu_truth = synthetic_data)
#' Phi_hat = apply(BayCount_inference$Phi[, , sample_ind], c(1, 2), mean)
#' Theta_hat_norm = apply(BayCount_inference$Theta_norm[, , sample_ind], c(1, 2), mean)
#' detach(synthetic_data)

#'
#' @export
BayCount_match_lable = function(BayCount_model, simu_truth, B = 1000, nmc = 1000){
  # use_package("combinat")
  G = dim(simu_truth$Phi)[1]
  K = dim(simu_truth$Phi)[2]
  S = dim(simu_truth$Theta_norm)[2]
  sample_ind=(B + 1): (B + nmc)
  # Posterior Mean of Theta and normalized Theta
  Theta_hat = apply(BayCount_model$Theta[, , sample_ind], c(1, 2), mean)
  Theta_hat_norm = apply(BayCount_model$Theta_norm[, , sample_ind], c(1, 2), mean)
  # Posterior Mean of Phi
  Phi_hat = apply(BayCount_model$Phi[, , sample_ind], c(1, 2), mean)
  # simu_truth$Phi_norm = simu_truth$Phi/(matrix(1,nrow=G,ncol=1)%*%matrix(apply(simu_truth$Phi,2,sum),nrow=1,ncol=K))
  # Finding the correct labeling permutation by minimizing MSE
  # of estimated subclonal proportions with the ground truth proportionslibrary(combinat)
  perm_all = combinat::permn(1:K)
  mse = rep(NA, factorial(K))
  for (t in 1:factorial(K)){
    perm_tmp = perm_all[[t]]
    mse[t] = sum((Theta_hat_norm[perm_tmp, ] - simu_truth$Theta_norm)^2)
  }
  ind_perm = perm_all[[which.min(mse)]]
  BayCount_model$Phi = BayCount_model$Phi[, ind_perm, ]
  BayCount_model$Theta = BayCount_model$Theta[ind_perm, , ]
  BayCount_model$Theta_norm = BayCount_model$Theta_norm[ind_perm, , ]
  return(BayCount_model)
}
