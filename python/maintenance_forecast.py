from __future__ import annotations

import pandas as pd


def main() -> None:
    assets = pd.DataFrame(
        [
            {"asset_id": "PUMP-001", "risk_index": 0.34},
            {"asset_id": "BRIDGE-001", "risk_index": 0.32},
            {"asset_id": "SUBSTATION-001", "risk_index": 0.19},
        ]
    )

    assets["maintenance_priority"] = assets["risk_index"].rank(ascending=False)
    print(assets)


if __name__ == "__main__":
    main()
