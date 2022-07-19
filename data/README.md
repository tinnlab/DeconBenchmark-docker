Data used for testing new Docker images.

The `Bone_Marrow.h5` file is written by `DeconBenchmark::.writeArgs` using data from `Bone_Marrow.rds` file and has the following structure:

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
8                    /                        markers   H5I_GROUP                    
9             /markers                          names H5I_DATASET  STRING           8
10            /markers                         values   H5I_GROUP                    
11     /markers/values CD4_positive_alpha_beta_T_cell H5I_DATASET  STRING          17
12     /markers/values CD8_positive_alpha_beta_T_cell H5I_DATASET  STRING          12
13     /markers/values      erythroid_progenitor_cell H5I_DATASET  STRING         200
14     /markers/values                    granulocyte H5I_DATASET  STRING          18
15     /markers/values        hematopoietic_stem_cell H5I_DATASET  STRING          62
16     /markers/values               mature_NK_T_cell H5I_DATASET  STRING          29
17     /markers/values                   naive_B_cell H5I_DATASET  STRING          11
18     /markers/values                    plasma_cell H5I_DATASET  STRING         200
19                   /                     nCellTypes   H5I_GROUP                    
20         /nCellTypes                         values H5I_DATASET INTEGER           1
21                   /                           seed   H5I_GROUP                    
22               /seed                         values H5I_DATASET   FLOAT           1
23                   /                       sigGenes   H5I_GROUP                    
24           /sigGenes                         values H5I_DATASET  STRING         549
25                   /                      signature   H5I_GROUP                    
26          /signature                       colnames H5I_DATASET  STRING           8
27          /signature                       rownames H5I_DATASET  STRING         549
28          /signature                         values H5I_DATASET   FLOAT     549 x 8
29                   /                 singleCellExpr   H5I_GROUP                    
30     /singleCellExpr                       colnames H5I_DATASET  STRING        1194
31     /singleCellExpr                       rownames H5I_DATASET  STRING        2291
32     /singleCellExpr                         values H5I_DATASET   FLOAT 2291 x 1194
33                   /               singleCellLabels   H5I_GROUP                    
34   /singleCellLabels                         values H5I_DATASET  STRING        1194
35                   /             singleCellSubjects   H5I_GROUP                    
36 /singleCellSubjects                         values H5I_DATASET  STRING        1194
```