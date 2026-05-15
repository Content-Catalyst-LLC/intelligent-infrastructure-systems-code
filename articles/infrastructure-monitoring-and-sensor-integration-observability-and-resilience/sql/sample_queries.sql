.headers on
.mode column

SELECT
  s.sensor_id,
  s.sensor_name,
  a.asset_name,
  a.infrastructure_domain,
  a.service_zone_id,
  ROUND(
    0.25 * t.accuracy_score +
    0.20 * t.precision_score +
    0.20 * t.completeness_score +
    0.20 * t.validity_score +
    0.15 * t.freshness_score,
    3
  ) AS signal_quality_score,
  ROUND(
    1 - (t.missing_readings + t.late_readings + t.invalid_readings) / NULLIF(t.expected_readings, 0),
    3
  ) AS telemetry_reliability_score,
  ROUND(
    (
      s.has_sensor_id +
      s.has_asset_id +
      s.has_location +
      s.has_unit +
      s.has_timestamp_source +
      s.has_owner +
      s.has_quality_flag +
      s.has_valid_use
    ) / 8.0,
    3
  ) AS metadata_completeness_score,
  ROUND(c.monitored_critical_assets / NULLIF(c.critical_assets, 0), 3) AS sensor_coverage_score,
  ROUND(c.unmonitored_high_risk_zones / NULLIF(c.total_service_zones, 0), 3) AS blindspot_penalty,
  t.quality_flag
FROM sensor_inventory s
LEFT JOIN sensor_telemetry_records t ON s.sensor_id = t.sensor_id
LEFT JOIN monitored_asset_registry a ON s.asset_id = a.asset_id
LEFT JOIN coverage_blindspot_review c ON a.service_zone_id = c.service_zone_id
ORDER BY signal_quality_score ASC, telemetry_reliability_score ASC;

SELECT
  c.service_zone_id,
  c.zone_name,
  c.infrastructure_domain,
  c.critical_assets,
  c.monitored_critical_assets,
  ROUND(c.monitored_critical_assets / NULLIF(c.critical_assets, 0), 3) AS coverage_score,
  c.unmonitored_high_risk_zones,
  c.primary_blindspot,
  c.coverage_review_status
FROM coverage_blindspot_review c
ORDER BY coverage_score ASC, unmonitored_high_risk_zones DESC;

SELECT
  r.alert_id,
  r.date,
  r.sensor_id,
  s.sensor_name,
  r.asset_id,
  a.asset_name,
  r.service_zone_id,
  r.alert_type,
  r.threshold_or_rule,
  r.response_owner,
  r.response_status,
  r.public_note_required
FROM monitoring_alert_response_register r
LEFT JOIN sensor_inventory s ON r.sensor_id = s.sensor_id
LEFT JOIN monitored_asset_registry a ON r.asset_id = a.asset_id
WHERE r.response_status IN ('open', 'in_progress')
ORDER BY r.date;
