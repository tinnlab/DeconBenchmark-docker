Data used for testing new Docker images.

The `bone-marrow.h5` file is written by `DeconBenchmark:::.writeArgs` using data from `bone-marrow.rds` file and has the following structure:

```
                 group                           name       otype  dclass         dim
0                    /                           bulk   H5I_GROUP                    
1                /bulk                       colnames H5I_DATASET  STRING         100
2                /bulk                       rownames H5I_DATASET  STRING        2291
3                /bulk                         values H5I_DATASET   FLOAT  2291 x 100
4                    /                   cellTypeExpr   H5I_GROUP                    
5        /cellTypeExpr                       colnames H5I_DATASET  STRING           8
6        /cellTypeExpr                       rownames H5I_DATASET  STRING        2291
7        /cellTypeExpr                         values H5I_DATASET   FLOAT    2291 x 8
8                    /                  isMethylation   H5I_GROUP                    
9       /isMethylation                         values H5I_DATASET INTEGER           1
10                   /                        markers   H5I_GROUP                    
11            /markers                          names H5I_DATASET  STRING           8
12            /markers                         values   H5I_GROUP                    
13     /markers/values CD4_positive_alpha_beta_T_cell H5I_DATASET  STRING          17
14     /markers/values CD8_positive_alpha_beta_T_cell H5I_DATASET  STRING          12
15     /markers/values      erythroid_progenitor_cell H5I_DATASET  STRING         200
16     /markers/values                    granulocyte H5I_DATASET  STRING          18
17     /markers/values        hematopoietic_stem_cell H5I_DATASET  STRING          62
18     /markers/values               mature_NK_T_cell H5I_DATASET  STRING          29
19     /markers/values                   naive_B_cell H5I_DATASET  STRING          11
20     /markers/values                    plasma_cell H5I_DATASET  STRING         200
21                   /                     nCellTypes   H5I_GROUP                    
22         /nCellTypes                         values H5I_DATASET INTEGER           1
23                   /                           seed   H5I_GROUP                    
24               /seed                         values H5I_DATASET   FLOAT           1
25                   /                       sigGenes   H5I_GROUP                    
26           /sigGenes                         values H5I_DATASET  STRING         549
27                   /                      signature   H5I_GROUP                    
28          /signature                       colnames H5I_DATASET  STRING           8
29          /signature                       rownames H5I_DATASET  STRING         549
30          /signature                         values H5I_DATASET   FLOAT     549 x 8
31                   /                 singleCellExpr   H5I_GROUP                    
32     /singleCellExpr                       colnames H5I_DATASET  STRING        1194
33     /singleCellExpr                       rownames H5I_DATASET  STRING        2291
34     /singleCellExpr                         values H5I_DATASET   FLOAT 2291 x 1194
35                   /               singleCellLabels   H5I_GROUP                    
36   /singleCellLabels                         values H5I_DATASET  STRING        1194
37                   /             singleCellSubjects   H5I_GROUP                    
38 /singleCellSubjects                         values H5I_DATASET  STRING        1194
```