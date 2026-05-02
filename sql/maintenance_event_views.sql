CREATE VIEW IF NOT EXISTS asset_health_summary AS
SELECT
    a.asset_id,
    a.asset_type,
    a.sector,
    a.criticality_score,
    COUNT(t.reading_id) AS telemetry_records,
    AVG(t.signal_quality) AS mean_signal_quality,
    AVG(t.battery_voltage) AS mean_battery_voltage
FROM infrastructure_assets a
LEFT JOIN infrastructure_sensors s ON a.asset_id = s.asset_id
LEFT JOIN telemetry_readings t ON s.sensor_id = t.sensor_id
GROUP BY
    a.asset_id,
    a.asset_type,
    a.sector,
    a.criticality_score;
