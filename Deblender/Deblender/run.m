function [] = run(tmp_dir)

addpath(tmp_dir)

mixed_data = readmatrix("bulk.txt")
K_source = readmatrix("nCellTypes.txt")
mixed_genes = tdfread("genes.txt").values
%%marker_genes = tdfread("markers.txt").values
%%marker_cell_type_index = tdfread("marker_cell_type_index.txt").values

low_cutoff=0.1; upper_cutoff=0.1; coef_var=0.1; clust_algo=1; log_option=1; algo_solver=1; call_NMF=0; limit_cent_neigh=0;

[A_estimated , ~, ~, ~]  = calc_A_unsupervised(mixed_genes, mixed_data, mixed_data, K_source, low_cutoff, upper_cutoff, coef_var, clust_algo, log_option, algo_solver, call_NMF, limit_cent_neigh);

%%algo_solver=1; call_NMF=0;

%%A_estimated  = calc_A_known_marker_genes(mixed_genes, mixed_data, mixed_data, marker_genes, marker_cell_type_index, algo_solver, call_NMF);

S = calculate_S(A_estimated, mixed_data, mixed_data, algo_solver)

writematrix(A_estimated, strcat(tmp_dir, "/P.csv"))
writematrix(S, strcat(tmp_dir, "/S.csv"))
end