.headers on
.mode column

SELECT
  t.sensor_id,
  i.sensor_name,
  t.domain,
  t.variable,
  t.value,
  c.threshold_value,
  CASE WHEN t.value >= c.threshold_value THEN 1 ELSE 0 END AS threshold_exceeded,
  t.latency_seconds,
  h.calibration_status,
  h.device_health_status,
  ROUND(1 - e.coverage_score, 3) AS coverage_gap_score
FROM urban_sensor_telemetry_sample t
LEFT JOIN urban_sensor_inventory i ON t.sensor_id = i.sensor_id
LEFT JOIN sensor_asset_linkage a ON t.sensor_id = a.sensor_id
LEFT JOIN calibration_device_health_log h ON t.sensor_id = h.sensor_id
LEFT JOIN coverage_exposure_review e ON a.service_zone_id = e.service_zone_id
LEFT JOIN urban_sensor_indicator_catalog c
  ON t.domain = c.domain AND t.variable = c.variable
ORDER BY threshold_exceeded DESC, coverage_gap_score DESC;

SELECT
  t.domain,
  COUNT(DISTINCT t.sensor_id) AS sensor_count,
  SUM(CASE WHEN t.value >= c.threshold_value THEN 1 ELSE 0 END) AS threshold_events,
  ROUND(AVG(e.coverage_score), 3) AS mean_coverage_score,
  ROUND(AVG(t.latency_seconds), 1) AS mean_latency_seconds
FROM urban_sensor_telemetry_sample t
LEFT JOIN sensor_asset_linkage a ON t.sensor_id = a.sensor_id
LEFT JOIN coverage_exposure_review e ON a.service_zone_id = e.service_zone_id
LEFT JOIN urban_sensor_indicator_catalog c
  ON t.domain = c.domain AND t.variable = c.variable
GROUP BY t.domain
ORDER BY threshold_events DESC, mean_coverage_score ASC;
