DROP TABLE IF EXISTS hazard_stress_register;
DROP TABLE IF EXISTS critical_service_inventory;
DROP TABLE IF EXISTS infrastructure_dependency_edges;
DROP TABLE IF EXISTS continuity_recovery_plan;
DROP TABLE IF EXISTS vulnerability_service_equity_review;
DROP TABLE IF EXISTS nature_based_resilience_register;
DROP TABLE IF EXISTS urban_resilience_governance_log;

CREATE TABLE hazard_stress_register (
  hazard_id TEXT PRIMARY KEY,
  service_zone_id TEXT,
  hazard_type TEXT,
  hazard_class TEXT,
  hazard_intensity REAL,
  exposure_score REAL,
  likely_service_impacts TEXT,
  scenario_note TEXT
);

CREATE TABLE critical_service_inventory (
  service_id TEXT PRIMARY KEY,
  service_zone_id TEXT,
  service_name TEXT,
  service_domain TEXT,
  responsible_owner TEXT,
  normal_capacity REAL,
  criticality TEXT,
  target_recovery_hours REAL,
  service_failure_probability REAL
);

CREATE TABLE infrastructure_dependency_edges (
  edge_id TEXT PRIMARY KEY,
  source_service_id TEXT,
  dependent_service_id TEXT,
  dependency_type TEXT,
  dependency_weight REAL,
  failure_mode TEXT,
  mitigation_note TEXT
);

CREATE TABLE continuity_recovery_plan (
  service_id TEXT PRIMARY KEY,
  disruption_capacity REAL,
  expected_recovery_hours REAL,
  redundancy_score REAL,
  maintainability_score REAL,
  adaptability_score REAL,
  governance_response_score REAL,
  continuity_plan_status TEXT
);

CREATE TABLE vulnerability_service_equity_review (
  service_zone_id TEXT PRIMARY KEY,
  zone_name TEXT,
  population_exposed TEXT,
  vulnerability_score REAL,
  service_access_gap REAL,
  recovery_capacity_score REAL,
  equity_gap_score REAL,
  community_feedback_status TEXT
);

CREATE TABLE nature_based_resilience_register (
  nbs_id TEXT PRIMARY KEY,
  service_zone_id TEXT,
  asset_name TEXT,
  nature_based_type TEXT,
  resilience_function TEXT,
  condition_score REAL,
  maintenance_status TEXT,
  equity_access_status TEXT
);

CREATE TABLE urban_resilience_governance_log (
  governance_id TEXT PRIMARY KEY,
  date TEXT,
  service_id TEXT,
  decision TEXT,
  owner TEXT,
  status TEXT,
  public_note_required TEXT
);
