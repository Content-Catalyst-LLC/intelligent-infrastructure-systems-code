DROP TABLE IF EXISTS water_asset_inventory;
DROP TABLE IF EXISTS water_telemetry_records;
DROP TABLE IF EXISTS water_quality_public_health_review;
DROP TABLE IF EXISTS leakage_hydraulic_control_review;
DROP TABLE IF EXISTS wastewater_stormwater_risk_review;
DROP TABLE IF EXISTS water_governance_response_log;

CREATE TABLE water_asset_inventory (
  asset_id TEXT PRIMARY KEY,
  asset_name TEXT,
  asset_class TEXT,
  domain TEXT,
  service_zone_id TEXT,
  hydraulic_zone_id TEXT,
  owner_operator TEXT,
  criticality TEXT,
  commission_year INTEGER,
  latitude REAL,
  longitude REAL,
  design_capacity_m3d REAL
);

CREATE TABLE water_telemetry_records (
  telemetry_id TEXT PRIMARY KEY,
  asset_id TEXT,
  timestamp TEXT,
  pressure_psi REAL,
  flow_m3h REAL,
  tank_level_m REAL,
  turbidity_ntu REAL,
  chlorine_mg_l REAL,
  ph REAL,
  conductivity_us_cm REAL,
  rainfall_mm REAL,
  pump_status TEXT,
  telemetry_reliability_score REAL,
  data_quality_score REAL,
  coverage_score REAL,
  metadata_completeness_score REAL,
  latency_seconds REAL,
  quality_flag TEXT
);

CREATE TABLE water_quality_public_health_review (
  service_zone_id TEXT PRIMARY KEY,
  zone_name TEXT,
  tested_observations INTEGER,
  compliant_observations INTEGER,
  turbidity_exceedance_count INTEGER,
  chlorine_low_count INTEGER,
  contamination_risk_score REAL,
  treatment_stability_score REAL,
  public_health_review_status TEXT
);

CREATE TABLE leakage_hydraulic_control_review (
  service_zone_id TEXT PRIMARY KEY,
  minimum_pressure_psi REAL,
  maximum_pressure_psi REAL,
  system_input_volume_m3 REAL,
  authorized_consumption_m3 REAL,
  breaks_12mo INTEGER,
  leak_detection_score REAL,
  pressure_management_score REAL,
  backup_capacity_score REAL,
  response_capacity_score REAL
);

CREATE TABLE wastewater_stormwater_risk_review (
  service_zone_id TEXT PRIMARY KEY,
  inflow_infiltration_score REAL,
  sewer_level_risk_score REAL,
  overflow_risk_score REAL,
  drainage_capacity_score REAL,
  flood_exposure_score REAL,
  exposure_risk_score REAL,
  stormwater_review_status TEXT
);

CREATE TABLE water_governance_response_log (
  governance_id TEXT PRIMARY KEY,
  date TEXT,
  asset_id TEXT,
  service_zone_id TEXT,
  decision TEXT,
  owner TEXT,
  status TEXT,
  public_note_required TEXT
);
