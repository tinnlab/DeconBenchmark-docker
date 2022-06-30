#tutorial: https://github.com/theislab/AutoGeneS/blob/master/deconv_example/bulkDeconvolution_using_singleCellReferenceProfiles.ipynb

import DeconUtils
args = DeconUtils.getArgs(['bulk', 'cellTypeExpr'])

import numpy as np
import scipy as sci
import pandas as pd
import autogenes as ag
from sklearn.svm import NuSVR

args['bulk'] = np.log2(args['bulk'] + 1)
args['cellTypeExpr'] = np.log2(args['cellTypeExpr'] + 1)

ag.init(args['cellTypeExpr'].T)
ag.optimize(ngen=10, seed=0, offspring_size=10, verbose=False)

markers = args['cellTypeExpr'].index[ag.select(index=0)]
bulk = args["bulk"].loc[markers, :]

coef_nusvr = ag.deconvolve(bulk.T, model='nusvr')

def normalize_proportions(data,copy):
    if copy==True:
        data_copy = data.copy()
    else:
        data_copy = data
    data_copy[data_copy < 0] = 0
    for raw in data_copy.index:
        sum = data_copy.loc[raw].sum()
        data_copy.loc[raw] = np.divide(data_copy.loc[raw],sum)
    return data_copy

P = normalize_proportions(pd.DataFrame(data=coef_nusvr, columns=args['cellTypeExpr'].columns, index=bulk.columns), copy = False)

DeconUtils.writeH5(None, P, "AutoGeneS")