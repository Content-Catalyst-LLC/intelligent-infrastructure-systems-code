DROP TABLE IF EXISTS twin_asset_registry;
DROP TABLE IF EXISTS telemetry_source_registry;
DROP TABLE IF EXISTS digital_twin_state_table;
DROP TABLE IF EXISTS model_registry;
DROP TABLE IF EXISTS simulation_scenario_manifest;
DROP TABLE IF EXISTS simulation_outputs;
DROP TABLE IF EXISTS validation_sensitivity_log;
DROP TABLE IF EXISTS decision_intervention_log;
DROP TABLE IF EXISTS governance_review_log;

CREATE TABLE twin_asset_registry (
  asset_id TEXT PRIMARY KEY,
  asset_class TEXT,
  asset_name TEXT,
  location TEXT,
  owner TEXT,
  service_role TEXT,
  network_id TEXT,
  criticality_score REAL,
  operational_status TEXT
);

CREATE TABLE telemetry_source_registry (
  source_id TEXT PRIMARY KEY,
  asset_id TEXT,
  source_type TEXT,
  signal_name TEXT,
  unit TEXT,
  update_frequency_minutes INTEGER,
  owner TEXT,
  qc_status TEXT,
  valid_use TEXT,
  notes TEXT
);

CREATE TABLE digital_twin_state_table (
  state_id TEXT PRIMARY KEY,
  asset_id TEXT,
  timestamp TEXT,
  condition_state REAL,
  load_factor REAL,
  climate_exposure REAL,
  service_criticality REAL,
  estimated_failure_risk REAL,
  state_quality_flag TEXT
);

CREATE TABLE model_registry (
  model_id TEXT PRIMARY KEY,
  model_name TEXT,
  model_type TEXT,
  model_version TEXT,
  owner TEXT,
  decision_use TEXT,
  validation_status TEXT,
  uncertainty_statement TEXT,
  valid_use TEXT
);

CREATE TABLE simulation_scenario_manifest (
  scenario_id TEXT PRIMARY KEY,
  scenario_type TEXT,
  load_multiplier REAL,
  climate_multiplier REAL,
  disruption_multiplier REAL,
  intervention TEXT,
  time_horizon_years INTEGER,
  assumption_note TEXT
);

CREATE TABLE simulation_outputs (
  output_id TEXT PRIMARY KEY,
  scenario_id TEXT,
  asset_id TEXT,
  intervention TEXT,
  sim_condition REAL,
  failure_risk REAL,
  service_risk REAL,
  cost_index REAL,
  decision_value REAL,
  review_required INTEGER
);

CREATE TABLE validation_sensitivity_log (
  validation_id TEXT PRIMARY KEY,
  model_id TEXT,
  test_date TEXT,
  test_type TEXT,
  result TEXT,
  status TEXT,
  notes TEXT
);

CREATE TABLE decision_intervention_log (
  decision_id TEXT PRIMARY KEY,
  date TEXT,
  scenario_id TEXT,
  asset_id TEXT,
  recommended_intervention TEXT,
  decision_owner TEXT,
  status TEXT,
  public_note_required INTEGER,
  notes TEXT
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

INSERT INTO twin_asset_registry VALUES
('DT-0001','pump_station','North Pump Station','north_zone','water_utility','primary_pumping','water_network',0.86,'active'),
('DT-0002','bridge','River Crossing Bridge','river_corridor','transport_agency','strategic_crossing','transport_network',0.92,'review_required'),
('DT-0003','substation','East Substation','east_grid','power_utility','critical_distribution','power_network',0.89,'active'),
('DT-0004','road_segment','Freight Corridor Segment','industrial_corridor','transport_agency','freight_and_bus_route','transport_network',0.72,'active'),
('DT-0005','water_main','Older District Water Main','older_neighborhood','water_utility','distribution_main','water_network',0.84,'review_required'),
('DT-0006','building_system','Hospital HVAC System','medical_district','public_buildings','critical_facility_support','building_network',0.80,'active'),
('DT-0007','communications_node','Emergency Communications Node','civic_center','communications_agency','emergency_communications','communications_network',0.88,'active'),
('DT-0008','rail_component','Switch Assembly R12','rail_yard','transport_agency','rail_switching','rail_network',0.77,'active');

INSERT INTO digital_twin_state_table VALUES
('STATE-001','DT-0001','2026-05-01T12:00:00Z',0.72,0.68,0.45,0.86,0.34,'pass'),
('STATE-002','DT-0002','2026-05-01T12:00:00Z',0.48,0.74,0.72,0.92,0.51,'review_required'),
('STATE-003','DT-0003','2026-05-01T12:00:00Z',0.63,0.82,0.51,0.89,0.42,'pass'),
('STATE-004','DT-0004','2026-05-01T12:00:00Z',0.58,0.91,0.62,0.72,0.40,'pass'),
('STATE-005','DT-0005','2026-05-01T12:00:00Z',0.44,0.69,0.66,0.84,0.53,'review_required'),
('STATE-006','DT-0006','2026-05-01T12:00:00Z',0.76,0.62,0.54,0.80,0.31,'pass'),
('STATE-007','DT-0007','2026-05-01T12:00:00Z',0.81,0.57,0.48,0.88,0.28,'pass'),
('STATE-008','DT-0008','2026-05-01T12:00:00Z',0.69,0.77,0.40,0.77,0.35,'pass');

INSERT INTO model_registry VALUES
('MOD-001','Asset State Estimator','state_estimation','v1.0','infrastructure_analytics','current','Validated against recent inspections for example data','Educational state-estimation only','educational'),
('MOD-002','Scenario Stress Model','scenario_simulation','v1.0','infrastructure_analytics','review_required','Sensitivity to load and climate multipliers remains high','Educational stress testing only','educational'),
('MOD-003','Intervention Value Model','decision_support','v1.0','planning_team','review_required','Cost and benefit functions are simplified','Decision-support demonstration only','educational');

INSERT INTO simulation_scenario_manifest VALUES
('SCN-001','baseline',1.00,1.00,1.00,'defer',5,'Current conditions with no major stressor'),
('SCN-002','heat_stress',1.15,1.30,1.05,'inspect',5,'High heat stresses power and building systems'),
('SCN-003','flood_stress',1.05,1.45,1.20,'targeted_repair',10,'Flood exposure stresses transport and water assets'),
('SCN-004','demand_surge',1.30,1.10,1.05,'targeted_repair',10,'Demand growth stresses network capacity'),
('SCN-005','cascading_failure',1.20,1.25,1.50,'renewal',15,'Critical asset failure creates network disruption'),
('SCN-006','adaptation_investment',1.10,1.35,1.10,'renewal',20,'Long-horizon climate adaptation investment pathway');

INSERT INTO simulation_outputs VALUES
('OUT-001','SCN-001','DT-0001','defer',0.72,0.34,0.29,0.00,0.54,0),
('OUT-002','SCN-002','DT-0003','inspect',0.66,0.46,0.41,0.10,0.32,1),
('OUT-003','SCN-003','DT-0002','targeted_repair',0.63,0.49,0.45,0.35,0.19,1),
('OUT-004','SCN-003','DT-0005','targeted_repair',0.59,0.55,0.46,0.35,0.16,1),
('OUT-005','SCN-004','DT-0004','targeted_repair',0.73,0.42,0.30,0.35,0.31,1),
('OUT-006','SCN-005','DT-0007','renewal',1.00,0.31,0.27,0.85,0.14,1),
('OUT-007','SCN-006','DT-0002','renewal',0.83,0.34,0.31,0.85,0.10,1),
('OUT-008','SCN-006','DT-0005','renewal',0.79,0.38,0.32,0.85,0.08,1);
