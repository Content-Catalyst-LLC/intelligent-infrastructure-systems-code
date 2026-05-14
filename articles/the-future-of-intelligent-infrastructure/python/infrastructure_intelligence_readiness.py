from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
import pandas as pd

ARTICLE_DIR = Path(__file__).resolve().parents[1]
DATA_DIR = ARTICLE_DIR / "data"
OUTPUT_DIR = ARTICLE_DIR / "outputs"
OUTPUT_DIR.mkdir(exist_ok=True)

KPI_PATH = DATA_DIR / "infrastructure_intelligence_kpis.csv"
ASSET_PATH = DATA_DIR / "asset_service_register.csv"
OBS_PATH = DATA_DIR / "observability_registry.csv"
CYBER_PATH = DATA_DIR / "cyber_resilience_controls.csv"
SCENARIO_PATH = DATA_DIR / "resilience_scenario_manifest.csv"


@dataclass
class ReadinessWeights:
    observability: float = 0.15
    interoperability: float = 0.13
    ai_governance: float = 0.12
    resilience_readiness: float = 0.15
    cyber_resilience: float = 0.14
    equity_readiness: float = 0.12
    public_accountability: float = 0.10
    adaptive_capacity: float = 0.09


def as_bool(value) -> bool:
    if isinstance(value, bool):
        return value
    return str(value).strip().lower() in {"true", "1", "yes", "y"}


def intelligence_quality(row: pd.Series, weights: ReadinessWeights = ReadinessWeights()) -> float:
    return (
        weights.observability * row["observability"]
        + weights.interoperability * row["interoperability"]
        + weights.ai_governance * row["ai_governance"]
        + weights.resilience_readiness * row["resilience_readiness"]
        + weights.cyber_resilience * row["cyber_resilience"]
        + weights.equity_readiness * row["equity_readiness"]
        + weights.public_accountability * row["public_accountability"]
        + weights.adaptive_capacity * row["adaptive_capacity"]
    )


def classify_review(row: pd.Series) -> str:
    if as_bool(row["high_criticality"]) and row["cyber_resilience"] < 0.70:
        return "urgent_cyber_resilience_review"
    if as_bool(row["high_criticality"]) and row["resilience_readiness"] < 0.70:
        return "urgent_resilience_review"
    if row["ai_governance"] < 0.70:
        return "ai_governance_review"
    if row["interoperability"] < 0.65:
        return "interoperability_review"
    if row["equity_readiness"] < 0.65:
        return "equity_review"
    if row["public_accountability"] < 0.65:
        return "public_accountability_review"
    if row["intelligence_quality"] < 0.70:
        return "infrastructure_intelligence_review"
    return "routine_monitoring"


def summarize_assets() -> pd.DataFrame:
    assets = pd.read_csv(ASSET_PATH)
    assets["observability_coverage"] = (
        assets["observable_critical_assets"] / assets["critical_assets"]
    ).round(3)
    return assets.sort_values("observability_coverage")


def summarize_scenarios() -> pd.DataFrame:
    scenarios = pd.read_csv(SCENARIO_PATH)
    return (
        scenarios.groupby(["system_id", "scenario_status"], dropna=False)
        .agg(
            scenarios=("scenario_id", "count"),
            max_recovery_objective_hours=("recovery_objective_hours", "max"),
        )
        .reset_index()
        .sort_values(["scenario_status", "max_recovery_objective_hours"], ascending=[False, False])
    )


def summarize_cyber() -> pd.DataFrame:
    cyber = pd.read_csv(CYBER_PATH)
    cyber["cyber_resilience_recomputed"] = (
        0.25 * cyber["segmentation_score"]
        + 0.25 * cyber["access_control_score"]
        + 0.25 * cyber["recovery_score"]
        + 0.25 * cyber["monitoring_score"]
    ).round(3)
    cyber["cyber_review_required"] = cyber["cyber_resilience_recomputed"] < 0.70
    return cyber.sort_values(["cyber_review_required", "cyber_resilience_recomputed"], ascending=[False, True])


def main() -> None:
    readiness = pd.read_csv(KPI_PATH)
    readiness["intelligence_quality"] = readiness.apply(intelligence_quality, axis=1).round(3)
    readiness["review_priority"] = readiness.apply(classify_review, axis=1)
    readiness = readiness.sort_values(["review_priority", "intelligence_quality"])

    readiness_output = OUTPUT_DIR / "infrastructure_intelligence_readiness.csv"
    readiness.to_csv(readiness_output, index=False)

    sector_summary = (
        readiness.groupby("sector", dropna=False)
        .agg(
            systems=("system_id", "count"),
            mean_intelligence_quality=("intelligence_quality", "mean"),
            mean_observability=("observability", "mean"),
            mean_interoperability=("interoperability", "mean"),
            mean_resilience=("resilience_readiness", "mean"),
            mean_cyber_resilience=("cyber_resilience", "mean"),
            mean_equity_readiness=("equity_readiness", "mean"),
            review_items=("review_priority", lambda s: int((s != "routine_monitoring").sum())),
        )
        .reset_index()
        .round(3)
        .sort_values(["review_items", "mean_intelligence_quality"], ascending=[False, True])
    )
    sector_output = OUTPUT_DIR / "infrastructure_intelligence_sector_summary.csv"
    sector_summary.to_csv(sector_output, index=False)

    assets = summarize_assets()
    asset_output = OUTPUT_DIR / "asset_service_observability_summary.csv"
    assets.to_csv(asset_output, index=False)

    cyber = summarize_cyber()
    cyber_output = OUTPUT_DIR / "cyber_resilience_review_summary.csv"
    cyber.to_csv(cyber_output, index=False)

    scenarios = summarize_scenarios()
    scenario_output = OUTPUT_DIR / "resilience_scenario_review_summary.csv"
    scenarios.to_csv(scenario_output, index=False)

    governance_watchlist = readiness[readiness["review_priority"] != "routine_monitoring"]
    watchlist_output = OUTPUT_DIR / "infrastructure_governance_watchlist.csv"
    governance_watchlist.to_csv(watchlist_output, index=False)

    print("Infrastructure intelligence readiness:")
    print(readiness.to_string(index=False))
    print(f"\nWrote: {readiness_output}")

    print("\nSector summary:")
    print(sector_summary.to_string(index=False))
    print(f"\nWrote: {sector_output}")

    print("\nCyber resilience summary:")
    print(cyber.to_string(index=False))
    print(f"\nWrote: {cyber_output}")

    print("\nResilience scenario summary:")
    print(scenarios.to_string(index=False))
    print(f"\nWrote: {scenario_output}")

    print("\nGovernance watchlist:")
    print(governance_watchlist.to_string(index=False))
    print(f"\nWrote: {watchlist_output}")


if __name__ == "__main__":
    main()
