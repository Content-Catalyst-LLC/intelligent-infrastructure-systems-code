.mode column
.headers on

SELECT
  asset_id,
  asset_name,
  infrastructure_domain,
  primary_hazard,
  ROUND(exposure_score * vulnerability_score * criticality_score, 3) AS climate_risk_index
FROM asset_exposure
ORDER BY climate_risk_index DESC;

SELECT
  d.to_asset_id AS dependent_asset,
  COUNT(*) AS dependency_count,
  ROUND(AVG(d.dependency_strength), 3) AS mean_dependency_strength
FROM dependency_edges d
GROUP BY d.to_asset_id
ORDER BY dependency_count DESC, mean_dependency_strength DESC;

SELECT
  o.intervention_type,
  COUNT(*) AS option_count,
  ROUND(AVG(o.expected_risk_reduction), 3) AS mean_risk_reduction,
  ROUND(AVG(o.equity_benefit), 3) AS mean_equity_benefit,
  ROUND(AVG(o.maladaptation_risk), 3) AS mean_maladaptation_risk
FROM adaptation_options o
GROUP BY o.intervention_type
ORDER BY mean_maladaptation_risk DESC;
