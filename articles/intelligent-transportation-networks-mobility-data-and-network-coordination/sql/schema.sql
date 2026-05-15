DROP TABLE IF EXISTS transport_network_inventory;
DROP TABLE IF EXISTS mobility_telemetry_sample;
DROP TABLE IF EXISTS service_performance_review;
DROP TABLE IF EXISTS multimodal_coordination_edges;
DROP TABLE IF EXISTS safety_accessibility_review;
DROP TABLE IF EXISTS transport_governance_operations_log;

CREATE TABLE transport_network_inventory (
  network_element_id TEXT PRIMARY KEY,
  network_element_name TEXT,
  mode TEXT,
  service_zone_id TEXT,
  operator TEXT,
  element_type TEXT,
  criticality TEXT,
  latitude REAL,
  longitude REAL
);

CREATE TABLE mobility_telemetry_sample (
  telemetry_id TEXT PRIMARY KEY,
  network_element_id TEXT,
  timestamp TEXT,
  metric TEXT,
  value REAL,
  unit TEXT,
  quality_flag TEXT,
  latency_seconds REAL
);

CREATE TABLE service_performance_review (
  network_element_id TEXT PRIMARY KEY,
  travel_time_mean_minutes REAL,
  travel_time_std_minutes REAL,
  target_recovery_minutes REAL,
  expected_recovery_minutes REAL,
  accessibility_score REAL,
  safety_score REAL,
  coordination_score REAL,
  emissions_burden_score REAL
);

CREATE TABLE multimodal_coordination_edges (
  edge_id TEXT PRIMARY KEY,
  source_element_id TEXT,
  target_element_id TEXT,
  dependency_type TEXT,
  dependency_weight REAL,
  coordination_issue TEXT,
  mitigation_note TEXT
);

CREATE TABLE safety_accessibility_review (
  service_zone_id TEXT PRIMARY KEY,
  zone_name TEXT,
  population_exposed TEXT,
  accessibility_gap_score REAL,
  safety_risk_score REAL,
  digital_access_gap_score REAL,
  disability_access_gap_score REAL,
  public_review_status TEXT
);

CREATE TABLE transport_governance_operations_log (
  governance_id TEXT PRIMARY KEY,
  date TEXT,
  network_element_id TEXT,
  decision TEXT,
  owner TEXT,
  status TEXT,
  public_note_required TEXT
);
