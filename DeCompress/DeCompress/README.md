Originial code is at https://github.com/bhattacharya-a-bt/DeCompress
This version is modified to work with R version 4

# DeCompress

Welcome to `DeCompress` - a semi-reference-free method to
deconvolve targeted panels of mRNA expression
into tissue compartment. A tissue compartment is a group
of cells of similar type or biological function (i.e. immune
or stroma or tumor compartments).
Please cite 
[Bhattacharya et al 2020](https://www.biorxiv.org/content/10.1101/2020.08.14.250902v2) 
if you use our package. Visit [our documentation page](https://bhattacharya-a-bt.github.io/DeCompress/).

## Installation

You can install `DeCompress` using 
`devtools::install_github('bhattacharya-a-bt/DeCompress')`.
Make sure to have dependencies installed as well!


## Using DeCompress

`DeCompress` requires two input data matrices:
- the *target* matrix (k X n) with k genes and n samples, and
- the *reference* matrix (K X n) with K genes and N samples with
K > k.

`DeCompress` also requires *a priori* knowledge of the number of tissue
compartments. If you don't know the number of compartments you wish
to deconvolve to, you can use the `findNumberCells()` function to get
an estimate from an singular value decomposition of the target matrix.

To illustrate `DeCompress`, let's generate some fake data.
Here, `pure` is a matrix of compartment-specific expression profiles,
`reference_props` and `target_props` are different $200 \times 4$ matrices
of proportions, and `reference` and `target` gives us the input expression
matrices.

```r
pure = matrix(abs(rnorm(1e4*4)),ncol=4)
rownames(pure) = paste0('Gene',1:1e4)
reference_props = apply(matrix(abs(rnorm(200*4)),ncol=4),
        1,function(x) x/sum(x))
target_props = apply(matrix(abs(rnorm(200*4)),ncol=4),
        1,function(x) x/sum(x))

reference = pure %*% reference_props
target = pure[sample(1:1e4,400),] %*% target_props
```

### Step 1: Feature selection

Step 1 of DeCompress is to feature select a set of $K'$ genes from
the reference that are compartment-specific. 
We have a wrapper function for this:

```r
compSpec = findInformSet(yref = reference,
                         method = 'variance',
                         n_genes = 1000,
                         n.types = 4)
```

The `method = variance` option calls `TOAST` for this feature selection,
a method we have seen to be best suited for this task. The
`method = linearity` uses the `linseed` method's mutual linearity
assumption to select compartment-specific genes. `findInformSet()`
returns the reference matrix, reduced to these $K'$ genes.

### Step 2: Train the compressed sensing matrix

Step 2 of DeCompress is to train the compressed sensing
model that projects the feature space of target matrix to
the $K'$ compartment-specific genes. This is done 
with the `trainCS()` function.

```r
csModel = trainCS(yref = reference[rownames(target),],
                    yref_need = compSpec,
                    seed = 1111,
                    method = c('lar',
                               'lasso',
                               'enet',
                               'ridge',
                               'l1',
                               'TV',
                               'l2'),
                    par = T,
                    n.cores = 4,
                    lambda = .1)
```

Here, `yref` takes in the reference matrix subsetted to
the $k$ genes on the target and `yref_need` takes in the reference matrix
subsetted to the $K'$ compartment-specific genes. The `method` option
allows for various predictive models: `lar` is least angle
regression, `lasso`, `enet`, and `ridge` fits the `glmnet`
methods, and `l1`, `TV`, and `l2` are non-linear optimization
methods to different penalties (see the `R1Magic` package).
You can also parallelize by toggling `par` and setting the number
of cores to `n.cores`. `lambda` is a penalization parameter
for the non-linear methods defaulted to 0.1. The three 
`glmnet` methods are fastest and work as well as (if not better than)
the other methods.

Once the compressed sensing model is fit, the compression
matrix is extracted with `csModel$compression.matrix`
and the DeCompressed expression is calculated with 
`dcexp = expandTarget(target,csModel$compression.matrix)`.

### Step 3: Ensemble deconvolution

Step 3 of DeCompress is to run ensemble deconvolution
on the DeCompressed expression data.

```r
csModel = bestDeconvolution(yref = dcexp,
                            n.types = 4,
                            known.props = target_props,
                            methods = c('TOAST',
                                        'linseed',
                                        'celldistinguisher'))
```

Here, `yref` takes in the DeCompressed matrix with
`n.types` taking in the number of compartments.
`known.props` can be passed a proportion matrix
if that is known; if left set to `NULL`, the
function will output the deconvolution
with the smallest reconstruction error. The `method` option
allows for various deconvolution methods. Feel free to use your
favorite reference-free method to deconvolve `dcexp`.
