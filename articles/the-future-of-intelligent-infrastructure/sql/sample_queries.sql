.headers on
.mode column

SELECT
  system_id,
  sector,
  ROUND(
    0.15 * observability +
    0.13 * interoperability +
    0.12 * ai_governance +
    0.15 * resilience_readiness +
    0.14 * cyber_resilience +
    0.12 * equity_readiness +
    0.10 * public_accountability +
    0.09 * adaptive_capacity,
    3
  ) AS intelligence_quality,
  CASE
    WHEN high_criticality = 1 AND cyber_resilience < 0.70 THEN 'urgent_cyber_resilience_review'
    WHEN high_criticality = 1 AND resilience_readiness < 0.70 THEN 'urgent_resilience_review'
    WHEN ai_governance < 0.70 THEN 'ai_governance_review'
    WHEN interoperability < 0.65 THEN 'interoperability_review'
    WHEN equity_readiness < 0.65 THEN 'equity_review'
    WHEN public_accountability < 0.65 THEN 'public_accountability_review'
    ELSE 'routine_monitoring'
  END AS review_priority
FROM infrastructure_intelligence_kpis
ORDER BY review_priority, intelligence_quality;

SELECT
  sector,
  COUNT(*) AS systems,
  ROUND(AVG(observability), 3) AS mean_observability,
  ROUND(AVG(interoperability), 3) AS mean_interoperability,
  ROUND(AVG(resilience_readiness), 3) AS mean_resilience,
  ROUND(AVG(cyber_resilience), 3) AS mean_cyber_resilience,
  ROUND(AVG(equity_readiness), 3) AS mean_equity_readiness
FROM infrastructure_intelligence_kpis
GROUP BY sector
ORDER BY mean_cyber_resilience ASC;

SELECT
  system_id,
  critical_assets,
  observable_critical_assets,
  ROUND(CAST(observable_critical_assets AS REAL) / critical_assets, 3) AS observability_coverage
FROM asset_service_register
ORDER BY observability_coverage ASC;

SELECT
  system_id,
  ROUND(
    0.25 * segmentation_score +
    0.25 * access_control_score +
    0.25 * recovery_score +
    0.25 * monitoring_score,
    3
  ) AS cyber_resilience_recomputed,
  incident_response_status
FROM cyber_resilience_controls
ORDER BY cyber_resilience_recomputed ASC;

SELECT
  system_id,
  scenario_type,
  severity,
  recovery_objective_hours,
  scenario_status
FROM resilience_scenario_manifest
ORDER BY scenario_status DESC, recovery_objective_hours DESC;
