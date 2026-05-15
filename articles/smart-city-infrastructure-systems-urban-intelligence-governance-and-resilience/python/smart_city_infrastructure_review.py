from __future__ import annotations

from pathlib import Path
import pandas as pd

ARTICLE_DIR = Path(__file__).resolve().parents[1]
DATA_DIR = ARTICLE_DIR / "data"
OUTPUT_DIR = ARTICLE_DIR / "outputs"
OUTPUT_DIR.mkdir(exist_ok=True)


def build_review() -> pd.DataFrame:
    inventory = pd.read_csv(DATA_DIR / "urban_infrastructure_inventory.csv")
    observability = pd.read_csv(DATA_DIR / "urban_observability_records.csv", parse_dates=["timestamp"])
    dependencies = pd.read_csv(DATA_DIR / "cross_domain_dependency_edges.csv")
    indicators = pd.read_csv(DATA_DIR / "public_value_indicator_catalog.csv")
    rights = pd.read_csv(DATA_DIR / "digital_inclusion_rights_review.csv")

    review = (
        observability
        .merge(inventory, on=["infrastructure_id", "domain"], how="left")
        .merge(rights, on="service_zone_id", how="left")
        .merge(indicators, on=["domain", "indicator_name"], how="left")
    )

    review["service_continuity_score"] = (
        review["observed_service_capacity"] / review["normal_service_capacity"]
    ).clip(lower=0, upper=1)

    max_latency = max(review["latency_seconds"].max(), 1)
    review["latency_score"] = (1 - review["latency_seconds"] / max_latency).clip(lower=0, upper=1)

    review["domain_observability_score"] = (
        0.25 * review["data_quality_score"]
        + 0.20 * review["coverage_score"]
        + 0.20 * review["interoperability_score"]
        + 0.20 * review["latency_score"]
        + 0.15 * review["governance_response_score"]
    )

    review["public_value_score"] = (
        0.25 * review["service_continuity_score"]
        + 0.20 * review["accessibility_score"]
        + 0.20 * review["resilience_score"]
        + 0.20 * review["inclusion_score"]
        + 0.15 * review["trust_score"]
        - 0.15 * review["unequal_burden_score"]
    ).clip(lower=0, upper=1)

    dependency_stress = (
        dependencies
        .merge(
            inventory[["infrastructure_id", "domain_failure_probability"]],
            left_on="target_infrastructure_id",
            right_on="infrastructure_id",
            how="left",
        )
        .assign(
            dependency_stress=lambda df:
                df["dependency_weight"] * df["domain_failure_probability"].fillna(0)
        )
        .groupby("source_infrastructure_id", as_index=False)["dependency_stress"]
        .sum()
        .rename(columns={"source_infrastructure_id": "infrastructure_id"})
    )

    review = review.merge(dependency_stress, on="infrastructure_id", how="left")
    review["dependency_stress"] = review["dependency_stress"].fillna(0)

    review["smart_city_review_flag"] = (
        (review["service_continuity_score"] < 0.75)
        | (review["domain_observability_score"] < 0.70)
        | (review["public_value_score"] < 0.65)
        | (review["dependency_stress"] >= 0.30)
        | (review["digital_access_gap_score"] >= 0.35)
        | (review["privacy_risk_score"] >= 0.35)
        | (review["quality_flag"].eq("review"))
    )

    return review


def main() -> None:
    review = build_review()
    review.to_csv(OUTPUT_DIR / "smart_city_infrastructure_review.csv", index=False)

    watchlist = (
        review[review["smart_city_review_flag"]]
        .sort_values(
            ["dependency_stress", "digital_access_gap_score", "privacy_risk_score"],
            ascending=[False, False, False],
        )
    )
    watchlist.to_csv(OUTPUT_DIR / "smart_city_governance_watchlist.csv", index=False)

    domain_summary = (
        review.groupby("domain", as_index=False)
        .agg(
            infrastructure_assets=("infrastructure_id", "nunique"),
            observations=("record_id", "count"),
            mean_service_continuity=("service_continuity_score", "mean"),
            mean_observability=("domain_observability_score", "mean"),
            mean_public_value=("public_value_score", "mean"),
            mean_dependency_stress=("dependency_stress", "mean"),
            mean_digital_access_gap=("digital_access_gap_score", "mean"),
            mean_privacy_risk=("privacy_risk_score", "mean"),
            review_flags=("smart_city_review_flag", "sum"),
        )
        .sort_values(["review_flags", "mean_dependency_stress"], ascending=[False, False])
    )
    domain_summary.to_csv(OUTPUT_DIR / "smart_city_domain_summary.csv", index=False)

    print("Smart city infrastructure review written to outputs/smart_city_infrastructure_review.csv")
    print("Smart city governance watchlist written to outputs/smart_city_governance_watchlist.csv")
    print(watchlist[[
        "infrastructure_id", "asset_name", "domain", "service_zone_id",
        "service_continuity_score", "domain_observability_score",
        "public_value_score", "dependency_stress",
        "digital_access_gap_score", "privacy_risk_score"
    ]].to_string(index=False))


if __name__ == "__main__":
    main()
