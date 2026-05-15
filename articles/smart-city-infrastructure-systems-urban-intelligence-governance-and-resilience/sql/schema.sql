DROP TABLE IF EXISTS urban_infrastructure_inventory;
DROP TABLE IF EXISTS urban_observability_records;
DROP TABLE IF EXISTS cross_domain_dependency_edges;
DROP TABLE IF EXISTS public_value_indicator_catalog;
DROP TABLE IF EXISTS digital_inclusion_rights_review;
DROP TABLE IF EXISTS smart_city_governance_response_log;

CREATE TABLE urban_infrastructure_inventory (
  infrastructure_id TEXT PRIMARY KEY,
  asset_name TEXT,
  domain TEXT,
  service_zone_id TEXT,
  responsible_agency TEXT,
  asset_type TEXT,
  criticality TEXT,
  latitude REAL,
  longitude REAL,
  domain_failure_probability REAL
);

CREATE TABLE urban_observability_records (
  record_id TEXT PRIMARY KEY,
  infrastructure_id TEXT,
  timestamp TEXT,
  domain TEXT,
  indicator_name TEXT,
  observed_service_capacity REAL,
  normal_service_capacity REAL,
  data_quality_score REAL,
  coverage_score REAL,
  interoperability_score REAL,
  governance_response_score REAL,
  latency_seconds REAL,
  quality_flag TEXT
);

CREATE TABLE cross_domain_dependency_edges (
  edge_id TEXT PRIMARY KEY,
  source_infrastructure_id TEXT,
  target_infrastructure_id TEXT,
  dependency_type TEXT,
  dependency_weight REAL,
  coordination_issue TEXT,
  mitigation_note TEXT
);

CREATE TABLE public_value_indicator_catalog (
  domain TEXT,
  indicator_name TEXT,
  accessibility_score REAL,
  resilience_score REAL,
  inclusion_score REAL,
  trust_score REAL,
  unequal_burden_score REAL,
  interpretation TEXT
);

CREATE TABLE digital_inclusion_rights_review (
  service_zone_id TEXT PRIMARY KEY,
  zone_name TEXT,
  population_exposed TEXT,
  digital_access_gap_score REAL,
  language_access_gap_score REAL,
  disability_access_gap_score REAL,
  offline_service_gap_score REAL,
  privacy_risk_score REAL,
  public_review_status TEXT
);

CREATE TABLE smart_city_governance_response_log (
  governance_id TEXT PRIMARY KEY,
  date TEXT,
  infrastructure_id TEXT,
  decision TEXT,
  owner TEXT,
  status TEXT,
  public_note_required TEXT
);
