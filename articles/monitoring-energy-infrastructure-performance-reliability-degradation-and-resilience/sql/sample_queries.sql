.headers on
.mode column

SELECT
  a.asset_id,
  a.asset_name,
  a.asset_class,
  a.criticality,
  ROUND(t.available_hours / t.total_hours, 3) AS availability_score,
  CASE
    WHEN t.power_demand_mw > 0 THEN ROUND(t.power_served_mw / t.power_demand_mw, 3)
    ELSE 1.0
  END AS service_continuity_score,
  ROUND((c.baseline_health_score - c.current_health_score) / c.baseline_health_score, 3) AS degradation_score,
  ROUND(
    0.30 * c.loading_stress_score +
    0.25 * c.thermal_stress_score +
    0.25 * c.cycling_stress_score +
    0.20 * c.environmental_exposure_score,
    3
  ) AS stress_score,
  p.power_quality_risk_score,
  c.maintenance_status
FROM energy_asset_inventory a
LEFT JOIN energy_performance_telemetry t ON a.asset_id = t.asset_id
LEFT JOIN condition_degradation_log c ON a.asset_id = c.asset_id
LEFT JOIN power_quality_stability_records p ON a.asset_id = p.asset_id
ORDER BY stress_score DESC, degradation_score DESC, p.power_quality_risk_score DESC;

SELECT
  asset_class,
  COUNT(*) AS asset_count,
  ROUND(AVG(t.available_hours / t.total_hours), 3) AS mean_availability,
  ROUND(AVG((c.baseline_health_score - c.current_health_score) / c.baseline_health_score), 3) AS mean_degradation,
  ROUND(AVG(p.power_quality_risk_score), 3) AS mean_power_quality_risk
FROM energy_asset_inventory a
LEFT JOIN energy_performance_telemetry t ON a.asset_id = t.asset_id
LEFT JOIN condition_degradation_log c ON a.asset_id = c.asset_id
LEFT JOIN power_quality_stability_records p ON a.asset_id = p.asset_id
GROUP BY asset_class
ORDER BY mean_degradation DESC;

SELECT
  g.governance_id,
  g.date,
  g.asset_id,
  a.asset_name,
  g.decision,
  g.owner,
  g.status,
  g.public_note_required
FROM energy_governance_maintenance_log g
LEFT JOIN energy_asset_inventory a ON g.asset_id = a.asset_id
WHERE g.status = 'open'
ORDER BY g.date;
