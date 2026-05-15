DROP TABLE IF EXISTS monitoring_site_inventory;
DROP TABLE IF EXISTS environmental_observations_sample;
DROP TABLE IF EXISTS environmental_threshold_indicator_catalog;
DROP TABLE IF EXISTS calibration_device_health_log;
DROP TABLE IF EXISTS coverage_equity_review;
DROP TABLE IF EXISTS environmental_governance_log;

CREATE TABLE monitoring_site_inventory (
  site_id TEXT PRIMARY KEY,
  monitoring_zone_id TEXT,
  site_name TEXT,
  domain TEXT,
  platform_type TEXT,
  latitude REAL,
  longitude REAL,
  operator TEXT,
  operational_status TEXT,
  primary_variable TEXT
);

CREATE TABLE environmental_observations_sample (
  observation_id TEXT PRIMARY KEY,
  site_id TEXT,
  timestamp TEXT,
  domain TEXT,
  variable TEXT,
  value REAL,
  unit TEXT,
  method TEXT,
  quality_flag TEXT
);

CREATE TABLE environmental_threshold_indicator_catalog (
  domain TEXT,
  variable TEXT,
  indicator_name TEXT,
  threshold_value REAL,
  threshold_unit TEXT,
  threshold_basis TEXT,
  interpretation TEXT
);

CREATE TABLE calibration_device_health_log (
  site_id TEXT PRIMARY KEY,
  calibration_status TEXT,
  telemetry_status TEXT,
  battery_status TEXT,
  last_calibration_date TEXT,
  record_completeness REAL,
  calibration_score REAL,
  metadata_score REAL,
  provenance_score REAL,
  sampling_design_score REAL
);

CREATE TABLE coverage_equity_review (
  monitoring_zone_id TEXT PRIMARY KEY,
  zone_name TEXT,
  population_exposed TEXT,
  ecosystem_exposed TEXT,
  coverage_gap_score REAL,
  exposure_score REAL,
  vulnerability_score REAL,
  governance_response_score REAL,
  review_status TEXT
);

CREATE TABLE environmental_governance_log (
  governance_id TEXT PRIMARY KEY,
  date TEXT,
  site_id TEXT,
  decision TEXT,
  owner TEXT,
  status TEXT,
  public_note_required TEXT
);
