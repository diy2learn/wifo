import pytest
import pandas as pd
import numpy as np


@pytest.fixture()
def moc_ts_dataframe():
    n_cols = 3
    date_time = pd.date_range('2020-01-01','2020-01-02', freq='H')
    np.random.seed(10)
    data = np.random.randn(len(date_time), n_cols)
    col_names = [f'col_{idx}' for idx in range(n_cols)]
    df = pd.DataFrame(data=data, index=date_time, columns=col_names)
    df.index.name = 'date_time'
    return df
