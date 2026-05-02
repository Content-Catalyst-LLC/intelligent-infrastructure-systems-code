INSERT INTO infrastructure_assets VALUES
('PUMP-001', 'pump_station', 'water', 'River Pump Station', 41.8810, -87.6400, '2017-05-01', 0.88, 1),
('BRIDGE-001', 'bridge', 'transportation', 'Canal Bridge', 41.8850, -87.6500, '1985-09-15', 0.92, 1),
('SUBSTATION-001', 'substation', 'energy', 'North Substation', 41.8900, -87.6200, '2001-03-12', 0.95, 1),
('FLOOD-GAUGE-001', 'flood_gauge', 'disaster_monitoring', 'Lowland Gauge', 41.8700, -87.6600, '2022-07-21', 0.90, 1);

INSERT INTO infrastructure_sensors VALUES
('VIB-PUMP-001', 'PUMP-001', 'vibration', 'g', 'lorawan', 300),
('STRAIN-BRIDGE-001', 'BRIDGE-001', 'strain', 'microstrain', 'cellular', 300),
('TEMP-SUB-001', 'SUBSTATION-001', 'temperature', 'celsius', 'ethernet', 60),
('LEVEL-FLOOD-001', 'FLOOD-GAUGE-001', 'water_level', 'meters', 'lpwan', 300);

INSERT INTO telemetry_readings
(sensor_id, observed_at, observed_value, battery_voltage, signal_quality, payload_bytes, transmitted, quality_flag)
VALUES
('VIB-PUMP-001', '2026-04-01T10:00:00', 0.81, 3.71, 0.93, 12, 1, 'valid'),
('VIB-PUMP-001', '2026-04-01T10:05:00', 1.42, 3.68, 0.87, 12, 1, 'valid'),
('STRAIN-BRIDGE-001', '2026-04-01T10:00:00', 12.5, 3.82, 0.91, 16, 1, 'valid'),
('TEMP-SUB-001', '2026-04-01T10:00:00', 41.2, 4.02, 0.96, 10, 1, 'valid'),
('LEVEL-FLOOD-001', '2026-04-01T10:00:00', 2.8, 3.45, 0.74, 10, 0, 'low_signal_quality');
