import DeconUtils
args = DeconUtils.getArgs(['bulk', 'singleCellExpr', 'singleCellLabels'])

import pandas as pd
import numpy as np
from rnasieve.preprocessing import model_from_raw_counts


counts = dict()
for label in args['singleCellLabels'].unique():
    counts[label] = args['singleCellExpr'].loc[:, (args['singleCellLabels'] == label).values].values #needs counts data

model, cleaned_psis = model_from_raw_counts(counts, args['bulk'].values)

P = model.predict(cleaned_psis)
P.index = args['bulk'].columns

DeconUtils.writeH5(None, P, "RNA-Sieve")