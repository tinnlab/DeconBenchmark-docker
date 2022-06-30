function [] = run(tmp_dir)

addpath(tmp_dir)

X = readmatrix('bulk.csv')
model_covars = ones(size(X, 2), 1)
refactor_covars = ones(size(X, 2), 1)
k_refactor = readmatrix('nCellTypes.csv')
d = k_refactor
t = 500
alpha = readmatrix('a_fit.csv')

[R_est,M_est,~,sites] = bayescce(X,model_covars,refactor_covars,k_refactor,d,t,alpha)

disp(size(R_est))
disp(size(M_est))

writematrix(R_est,strcat(tmp_dir, '/P.csv'))
writematrix(M_est,strcat(tmp_dir, '/S.csv'))
writematrix(sites,strcat(tmp_dir, '/sites.csv'))

end