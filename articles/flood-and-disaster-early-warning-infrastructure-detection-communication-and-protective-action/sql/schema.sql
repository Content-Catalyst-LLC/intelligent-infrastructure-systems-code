DROP TABLE IF EXISTS hazard_exposure_register;
DROP TABLE IF EXISTS observation_network_inventory;
DROP TABLE IF EXISTS forecast_product_register;
DROP TABLE IF EXISTS warning_channel_register;
DROP TABLE IF EXISTS preparedness_action_log;
DROP TABLE IF EXISTS accessibility_inclusion_review;
DROP TABLE IF EXISTS governance_after_action_log;

CREATE TABLE hazard_exposure_register (
  hazard_id TEXT PRIMARY KEY,
  warning_zone_id TEXT,
  community_name TEXT,
  hazard_type TEXT,
  criticality TEXT,
  hazard_severity REAL,
  exposure_score REAL,
  vulnerability_score REAL,
  lead_time_need_minutes REAL,
  primary_protective_action TEXT
);

CREATE TABLE observation_network_inventory (
  observation_id TEXT PRIMARY KEY,
  hazard_id TEXT,
  asset_name TEXT,
  observation_type TEXT,
  owner TEXT,
  telemetry_status TEXT,
  calibration_status TEXT,
  uptime_score REAL,
  maintenance_status TEXT,
  detection_reliability REAL
);

CREATE TABLE forecast_product_register (
  forecast_id TEXT PRIMARY KEY,
  hazard_id TEXT,
  forecast_name TEXT,
  forecast_type TEXT,
  model_owner TEXT,
  forecast_lead_time_minutes REAL,
  decision_delay_minutes REAL,
  uncertainty_level TEXT,
  threshold_status TEXT,
  impact_interpretation_status TEXT
);

CREATE TABLE warning_channel_register (
  channel_id TEXT PRIMARY KEY,
  warning_zone_id TEXT,
  primary_channel TEXT,
  secondary_channel TEXT,
  community_channel TEXT,
  population_reach REAL,
  message_comprehension REAL,
  trust_score REAL,
  communication_delay_minutes REAL,
  channel_test_status TEXT
);

CREATE TABLE preparedness_action_log (
  preparedness_id TEXT PRIMARY KEY,
  warning_zone_id TEXT,
  protective_action_plan TEXT,
  shelter_status TEXT,
  evacuation_route_status TEXT,
  drill_status TEXT,
  mobilization_time_minutes REAL,
  action_capacity REAL,
  preparedness_owner TEXT
);

CREATE TABLE accessibility_inclusion_review (
  review_id TEXT PRIMARY KEY,
  warning_zone_id TEXT,
  language_access TEXT,
  disability_access TEXT,
  device_access_gap TEXT,
  mobility_support TEXT,
  community_trust_status TEXT,
  accessibility_readiness REAL,
  review_status TEXT
);

CREATE TABLE governance_after_action_log (
  governance_id TEXT PRIMARY KEY,
  date TEXT,
  warning_zone_id TEXT,
  decision TEXT,
  owner TEXT,
  status TEXT,
  public_note_required TEXT
);
