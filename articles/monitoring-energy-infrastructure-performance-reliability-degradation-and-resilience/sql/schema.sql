DROP TABLE IF EXISTS energy_asset_inventory;
DROP TABLE IF EXISTS energy_performance_telemetry;
DROP TABLE IF EXISTS condition_degradation_log;
DROP TABLE IF EXISTS reliability_resilience_review;
DROP TABLE IF EXISTS power_quality_stability_records;
DROP TABLE IF EXISTS energy_governance_maintenance_log;

CREATE TABLE energy_asset_inventory (
  asset_id TEXT PRIMARY KEY,
  asset_name TEXT,
  asset_class TEXT,
  service_zone_id TEXT,
  owner_operator TEXT,
  criticality TEXT,
  commission_year INTEGER,
  latitude REAL,
  longitude REAL,
  nominal_capacity_mw REAL
);

CREATE TABLE energy_performance_telemetry (
  telemetry_id TEXT PRIMARY KEY,
  asset_id TEXT,
  timestamp TEXT,
  available_hours REAL,
  total_hours REAL,
  power_served_mw REAL,
  power_demand_mw REAL,
  loading_percent REAL,
  temperature_c REAL,
  voltage_pu REAL,
  current_a REAL,
  efficiency_score REAL,
  latency_seconds REAL,
  quality_flag TEXT
);

CREATE TABLE condition_degradation_log (
  asset_id TEXT PRIMARY KEY,
  baseline_health_score REAL,
  current_health_score REAL,
  loading_stress_score REAL,
  thermal_stress_score REAL,
  cycling_stress_score REAL,
  environmental_exposure_score REAL,
  last_inspection_date TEXT,
  maintenance_status TEXT
);

CREATE TABLE reliability_resilience_review (
  asset_id TEXT PRIMARY KEY,
  outage_events_12mo INTEGER,
  mean_restoration_minutes REAL,
  fallback_capacity_score REAL,
  observability_score REAL,
  restoration_time_score REAL,
  black_start_or_islanding_relevance TEXT,
  resilience_review_status TEXT
);

CREATE TABLE power_quality_stability_records (
  asset_id TEXT PRIMARY KEY,
  voltage_deviation_score REAL,
  frequency_deviation_score REAL,
  harmonics_score REAL,
  reactive_power_imbalance_score REAL,
  power_quality_risk_score REAL,
  stability_review_status TEXT
);

CREATE TABLE energy_governance_maintenance_log (
  governance_id TEXT PRIMARY KEY,
  date TEXT,
  asset_id TEXT,
  decision TEXT,
  owner TEXT,
  status TEXT,
  public_note_required TEXT
);
