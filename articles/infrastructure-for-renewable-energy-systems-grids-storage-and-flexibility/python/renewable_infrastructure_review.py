from __future__ import annotations

from pathlib import Path
import pandas as pd

ARTICLE_DIR = Path(__file__).resolve().parents[1]
DATA_DIR = ARTICLE_DIR / "data"
OUTPUT_DIR = ARTICLE_DIR / "outputs"
OUTPUT_DIR.mkdir(exist_ok=True)


def build_review() -> pd.DataFrame:
    assets = pd.read_csv(DATA_DIR / "renewable_asset_inventory.csv")
    grid = pd.read_csv(DATA_DIR / "grid_connection_constraint_register.csv")
    generation = pd.read_csv(DATA_DIR / "renewable_generation_forecast_records.csv", parse_dates=["timestamp"])
    flexibility = pd.read_csv(DATA_DIR / "storage_flexibility_register.csv")
    resilience = pd.read_csv(DATA_DIR / "renewable_reliability_resilience_review.csv")

    review = (
        generation
        .merge(assets, on="asset_id", how="left")
        .merge(grid, on="grid_node_id", how="left")
        .merge(flexibility, on="flexibility_zone_id", how="left")
        .merge(resilience, on="service_zone_id", how="left")
    )

    review["forecast_error_mw"] = (
        review["forecast_generation_mw"] - review["actual_generation_mw"]
    ).abs()

    base_usable = review[["actual_generation_mw", "grid_transfer_capacity_mw"]].min(axis=1)
    review["usable_renewable_mw"] = (
        base_usable
        + review["available_flexibility_mw"].fillna(0)
        + review["available_storage_charge_mw"].fillna(0)
    ).clip(upper=review["actual_generation_mw"])

    review["curtailment_mw"] = (
        review["actual_generation_mw"] - review["usable_renewable_mw"]
    ).clip(lower=0)

    review["curtailment_rate"] = (
        review["curtailment_mw"] / review["actual_generation_mw"].replace(0, pd.NA)
    ).fillna(0).clip(lower=0, upper=1)

    review["flexibility_adequacy_score"] = (
        review["available_flexibility_mw"] / review["flexibility_need_mw"].replace(0, pd.NA)
    ).fillna(1).clip(lower=0, upper=1)

    review["grid_constraint_score"] = (
        1 - review["grid_transfer_capacity_mw"] / review["connection_capacity_mw"].replace(0, pd.NA)
    ).fillna(0).clip(lower=0, upper=1)

    review["renewable_infrastructure_score"] = (
        0.25 * (1 - review["curtailment_rate"])
        + 0.20 * review["flexibility_adequacy_score"]
        + 0.20 * review["resilience_score"]
        + 0.15 * review["forecast_quality_score"]
        + 0.10 * review["storage_readiness_score"]
        - 0.10 * review["grid_constraint_score"]
    ).clip(lower=0, upper=1)

    review["renewable_review_flag"] = (
        (review["curtailment_rate"] >= 0.10)
        | (review["flexibility_adequacy_score"] < 0.75)
        | (review["grid_constraint_score"] >= 0.30)
        | (review["forecast_quality_score"] < 0.70)
        | (review["resilience_score"] < 0.70)
        | (review["interconnection_status"].isin(["delayed", "queued", "constrained"]))
        | (review["quality_flag"].eq("review"))
    )

    return review


def main() -> None:
    review = build_review()
    review.to_csv(OUTPUT_DIR / "renewable_infrastructure_review.csv", index=False)

    watchlist = (
        review[review["renewable_review_flag"]]
        .sort_values(
            ["curtailment_rate", "grid_constraint_score", "flexibility_adequacy_score"],
            ascending=[False, False, True],
        )
    )
    watchlist.to_csv(OUTPUT_DIR / "renewable_infrastructure_governance_watchlist.csv", index=False)

    technology_summary = (
        review.groupby("technology", as_index=False)
        .agg(
            assets=("asset_id", "nunique"),
            observations=("record_id", "count"),
            mean_curtailment_rate=("curtailment_rate", "mean"),
            mean_flexibility_adequacy=("flexibility_adequacy_score", "mean"),
            mean_grid_constraint=("grid_constraint_score", "mean"),
            mean_resilience=("resilience_score", "mean"),
            mean_infrastructure_score=("renewable_infrastructure_score", "mean"),
            review_flags=("renewable_review_flag", "sum"),
        )
        .sort_values(["review_flags", "mean_curtailment_rate"], ascending=[False, False])
    )
    technology_summary.to_csv(OUTPUT_DIR / "renewable_technology_summary.csv", index=False)

    print("Renewable infrastructure review written to outputs/renewable_infrastructure_review.csv")
    print("Renewable infrastructure governance watchlist written to outputs/renewable_infrastructure_governance_watchlist.csv")
    print(watchlist[[
        "asset_id", "asset_name", "technology", "grid_node_id",
        "interconnection_status", "curtailment_rate",
        "flexibility_adequacy_score", "grid_constraint_score",
        "renewable_infrastructure_score"
    ]].to_string(index=False))


if __name__ == "__main__":
    main()
