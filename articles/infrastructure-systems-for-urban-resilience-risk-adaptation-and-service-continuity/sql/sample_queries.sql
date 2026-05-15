.headers on
.mode column

SELECT
  s.service_id,
  s.service_name,
  s.service_domain,
  s.service_zone_id,
  ROUND(c.disruption_capacity / s.normal_capacity, 3) AS service_continuity_score,
  MAX(c.expected_recovery_hours - s.target_recovery_hours, 0) AS recovery_lag_hours,
  ROUND(h.hazard_intensity * h.exposure_score * e.vulnerability_score * (1 - c.governance_response_score), 3) AS urban_risk_score,
  e.equity_gap_score,
  c.continuity_plan_status
FROM critical_service_inventory s
LEFT JOIN continuity_recovery_plan c ON s.service_id = c.service_id
LEFT JOIN vulnerability_service_equity_review e ON s.service_zone_id = e.service_zone_id
LEFT JOIN hazard_stress_register h ON s.service_zone_id = h.service_zone_id
ORDER BY urban_risk_score DESC, recovery_lag_hours DESC;

SELECT
  d.source_service_id,
  s.service_name AS source_service_name,
  ROUND(SUM(d.dependency_weight * dep.service_failure_probability), 3) AS dependency_stress
FROM infrastructure_dependency_edges d
LEFT JOIN critical_service_inventory s ON d.source_service_id = s.service_id
LEFT JOIN critical_service_inventory dep ON d.dependent_service_id = dep.service_id
GROUP BY d.source_service_id, s.service_name
ORDER BY dependency_stress DESC;

SELECT
  service_domain,
  COUNT(*) AS service_count,
  ROUND(AVG(c.disruption_capacity / s.normal_capacity), 3) AS mean_service_continuity,
  ROUND(AVG(e.equity_gap_score), 3) AS mean_equity_gap
FROM critical_service_inventory s
LEFT JOIN continuity_recovery_plan c ON s.service_id = c.service_id
LEFT JOIN vulnerability_service_equity_review e ON s.service_zone_id = e.service_zone_id
GROUP BY service_domain
ORDER BY mean_equity_gap DESC;
