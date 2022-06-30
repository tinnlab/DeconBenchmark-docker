%%% bayescce.m
%%% 
%%% Summary: A function to estimate cell counts using DNA methylation data from heterogeneous tissue and a prior information on the cell type distribution in the studied tissue.
%%% This is an implementation of the BayesCCE method (Bayesian Cell Count Estimation). The algorithm is described in Rahmani et al. 2018: A Bayesian Framework for Estimating Cell Type Composition from DNA Methylation Without the Need for Methylation Reference.
%%% Author: Elior Rahmani (elior.rahmani@gmail.com)
%%% Date: 25th January 2017 (latest update: Feb 10th 2018)
%%%
%%% This function was implemented and tested using Matlab 2015b.
% 
% INPUT:
% (1) X - an m by n matrix of sites by samples methylation levels.
% For data preparation, it is advised to follow the recommendations for applying ReFACTor (Rahmani et al., Nature Methods 2016): exclude sites with extremely low variability and exclude polymorphic and cross-reactive sites as well sites coming from the sex chromosomes.
% The full set of recommendations for data preparations for ReFACTor can be found under "Tissue heterogeneity" at: glint-epigenetics.readthedocs.io
% (2) model_covars - an n by p matrix of p covariates for the n individuals.
% model_covars should include covariates that may have large effects on many methylation sites but are not expected to be correlated with the cell type composition (e.g., batch information).
% (3) refactor_covars - an n by p' matrix of p' covariates for the n individuals. Note that p' may be different than p (the number of covariates in model_covars).
% These covariates will be accounted for while calculating the ReFACTor components. Any covariate that is expected to have large effects on many methylation sites should be included, including covariates that may be correlated with the cell type composition (e.g., age and sex).
% (4) k_refactor - the parameter k for the calculation of the ReFACTor components (the number of assumed cell types; for more information see the documentation of ReFACTor at: glint-epigenetics.readthedocs.io).
% (5) d - the number of ReFACTor components to use (typically can be the same as k_refactor, however, when the cell type composition information spans over more PCs, increasing d is expected to improve the resutls).
% (6) t - the number of sites to use in the optimization (the top t sites selected by ReFACTor are considered; for more information see the documentation of ReFACTor at: glint-epigenetics.readthedocs.io).
% (7) alpha - a column vector with k values (the number of assumed cell types), each corresponding to one parameter of the Dirichlet prior on the cell proportions. Note that k=length(alpha) (i.e. the number of assumed cell types)
%       Alternatively, alpha can be a k times n matrix, in which case each individual gets their own prior (can be used, for example, for providing different priors to different populations in the sample such as cases and controls).
%
% BayesCCE impute (OPTIONAL; provide cell counts for some of the samples):
% (8) R_reference (optional) - an n0 by k matrix of cell type proportions
% for n0 refernece individuals. Provide an empty vector if does not apply (i.e. []).
% (9) reference_indices (optional) - an n0 by 1 vector with indices of the
% reference samples in X. Provide an empty vector if does not apply (i.e. []).
%
% OUTPUT:
% (1) R_est - an n by k matrix of cell composition estimates. Each column is expected to correspond to one cell type.
% Note that the i-th column is not guaranteed to correspond to the i-th cell type as indicated by alpha, unless BayesCCE impute is used (i.e. the R_reference and reference_indices are provided).
% If BayesCCE impute is used then each estimated colum is also expected to match its corresponding cell type in scale (i.e. provide estimates in absolute values).
% Note that if R_reference is given then R_est(reference_indices,:) contain R_reference.
% (2) M_est - a t by k matrix of the estimated cell-type specific mean levels in each of the t selected sites.
% (3) beta_est - t by p matrix of the estimated effects of the model covariates on on each of the t selected sites (empy if no covariates were provided).
% (4) sites - the indices of the sites in X that were used in the optimization.

function [R_est,M_est,beta_est,sites] = bayescce(X,model_covars,refactor_covars,k_refactor,d,t,alpha,R_reference,reference_indices)

epsilon = 0.0001;   % the minimal value for R_{ih} (should be greater than zero to allow evaluation of the log(R_{ih}) values in the objective).
epsilon_sum = 0.05; % the sum of each sample's cell proportions will be in the range [1-epsilon_sum,1+epsilon_sum].
epsilon_ref = 0.01;    % cell counts (if R_reference is provided) may include measurement errors; R_{ih} will be constrained to the range [R_{ih}*(1-epsilon_ref],R_{ih}*(1+epsilon_ref)].

% Settings for the optimization
fmincon_options = optimset('fmincon');
fmincon_options = optimset('GradObj','on','Display','iter','MaxIter',5000,'MaxFunEvals',30000);
fmincon_options_given_M = optimset('GradObj','on','Display','iter','MaxIter',5000,'MaxFunEvals',30000);

if ~exist('R_reference','var')
      R_reference = [];
      reference_indices = [];
else
    assert (size(R_reference,1) == length(reference_indices));
    non_reference_indices = setdiff(1:size(X,2),reference_indices);
end

% Compute the ReFACTor components
X_adj = X;
if (~isempty(refactor_covars))
    X_adj = adjust_data(X',refactor_covars)';
end
[~,ranked_list] = refactor(X_adj,k_refactor,t,k_refactor);
sites = ranked_list(1:t);
O = X(sites,:);

if (size(alpha,2) == 1)
    alpha = repmat(alpha,1,size(O,2));
end
assert (size(alpha,2) == size(O,2));

% Set the dimensions of the problem
m = t;
n = size(O,2);
n0 = length(reference_indices);
n1 = n-n0;
C = model_covars;
p = size(C,2);
k = size(alpha,1);

M_est = [];
if (~isempty(R_reference))
    % There are cell counts for a subset of the samples; estimate M, the cell type specific methylation mean of each site in O
    M_est = zeros(size(O,1),k);
    options_lsqlin = optimset('lsqlin');
    options_lsqlin = optimset(options_lsqlin,'Display','none');
    % foreach 1<=i<=m: M_{ih} in [0,1]
    lb = zeros(k,1);
    ub = ones(k,1);
    for i = 1:m
        M_est(i,:) = lsqlin(R_reference,O(i,reference_indices)',[],[],[],[],lb,ub,[],options_lsqlin);
    end
end

% Compute the loadings and scores of the PCs of O (these are the ReFACTor components)
[L,P] = pca(zscore(O'));
L = [ones(m,1) L(:,1:(d))];
P = [ones(n,1) P(:,1:(d))];
d = d + 1;

% Set an initial point that is feasible under the constraints
xx = [mean(alpha')/n]';
s = xx'/sum(xx);
if (isempty(M_est))
    x0 = zeros(2*d*k+d*p,1);
    for h = 1:k
        x0(d*k+1+(h-1)*d) = s(h);
    end
else
   x0 = zeros(d*k+d*p,1);
    for h = 1:k
        x0(1+(h-1)*d) = s(h);
    end 
end

% Formulate the constraints of the problem
A_eq = [];
b_eq = [];

if (isempty(M_est))
    
    % No reference cell counts were provided
    A_ineq = zeros(k*(n+2*m)+n*2,length(x0));
    b_ineq = zeros(k*(n+2*m)+n*2,1);    
    for h = 1:k
        % foreach i: foreach h: R_{ih} >= 0
        A_ineq((h-1)*n+1:h*n , d*k+1+(h-1)*d:d*k+h*d) = -P;
        b_ineq((h-1)*n+1:h*n) = epsilon;
        % foreach j: foreach h: M_{jk} is in the range [0,1]
        A_ineq((k+2)*n+1+(h-1)*m:(k+2)*n+h*m, (h-1)*d+1:h*d) = -L;
        A_ineq((k+2)*n+m*k+1+(h-1)*m:(k+2)*n+m*k+h*m, (h-1)*d+1:h*d) = L;
        b_ineq((k+2)*n+1+(h-1)*m:(k+2)*n+h*m) = 0;
        b_ineq((k+2)*n+m*k+1+(h-1)*m:(k+2)*n+m*k+h*m) = 1;
    end
    % foreach i: sum_{h=1}^k R_{ih} is in the range [1-epsilon,1+epsilon]
    A_ineq(k*n+1:(k+1)*n , d*k+1:2*k*d) = repmat(P,1,k);
    A_ineq((k+1)*n+1:(k+2)*n , d*k+1:2*k*d) = repmat(-P,1,k);
    b_ineq(k*n+1:(k+1)*n) = 1+epsilon_sum;
    b_ineq((k+1)*n+1:(k+2)*n) = -(1-epsilon_sum);

else
    
    % Cell counts were provided for some of the samples; use M_est
    
    A_ineq = zeros(n1*k+2*n+n0*2*k,length(x0));
    b_ineq = zeros(n1*k+2*n+n0*2*k,1);    
    for h = 1:k
        % foreach i in n1 (non-reference): foreach h: R_{ih} >= 0
        A_ineq((h-1)*n1+1:h*n1 , 1+(h-1)*d:h*d) = -P(non_reference_indices,:);
        b_ineq((h-1)*n1+1:h*n1) = epsilon;
        % foreach i in n0 (reference): foreach h: R_{ih} in [R_{ih}*(1-epsilon_ref],R_{ih}*(1+epsilon_ref)]
        A_ineq(n1*k+(h-1)*n0+1:n1*k+h*n0 , 1+(h-1)*d:h*d) = P(reference_indices,:);
        A_ineq(n1*k+n0*k+(h-1)*n0+1:n1*k+n0*k+h*n0 , 1+(h-1)*d:h*d) = -P(reference_indices,:);
        b_ineq(n1*k+(h-1)*n0+1:n1*k+h*n0) = R_reference(:,h)*(1+epsilon_ref);
        b_ineq(n1*k+n0*k+(h-1)*n0+1:n1*k+n0*k+h*n0) = -R_reference(:,h)*(1-epsilon_ref);
    end
    % foreach i: sum_{h=1}^k R_{ih} is in the range [1-epsilon,1+epsilon]
    A_ineq(k*(n0*2+n1)+1:k*(n0*2+n1)+n , 1:k*d) = repmat(P,1,k);
    A_ineq(k*(n0*2+n1)+n+1:k*(n0*2+n1)+n*2 , 1:k*d) = repmat(-P,1,k);
    b_ineq(k*(n0*2+n1)+1:k*(n0*2+n1)+n) = 1+epsilon_sum;
    b_ineq(k*(n0*2+n1)+n+1:k*(n0*2+n1)+n*2) = -(1-epsilon_sum);
    
end

% Estimate sigma^2
sse = 0;
for i = 1:m
    [~,~,res] = regress(O(i,:)',[P C]);
    sse = sse + sum(res.^2);
end
sigma2_hat = sse./(n*m);

if (isempty(M_est))
    
    if (p ==0)
        % No covaraites were provided
        f = @(X) ecc_obj(O,L,P,reshape(X(1:(k*d)),d,k),reshape(X(k*d+1:2*k*d),d,k),reshape(X(2*k*d+1:end),d,p),alpha,sigma2_hat);
    else
        f = @(X) ecc_obj_covars(O,L,P,C,reshape(X(1:(k*d)),d,k),reshape(X(k*d+1:2*k*d),d,k),reshape(X(2*k*d+1:end),d,p),alpha,sigma2_hat);
    end
    [x,fval,exitflag,output,lamb,grad] = fmincon(f,x0,A_ineq,b_ineq,A_eq,b_eq,[],[],[],fmincon_options);
    
else
    
    if (p ==0)
        % No covaraites were provided
        f = @(X) ecc_obj_given_M(O,L,P,M_est,reshape(X(1:(k*d)),d,k),reshape(X(k*d+1:k*d+p*d),d,p),alpha,sigma2_hat);
    else
        f = @(X) ecc_obj_given_M_covars(O,L,P,M_est,reshape(X(1:(k*d)),d,k),reshape(X(k*d+1:k*d+p*d),d,p),alpha,sigma2_hat,model_covars);
    end     
    [x,fval,exitflag,output,lamb,grad] = fmincon(f,x0,A_ineq,b_ineq,A_eq,b_eq,[],[],[],fmincon_options_given_M );
    
end

beta_est = [];
if (isempty(M_est))
    A = reshape(x(1:d*k),d,k);
    V = reshape(x(d*k+1:2*k*d),d,k);
    B = reshape(x(2*k*d+1:end),d,p);
    R_est = [V'*P']';
    M_est = L*A;
    if (~isempty(B))
        beta_est = L*B;
    end
else
    V = reshape(x(1:k*d),d,k);
    B = reshape(x(k*d+1:end),d,p);
    R_est = [V'*P']';
    % Use the known cell counts for the reference samples
    R_est(reference_indices,:) = R_reference;
    if (~isempty(B))
        beta_est = L*B;
    end
    
end
    
end