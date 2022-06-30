Original code: https://github.com/lihuamei/DeconPeaker

DeconPeaker
===================================================

`DeconPeaker`: a deconvolution method to estimate cell type proportions in chromatin accessibility data (ATAC-Seq), as well as gene expression data (RNA-Seq & Microarray).
![DeconPeaker\_pipeline](pipeline.png)

How to use `DeconPeaker`?
---------------------
DeconPeaker's code is a mix of Python3.8 and R(4.0), which requires the following dependencies.
* Python3.8:
	* Numpy
	* Scipy
	* Pandas
	* bx
	* Matplotlib
	* rpy2
* R4.0:
	* pls
	* transport
	* colorRamps
	* MASS
* Other tools (when excute preprocess and simulation steps):
	* bedtools
	* samtools
	* featureCounts

-------------------
It is necessary to mention that there are four parts in DeconPeaker, and details as follows:
* preprocess: only supports on Linux system
* findctsps: supports on Windows and Linux systems
* deconvolution: supports on Windows and Linux systems
* simulation: only supports on Linux system

More Information
--------------------
Please see [Tutorial](https://lihuamei.github.io//DeconPeaker/test/DeconPeak_demo.html).

Citation
---------------------
Please cite the publication: ***Li H, Sharma A, Luo K, et al. DeconPeaker, a deconvolution model to identify cell types based on chromatin accessibility in ATAC-Seq data of mixture samples[J]. Frontiers in genetics, 2020, 11: 392.***<br>
