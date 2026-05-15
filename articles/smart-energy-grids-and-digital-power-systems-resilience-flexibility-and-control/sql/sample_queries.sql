.headers on
.mode column

SELECT
  a.asset_id,
  a.asset_name,
  a.asset_class,
  a.service_zone_id,
  ROUND(
    0.25 * t.telemetry_reliability_score +
    0.25 * t.data_quality_score +
    0.20 * t.coverage_score +
    0.15 * t.metadata_completeness_score +
    0.15 * MAX(0, MIN(1, 1 - t.latency_seconds / 120.0)),
    3
  ) AS grid_observability_score,
  ROUND(MAX(0, MIN(1, 1 - ABS(t.voltage_pu - 1.0) / t.allowed_voltage_deviation_pu)), 3) AS voltage_adequacy_score,
  ROUND(
    CASE
      WHEN d.flexibility_need_mw > 0 THEN MIN(1.0, d.available_flexibility_mw / d.flexibility_need_mw)
      ELSE 1.0
    END,
    3
  ) AS flexibility_adequacy_score,
  ROUND(
    CASE
      WHEN t.load_mw > 0 THEN MIN(1.0, ABS(t.load_mw - t.available_supply_mw - d.available_flexibility_mw) / t.load_mw)
      ELSE 0
    END,
    3
  ) AS balancing_pressure_score,
  c.cyber_physical_risk_score
FROM grid_asset_inventory a
LEFT JOIN grid_telemetry_records t ON a.asset_id = t.asset_id
LEFT JOIN distributed_resource_coordination_register d ON a.service_zone_id = d.service_zone_id
LEFT JOIN cyber_physical_grid_review c ON a.service_zone_id = c.service_zone_id
ORDER BY c.cyber_physical_risk_score DESC, balancing_pressure_score DESC;

SELECT
  a.service_zone_id,
  COUNT(DISTINCT a.asset_id) AS assets,
  ROUND(AVG(t.served_hours / t.required_service_hours), 3) AS mean_service_continuity,
  ROUND(AVG(d.available_flexibility_mw / NULLIF(d.flexibility_need_mw, 0)), 3) AS mean_flexibility_adequacy,
  ROUND(AVG(c.cyber_physical_risk_score), 3) AS mean_cyber_physical_risk,
  ROUND(AVG(r.exposure_risk_score), 3) AS mean_exposure_risk
FROM grid_asset_inventory a
LEFT JOIN grid_telemetry_records t ON a.asset_id = t.asset_id
LEFT JOIN distributed_resource_coordination_register d ON a.service_zone_id = d.service_zone_id
LEFT JOIN cyber_physical_grid_review c ON a.service_zone_id = c.service_zone_id
LEFT JOIN grid_reliability_resilience_review r ON a.service_zone_id = r.service_zone_id
GROUP BY a.service_zone_id
ORDER BY mean_cyber_physical_risk DESC, mean_exposure_risk DESC;

SELECT
  g.governance_id,
  g.date,
  g.asset_id,
  a.asset_name,
  g.service_zone_id,
  g.decision,
  g.owner,
  g.status,
  g.public_note_required
FROM grid_governance_interoperability_log g
LEFT JOIN grid_asset_inventory a ON g.asset_id = a.asset_id
WHERE g.status = 'open'
ORDER BY g.date;
