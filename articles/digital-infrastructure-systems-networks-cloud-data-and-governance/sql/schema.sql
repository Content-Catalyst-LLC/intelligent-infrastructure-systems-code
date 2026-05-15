DROP TABLE IF EXISTS connectivity_infrastructure_inventory;
DROP TABLE IF EXISTS cloud_data_infrastructure_register;
DROP TABLE IF EXISTS interoperability_exchange_register;
DROP TABLE IF EXISTS identity_trust_register;
DROP TABLE IF EXISTS digital_dependency_continuity_review;
DROP TABLE IF EXISTS access_inclusion_review;
DROP TABLE IF EXISTS digital_infrastructure_governance_action_log;

CREATE TABLE connectivity_infrastructure_inventory (
  service_zone_id TEXT PRIMARY KEY,
  region_name TEXT,
  infrastructure_context TEXT,
  users_needing_access REAL,
  users_with_affordable_reliable_access REAL,
  bandwidth_score REAL,
  latency_score REAL,
  uptime_score REAL,
  redundancy_score REAL,
  coverage_status TEXT,
  primary_gap TEXT
);

CREATE TABLE cloud_data_infrastructure_register (
  service_zone_id TEXT PRIMARY KEY,
  primary_cloud_provider TEXT,
  secondary_provider_available TEXT,
  cloud_region_count REAL,
  data_center_dependency TEXT,
  edge_node_count REAL,
  compute_capacity_score REAL,
  storage_capacity_score REAL,
  geo_redundancy_score REAL,
  edge_readiness_score REAL,
  portability_status TEXT
);

CREATE TABLE interoperability_exchange_register (
  service_zone_id TEXT PRIMARY KEY,
  systems_requiring_exchange REAL,
  systems_using_shared_standards REAL,
  api_catalog_available TEXT,
  schema_catalog_available TEXT,
  data_exchange_agreement_status TEXT,
  metadata_quality_score REAL,
  interoperability_review_status TEXT
);

CREATE TABLE identity_trust_register (
  service_zone_id TEXT PRIMARY KEY,
  identity_system_type TEXT,
  mfa_coverage_score REAL,
  consent_architecture_status TEXT,
  security_control_score REAL,
  privacy_safeguard_score REAL,
  auditability_score REAL,
  recovery_readiness_score REAL,
  governance_maturity_score REAL,
  rights_review_status TEXT
);

CREATE TABLE digital_dependency_continuity_review (
  service_zone_id TEXT PRIMARY KEY,
  critical_digital_services REAL,
  critical_services_dependent_on_concentrated_providers REAL,
  backup_status TEXT,
  failover_tested TEXT,
  recovery_time_objective_hours REAL,
  recovery_readiness_notes TEXT,
  exposure_score REAL,
  continuity_review_status TEXT
);

CREATE TABLE access_inclusion_review (
  service_zone_id TEXT PRIMARY KEY,
  affordability_score REAL,
  accessibility_score REAL,
  language_support_score REAL,
  device_access_score REAL,
  assisted_service_availability_score REAL,
  documentation_burden_score REAL,
  exclusion_risk_score REAL,
  primary_exclusion_risk TEXT
);

CREATE TABLE digital_infrastructure_governance_action_log (
  governance_action_id TEXT PRIMARY KEY,
  date TEXT,
  service_zone_id TEXT,
  decision TEXT,
  owner TEXT,
  status TEXT,
  public_note_required TEXT
);
