.headers on
.mode column

SELECT
  system_id,
  sector,
  ROUND(exposure * vulnerability, 3) AS raw_exposure,
  ROUND((exposure * vulnerability) * (1 - control_effectiveness), 3) AS residual_exposure,
  ROUND(
    0.14 * asset_visibility +
    0.14 * identity_governance +
    0.15 * control_effectiveness +
    0.14 * detection_capability +
    0.13 * containment_readiness +
    0.15 * recovery_readiness +
    0.15 * governance_readiness,
    3
  ) AS resilience_quality,
  continuity_readiness,
  recovery_readiness
FROM cyber_resilience_kpis
ORDER BY residual_exposure DESC;

SELECT
  sector,
  COUNT(*) AS systems,
  ROUND(AVG((exposure * vulnerability) * (1 - control_effectiveness)), 3) AS mean_residual_exposure,
  ROUND(AVG(recovery_readiness), 3) AS mean_recovery,
  ROUND(AVG(continuity_readiness), 3) AS mean_continuity
FROM cyber_resilience_kpis
GROUP BY sector
ORDER BY mean_residual_exposure DESC;

SELECT
  system_id,
  control_family,
  implementation_status,
  COUNT(*) AS controls,
  ROUND(AVG(control_effectiveness), 3) AS mean_control_effectiveness
FROM cyber_control_baseline
GROUP BY system_id, control_family, implementation_status
ORDER BY implementation_status DESC, mean_control_effectiveness ASC;

SELECT
  system_id,
  scenario_type,
  affected_service,
  detection_objective_minutes,
  containment_objective_minutes,
  recovery_objective_hours,
  status
FROM cyber_incident_scenario_manifest
ORDER BY status DESC, recovery_objective_hours DESC;

SELECT
  system_id,
  essential_service,
  fallback_mode,
  recovery_time_objective_hours,
  backup_test_status,
  manual_operation_status,
  public_communication_status
FROM continuity_recovery_log
ORDER BY recovery_time_objective_hours DESC;
