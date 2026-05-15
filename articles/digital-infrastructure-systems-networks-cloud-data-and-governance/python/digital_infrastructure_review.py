from __future__ import annotations

from pathlib import Path
import pandas as pd

ARTICLE_DIR = Path(__file__).resolve().parents[1]
DATA_DIR = ARTICLE_DIR / "data"
OUTPUT_DIR = ARTICLE_DIR / "outputs"
OUTPUT_DIR.mkdir(exist_ok=True)


def build_review() -> pd.DataFrame:
    connectivity = pd.read_csv(DATA_DIR / "connectivity_infrastructure_inventory.csv")
    cloud = pd.read_csv(DATA_DIR / "cloud_data_infrastructure_register.csv")
    interoperability = pd.read_csv(DATA_DIR / "interoperability_exchange_register.csv")
    trust = pd.read_csv(DATA_DIR / "identity_trust_register.csv")
    continuity = pd.read_csv(DATA_DIR / "digital_dependency_continuity_review.csv")
    inclusion = pd.read_csv(DATA_DIR / "access_inclusion_review.csv")

    review = (
        connectivity
        .merge(cloud, on="service_zone_id", how="left")
        .merge(interoperability, on="service_zone_id", how="left")
        .merge(trust, on="service_zone_id", how="left")
        .merge(continuity, on="service_zone_id", how="left")
        .merge(inclusion, on="service_zone_id", how="left")
    )

    review["digital_access_score"] = (
        review["users_with_affordable_reliable_access"]
        / review["users_needing_access"].replace(0, pd.NA)
    ).fillna(0).clip(lower=0, upper=1)

    review["network_capacity_score"] = (
        0.30 * review["bandwidth_score"]
        + 0.25 * review["latency_score"]
        + 0.25 * review["uptime_score"]
        + 0.20 * review["redundancy_score"]
    ).clip(lower=0, upper=1)

    review["compute_storage_score"] = (
        0.30 * review["compute_capacity_score"]
        + 0.25 * review["storage_capacity_score"]
        + 0.25 * review["geo_redundancy_score"]
        + 0.20 * review["edge_readiness_score"]
    ).clip(lower=0, upper=1)

    review["interoperability_score"] = (
        review["systems_using_shared_standards"]
        / review["systems_requiring_exchange"].replace(0, pd.NA)
    ).fillna(0).clip(lower=0, upper=1)

    review["trust_security_score"] = (
        0.25 * review["security_control_score"]
        + 0.20 * review["privacy_safeguard_score"]
        + 0.20 * review["auditability_score"]
        + 0.20 * review["recovery_readiness_score"]
        + 0.15 * review["governance_maturity_score"]
    ).clip(lower=0, upper=1)

    review["vendor_dependency_score"] = (
        review["critical_services_dependent_on_concentrated_providers"]
        / review["critical_digital_services"].replace(0, pd.NA)
    ).fillna(0).clip(lower=0, upper=1)

    review["inclusion_capacity_score"] = (
        0.20 * review["affordability_score"]
        + 0.20 * review["accessibility_score"]
        + 0.15 * review["language_support_score"]
        + 0.15 * review["device_access_score"]
        + 0.20 * review["assisted_service_availability_score"]
        + 0.10 * (1 - review["documentation_burden_score"])
    ).clip(lower=0, upper=1)

    review["digital_resilience_score"] = (
        0.20 * review["digital_access_score"]
        + 0.20 * review["network_capacity_score"]
        + 0.20 * review["compute_storage_score"]
        + 0.15 * review["interoperability_score"]
        + 0.20 * review["trust_security_score"]
        - 0.15 * review["vendor_dependency_score"]
        - 0.10 * review["exposure_score"]
    ).clip(lower=0, upper=1)

    review["digital_infrastructure_review_flag"] = (
        (review["digital_access_score"] < 0.85)
        | (review["network_capacity_score"] < 0.80)
        | (review["compute_storage_score"] < 0.75)
        | (review["interoperability_score"] < 0.70)
        | (review["trust_security_score"] < 0.75)
        | (review["digital_resilience_score"] < 0.75)
        | (review["vendor_dependency_score"] > 0.70)
        | (review["exposure_score"] > 0.40)
        | (review["exclusion_risk_score"] > 0.30)
    )

    return review


def main() -> None:
    review = build_review()
    review.to_csv(OUTPUT_DIR / "digital_infrastructure_review.csv", index=False)

    watchlist = (
        review[review["digital_infrastructure_review_flag"]]
        .sort_values(
            ["digital_resilience_score", "digital_access_score", "vendor_dependency_score"],
            ascending=[True, True, False],
        )
    )
    watchlist.to_csv(OUTPUT_DIR / "digital_infrastructure_watchlist.csv", index=False)

    zone_summary = (
        review.groupby(["service_zone_id", "region_name", "infrastructure_context"], as_index=False)
        .agg(
            mean_access=("digital_access_score", "mean"),
            mean_network_capacity=("network_capacity_score", "mean"),
            mean_compute_storage=("compute_storage_score", "mean"),
            mean_interoperability=("interoperability_score", "mean"),
            mean_trust_security=("trust_security_score", "mean"),
            mean_vendor_dependency=("vendor_dependency_score", "mean"),
            mean_resilience=("digital_resilience_score", "mean"),
            mean_inclusion_capacity=("inclusion_capacity_score", "mean"),
            mean_exclusion_risk=("exclusion_risk_score", "mean"),
            review_flags=("digital_infrastructure_review_flag", "sum"),
        )
        .sort_values(["review_flags", "mean_resilience"], ascending=[False, True])
    )
    zone_summary.to_csv(OUTPUT_DIR / "digital_infrastructure_zone_summary.csv", index=False)

    print("Digital infrastructure review written to outputs/digital_infrastructure_review.csv")
    print("Digital infrastructure watchlist written to outputs/digital_infrastructure_watchlist.csv")
    print(watchlist[[
        "service_zone_id",
        "region_name",
        "digital_access_score",
        "network_capacity_score",
        "compute_storage_score",
        "interoperability_score",
        "trust_security_score",
        "vendor_dependency_score",
        "digital_resilience_score",
        "exclusion_risk_score",
    ]].to_string(index=False))


if __name__ == "__main__":
    main()
