DROP TABLE IF EXISTS climate_scenario_manifest;
DROP TABLE IF EXISTS infrastructure_exposure_inventory;
DROP TABLE IF EXISTS vulnerability_adaptive_capacity;
DROP TABLE IF EXISTS adaptation_option_portfolio;
DROP TABLE IF EXISTS adaptation_finance_implementation_log;
DROP TABLE IF EXISTS maladaptation_review;
DROP TABLE IF EXISTS adaptation_governance_log;

CREATE TABLE climate_scenario_manifest (
  scenario_id TEXT PRIMARY KEY,
  hazard_type TEXT,
  time_horizon INTEGER,
  scenario_assumption TEXT,
  uncertainty_note TEXT,
  source_note TEXT,
  status TEXT
);

CREATE TABLE infrastructure_exposure_inventory (
  system_id TEXT PRIMARY KEY,
  asset_name TEXT,
  sector TEXT,
  community_id TEXT,
  hazard_type TEXT,
  service_role TEXT,
  criticality TEXT,
  condition_status TEXT,
  hazard_intensity REAL,
  exposure_score REAL,
  sensitivity_score REAL,
  adaptive_capacity_score REAL
);

CREATE TABLE vulnerability_adaptive_capacity (
  community_id TEXT PRIMARY KEY,
  community_name TEXT,
  vulnerable_population_share REAL,
  affordability_risk REAL,
  service_access_risk REAL,
  health_sensitivity_score REAL,
  community_priority_status TEXT
);

CREATE TABLE adaptation_option_portfolio (
  adaptation_id TEXT PRIMARY KEY,
  system_id TEXT,
  option_name TEXT,
  option_type TEXT,
  option_effectiveness REAL,
  maladaptation_penalty REAL,
  option_quality REAL,
  maintenance_need TEXT,
  review_status TEXT
);

CREATE TABLE adaptation_finance_implementation_log (
  adaptation_id TEXT PRIMARY KEY,
  funding_source TEXT,
  estimated_cost_millions REAL,
  finance_readiness REAL,
  delivery_readiness REAL,
  operations_readiness REAL,
  monitoring_readiness REAL,
  governance_readiness REAL,
  implementation_status TEXT,
  governance_owner TEXT
);

CREATE TABLE maladaptation_review (
  adaptation_id TEXT PRIMARY KEY,
  risk_transfer TEXT,
  lock_in_risk TEXT,
  ecological_damage_risk TEXT,
  emissions_rebound_risk TEXT,
  unequal_protection_risk TEXT,
  overall_maladaptation_flag TEXT,
  review_note TEXT
);

CREATE TABLE adaptation_governance_log (
  governance_id TEXT PRIMARY KEY,
  date TEXT,
  adaptation_id TEXT,
  decision TEXT,
  owner TEXT,
  status TEXT,
  public_note_required TEXT
);
