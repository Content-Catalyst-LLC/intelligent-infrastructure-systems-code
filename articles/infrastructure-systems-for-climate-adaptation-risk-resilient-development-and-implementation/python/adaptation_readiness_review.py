from pathlib import Path
import pandas as pd

ARTICLE_DIR = Path(__file__).resolve().parents[1]
DATA_DIR = ARTICLE_DIR / "data"
OUTPUT_DIR = ARTICLE_DIR / "outputs"
OUTPUT_DIR.mkdir(exist_ok=True)

def main() -> None:
    exposure = pd.read_csv(DATA_DIR / "infrastructure_exposure_inventory.csv")
    options = pd.read_csv(DATA_DIR / "adaptation_option_portfolio.csv")
    finance = pd.read_csv(DATA_DIR / "adaptation_finance_implementation_log.csv")
    vulnerability = pd.read_csv(DATA_DIR / "vulnerability_adaptive_capacity.csv")
    maladaptation = pd.read_csv(DATA_DIR / "maladaptation_review.csv")

    df = (
        exposure
        .merge(options, on="system_id", how="left")
        .merge(finance, on="adaptation_id", how="left")
        .merge(vulnerability, on="community_id", how="left")
        .merge(maladaptation, on="adaptation_id", how="left")
    )

    df["baseline_risk"] = df["hazard_intensity"] * df["exposure_score"] * df["sensitivity_score"] * (1 - df["adaptive_capacity_score"])
    df["residual_risk"] = df["baseline_risk"] * (1 - df["option_effectiveness"]) + df["maladaptation_penalty"]
    df["implementation_readiness"] = (
        0.25 * df["finance_readiness"] +
        0.25 * df["delivery_readiness"] +
        0.20 * df["operations_readiness"] +
        0.15 * df["monitoring_readiness"] +
        0.15 * df["governance_readiness"]
    )
    df["equity_priority"] = df["vulnerable_population_share"] * df["health_sensitivity_score"] * df["residual_risk"]
    df["watchlist_flag"] = (
        (df["criticality"] == "high") &
        ((df["residual_risk"] >= 0.25) | (df["implementation_readiness"] < 0.65) | (df["overall_maladaptation_flag"] == "review_required"))
    )

    df.to_csv(OUTPUT_DIR / "adaptation_residual_risk_review.csv", index=False)
    df[df["watchlist_flag"]].to_csv(OUTPUT_DIR / "adaptation_governance_watchlist.csv", index=False)
    print("Wrote adaptation review outputs.")

if __name__ == "__main__":
    main()
