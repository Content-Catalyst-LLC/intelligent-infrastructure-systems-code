DROP TABLE IF EXISTS renewable_asset_inventory;
DROP TABLE IF EXISTS grid_connection_constraint_register;
DROP TABLE IF EXISTS renewable_generation_forecast_records;
DROP TABLE IF EXISTS storage_flexibility_register;
DROP TABLE IF EXISTS renewable_reliability_resilience_review;
DROP TABLE IF EXISTS renewable_governance_planning_log;

CREATE TABLE renewable_asset_inventory (
  asset_id TEXT PRIMARY KEY,
  asset_name TEXT,
  technology TEXT,
  asset_class TEXT,
  grid_node_id TEXT,
  service_zone_id TEXT,
  flexibility_zone_id TEXT,
  owner_operator TEXT,
  criticality TEXT,
  commission_year INTEGER,
  latitude REAL,
  longitude REAL,
  nominal_capacity_mw REAL
);

CREATE TABLE grid_connection_constraint_register (
  grid_node_id TEXT PRIMARY KEY,
  node_name TEXT,
  connection_capacity_mw REAL,
  grid_transfer_capacity_mw REAL,
  hosting_capacity_mw REAL,
  interconnection_status TEXT,
  congestion_score REAL,
  reinforcement_need_score REAL,
  queue_position INTEGER,
  permitting_status TEXT
);

CREATE TABLE renewable_generation_forecast_records (
  record_id TEXT PRIMARY KEY,
  asset_id TEXT,
  timestamp TEXT,
  forecast_generation_mw REAL,
  actual_generation_mw REAL,
  resource_condition_score REAL,
  forecast_quality_score REAL,
  availability_score REAL,
  available_storage_charge_mw REAL,
  quality_flag TEXT
);

CREATE TABLE storage_flexibility_register (
  flexibility_zone_id TEXT PRIMARY KEY,
  zone_name TEXT,
  available_flexibility_mw REAL,
  flexibility_need_mw REAL,
  storage_readiness_score REAL,
  demand_response_readiness_score REAL,
  interconnection_support_score REAL,
  dispatch_coordination_score REAL,
  primary_flexibility_issue TEXT
);

CREATE TABLE renewable_reliability_resilience_review (
  service_zone_id TEXT PRIMARY KEY,
  zone_name TEXT,
  service_continuity_score REAL,
  resilience_score REAL,
  fallback_capacity_score REAL,
  islanding_relevance_score REAL,
  restoration_support_score REAL,
  weather_exposure_score REAL,
  resilience_review_status TEXT
);

CREATE TABLE renewable_governance_planning_log (
  governance_id TEXT PRIMARY KEY,
  date TEXT,
  asset_id TEXT,
  grid_node_id TEXT,
  decision TEXT,
  owner TEXT,
  status TEXT,
  public_note_required TEXT
);
