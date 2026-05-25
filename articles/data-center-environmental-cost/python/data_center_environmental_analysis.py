#!/usr/bin/env python3
"""
Data center environmental analysis with synthetic data.

This script computes:
- PUE
- WUE
- operational emissions
- water stress and AI workload flags
- renewable mismatch proxy
- facility-level infrastructure risk category
"""

from pathlib import Path
import pandas as pd
import numpy as np

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data" / "raw" / "data_center_environmental_synthetic.csv"
OUT = ROOT / "outputs" / "tables" / "data_center_environmental_summary.csv"
PROCESSED = ROOT / "data" / "processed" / "data_center_environmental_scored.csv"

def classify_risk(row: pd.Series) -> str:
    score = 0
    if row["pue"] > 1.25:
        score += 1
    if row["wue_l_per_kwh_it"] > 1.0:
        score += 1
    if row["water_stress_level"] == "high":
        score += 1
    if row["ai_workload_share"] >= 0.50:
        score += 1
    if row["renewable_hourly_match_share"] < 0.50:
        score += 1
    if row["operational_emissions_tco2e"] > 250000:
        score += 1

    if score >= 4:
        return "high"
    if score >= 2:
        return "medium"
    return "lower"

def main() -> None:
    df = pd.read_csv(DATA)

    df["pue"] = df["total_facility_energy_mwh"] / df["it_energy_mwh"]

    # WUE in liters per kWh of IT energy.
    # 1 m3 = 1000 liters, 1 MWh = 1000 kWh.
    df["wue_l_per_kwh_it"] = (
        df["water_consumption_m3"] * 1000
    ) / (
        df["it_energy_mwh"] * 1000
    )

    df["operational_emissions_tco2e"] = (
        df["total_facility_energy_mwh"]
        * df["grid_carbon_intensity_kgco2e_mwh"]
        / 1000
    )

    df["renewable_mismatch_share"] = 1 - df["renewable_hourly_match_share"]
    df["high_ai_workload"] = df["ai_workload_share"] >= 0.50
    df["high_water_stress_flag"] = df["water_stress_level"] == "high"

    df["environmental_risk_category"] = df.apply(classify_risk, axis=1)

    summary_columns = [
        "facility_id",
        "region",
        "facility_type",
        "pue",
        "wue_l_per_kwh_it",
        "operational_emissions_tco2e",
        "ai_workload_share",
        "peak_load_mw",
        "renewable_hourly_match_share",
        "water_stress_level",
        "environmental_risk_category",
    ]

    OUT.parent.mkdir(parents=True, exist_ok=True)
    PROCESSED.parent.mkdir(parents=True, exist_ok=True)

    df.to_csv(PROCESSED, index=False)
    df[summary_columns].to_csv(OUT, index=False)

    print("Data center environmental summary written to:")
    print(OUT)
    print()
    print(df[summary_columns].to_string(index=False))

if __name__ == "__main__":
    main()
