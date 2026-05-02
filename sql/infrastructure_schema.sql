CREATE TABLE IF NOT EXISTS infrastructure_assets (
    asset_id TEXT PRIMARY KEY,
    asset_type TEXT NOT NULL,
    sector TEXT NOT NULL,
    location_name TEXT NOT NULL,
    latitude REAL,
    longitude REAL,
    installed_at TEXT,
    criticality_score REAL NOT NULL,
    active INTEGER NOT NULL CHECK (active IN (0, 1))
);

CREATE TABLE IF NOT EXISTS infrastructure_sensors (
    sensor_id TEXT PRIMARY KEY,
    asset_id TEXT NOT NULL,
    sensor_type TEXT NOT NULL,
    unit TEXT NOT NULL,
    communication_mode TEXT NOT NULL,
    sampling_interval_seconds INTEGER NOT NULL,
    FOREIGN KEY (asset_id) REFERENCES infrastructure_assets(asset_id)
);

CREATE TABLE IF NOT EXISTS telemetry_readings (
    reading_id INTEGER PRIMARY KEY AUTOINCREMENT,
    sensor_id TEXT NOT NULL,
    observed_at TEXT NOT NULL,
    observed_value REAL NOT NULL,
    battery_voltage REAL,
    signal_quality REAL,
    payload_bytes INTEGER,
    transmitted INTEGER NOT NULL CHECK (transmitted IN (0, 1)),
    quality_flag TEXT NOT NULL,
    FOREIGN KEY (sensor_id) REFERENCES infrastructure_sensors(sensor_id)
);

CREATE TABLE IF NOT EXISTS maintenance_events (
    maintenance_id INTEGER PRIMARY KEY AUTOINCREMENT,
    asset_id TEXT NOT NULL,
    event_time TEXT NOT NULL,
    maintenance_type TEXT NOT NULL,
    severity TEXT NOT NULL,
    notes TEXT,
    FOREIGN KEY (asset_id) REFERENCES infrastructure_assets(asset_id)
);

CREATE TABLE IF NOT EXISTS disaster_events (
    disaster_event_id INTEGER PRIMARY KEY AUTOINCREMENT,
    event_time TEXT NOT NULL,
    event_type TEXT NOT NULL,
    affected_sector TEXT NOT NULL,
    severity TEXT NOT NULL,
    latitude REAL,
    longitude REAL,
    notes TEXT
);

CREATE TABLE IF NOT EXISTS infrastructure_alerts (
    alert_id INTEGER PRIMARY KEY AUTOINCREMENT,
    sensor_id TEXT NOT NULL,
    observed_at TEXT NOT NULL,
    alert_type TEXT NOT NULL,
    severity TEXT NOT NULL,
    observed_value REAL NOT NULL,
    threshold_value REAL NOT NULL,
    handled_locally INTEGER NOT NULL CHECK (handled_locally IN (0, 1)),
    FOREIGN KEY (sensor_id) REFERENCES infrastructure_sensors(sensor_id)
);
