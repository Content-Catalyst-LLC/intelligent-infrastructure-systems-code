.headers on
.mode column

SELECT
  p.station_id,
  p.station_name,
  p.domain,
  o.variable,
  COUNT(o.value) AS observed_count,
  ROUND(AVG(o.value), 3) AS mean_value,
  m.calibration_status,
  m.metadata_status,
  m.known_breakpoint
FROM climate_observation_platforms p
LEFT JOIN climate_observations_sample o ON p.station_id = o.station_id
LEFT JOIN instrument_metadata_calibration_log m
  ON p.station_id = m.station_id AND o.variable = m.variable
GROUP BY
  p.station_id,
  p.station_name,
  p.domain,
  o.variable,
  m.calibration_status,
  m.metadata_status,
  m.known_breakpoint
ORDER BY p.domain, p.station_id;

SELECT
  domain,
  COUNT(*) AS platform_count,
  SUM(CASE WHEN operational_status = 'current' THEN 1 ELSE 0 END) AS current_platforms
FROM climate_observation_platforms
GROUP BY domain
ORDER BY platform_count DESC;

SELECT
  dataset_id,
  dataset_name,
  version,
  domain,
  archive_status,
  provenance_status,
  access_policy
FROM climate_archive_manifest
WHERE archive_status != 'current' OR provenance_status != 'current';
