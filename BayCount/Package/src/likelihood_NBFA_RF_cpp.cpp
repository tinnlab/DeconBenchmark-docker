#include <Rcpp.h>
#include <R.h>
#include <iostream>
#include <assert.h>
#include <math.h>

using namespace Rcpp;

//[[Rcpp::export]]
double log_likelihood_Y(NumericMatrix Y, NumericMatrix PhiTheta, NumericVector alpha, NumericVector p, double lambda){
  int G = Y(_,0).size();
  int S = Y(0,_).size();
  NumericMatrix log_L(G,S);
  for (int i = 0; i < G; i++){
    for (int j = 0; j < S; j++){
      log_L(i,j) = R::dnbinom(Y(i,j),alpha[i] * lambda+PhiTheta(i,j),p[j],1);
    }
  }
  return(sum(log_L));
}

//[[Rcpp::export]]
NumericMatrix likelihood_mat(NumericMatrix Y, NumericMatrix PhiTheta, NumericVector alpha, NumericVector p, double lambda){
  int G = Y(_,0).size();
  int S = Y(0,_).size();
  NumericMatrix L(G,S);
  for (int i = 0; i < G; i++){
    for (int j = 0; j < S; j++){
      L(i,j) = R::dnbinom(Y(i,j),alpha[i] * lambda+PhiTheta(i,j),p[j],0);
    }
  }
  return(L);
}

//[[Rcpp::export]]
double log_likelihood_alpha(NumericVector alpha, double g0, double h0){
  return((g0-1)*sum(log(alpha)));
}

//[[Rcpp::export]]
double log_likelihood_Phi(NumericMatrix Phi, double eta){
  int K = Phi(0,_).size();
  NumericVector log_L(K);
  for (int k = 0; k < K; k++){
    log_L[k] = (eta-1)*sum(log(Phi(_,k)));
  }
  return(sum(log_L));
}

//[[Rcpp::export]]
double log_likelihood_Theta(NumericMatrix Theta, NumericVector r, NumericVector c){
  int K = r.size();
  int S = c.size();
  NumericMatrix log_L(K,S);
  for (int k = 0; k < K; k++){
    for (int j = 0; j < S; j++){
      log_L(k,j) = R::dgamma(Theta(k,j), r[k], 1/c[j], 1);
      if (log_L(k,j) > 700){log_L(k,j) = 700;}
    }
  }
  return(sum(log_L));
}

// //[[Rcpp::export]]
// double log_likelihood_r(NumericVector r, double gamma0, double c0, int K){
//   int K = r.size();
//   for (int k = 0; k < K; k++){
//     log_L[k] = R::dgamma(r[k], gamma0/K, 1/c0);
//   }
//   return(sum(log_L));
// }
//
// //[[Rcpp::export]]
// double log_likelihood_c(NumericVector c, double e0, double f0, int S){
//   int S = c.size();
//   NumericVector log_L(S);
//   for (int j = 0; j < S; j++){
//     log_L[j] = R::dgamma(c[j], e0, 1/f0, 1);
//   }
//   return(sum(log_L));
// }
//
// //[[Rcpp::export]]
// double log_likelihood_p(NumericVector p, double a0, double b0, int S){
//   int S = p.size();
//   NumericVector log_L(S);
//   for (int j = 0; j < S; j++){
//     log_L[j] = R::dbeta(p[j], a0, b0, 1);
//   }
//   return(sum(log_L));
// }
