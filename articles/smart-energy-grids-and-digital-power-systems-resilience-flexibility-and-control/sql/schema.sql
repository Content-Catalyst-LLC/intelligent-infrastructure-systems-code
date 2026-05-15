DROP TABLE IF EXISTS grid_asset_inventory;
DROP TABLE IF EXISTS grid_telemetry_records;
DROP TABLE IF EXISTS distributed_resource_coordination_register;
DROP TABLE IF EXISTS grid_reliability_resilience_review;
DROP TABLE IF EXISTS cyber_physical_grid_review;
DROP TABLE IF EXISTS grid_governance_interoperability_log;

CREATE TABLE grid_asset_inventory (
  asset_id TEXT PRIMARY KEY,
  asset_name TEXT,
  asset_class TEXT,
  domain TEXT,
  service_zone_id TEXT,
  grid_node_id TEXT,
  owner_operator TEXT,
  criticality TEXT,
  commission_year INTEGER,
  latitude REAL,
  longitude REAL,
  nominal_capacity_mw REAL
);

CREATE TABLE grid_telemetry_records (
  telemetry_id TEXT PRIMARY KEY,
  asset_id TEXT,
  timestamp TEXT,
  voltage_pu REAL,
  frequency_hz REAL,
  current_a REAL,
  power_flow_mw REAL,
  loading_percent REAL,
  load_mw REAL,
  available_supply_mw REAL,
  allowed_voltage_deviation_pu REAL,
  served_hours REAL,
  required_service_hours REAL,
  telemetry_reliability_score REAL,
  data_quality_score REAL,
  coverage_score REAL,
  metadata_completeness_score REAL,
  latency_seconds REAL,
  quality_flag TEXT
);

CREATE TABLE distributed_resource_coordination_register (
  service_zone_id TEXT PRIMARY KEY,
  zone_name TEXT,
  available_flexibility_mw REAL,
  flexibility_need_mw REAL,
  storage_flexibility_mw REAL,
  demand_response_mw REAL,
  der_flexibility_mw REAL,
  interconnection_support_mw REAL,
  dispatch_coordination_score REAL,
  customer_protection_score REAL,
  primary_flexibility_issue TEXT
);

CREATE TABLE grid_reliability_resilience_review (
  service_zone_id TEXT PRIMARY KEY,
  zone_name TEXT,
  outage_events_12mo INTEGER,
  mean_restoration_minutes REAL,
  backup_capability_score REAL,
  response_capacity_score REAL,
  exposure_risk_score REAL,
  resilience_review_status TEXT
);

CREATE TABLE cyber_physical_grid_review (
  service_zone_id TEXT PRIMARY KEY,
  scada_visibility_score REAL,
  device_inventory_score REAL,
  remote_access_risk_score REAL,
  segmentation_gap_score REAL,
  firmware_governance_score REAL,
  incident_readiness_score REAL,
  cyber_physical_risk_score REAL,
  cyber_review_status TEXT
);

CREATE TABLE grid_governance_interoperability_log (
  governance_id TEXT PRIMARY KEY,
  date TEXT,
  asset_id TEXT,
  service_zone_id TEXT,
  decision TEXT,
  owner TEXT,
  status TEXT,
  public_note_required TEXT
);
