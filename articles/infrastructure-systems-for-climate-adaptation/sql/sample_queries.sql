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
  intervention_type,
  COUNT(*) AS option_count,
  ROUND(AVG(expected_risk_reduction), 3) AS mean_risk_reduction,
  ROUND(AVG(maladaptation_risk), 3) AS mean_maladaptation_risk
FROM adaptation_options
GROUP BY intervention_type
ORDER BY mean_maladaptation_risk DESC;
