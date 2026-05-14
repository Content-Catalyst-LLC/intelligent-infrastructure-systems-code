DROP TABLE IF EXISTS asset_service_register;
DROP TABLE IF EXISTS observability_registry;
DROP TABLE IF EXISTS interoperability_map;
DROP TABLE IF EXISTS ai_analytics_registry;
DROP TABLE IF EXISTS cyber_resilience_controls;
DROP TABLE IF EXISTS resilience_scenario_manifest;
DROP TABLE IF EXISTS infrastructure_intelligence_kpis;
DROP TABLE IF EXISTS decision_intervention_log;
DROP TABLE IF EXISTS governance_review_log;

CREATE TABLE asset_service_register (
  system_id TEXT PRIMARY KEY,
  sector TEXT,
  service_role TEXT,
  critical_assets INTEGER,
  total_assets INTEGER,
  observable_critical_assets INTEGER,
  owner TEXT,
  high_criticality INTEGER,
  operational_status TEXT
);

CREATE TABLE observability_registry (
  observability_id TEXT PRIMARY KEY,
  system_id TEXT,
  observability_source TEXT,
  coverage_score REAL,
  freshness_score REAL,
  quality_score REAL,
  blind_spot_note TEXT
);

CREATE TABLE interoperability_map (
  interop_id TEXT PRIMARY KEY,
  system_id TEXT,
  core_systems INTEGER,
  systems_with_shared_identifiers INTEGER,
  api_documented INTEGER,
  schema_governed INTEGER,
  interoperability_score REAL,
  notes TEXT
);

CREATE TABLE ai_analytics_registry (
  model_id TEXT PRIMARY KEY,
  system_id TEXT,
  model_name TEXT,
  model_type TEXT,
  decision_use TEXT,
  validation_status TEXT,
  human_review_required INTEGER,
  ai_governance_score REAL,
  notes TEXT
);

CREATE TABLE cyber_resilience_controls (
  control_id TEXT PRIMARY KEY,
  system_id TEXT,
  segmentation_score REAL,
  access_control_score REAL,
  recovery_score REAL,
  monitoring_score REAL,
  incident_response_status TEXT,
  cyber_resilience_score REAL
);

CREATE TABLE resilience_scenario_manifest (
  scenario_id TEXT PRIMARY KEY,
  system_id TEXT,
  scenario_type TEXT,
  severity TEXT,
  time_horizon_years INTEGER,
  recovery_objective_hours INTEGER,
  scenario_status TEXT,
  assumption_note TEXT
);

CREATE TABLE infrastructure_intelligence_kpis (
  system_id TEXT PRIMARY KEY,
  sector TEXT,
  observability REAL,
  interoperability REAL,
  ai_governance REAL,
  resilience_readiness REAL,
  cyber_resilience REAL,
  equity_readiness REAL,
  public_accountability REAL,
  adaptive_capacity REAL,
  high_criticality INTEGER
);

CREATE TABLE decision_intervention_log (
  decision_id TEXT PRIMARY KEY,
  date TEXT,
  system_id TEXT,
  recommendation TEXT,
  decision_owner TEXT,
  status TEXT,
  public_note_required INTEGER
);

CREATE TABLE governance_review_log (
  review_id TEXT PRIMARY KEY,
  date TEXT,
  review_area TEXT,
  decision TEXT,
  owner TEXT,
  status TEXT,
  public_note_required INTEGER
);

INSERT INTO infrastructure_intelligence_kpis VALUES
('water-network-intelligence','water',0.78,0.66,0.70,0.74,0.68,0.72,0.70,0.73,1),
('transport-corridor-intelligence','transport',0.82,0.70,0.68,0.76,0.72,0.62,0.66,0.71,1),
('energy-grid-intelligence','energy',0.80,0.74,0.72,0.78,0.69,0.68,0.70,0.75,1),
('stormwater-monitoring-intelligence','stormwater',0.70,0.58,0.64,0.66,0.62,0.78,0.68,0.70,1),
('public-buildings-intelligence','public_buildings',0.67,0.61,0.66,0.64,0.60,0.74,0.72,0.65,0),
('communications-resilience-intelligence','communications',0.86,0.75,0.74,0.82,0.79,0.70,0.74,0.78,1),
('digital-public-infrastructure','digital_public_infrastructure',0.84,0.82,0.76,0.80,0.82,0.76,0.78,0.80,1);

INSERT INTO asset_service_register VALUES
('water-network-intelligence','water','drinking_water_distribution',42,96,33,'water_utility',1,'active'),
('transport-corridor-intelligence','transport','freight_bus_emergency_access',30,74,25,'transport_agency',1,'active'),
('energy-grid-intelligence','energy','critical_distribution',38,88,30,'power_utility',1,'active'),
('stormwater-monitoring-intelligence','stormwater','flood_risk_and_drainage',24,60,17,'stormwater_agency',1,'review_required'),
('public-buildings-intelligence','public_buildings','schools_hospitals_civic_facilities',18,52,12,'public_buildings',0,'active'),
('communications-resilience-intelligence','communications','emergency_communications',16,40,14,'communications_agency',1,'active'),
('digital-public-infrastructure','digital_public_infrastructure','civic_service_platforms',12,28,10,'digital_services',1,'active');

INSERT INTO cyber_resilience_controls VALUES
('CYB-001','water-network-intelligence',0.70,0.72,0.64,0.66,'review_required',0.68),
('CYB-002','transport-corridor-intelligence',0.74,0.72,0.70,0.72,'current',0.72),
('CYB-003','energy-grid-intelligence',0.76,0.74,0.66,0.70,'review_required',0.69),
('CYB-004','stormwater-monitoring-intelligence',0.62,0.64,0.60,0.62,'review_required',0.62),
('CYB-005','public-buildings-intelligence',0.60,0.62,0.58,0.60,'review_required',0.60),
('CYB-006','communications-resilience-intelligence',0.80,0.78,0.76,0.80,'current',0.79),
('CYB-007','digital-public-infrastructure',0.82,0.84,0.78,0.82,'current',0.82);

INSERT INTO resilience_scenario_manifest VALUES
('SCN-001','water-network-intelligence','drought_and_pipe_failure','high',10,24,'review_required','Drought plus pressure transient event'),
('SCN-002','transport-corridor-intelligence','heat_flood_and_signal_outage','high',5,12,'current','Extreme heat and localized flood disruption'),
('SCN-003','energy-grid-intelligence','heat_peak_load_and_transformer_failure','high',5,8,'current','Heat-driven peak demand and component stress'),
('SCN-004','stormwater-monitoring-intelligence','extreme_rainfall_and_sensor_gap','high',10,18,'review_required','Localized flood under incomplete monitoring'),
('SCN-005','public-buildings-intelligence','heat_event_and_hvac_failure','medium',5,24,'review_required','School and hospital HVAC stress scenario'),
('SCN-006','communications-resilience-intelligence','backup_power_and_node_failure','high',5,6,'current','Emergency communications continuity scenario'),
('SCN-007','digital-public-infrastructure','platform_outage_and_service_demand_spike','high',3,4,'current','Civic service platform outage during emergency demand');
