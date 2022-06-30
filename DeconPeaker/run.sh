#!/bin/sh
set -e

tmp_dir=$(mktemp -d -t ci-XXXXXXXXXX)
cd "$tmp_dir"

python3 -c "$(cat <<EOF
import DeconUtils
args = DeconUtils.getArgs(['bulk', 'signature'])

import numpy as np
import pandas as pd

args['bulk'].to_csv("bulk.txt", sep="\t")
args['signature'].to_csv("signature.txt", sep="\t")

EOF
)"

cd /code/DeconPeaker
python3 deconPeaker.py deconvolution --lib-strategy=RNA-Seq --mixture="$tmp_dir"/bulk.txt --pure="$tmp_dir"/signature.txt --format=TABLE --pvalue=FALSE --outdir="$tmp_dir"

cd "$tmp_dir"
python3 -c "$(cat <<EOF
import DeconUtils
import pandas as pd

args = DeconUtils.getArgs(['singleCellLabels'])

P = pd.read_csv("./deconvolution/deconPeaker-Results.xls", sep='\t', header=0, index_col=0)

DeconUtils.writeH5(None, P.loc[:, args['singleCellLabels'].unique()], "DeconPeaker")

EOF
)"