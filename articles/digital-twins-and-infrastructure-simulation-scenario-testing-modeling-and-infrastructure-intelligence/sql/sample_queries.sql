.headers on
.mode column

SELECT
  o.scenario_id,
  s.scenario_type,
  o.intervention,
  COUNT(*) AS output_count,
  ROUND(AVG(o.failure_risk), 3) AS mean_failure_risk,
  ROUND(AVG(o.service_risk), 3) AS mean_service_risk,
  ROUND(AVG(o.decision_value), 3) AS mean_decision_value,
  SUM(o.review_required) AS review_items
FROM simulation_outputs o
JOIN simulation_scenario_manifest s ON s.scenario_id = o.scenario_id
GROUP BY o.scenario_id, s.scenario_type, o.intervention
ORDER BY mean_service_risk DESC;

SELECT
  a.asset_id,
  a.asset_class,
  a.asset_name,
  o.scenario_id,
  o.intervention,
  o.service_risk,
  o.decision_value,
  o.review_required
FROM simulation_outputs o
JOIN twin_asset_registry a ON a.asset_id = o.asset_id
WHERE o.review_required = 1
ORDER BY o.service_risk DESC, o.decision_value ASC;

SELECT
  model_id,
  model_name,
  model_type,
  model_version,
  owner,
  validation_status,
  uncertainty_statement
FROM model_registry
ORDER BY validation_status DESC, model_id;

SELECT
  asset_id,
  AVG(condition_state) AS mean_condition_state,
  AVG(estimated_failure_risk) AS mean_estimated_failure_risk,
  MAX(state_quality_flag) AS state_quality_flag
FROM digital_twin_state_table
GROUP BY asset_id
ORDER BY mean_estimated_failure_risk DESC;
