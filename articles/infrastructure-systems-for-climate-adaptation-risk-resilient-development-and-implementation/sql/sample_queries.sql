.headers on
.mode column

SELECT
  e.system_id,
  e.asset_name,
  e.sector,
  e.hazard_type,
  ROUND(e.hazard_intensity * e.exposure_score * e.sensitivity_score * (1 - e.adaptive_capacity_score), 3) AS baseline_risk,
  ROUND((e.hazard_intensity * e.exposure_score * e.sensitivity_score * (1 - e.adaptive_capacity_score)) * (1 - o.option_effectiveness) + o.maladaptation_penalty, 3) AS residual_risk,
  f.implementation_status,
  m.overall_maladaptation_flag
FROM infrastructure_exposure_inventory e
LEFT JOIN adaptation_option_portfolio o ON e.system_id = o.system_id
LEFT JOIN adaptation_finance_implementation_log f ON o.adaptation_id = f.adaptation_id
LEFT JOIN maladaptation_review m ON o.adaptation_id = m.adaptation_id
ORDER BY residual_risk DESC;
