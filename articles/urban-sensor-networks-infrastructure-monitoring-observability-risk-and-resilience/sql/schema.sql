DROP TABLE IF EXISTS urban_sensor_inventory;
DROP TABLE IF EXISTS urban_sensor_telemetry_sample;
DROP TABLE IF EXISTS sensor_asset_linkage;
DROP TABLE IF EXISTS calibration_device_health_log;
DROP TABLE IF EXISTS coverage_exposure_review;
DROP TABLE IF EXISTS urban_sensor_indicator_catalog;
DROP TABLE IF EXISTS urban_sensor_governance_log;

CREATE TABLE urban_sensor_inventory (
  sensor_id TEXT PRIMARY KEY,
  sensor_name TEXT,
  domain TEXT,
  platform_type TEXT,
  latitude REAL,
  longitude REAL,
  operator TEXT,
  operational_status TEXT,
  variable TEXT,
  firmware_version TEXT
);

CREATE TABLE urban_sensor_telemetry_sample (
  telemetry_id TEXT PRIMARY KEY,
  sensor_id TEXT,
  timestamp TEXT,
  domain TEXT,
  variable TEXT,
  value REAL,
  unit TEXT,
  quality_flag TEXT,
  latency_seconds REAL
);

CREATE TABLE sensor_asset_linkage (
  sensor_id TEXT PRIMARY KEY,
  asset_id TEXT,
  asset_name TEXT,
  service_zone_id TEXT,
  responsible_agency TEXT,
  asset_criticality TEXT,
  service_relevance_score REAL
);

CREATE TABLE calibration_device_health_log (
  sensor_id TEXT PRIMARY KEY,
  calibration_status TEXT,
  last_calibration_date TEXT,
  battery_status TEXT,
  uptime_score REAL,
  calibration_score REAL,
  metadata_score REAL,
  provenance_score REAL,
  device_health_status TEXT
);

CREATE TABLE coverage_exposure_review (
  service_zone_id TEXT PRIMARY KEY,
  zone_name TEXT,
  population_exposed TEXT,
  critical_assets_observed INTEGER,
  critical_assets_needed INTEGER,
  coverage_score REAL,
  exposure_score REAL,
  vulnerability_score REAL,
  interoperability_score REAL,
  governance_response_score REAL,
  review_status TEXT
);

CREATE TABLE urban_sensor_indicator_catalog (
  domain TEXT,
  variable TEXT,
  indicator_name TEXT,
  threshold_value REAL,
  threshold_unit TEXT,
  max_acceptable_latency_seconds REAL,
  interpretation TEXT
);

CREATE TABLE urban_sensor_governance_log (
  governance_id TEXT PRIMARY KEY,
  date TEXT,
  sensor_id TEXT,
  decision TEXT,
  owner TEXT,
  status TEXT,
  public_note_required TEXT
);
