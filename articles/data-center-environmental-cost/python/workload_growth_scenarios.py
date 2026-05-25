#!/usr/bin/env python3
"""
Synthetic workload growth scenario analysis.

This script demonstrates the rebound problem:
efficiency improves, but total energy demand may still rise if compute demand grows faster.
"""

from pathlib import Path
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data" / "raw" / "workload_growth_scenarios_synthetic.csv"
OUT = ROOT / "outputs" / "tables" / "workload_growth_scenario_summary.csv"

def main() -> None:
    df = pd.read_csv(DATA)
    baseline = df[df["year"] == 2026][["scenario", "total_energy_index"]].rename(
        columns={"total_energy_index": "baseline_energy_index"}
    )

    df = df.merge(baseline, on="scenario", how="left")
    df["energy_growth_since_baseline_pct"] = (
        (df["total_energy_index"] / df["baseline_energy_index"] - 1) * 100
    )

    OUT.parent.mkdir(parents=True, exist_ok=True)
    df.to_csv(OUT, index=False)

    print("Workload growth scenario summary written to:")
    print(OUT)
    print()
    print(df.to_string(index=False))

if __name__ == "__main__":
    main()
