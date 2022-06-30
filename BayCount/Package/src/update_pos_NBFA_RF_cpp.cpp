#include <Rcpp.h>
#include <R.h>
#include <iostream>
#include <assert.h>
#include <math.h>

using namespace Rcpp;

// [[Rcpp::export]]
double rand_normal(double mean, double stddev){
  //Box muller method
  static double n2 = 0.0;
  static int n2_cached = 0;
  if (!n2_cached){
    double x, y, r;
    do
    {
      x = 2.0*rand()/RAND_MAX - 1;
      y = 2.0*rand()/RAND_MAX - 1;
      r = x*x + y*y;
    }
    while (r == 0.0 || r > 1.0);
    {
      double d = sqrt(-2.0*log(r)/r);
      double n1 = x*d;
      n2 = y*d;
      double result = n1*stddev + mean;
      n2_cached = 1;
      return result;
    }
  }
  else
  {
    n2_cached = 0;
    return n2*stddev + mean;
  }
}


//[[Rcpp::export]]
int CrtRng(int n, double r){
  int ans;
  int m = 200;
  if (n == 0){ return(0);}
  if (n <= m){
    Rcpp::NumericVector pr(n);
    Rcpp::IntegerVector binom_rng(n);
    for (int j = 0; j < n; j++){
      pr[j] = r/(r + j);
      if (pr[j] > 1) {pr[j] = 1;}
      if (pr[j] < 0) {pr[j] = 0;}
      binom_rng[j] = R::rbinom(1, pr[j]);
      if (binom_rng[j] < 0) {binom_rng[j] = 0;}
    }
    ans = sum(binom_rng);
    return(ans);
  }
  else
  {
    double crt_mean = r*(R::digamma(r + n) - R::digamma(r));
    double crt_var = crt_mean + r * r * (R::trigamma(r) - R::trigamma(r + n));
    // ans = ceil(sqrt(crt_var) * R::rnorm(0, 1) + crt_mean);
    ans = ceil(rand_normal(crt_mean, sqrt(crt_var)));
    if (ans < 0) {ans = 0;}
    if (ans > n) {ans = n;}
    return(ans);
  }
}

// //[[Rcpp::export]]
// int CrtRng(int n, double r){
//   int ans;
//   int m = 30;
//   if (n == 0){ return(0);}
//   if (n <= m){
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
//     Rcpp::NumericVector pr(m);
//     Rcpp::IntegerVector binom_rng(m);
//     for (int j = 0; j < m; j++){
//       pr[j] = r/(r + j);
//       if (pr[j] > 1) {pr[j] = 1;}
//       if (pr[j] < 0) {pr[j] = 0;}
//       binom_rng[j] = R::rbinom(1, pr[j]);
//       if (binom_rng[j] < 0) {binom_rng[j] = 0;}
//     }
//     double L1 = sum(binom_rng);
//     double rate = r * (R::digamma(r + n) - R::digamma(r + m));
//     double L2 = R::rpois(rate);
//     if (L2 < 0) {L2 = 0;}
//     ans = L1 + L2;
//     return(ans);
//   }
// }

int rcategorical(Rcpp::NumericVector probs){
  probs = probs/sum(probs);
  int K = probs.size();
  Rcpp::IntegerVector ans(K);
  R::rmultinom(1, probs.begin(), K, ans.begin());
  return(Rcpp::which_max(ans) + 1);
}

// // [[Rcpp::export]]
// int CrtRng(int customers, double concentration){
//   int ans;
//   if (customers==0){
//     ans = 0;
//   }
//   else
//   {
//     Rcpp::NumericVector pr(customers);
//     Rcpp::IntegerVector binom_rng(customers);
//     for (int j = 0; j < customers; j++){
//       pr[j]=concentration/(concentration+j);
//       if (pr[j]>1){pr[j]=1;}
//       if (pr[j]<0){pr[j]=0;}
//       binom_rng[j]=R::rbinom(1,pr[j]);
//     }
//     ans = sum(binom_rng);
//   }
//   return(ans);
// }
//
// int rcategorical(Rcpp::NumericVector probs){
//   probs = probs/sum(probs);
//   int K = probs.size();
//   Rcpp::IntegerVector ans(K);
//   R::rmultinom(1, probs.begin(), K, ans.begin());
//   return(Rcpp::which_max(ans)+1);
// }

//[[Rcpp::export]]
NumericMatrix update_ELL(NumericMatrix PhiTheta, IntegerMatrix x){
  int G = x(_,0).size();
  int S = x(0,_).size();
  NumericMatrix ELL(G,S);
  // Following is the non-sparse treatment of assigning integer values to ELL
  for (int i = 0; i < G; i++){
    for (int j = 0; j < S; j++){
      ELL(i,j) = CrtRng(x(i,j), PhiTheta(i,j));
    }
  }
  // Following is the sparse treatment of assigning integer values to ELL
  // int n_temp = Sparse_Ind(_,0).size();
  // for (int i_temp = 0; i_temp < n_temp; i_temp++){
  //   int i = Sparse_Ind(i_temp,0);
  //   int j = Sparse_Ind(i_temp,1);
  //   int l = Y(i,j);
  //   double alpha = PhiTheta(i,j);
  //   ELL(i,j) = CrtRng(l,alpha);
  // }
  return(ELL);
}

//[[Rcpp::export]]
IntegerMatrix update_z(NumericVector alpha, NumericMatrix PhiTheta, IntegerMatrix Y){
  int G = alpha.size();
  int S = PhiTheta(0,_).size();
  // int m = 30;
  IntegerMatrix z(G,S);
  for (int i = 0; i < G; i++){
    for (int j = 0; j < S; j++){
      double p_ij = R::rbeta(alpha[i],PhiTheta(i,j));
      z(i,j) = R::rbinom(Y(i,j),p_ij);
      // if (Y(i, j) <= m){
      //   z(i,j) = R::rbinom(Y(i,j),p_ij);
      // }
      // else
      // {
      //   double binom_mean = Y(i, j) * p_ij;
      //   double binom_std = sqrt(Y(i, j) * p_ij * (1 - p_ij));
      //   z(i, j) = ceil(rand_normal(binom_mean, binom_std));
      //   if (z(i, j) < 0){ z(i, j) = 0; }
      //   if (z(i, j) > Y(i, j)){ z(i, j) = Y(i, j); }
      // }
    }
  }
  return(z);
}

//[[Rcpp::export]]
IntegerMatrix update_m(NumericVector alpha, IntegerMatrix z, double lambda){
  int G = alpha.size();
  int S = z(0, _).size();
  IntegerMatrix m(G,S);
  for (int i = 0; i < G; i++){
    for (int j = 0; j < S; j++){
      m(i,j) = CrtRng(z(i, j), lambda * alpha[i]);
    }
  }
  return(m);
}

//[[Rcpp::export]]
NumericVector update_alpha(double g0, double h0, NumericMatrix m, NumericVector p){
  int G = m(_,0).size();
  NumericVector alpha(G);
  double rate_par = h0 - sum(log(1-p));
  for (int i = 0; i < G; i++){
    double shape_par = g0 + sum(m(i,_));
    alpha[i] =  R::rgamma(shape_par, 1/rate_par);
  }
  alpha = alpha/sum(alpha);
  return(alpha);
}


//[[Rcpp::export]]
NumericMatrix update_Phi(double eta, NumericMatrix ell_ik, NumericMatrix Theta, NumericVector p){
  int K = ell_ik(0,_).size();
  int G = ell_ik(_,0).size();
  NumericMatrix Phi(G,K);
  for (int k = 0; k < K; k++){
    for (int i = 0; i < G; i++){
      double shape_par = eta+ell_ik(i,k);
      // Following is for the Gamma case of Phi(not Dirichlet distributed)
      // double rate_par = -sum(Theta(k,_)*log(1-p));
      double rate_par = 1;
      Phi(i,k)=R::rgamma(shape_par,rate_par);
    }
    Phi(_,k) = Phi(_,k)/sum(Phi(_,k));
  }
  return(Phi);
}

//[[Rcpp::export]]
NumericMatrix update_Theta(NumericVector r, NumericVector c, NumericVector p, NumericMatrix ell_jk, NumericMatrix Phi){
  int K = r.size();
  int S = c.size();
  NumericMatrix Theta(K,S);
  for (int j = 0; j < S; j++){
    for (int k = 0; k < K; k++){
      double shape_par = r[k] + ell_jk(j,k);
      double rate_par = c[j] - log(1-p[j]);
      Theta(k,j) = R::rgamma(shape_par,1/rate_par);
    }
  }
  return(Theta);
}

//[[Rcpp::export]]
NumericVector update_p(double a0, double b0, NumericVector n, NumericMatrix Theta, NumericVector alpha){
  int S = n.size();
  NumericVector p(S);
  for (int j = 0; j < S; j++){
    double shape1 = a0 + n[j];
    double shape2 = b0 + sum(alpha)+sum(Theta(_,j));
    p[j] = R::rbeta(shape1,shape2);
  }
  return(p);
}

//[[Rcpp::export]]
NumericVector update_c(double e0, double f0, NumericVector r, NumericMatrix Theta){
  int S = Theta(0,_).size();
  NumericVector c(S);
  for (int j = 0; j < S; j++){
    double shape_par = e0 + sum(r);
    double rate_par = f0 + sum(Theta(_,j));
    c[j] = R::rgamma(shape_par,1/rate_par);
  }
  return(c);
}

//[[Rcpp::export]]
double update_gamma0(double a0, double b0, double p_tilde, double gamma0, NumericVector ell_k){
  int K = ell_k.size();
  IntegerVector ell_prime(K);
  for (int k = 0; k < K; k++){
    ell_prime[k] = CrtRng(ell_k[k],gamma0/K);
  }
  double shape_par = a0 + sum(ell_prime);
  double rate_par = b0-log(1-p_tilde);
  return(R::rgamma(shape_par,1/rate_par));
}

//[[Rcpp::export]]
double update_c0(double e0, double f0, double gamma0, NumericVector r){
  double shape_par = e0 + gamma0;
  double rate_par = f0 + sum(r);
  return(R::rgamma(shape_par,1/rate_par));
}

//[[Rcpp::export]]
NumericMatrix update_ell_tilde(NumericMatrix ell_jk, NumericVector r){
  int S = ell_jk(_,0).size();
  int K = ell_jk(0,_).size();
  NumericMatrix ell_tilde(S,K);
  for (int j = 0; j < S; j++){
    for (int k = 0; k < K; k++){
      ell_tilde(j,k) = CrtRng(ell_jk(j,k),r[k]);
    }
  }
  return(ell_tilde);
}

//[[Rcpp::export]]
NumericVector update_r(double c0, double gamma0, NumericVector p_tilde_j, NumericVector ell_tilde_k){
  int K = ell_tilde_k.size();
  NumericVector r(K);
  for (int k = 0; k < K; k++){
    double shape_par = ell_tilde_k[k]+gamma0/K;
    double rate_par = c0-sum(log(1-p_tilde_j));
    r[k] =  R::rgamma(shape_par,1/rate_par);
  }
  return(r);
}


// The following sampling scheme for r is for the Gibbs sampler for the nonparametric version of the NBFA
// //[[Rcpp::export]]
// NumericVector update_r(double c0, double gamma0, NumericMatrix ell_tilde, NumericVector p, NumericVector c, NumericVector y_k){
//   int K = y_k.size();
//   NumericVector r(K);
//   int S = p.size();
//   int K_plus = 0;
//   for (int k = 0; k < K; k++){
//     if (y_k[k] > 0){K_plus = K_plus + 1;}
//   }
//   int K_star = K - K_plus;
//   NumericVector p_tilde(S);
//   for (int j = 0; j < S; j++){
//     p_tilde[j] = -log(1-p[j])/(c[j]-log(1-p[j]));
//   }
//   double rate_par = c0 - sum(log(1-p_tilde));
//   for (int k = 0; k < K; k++){
//     if (y_k[k] > 0){
//       double shape_par = sum(ell_tilde(_,k));
//       r[k] = R::rgamma(shape_par,1/rate_par);
//     }
//     else
//     {
//       double shape_par = gamma0/K_star;
//       r[k] = R::rgamma(shape_par,1/rate_par);
//     }
//   }
//   return(r);
// }
