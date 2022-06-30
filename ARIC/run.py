import DeconUtils
args = DeconUtils.getArgs(['bulk', 'cellTypeExpr', 'isMethylation'])

from ARIC import *
import pandas as pd
import tempfile
import os

args['bulk'].to_csv("bulk.csv")
args['cellTypeExpr'].to_csv("signature.csv")

result_file = tempfile.NamedTemporaryFile().name
ARIC("bulk.csv", "signature.csv", save_path=result_file, is_methylation=(args['isMethylation'] == 1).any())
P = pd.read_csv(result_file, header=0, index_col=0)

DeconUtils.writeH5(None, P.T, "ARIC")
os.unlink(result_file)