SELECT *
FROM telemetry_readings
WHERE battery_voltage IS NULL
   OR battery_voltage < 3.3;

SELECT *
FROM telemetry_readings
WHERE signal_quality IS NULL
   OR signal_quality < 0.80;

SELECT
    s.communication_mode,
    COUNT(*) AS records,
    AVG(CASE WHEN t.quality_flag = 'valid' THEN 1.0 ELSE 0.0 END) AS valid_record_rate,
    AVG(t.battery_voltage) AS mean_battery_voltage,
    AVG(t.signal_quality) AS mean_signal_quality
FROM telemetry_readings t
JOIN infrastructure_sensors s ON t.sensor_id = s.sensor_id
GROUP BY s.communication_mode;
