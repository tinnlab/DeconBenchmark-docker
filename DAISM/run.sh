#!/bin/sh

tmp_dir=$(mktemp -d -t ci-XXXXXXXXXX)
cd "$tmp_dir"

python3 -c "$(cat <<EOF
import DeconUtils
args = DeconUtils.getArgs(['bulk', 'singleCellExpr', 'singleCellLabels'])

import numpy as np
import pandas as pd

#count data
args['bulk'].to_csv("bulk.txt", sep="\t")
args['singleCellExpr'].to_csv("singleCellExpr.txt", sep="\t")
pd.DataFrame({'sample.name': args['singleCellExpr'].columns.values, 'cell.type': args['singleCellLabels'].values}).to_csv("singleCellLabels.txt", index=False)

EOF
)"

python3 /code/create_h5ad.py -anno singleCellLabels.txt -exp singleCellExpr.txt -outdir ./
#daism Generic_simulation -platform S -aug ./purified.h5ad -N 16000 -testexp ./bulk.txt -outdir ./
daism Generic_simulation -platform S -aug ./purified.h5ad -N 4800 -testexp ./bulk.txt -outdir ./ #for more reasonable running time, need to be divided by 64
daism training -trainexp ./output/Generic_mixsam.txt -trainfra ./output/Generic_mixfra.txt -outdir ./
daism prediction -testexp ./bulk.txt -model ./output/DAISM_model.pkl -celltype ./output/DAISM_model_celltypes.txt -feature ./output/DAISM_model_feature.txt -outdir ./

python3 -c "$(cat <<EOF
import DeconUtils
import pandas as pd

P = pd.read_csv("./output/DAISM_result.txt", sep='\t', header=0, index_col=0)

DeconUtils.writeH5(None, P.T, "DAISM")

EOF
)"