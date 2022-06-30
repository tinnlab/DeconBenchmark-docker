#!/bin/sh
set -e

LIC_FILE=/licenses/license.lic
if test -f "$LIC_FILE"; then
    export MLM_LICENSE_FILE=/licenses/license.lic
fi

tmp_dir=$(mktemp -d -t ci-XXXXXXXXXX)
cd "$tmp_dir"

python3.7 -c "$(cat <<EOF
import DeconUtils
args = DeconUtils.getArgs(['bulk', 'singleCellExpr', 'singleCellLabels', 'singleCellSubjects'])

import pandas as pd
import numpy as np

pDataC = pd.DataFrame({
    'cellID': args['singleCellExpr'].columns,
    'cellType': args['singleCellLabels'],
    'sampleID': args['singleCellSubjects']
})

args['bulk'].to_csv('bulk.csv', sep = "\t")
args['singleCellExpr'].to_csv('singleCellExpr.csv', sep = "\t")
pDataC.to_csv('pDataC.csv', sep = "\t")

EOF
)"

mkdir "$tmp_dir"/lambda/
cd /code/Package/DecOT/DecOT

#dissTOM causes errors, use euclidean
python3.7 DecOT.py --y "$tmp_dir"/bulk.csv --c "$tmp_dir"/singleCellExpr.csv --pDataC "$tmp_dir"/pDataC.csv --metric correlation -gamma 0.001 -rho 0.001 --save_path "$tmp_dir" --ground_cost_path "$tmp_dir"/ground_cost

cd "$tmp_dir"
python3 -c "$(cat <<EOF
import DeconUtils
import pandas as pd
import numpy as np

args = DeconUtils.getArgs(['bulk', 'singleCellLabels'])

P = pd.read_csv("./lambda/lambda_decot_correlation.txt", sep=" ", header=None, index_col=None).T
D = pd.read_csv("./lambda/D.csv")

P.index = args['bulk'].columns.values
P.columns = D.columns.values[1:]

DeconUtils.writeH5(None, P, "DecOT")

EOF
)"