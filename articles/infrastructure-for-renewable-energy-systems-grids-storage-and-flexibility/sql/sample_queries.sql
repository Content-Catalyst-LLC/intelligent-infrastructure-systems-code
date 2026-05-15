.headers on
.mode column

SELECT
  a.asset_id,
  a.asset_name,
  a.technology,
  a.grid_node_id,
  g.interconnection_status,
  ROUND(ABS(f.forecast_generation_mw - f.actual_generation_mw), 3) AS forecast_error_mw,
  ROUND(
    MAX(0, f.actual_generation_mw - MIN(f.actual_generation_mw, g.grid_transfer_capacity_mw + s.available_flexibility_mw + f.available_storage_charge_mw)),
    3
  ) AS curtailment_mw,
  ROUND(
    CASE
      WHEN f.actual_generation_mw > 0 THEN
        MAX(0, f.actual_generation_mw - MIN(f.actual_generation_mw, g.grid_transfer_capacity_mw + s.available_flexibility_mw + f.available_storage_charge_mw)) / f.actual_generation_mw
      ELSE 0
    END,
    3
  ) AS curtailment_rate,
  ROUND(
    CASE
      WHEN s.flexibility_need_mw > 0 THEN MIN(1.0, s.available_flexibility_mw / s.flexibility_need_mw)
      ELSE 1.0
    END,
    3
  ) AS flexibility_adequacy_score,
  ROUND(
    CASE
      WHEN g.connection_capacity_mw > 0 THEN MAX(0, 1 - g.grid_transfer_capacity_mw / g.connection_capacity_mw)
      ELSE 0
    END,
    3
  ) AS grid_constraint_score
FROM renewable_asset_inventory a
LEFT JOIN renewable_generation_forecast_records f ON a.asset_id = f.asset_id
LEFT JOIN grid_connection_constraint_register g ON a.grid_node_id = g.grid_node_id
LEFT JOIN storage_flexibility_register s ON a.flexibility_zone_id = s.flexibility_zone_id
ORDER BY curtailment_rate DESC, grid_constraint_score DESC;

SELECT
  a.technology,
  COUNT(DISTINCT a.asset_id) AS assets,
  ROUND(AVG(g.congestion_score), 3) AS mean_congestion,
  ROUND(AVG(s.available_flexibility_mw / NULLIF(s.flexibility_need_mw, 0)), 3) AS mean_flexibility_adequacy,
  ROUND(AVG(r.resilience_score), 3) AS mean_resilience
FROM renewable_asset_inventory a
LEFT JOIN grid_connection_constraint_register g ON a.grid_node_id = g.grid_node_id
LEFT JOIN storage_flexibility_register s ON a.flexibility_zone_id = s.flexibility_zone_id
LEFT JOIN renewable_reliability_resilience_review r ON a.service_zone_id = r.service_zone_id
GROUP BY a.technology
ORDER BY mean_congestion DESC;

SELECT
  p.governance_id,
  p.date,
  p.asset_id,
  a.asset_name,
  p.grid_node_id,
  p.decision,
  p.owner,
  p.status,
  p.public_note_required
FROM renewable_governance_planning_log p
LEFT JOIN renewable_asset_inventory a ON p.asset_id = a.asset_id
WHERE p.status = 'open'
ORDER BY p.date;
