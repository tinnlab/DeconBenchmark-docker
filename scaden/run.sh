#!/bin/sh

tmp_dir=$(mktemp -d -t ci-XXXXXXXXXX)
cd "$tmp_dir"

python3 -c "$(cat <<EOF
import DeconUtils
args = DeconUtils.getArgs(['bulk', 'singleCellExpr', 'singleCellLabels'])

import numpy as np


#count data
(args['bulk']).round().astype(int).to_csv("bulk.txt", sep="\t")
singleCellCounts = (args['singleCellExpr']).round().astype(int).transpose()
singleCellCounts.index = np.arange(0, len(singleCellCounts.index))
singleCellCounts.to_csv("singleCell_counts.txt", sep="\t")
args['singleCellLabels'].to_frame('Celltype').to_csv("singleCell_celltypes.txt", sep="\t", index=False)

EOF
)"

scaden simulate --data ./ -n 100 --pattern "*_counts.txt"
scaden process data.h5ad bulk.txt
scaden train processed.h5ad --steps 5000 --model_dir model
scaden predict --model_dir model bulk.txt

python3 -c "$(cat <<EOF
import DeconUtils
import pandas as pd

P = pd.read_csv("scaden_predictions.txt", sep='\t', header=0, index_col=0)

DeconUtils.writeH5(None, P, "scaden")

EOF
)"