Original code is at: https://github.com/cozygene/BayesCCE

# BayesCCE

Bayesian Cell Count Estimation (BayesCCE) is a semi-supervised method for estimating cell counts (cell type proportions) from array-probed DNA methylation data collected from heterogeneous source.

BayesCCE does not require reference of methylation levels from sorted cell types, but rather an easier-to-obtain prior information on the distribution of the cell type proportions in the studied tissue. Such a prior information can be obtained from cell counts that were previously collected from the studied tissue (no need for corresponding methylation levels or any other genomic information). An extension of the method, BayesCCE impute, allows a considerable improvement in performance if cell counts are provided for a subset of the samples in the data (even as few as a couple of dozens of samples).

Here, we provide a Matlab implementation of the method (implemented and tested using Matlab 2015b).

## Usage

A full documentation of the input and output arguments is provided in the main function file (bayescce.m).

For data preparation, it is advised to follow the recommendations for applying ReFACTor (<a href="http://www.nature.com/nmeth/journal/vaop/ncurrent/full/nmeth.3809.html" target="_blank">Rahmani et al.</a>): exclude sites with extremely low variability and exclude polymorphic and cross-reactive sites, as well as sites coming from the sex chromosomes.
The full set of data preparation recommendations for ReFACTor can be found under "Tissue heterogeneity" in the documentation of the <a href="http://glint-epigenetics.readthedocs.io" target="_blank">GLINT toolset</a> for DNA methylation analysis.

For estimating the Dirichlet prior, it is advised to use the <a href="https://github.com/tminka/fastfit" target="_blank">Fastfit package</a> by <a href="https://tminka.github.io/papers/dirichlet/minka-dirichlet.pdf" target="_blank">Thomas P. Minka</a>.

  
### Citing BayesCCE

If you use BayesCCE in any published work, please cite the manuscript describing the method:

Elior Rahmani, Regev Schweiger, Liat Shenhav, Theodora Wingert, Ira Hofer, Eilon Gabel, Eleazar Eskin and Eran Halperin: BayesCCE: a Bayesian framework for estimating cell-type composition from DNA methylation without the need for methylation reference, *Genome Biology*, 2018.

### License

BayesCCE is available under the <a href="https://opensource.org/licenses/GPL-3.0" target="_blank">GPL-3 license</a>.

### Author

This software was developed by Elior Rahmani.





