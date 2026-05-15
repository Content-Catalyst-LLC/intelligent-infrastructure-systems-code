DROP TABLE IF EXISTS essential_climate_variable_map;
DROP TABLE IF EXISTS climate_observation_platforms;
DROP TABLE IF EXISTS instrument_metadata_calibration_log;
DROP TABLE IF EXISTS climate_observations_sample;
DROP TABLE IF EXISTS climate_archive_manifest;
DROP TABLE IF EXISTS climate_governance_log;

CREATE TABLE essential_climate_variable_map (
  ecv_id TEXT PRIMARY KEY,
  domain TEXT,
  variable TEXT,
  measurement_unit TEXT,
  monitoring_purpose TEXT,
  example_platform TEXT
);

CREATE TABLE climate_observation_platforms (
  station_id TEXT PRIMARY KEY,
  station_name TEXT,
  platform_type TEXT,
  domain TEXT,
  latitude REAL,
  longitude REAL,
  elevation_m REAL,
  owner TEXT,
  operational_status TEXT,
  record_start TEXT,
  record_end TEXT
);

CREATE TABLE instrument_metadata_calibration_log (
  station_id TEXT,
  instrument_type TEXT,
  variable TEXT,
  calibration_status TEXT,
  metadata_status TEXT,
  last_calibration_date TEXT,
  known_breakpoint TEXT,
  breakpoint_note TEXT,
  provenance_status TEXT
);

CREATE TABLE climate_observations_sample (
  station_id TEXT,
  date TEXT,
  variable TEXT,
  value REAL,
  unit TEXT,
  quality_flag TEXT
);

CREATE TABLE climate_archive_manifest (
  dataset_id TEXT PRIMARY KEY,
  dataset_name TEXT,
  version TEXT,
  domain TEXT,
  source TEXT,
  archive_status TEXT,
  provenance_status TEXT,
  access_policy TEXT,
  quality_flag_policy TEXT
);

CREATE TABLE climate_governance_log (
  governance_id TEXT PRIMARY KEY,
  date TEXT,
  station_id TEXT,
  decision TEXT,
  owner TEXT,
  status TEXT,
  public_note_required TEXT
);
