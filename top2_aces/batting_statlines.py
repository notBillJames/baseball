from collections import namedtuple

import pandas as pd
import numpy as np

ColFunction = namedtuple('StatFunction', 'name func')


PA_lambda = lambda row: row.AB + row.BB + row.HBP + row.SH + row.SF
OBP_lambda = lambda row: (row.H + row.BB + row.HBP) / (row.PA) if row.PA > 0 else np.NaN
AVG_lambda = lambda row: row.H / row.AB if row.AB > 0 else np.NaN
SLG_lambda = lambda row: (row.H + row['2B'] + 2 * row['3B'] + 3 * row.HR) / row.AB if row.AB > 0 else np.NaN
OPS_lambda = lambda row: row.SLG + row.OBP

stat_functions = [
    ColFunction(name='PA', func=PA_lambda),
    ColFunction(name='OBP', func=OBP_lambda),
    ColFunction(name='AVG', func=AVG_lambda),
    ColFunction(name='SLG', func=SLG_lambda),
    ColFunction(name='OPS', func=OPS_lambda)
]

def format_df(df):
    for func in stat_functions:
        df[func.name] = df.apply(func.func, axis=1)

def order_by(df, sort_column, ascending):
    df_copy = df.copy()
    df_copy.sort_values(by=sort_column, inplace=True, ascending=ascending)
    df_copy.reset_index(drop=True, inplace=True)
    return df_copy

