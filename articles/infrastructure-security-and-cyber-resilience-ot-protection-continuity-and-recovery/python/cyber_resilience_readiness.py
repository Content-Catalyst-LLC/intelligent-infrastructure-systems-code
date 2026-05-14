from __future__ import annotations

from pathlib import Path
import pandas as pd

ARTICLE_DIR = Path(__file__).resolve().parents[1]
DATA_DIR = ARTICLE_DIR / "data"
OUTPUT_DIR = ARTICLE_DIR / "outputs"
OUTPUT_DIR.mkdir(exist_ok=True)

KPI_PATH = DATA_DIR / "cyber_resilience_kpis.csv"
ASSET_PATH = DATA_DIR / "cyber_asset_register.csv"
CONTROL_PATH = DATA_DIR / "cyber_control_baseline.csv"
SCENARIO_PATH = DATA_DIR / "cyber_incident_scenario_manifest.csv"
VENDOR_PATH = DATA_DIR / "vendor_risk_register.csv"
CONTINUITY_PATH = DATA_DIR / "continuity_recovery_log.csv"


def as_bool(value) -> bool:
    if isinstance(value, bool):
        return value
    return str(value).strip().lower() in {"true", "1", "yes", "y"}


def resilience_quality(row: pd.Series) -> float:
    return (
        0.14 * row["asset_visibility"]
        + 0.14 * row["identity_governance"]
        + 0.15 * row["control_effectiveness"]
        + 0.14 * row["detection_capability"]
        + 0.13 * row["containment_readiness"]
        + 0.15 * row["recovery_readiness"]
        + 0.15 * row["governance_readiness"]
    )


def classify_review(row: pd.Series) -> str:
    if as_bool(row["high_criticality"]) and row["continuity_readiness"] < 0.65:
        return "urgent_continuity_review"
    if as_bool(row["high_criticality"]) and row["recovery_readiness"] < 0.65:
        return "urgent_recovery_review"
    if row["identity_governance"] < 0.65:
        return "identity_access_review"
    if row["detection_capability"] < 0.65:
        return "detection_monitoring_review"
    if row["residual_exposure"] > 0.30:
        return "residual_exposure_review"
    if row["resilience_quality"] < 0.70:
        return "cyber_resilience_review"
    return "routine_monitoring"


def main() -> None:
    readiness = pd.read_csv(KPI_PATH)
    readiness["raw_exposure"] = readiness["exposure"] * readiness["vulnerability"]
    readiness["residual_exposure"] = readiness["raw_exposure"] * (1 - readiness["control_effectiveness"])
    readiness["resilience_quality"] = readiness.apply(resilience_quality, axis=1)
    readiness["review_priority"] = readiness.apply(classify_review, axis=1)
    readiness = readiness.round(3).sort_values(["review_priority", "residual_exposure"], ascending=[True, False])

    readiness_output = OUTPUT_DIR / "cyber_resilience_readiness.csv"
    readiness.to_csv(readiness_output, index=False)

    sector_summary = (
        readiness.groupby("sector", dropna=False)
        .agg(
            systems=("system_id", "count"),
            mean_residual_exposure=("residual_exposure", "mean"),
            mean_resilience_quality=("resilience_quality", "mean"),
            mean_recovery=("recovery_readiness", "mean"),
            mean_continuity=("continuity_readiness", "mean"),
            review_items=("review_priority", lambda s: int((s != "routine_monitoring").sum())),
        )
        .reset_index()
        .round(3)
        .sort_values(["review_items", "mean_resilience_quality"], ascending=[False, True])
    )

    sector_output = OUTPUT_DIR / "cyber_resilience_sector_summary.csv"
    sector_summary.to_csv(sector_output, index=False)

    controls = pd.read_csv(CONTROL_PATH)
    control_summary = (
        controls.groupby(["system_id", "implementation_status"], dropna=False)
        .agg(
            controls=("control_id", "count"),
            mean_control_effectiveness=("control_effectiveness", "mean"),
        )
        .reset_index()
        .round(3)
        .sort_values(["implementation_status", "mean_control_effectiveness"])
    )
    control_output = OUTPUT_DIR / "cyber_control_baseline_summary.csv"
    control_summary.to_csv(control_output, index=False)

    scenarios = pd.read_csv(SCENARIO_PATH)
    scenario_summary = (
        scenarios.groupby(["system_id", "status"], dropna=False)
        .agg(
            scenarios=("scenario_id", "count"),
            max_recovery_objective_hours=("recovery_objective_hours", "max"),
            max_detection_objective_minutes=("detection_objective_minutes", "max"),
        )
        .reset_index()
        .sort_values(["status", "max_recovery_objective_hours"], ascending=[False, False])
    )
    scenario_output = OUTPUT_DIR / "cyber_incident_scenario_summary.csv"
    scenario_summary.to_csv(scenario_output, index=False)

    vendors = pd.read_csv(VENDOR_PATH)
    vendor_watchlist = vendors[
        (vendors["review_status"] != "current") |
        (vendors["concentration_risk"].isin(["high"]))
    ].sort_values(["review_status", "concentration_risk"], ascending=[False, True])
    vendor_output = OUTPUT_DIR / "vendor_risk_watchlist.csv"
    vendor_watchlist.to_csv(vendor_output, index=False)

    continuity = pd.read_csv(CONTINUITY_PATH)
    continuity_watchlist = continuity[
        (continuity["backup_test_status"] != "current") |
        (continuity["manual_operation_status"] != "current") |
        (continuity["public_communication_status"] != "current")
    ]
    continuity_output = OUTPUT_DIR / "continuity_recovery_watchlist.csv"
    continuity_watchlist.to_csv(continuity_output, index=False)

    governance_watchlist = readiness[readiness["review_priority"] != "routine_monitoring"]
    watchlist_output = OUTPUT_DIR / "cyber_governance_watchlist.csv"
    governance_watchlist.to_csv(watchlist_output, index=False)

    print("Cyber resilience readiness:")
    print(readiness.to_string(index=False))
    print(f"\nWrote: {readiness_output}")

    print("\nSector summary:")
    print(sector_summary.to_string(index=False))
    print(f"\nWrote: {sector_output}")

    print("\nControl summary:")
    print(control_summary.to_string(index=False))
    print(f"\nWrote: {control_output}")

    print("\nVendor risk watchlist:")
    print(vendor_watchlist.to_string(index=False))
    print(f"\nWrote: {vendor_output}")

    print("\nContinuity recovery watchlist:")
    print(continuity_watchlist.to_string(index=False))
    print(f"\nWrote: {continuity_output}")

    print("\nGovernance watchlist:")
    print(governance_watchlist.to_string(index=False))
    print(f"\nWrote: {watchlist_output}")


if __name__ == "__main__":
    main()
