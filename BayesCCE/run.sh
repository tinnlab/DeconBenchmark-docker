#!/bin/sh

LIC_FILE=/licenses/license.lic
if test -f "$LIC_FILE"; then
    export MLM_LICENSE_FILE=/licenses/license.lic
fi

tmp_dir=$(mktemp -d -t ci-XXXXXXXXXX)
cd "$tmp_dir"

python3 -c "$(cat <<EOF
import DeconUtils
args = DeconUtils.getArgs(['bulk', 'cellTypeExpr'])

import numpy as np
import pandas as pd
from numpy.linalg import norm
from scipy.special import psi
import dirichlet



args['bulk'] = args['bulk'] + 1e-4 # add 1e-4 to avoid log(0)
args['cellTypeExpr'] = args['cellTypeExpr'] + 1e-4 # add 1e-4 to avoid log(0)

a_fit = dirichlet.mle(args['cellTypeExpr'].values, method="meanprecision")

pd.DataFrame({'values': a_fit}).to_csv('a_fit.csv', header=False, index=False)
args['bulk'].to_csv('bulk.csv', header=False, index=False)
pd.DataFrame({'value': [args['cellTypeExpr'].shape[1]]}).to_csv('nCellTypes.csv', header=False, index=False)

EOF
)"

cd /code/source
matlab -nodisplay -nodesktop -nosoftwareopengl -nojvm -batch "run('$tmp_dir')"

cd "$tmp_dir"
python3 -c "$(cat <<EOF
import DeconUtils
import pandas as pd
import numpy as np

args = DeconUtils.getArgs(['bulk', 'cellTypeExpr'])

P = pd.read_csv("P.csv", header=None, index_col=None)
S = pd.read_csv("S.csv", header=None, index_col=None)
sites = pd.read_csv("sites.csv", header=None, index_col=None)

P.index = args['bulk'].columns.values
S.index = args['bulk'].index[sites.values[0, :]-1]

P.columns = S.columns = ["CellType" + str(i) for i in np.arange(args['cellTypeExpr'].shape[1]).astype(int)]

DeconUtils.writeH5(S, P, "BayesCCE")

EOF
)"