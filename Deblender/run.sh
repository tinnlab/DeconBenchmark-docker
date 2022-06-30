#!/bin/sh
set -e

LIC_FILE=/licenses/license.lic
if test -f "$LIC_FILE"; then
    export MLM_LICENSE_FILE=/licenses/license.lic
fi

tmp_dir=$(mktemp -d -t ci-XXXXXXXXXX)
cd "$tmp_dir"

python3 -c "$(cat <<EOF
import DeconUtils
args = DeconUtils.getArgs(['bulk', 'nCellTypes', 'markers'])

import numpy as np
import pandas as pd

args['bulk'] = args['bulk'] + 1e-4

#marker_genes = np.concatenate([args['markers'][k] for k in args['markers'].keys()])
#marker_genes = np.array([x.decode('UTF-8') + 'ds' for x in marker_genes])
#marker_cell_type_index = np.concatenate([ np.repeat(i+1, len(args['markers'][k])) for i, k in enumerate(args['markers'].keys()) ])

args['bulk'].to_csv("bulk.txt", index=False, header=False)
pd.DataFrame({'values': args['bulk'].index.values}) .to_csv("genes.txt", index=False, header=True)
args['nCellTypes'].to_csv("nCellTypes.txt", index=False, header=False)
#pd.DataFrame({'values': marker_genes}) .to_csv("markers.txt", index=False, header=True)
#pd.DataFrame({'values': marker_cell_type_index.astype(int)}).to_csv("marker_cell_type_index.txt", index=False, header=True)

EOF
)"

cd /code/source
matlab -nodisplay -nodesktop -nosoftwareopengl -nojvm -batch "run('$tmp_dir')"

cd "$tmp_dir"

python3 -c "$(cat <<EOF
import DeconUtils
import pandas as pd
import numpy as np

args = DeconUtils.getArgs(['bulk', 'nCellTypes'])

P = pd.read_csv("P.csv", header=None, index_col=None)
S = pd.read_csv("S.csv", header=None, index_col=None)

P.index = args['bulk'].columns.values
S.index = args['bulk'].index

P.columns = S.columns = ["CellType" + str(i) for i in np.arange(args['nCellTypes'].values[0]).astype(int)]

DeconUtils.writeH5(S, P, "Deblender")

EOF
)"