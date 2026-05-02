from __future__ import annotations

from pathlib import Path

import pandas as pd


PROJECT_ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = PROJECT_ROOT / "outputs" / "tables"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def main() -> None:
    assets = pd.DataFrame(
        [
            {"asset_id": "PUMP-001", "hazard": 0.7, "exposure": 0.8, "vulnerability": 0.6},
            {"asset_id": "BRIDGE-001", "hazard": 0.5, "exposure": 0.9, "vulnerability": 0.7},
            {"asset_id": "SUBSTATION-001", "hazard": 0.4, "exposure": 0.95, "vulnerability": 0.5},
        ]
    )

    assets["risk_index"] = assets["hazard"] * assets["exposure"] * assets["vulnerability"]
    assets.to_csv(OUTPUT_DIR / "geospatial_asset_risk_summary.csv", index=False)

    print(assets)


if __name__ == "__main__":
    main()
