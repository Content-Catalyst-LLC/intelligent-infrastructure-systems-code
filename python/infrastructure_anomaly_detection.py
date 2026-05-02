from __future__ import annotations

import pandas as pd


def rolling_anomaly_score(values: pd.Series, window: int = 3) -> pd.Series:
    rolling_mean = values.rolling(window=window, min_periods=1).mean()
    rolling_std = values.rolling(window=window, min_periods=1).std().fillna(0.0)
    return (values - rolling_mean) / rolling_std.replace(0.0, 1.0)


def main() -> None:
    values = pd.Series([0.8, 0.82, 0.81, 1.42, 1.55, 0.9])
    print(rolling_anomaly_score(values))


if __name__ == "__main__":
    main()
