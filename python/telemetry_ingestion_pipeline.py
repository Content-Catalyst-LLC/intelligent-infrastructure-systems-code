from __future__ import annotations

import sqlite3
from pathlib import Path

import pandas as pd


PROJECT_ROOT = Path(__file__).resolve().parents[1]
DATA_DIR = PROJECT_ROOT / "data" / "processed"
OUTPUT_DIR = PROJECT_ROOT / "outputs" / "tables"
DATABASE_PATH = PROJECT_ROOT / "outputs" / "intelligent_infrastructure.sqlite"

DATA_DIR.mkdir(parents=True, exist_ok=True)
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
DATABASE_PATH.parent.mkdir(parents=True, exist_ok=True)


def create_synthetic_telemetry() -> pd.DataFrame:
    return pd.DataFrame(
        [
            {"asset_id": "PUMP-001", "sector": "water", "sensor_type": "vibration", "observed_value": 0.81, "battery_voltage": 3.71, "signal_quality": 0.93, "communication_mode": "lorawan", "observed_at": "2026-04-01T10:00:00"},
            {"asset_id": "PUMP-001", "sector": "water", "sensor_type": "vibration", "observed_value": 1.42, "battery_voltage": 3.68, "signal_quality": 0.87, "communication_mode": "lorawan", "observed_at": "2026-04-01T10:05:00"},
            {"asset_id": "BRIDGE-001", "sector": "transportation", "sensor_type": "strain", "observed_value": 12.5, "battery_voltage": 3.82, "signal_quality": 0.91, "communication_mode": "cellular", "observed_at": "2026-04-01T10:00:00"},
            {"asset_id": "SUBSTATION-001", "sector": "energy", "sensor_type": "temperature", "observed_value": 41.2, "battery_voltage": 4.02, "signal_quality": 0.96, "communication_mode": "ethernet", "observed_at": "2026-04-01T10:00:00"},
            {"asset_id": "FLOOD-GAUGE-001", "sector": "disaster_monitoring", "sensor_type": "water_level", "observed_value": None, "battery_voltage": 3.45, "signal_quality": 0.74, "communication_mode": "lpwan", "observed_at": "2026-04-01T10:00:00"},
        ]
    )


def calculate_quality_report(df: pd.DataFrame) -> pd.DataFrame:
    valid_records = (
        df["observed_value"].notna()
        & (df["battery_voltage"] >= 3.3)
        & (df["signal_quality"] >= 0.80)
    )

    return pd.DataFrame(
        [
            {
                "record_count": len(df),
                "missing_observed_values": int(df["observed_value"].isna().sum()),
                "mean_battery_voltage": float(df["battery_voltage"].mean()),
                "mean_signal_quality": float(df["signal_quality"].mean()),
                "valid_records": int(valid_records.sum()),
                "valid_record_rate": float(valid_records.mean()),
            }
        ]
    )


def main() -> None:
    telemetry = create_synthetic_telemetry()
    telemetry["observed_at"] = pd.to_datetime(telemetry["observed_at"])

    quality_report = calculate_quality_report(telemetry)

    telemetry_path = DATA_DIR / "infrastructure_telemetry.csv"
    report_path = OUTPUT_DIR / "infrastructure_telemetry_quality_report.csv"

    telemetry.to_csv(telemetry_path, index=False)
    quality_report.to_csv(report_path, index=False)

    with sqlite3.connect(DATABASE_PATH) as connection:
        telemetry.to_sql("infrastructure_telemetry", connection, if_exists="replace", index=False)
        quality_report.to_sql("infrastructure_telemetry_quality_report", connection, if_exists="replace", index=False)

    print("Infrastructure Telemetry Quality Pipeline complete.")
    print(quality_report)


if __name__ == "__main__":
    main()
