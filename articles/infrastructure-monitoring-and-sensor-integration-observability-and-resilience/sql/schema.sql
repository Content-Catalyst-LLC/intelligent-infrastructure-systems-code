DROP TABLE IF EXISTS sensor_inventory;
DROP TABLE IF EXISTS monitored_asset_registry;
DROP TABLE IF EXISTS sensor_telemetry_records;
DROP TABLE IF EXISTS calibration_validation_log;
DROP TABLE IF EXISTS coverage_blindspot_review;
DROP TABLE IF EXISTS monitoring_alert_response_register;

CREATE TABLE sensor_inventory (
  sensor_id TEXT PRIMARY KEY,
  sensor_name TEXT,
  sensor_type TEXT,
  measurement_name TEXT,
  asset_id TEXT,
  source_system_id TEXT,
  unit TEXT,
  sampling_interval_seconds REAL,
  communication_path TEXT,
  owner TEXT,
  criticality TEXT,
  has_sensor_id INTEGER,
  has_asset_id INTEGER,
  has_location INTEGER,
  has_unit INTEGER,
  has_timestamp_source INTEGER,
  has_owner INTEGER,
  has_quality_flag INTEGER,
  has_valid_use INTEGER
);

CREATE TABLE monitored_asset_registry (
  asset_id TEXT PRIMARY KEY,
  asset_name TEXT,
  asset_class TEXT,
  infrastructure_domain TEXT,
  service_zone_id TEXT,
  source_system_id TEXT,
  owner_operator TEXT,
  criticality TEXT,
  latitude REAL,
  longitude REAL,
  active_status TEXT
);

CREATE TABLE sensor_telemetry_records (
  telemetry_id TEXT PRIMARY KEY,
  sensor_id TEXT,
  timestamp TEXT,
  measurement_value REAL,
  expected_readings REAL,
  missing_readings REAL,
  late_readings REAL,
  invalid_readings REAL,
  latency_seconds REAL,
  device_health_score REAL,
  accuracy_score REAL,
  precision_score REAL,
  completeness_score REAL,
  validity_score REAL,
  freshness_score REAL,
  quality_flag TEXT
);

CREATE TABLE calibration_validation_log (
  calibration_id TEXT PRIMARY KEY,
  sensor_id TEXT,
  last_calibration_date TEXT,
  calibration_method TEXT,
  drift_status TEXT,
  field_validation_score REAL,
  maintenance_status TEXT,
  replacement_recommended TEXT,
  calibration_owner TEXT
);

CREATE TABLE coverage_blindspot_review (
  service_zone_id TEXT PRIMARY KEY,
  zone_name TEXT,
  infrastructure_domain TEXT,
  critical_assets REAL,
  monitored_critical_assets REAL,
  total_service_zones REAL,
  unmonitored_high_risk_zones REAL,
  coverage_review_status TEXT,
  primary_blindspot TEXT
);

CREATE TABLE monitoring_alert_response_register (
  alert_id TEXT PRIMARY KEY,
  date TEXT,
  sensor_id TEXT,
  asset_id TEXT,
  service_zone_id TEXT,
  alert_type TEXT,
  threshold_or_rule TEXT,
  response_owner TEXT,
  response_status TEXT,
  public_note_required TEXT
);
