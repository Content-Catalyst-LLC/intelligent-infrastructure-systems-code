.headers on
.mode column

SELECT
  s.site_id,
  s.site_name,
  s.domain,
  o.variable,
  o.value,
  t.threshold_value,
  CASE WHEN o.value >= t.threshold_value THEN 1 ELSE 0 END AS threshold_exceeded,
  c.calibration_status,
  c.telemetry_status,
  e.coverage_gap_score,
  ROUND(
    0.25 * c.record_completeness +
    0.20 * c.calibration_score +
    0.20 * c.metadata_score +
    0.20 * c.provenance_score +
    0.15 * c.sampling_design_score,
    3
  ) AS monitoring_quality_score
FROM environmental_observations_sample o
LEFT JOIN monitoring_site_inventory s ON o.site_id = s.site_id
LEFT JOIN environmental_threshold_indicator_catalog t
  ON o.domain = t.domain AND o.variable = t.variable
LEFT JOIN calibration_device_health_log c ON o.site_id = c.site_id
LEFT JOIN coverage_equity_review e ON s.monitoring_zone_id = e.monitoring_zone_id
ORDER BY threshold_exceeded DESC, monitoring_quality_score ASC;

SELECT
  s.domain,
  COUNT(DISTINCT s.site_id) AS site_count,
  SUM(CASE WHEN o.value >= t.threshold_value THEN 1 ELSE 0 END) AS threshold_exceedances,
  ROUND(AVG(e.coverage_gap_score), 3) AS mean_coverage_gap,
  ROUND(AVG(c.record_completeness), 3) AS mean_record_completeness
FROM monitoring_site_inventory s
LEFT JOIN environmental_observations_sample o ON s.site_id = o.site_id
LEFT JOIN environmental_threshold_indicator_catalog t
  ON o.domain = t.domain AND o.variable = t.variable
LEFT JOIN calibration_device_health_log c ON s.site_id = c.site_id
LEFT JOIN coverage_equity_review e ON s.monitoring_zone_id = e.monitoring_zone_id
GROUP BY s.domain
ORDER BY mean_coverage_gap DESC;
