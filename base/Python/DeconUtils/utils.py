import h5py
import pandas as pd
import numpy as np
import os

def getArgs(params, path="/args.h5"):
    if os.getenv("PARAMS_OUTPUT_PATH") is not None:
        paramOutputPath = os.getenv("PARAMS_OUTPUT_PATH")
        pd.DataFrame({'params': params}).to_csv(paramOutputPath, index=False)
        quit(code=999)

    f = h5py.File(path, 'r')
    dAll = dict()

    for param in params:
        d = dict(f[param])

        if isinstance(d['values'], h5py.Dataset):
            if d['values'].dtype.kind in ['f', 'i', 'S']:
                values = d['values'][:]
                if len(values.shape) == 2:
                    values = pd.DataFrame(values.T)
                    if 'rownames' in d.keys():
                        values.index = np.char.decode(d['rownames'][:])
                    if 'colnames' in d.keys():
                        values.columns = np.char.decode(d['colnames'][:])
                else:
                    if d['values'].dtype.kind in ['S']:
                        values = pd.Series(np.char.decode(values))
                    else:
                        values = pd.Series(values)
                    if 'names' in d.keys():
                        values.index = np.char.decode(d['names'][:])

        else:
            values = dict()
            for (key, value) in d['values'].items():
                values[key] = value[:]

        dAll[param] = values

    f.close()
    return dAll


def writeH5(S, P, method):
    h5file = os.getenv("OUTPUT_PATH")

    print(method + " Writing results to " + h5file)

    f = h5py.File(h5file, 'w')

    if S is not None:
        values = S.values
        rownames = S.index.values
        colnames = S.columns.values

        grp = f.create_group("S")
        grp.create_dataset("values", data=values.T)
        grp.create_dataset("rownames", data=rownames)
        grp.create_dataset("colnames", data=colnames)

    if P is not None:
        values = P.values
        rownames = P.index.values
        colnames = P.columns.values

        grp = f.create_group("P")
        grp.create_dataset("values", data=values.T)
        grp.create_dataset("rownames", data=rownames)
        grp.create_dataset("colnames", data=colnames)

    f.close()