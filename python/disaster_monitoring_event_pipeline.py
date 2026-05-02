from __future__ import annotations

import pandas as pd


def main() -> None:
    events = pd.DataFrame(
        [
            {"event_id": "EVT-001", "event_type": "flood", "severity": "high", "asset_id": "FLOOD-GAUGE-001"},
            {"event_id": "EVT-002", "event_type": "storm", "severity": "medium", "asset_id": "BRIDGE-001"},
        ]
    )

    print(events)


if __name__ == "__main__":
    main()
