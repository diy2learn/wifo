import pytest
from wifo import dataset


class TestDataInfo(object):
    def test_data_info(self, moc_ts_dataframe):
        assert dataset.data_info(moc_ts_dataframe) is not None
