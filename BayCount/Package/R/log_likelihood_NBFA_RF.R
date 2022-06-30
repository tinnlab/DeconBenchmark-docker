# Log-likelihood function for NBFA with random effect
log_likelihood_NBFA_RF <- function(mcmc,Y,hyper,B,nmc,K){
  # Rcpp::sourceCpp('likelihood_NBFA_RF_cpp.cpp')
  log_likelihood = rep(NA, B+nmc)
  Evidence = 0
  for (iter in 1:(B+nmc)){
    PhiTheta = mcmc$Phi[,,iter]%*%mcmc$Theta[,,iter]
    # double log_likelihood_Y(NumericMatrix Y, NumericMatrix PhiTheta, NumericVector alpha, NumericVector p)
    log_L_Y = log_likelihood_Y(Y, PhiTheta, mcmc$alpha[,iter], mcmc$p[,iter], mcmc$lambda[iter])
    # double log_likelihood_alpha(NumericVector alpha, double e0, double f0)
    log_L_alpha = log_likelihood_alpha(mcmc$alpha[,iter], hyper$e0, hyper$f0)
    # double log_likelihood_Phi(NumericMatrix Phi, double eta)
    log_L_Phi = log_likelihood_Phi(mcmc$Phi[,,iter], hyper$eta)
    # double log_likelihood_Theta(NumericMatrix Theta, NumericVector r, NumericVector c)
    log_L_Theta = log_likelihood_Theta(mcmc$Theta[,,iter], mcmc$r[,iter], mcmc$c[,iter])
    log_L_r = sum(dgamma(mcmc$r[,iter],shape=mcmc$gamma0[iter]/K,rate=mcmc$c0[iter],log=TRUE))
    log_L_c = sum(dgamma(mcmc$c[,iter],shape=hyper$e0,rate=hyper$f0,log=TRUE))
    log_L_p = sum(dbeta(mcmc$p[,iter],shape1=hyper$a0,shape2=hyper$b0,log=TRUE))
    log_L_gamma0 = dgamma(mcmc$gamma0[iter],shape=hyper$a0,rate=hyper$b0,log=TRUE)
    log_L_c0 = dgamma(mcmc$c0[iter],shape=hyper$e0,rate=hyper$f0,log=TRUE)
    log_L_lambda = dgamma(mcmc$lambda[iter], shape = hyper$u0, rate = hyper$v0)
    log_likelihood[iter] = log_L_Y+log_L_alpha+log_L_Phi+log_L_Theta+log_L_r+log_L_c+log_L_p+log_L_gamma0+log_L_c0
    Evidence = Evidence + log_L_Y
    if (floor(iter/100) == iter/100){
      print(paste("Iteration: ",iter))
    }
  }
  return(list(loglik = log_likelihood, Evidence = Evidence/(B+nmc)))
}
