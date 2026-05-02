CREATE VIEW IF NOT EXISTS resilience_indicator_summary AS
SELECT
    a.sector,
    COUNT(DISTINCT a.asset_id) AS asset_count,
    AVG(a.criticality_score) AS mean_criticality,
    AVG(t.signal_quality) AS mean_signal_quality,
    AVG(CASE WHEN t.quality_flag = 'valid' THEN 1.0 ELSE 0.0 END) AS valid_telemetry_rate
FROM infrastructure_assets a
LEFT JOIN infrastructure_sensors s ON a.asset_id = s.asset_id
LEFT JOIN telemetry_readings t ON s.sensor_id = t.sensor_id
GROUP BY a.sector;
