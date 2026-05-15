.headers on
.mode column

SELECT
  a.asset_id,
  a.asset_name,
  a.asset_class,
  a.domain,
  a.service_zone_id,
  ROUND(q.compliant_observations * 1.0 / q.tested_observations, 3) AS quality_compliance_score,
  ROUND(
    CASE
      WHEN h.maximum_pressure_psi > h.minimum_pressure_psi THEN
        MAX(0, MIN(1, (t.pressure_psi - h.minimum_pressure_psi) / (h.maximum_pressure_psi - h.minimum_pressure_psi)))
      ELSE 0
    END,
    3
  ) AS pressure_adequacy_score,
  ROUND((h.system_input_volume_m3 - h.authorized_consumption_m3) / h.system_input_volume_m3, 3) AS leakage_rate,
  s.overflow_risk_score,
  s.exposure_risk_score,
  t.quality_flag
FROM water_asset_inventory a
LEFT JOIN water_telemetry_records t ON a.asset_id = t.asset_id
LEFT JOIN water_quality_public_health_review q ON a.service_zone_id = q.service_zone_id
LEFT JOIN leakage_hydraulic_control_review h ON a.service_zone_id = h.service_zone_id
LEFT JOIN wastewater_stormwater_risk_review s ON a.service_zone_id = s.service_zone_id
ORDER BY s.exposure_risk_score DESC, leakage_rate DESC, s.overflow_risk_score DESC;

SELECT
  a.service_zone_id,
  COUNT(DISTINCT a.asset_id) AS assets,
  ROUND(AVG(q.compliant_observations * 1.0 / q.tested_observations), 3) AS mean_quality_compliance,
  ROUND(AVG((h.system_input_volume_m3 - h.authorized_consumption_m3) / h.system_input_volume_m3), 3) AS mean_leakage_rate,
  ROUND(AVG(s.overflow_risk_score), 3) AS mean_overflow_risk,
  ROUND(AVG(s.exposure_risk_score), 3) AS mean_exposure_risk
FROM water_asset_inventory a
LEFT JOIN water_quality_public_health_review q ON a.service_zone_id = q.service_zone_id
LEFT JOIN leakage_hydraulic_control_review h ON a.service_zone_id = h.service_zone_id
LEFT JOIN wastewater_stormwater_risk_review s ON a.service_zone_id = s.service_zone_id
GROUP BY a.service_zone_id
ORDER BY mean_exposure_risk DESC, mean_leakage_rate DESC;

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
FROM water_governance_response_log g
LEFT JOIN water_asset_inventory a ON g.asset_id = a.asset_id
WHERE g.status = 'open'
ORDER BY g.date;
