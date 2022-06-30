#include <RcppArmadillo.h>
#include <R.h>
// #include <Rmath.h>
#include <iostream>
// #include <assert.h>
// #include <math.h>

// [[Rcpp::depends(RcppArmadillo)]]

// //[[Rcpp::export]]
// int CrtRng(int n, double r){
//   int ans;
//   if (n == 0){ return(0);}
//   if (n <= 40){
//     Rcpp::NumericVector pr(n);
//     Rcpp::IntegerVector binom_rng(n);
//     for (int j = 0; j < n; j++){
//       pr[j] = r/(r + j);
//       if (pr[j] > 1) {pr[j] = 1;}
//       if (pr[j] < 0) {pr[j] = 0;}
//       binom_rng[j] = R::rbinom(1, pr[j]);
//       if (binom_rng[j] < 0) {binom_rng[j] = 0;}
//     }
//     ans = sum(binom_rng);
//     return(ans);
//   }
//   else
//   {
//     double crt_mean = r*(R::digamma(r + n) - R::digamma(r));
//     double crt_var = crt_mean + r * r * (R::trigamma(r) - R::trigamma(r + n));
//     ans = ceil(sqrt(crt_var) * R::rnorm(0, 1) + crt_mean);
//     if (ans < 0){ans = 0;}
//     return(ans);
//   }
// }

// int rcategorical(Rcpp::NumericVector probs){
//   probs = probs/sum(probs);
//   int K = probs.size();
//   Rcpp::IntegerVector ans(K);
//   R::rmultinom(1, probs.begin(), K, ans.begin());
//   return(Rcpp::which_max(ans) + 1);
// }

//[[Rcpp::export]]
Rcpp::IntegerVector rmultinomial(int N, Rcpp::NumericVector probs){
  probs = probs/sum(probs);
  int K = probs.size();
  Rcpp::IntegerVector ans(K);
  R::rmultinom(N, probs.begin(), K, ans.begin());
  return(ans);
}

// The following sampling scheme for the latent topic z is for the regular blocked Gibbs sampler for NBFA
// //[[Rcpp::export]]
// Rcpp::NumericMatrix update_z(Rcpp::NumericMatrix x, arma::cube y, Rcpp::NumericMatrix z, Rcpp::NumericMatrix Phi, Rcpp::NumericMatrix Theta, Rcpp::NumericVector n){
//   int S = x(Rcpp::_,0).size();
//   int K = Phi(0,Rcpp::_).size();
//   int n_max = x(0,Rcpp::_).size();
//   Rcpp::NumericMatrix z_new(S,n_max);
//   for (int j = 0; j < S; j++){
//     for (int s = 0; s < n[j]; s++){
//       int i = x(j,s)-1;
//       Rcpp::NumericVector pr(K);
//       for (int k = 0; k < K; k++){
//         double temp = y(i,j,k);
//         if (z(j,s) == k + 1){temp = temp - 1;}
//         pr[k] = temp + Phi(i,k)*Theta(k,j);
//       }
//       pr = pr/sum(pr);
//       z_new(j,s) = rcategorical(pr);
//     }
//   }
//   return(z_new);
// }

// The following sampling scheme is for the regular blocked Gibbs sampler for NBFA
// // [[Rcpp::export]]
// arma::cube update_y(int G, int S, int K, Rcpp::NumericMatrix x, Rcpp::NumericMatrix z, Rcpp::IntegerVector n){
//   arma::cube y(G,S,K);
//   for (int i = 0; i < G; i++){
//     for (int j = 0; j < S; j++){
//       for (int k = 0; k < K; k++){
//         int count = 0;
//         for (int s = 0; s < n[j]; s++){
//           if ((x(j,s) == i) && (z(j,s) == k)){
//             count =  count + 1;
//           }
//         }
//         y(i,j,k) = count;
//       }
//     }
//   }
//   return(y);
// }

// The following sampling scheme is for the compound Poisson based blocked Gibbs sampler for NBFA
// [[Rcpp::export]]
arma::cube update_ell(Rcpp::NumericMatrix Phi, Rcpp::NumericMatrix Theta, Rcpp::IntegerMatrix ELL){
  int G = Phi(Rcpp::_,0).size();
  int S = Theta(0,Rcpp::_).size();
  int K = Phi(0,Rcpp::_).size();
  arma::cube ell(G,S,K);
  for (int i = 0; i < G; i++){
    for (int j = 0; j < S; j++){
      Rcpp::IntegerVector temp(K);
      Rcpp::NumericVector pr(K);
      pr = Phi(i,Rcpp::_) * Theta(Rcpp::_,j);
      pr = pr/sum(pr);
      temp = rmultinomial(ELL(i,j), pr);
      for (int k = 0; k < K; k++){
        if (temp[k] < 0){
          ell(i,j,k) = 0;
        }else{
          ell(i,j,k) = temp[k]; 
        }
      }
    }
  }
  return(ell);
}
