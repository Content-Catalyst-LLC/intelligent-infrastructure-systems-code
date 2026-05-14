DROP TABLE IF EXISTS asset_service_register;
DROP TABLE IF EXISTS infrastructure_risk_register;
DROP TABLE IF EXISTS criticality_matrix;
DROP TABLE IF EXISTS dependency_graph_edges;
DROP TABLE IF EXISTS risk_scenario_manifest;
DROP TABLE IF EXISTS treatment_mitigation_plan;
DROP TABLE IF EXISTS continuity_recovery_log;
DROP TABLE IF EXISTS risk_financing_register;
DROP TABLE IF EXISTS risk_governance_log;

CREATE TABLE asset_service_register (
  asset_id TEXT PRIMARY KEY,
  asset_name TEXT,
  sector TEXT,
  service_role TEXT,
  owner TEXT,
  critical_function TEXT,
  affected_population INTEGER,
  substitute_available INTEGER,
  recovery_owner TEXT,
  operational_status TEXT
);

CREATE TABLE infrastructure_risk_register (
  risk_id TEXT PRIMARY KEY,
  asset_id TEXT,
  sector TEXT,
  risk_type TEXT,
  hazard TEXT,
  vulnerability TEXT,
  failure_probability REAL,
  consequence_score REAL,
  mitigation_effectiveness REAL,
  continuity_readiness REAL,
  governance_readiness REAL,
  risk_owner TEXT,
  status TEXT
);

CREATE TABLE criticality_matrix (
  asset_id TEXT PRIMARY KEY,
  service_importance REAL,
  dependency_centrality REAL,
  substitute_gap REAL,
  public_harm REAL,
  criticality_score REAL,
  criticality_class TEXT
);

CREATE TABLE dependency_graph_edges (
  source_asset_id TEXT,
  target_asset_id TEXT,
  dependency_type TEXT,
  dependency_strength REAL,
  notes TEXT
);

CREATE TABLE risk_scenario_manifest (
  scenario_id TEXT PRIMARY KEY,
  scenario_type TEXT,
  primary_sector TEXT,
  affected_assets TEXT,
  severity TEXT,
  time_horizon_years INTEGER,
  assumption_note TEXT,
  status TEXT
);

CREATE TABLE treatment_mitigation_plan (
  treatment_id TEXT PRIMARY KEY,
  risk_id TEXT,
  treatment_type TEXT,
  description TEXT,
  estimated_cost REAL,
  mitigation_gain REAL,
  owner TEXT,
  status TEXT
);

CREATE TABLE continuity_recovery_log (
  continuity_id TEXT PRIMARY KEY,
  risk_id TEXT,
  essential_function TEXT,
  fallback_mode TEXT,
  recovery_time_objective_hours INTEGER,
  exercise_status TEXT,
  after_action_review_status TEXT,
  continuity_owner TEXT
);

CREATE TABLE risk_financing_register (
  finance_id TEXT PRIMARY KEY,
  risk_id TEXT,
  financing_strategy TEXT,
  insured INTEGER,
  retained_risk_statement TEXT,
  reserve_required REAL,
  finance_owner TEXT,
  status TEXT
);

CREATE TABLE risk_governance_log (
  governance_id TEXT PRIMARY KEY,
  date TEXT,
  risk_id TEXT,
  decision TEXT,
  owner TEXT,
  status TEXT,
  public_note_required INTEGER
);

INSERT INTO asset_service_register VALUES
('A-WATER-01','North Water Main','water','drinking_water_distribution','water_utility','water_service_continuity',48000,0,'water_operations','review_required'),
('A-POWER-07','East Transformer Bank','energy','critical_distribution','power_utility','electric_service_continuity',72000,0,'grid_operations','active'),
('A-BRIDGE-12','River Crossing Bridge','transport','freight_bus_emergency_access','transport_agency','emergency_route_continuity',62000,1,'transport_operations','review_required'),
('A-CYBER-03','Emergency Communications Node','communications','emergency_communications','communications_agency','emergency_coordination',105000,0,'communications_operations','active'),
('A-FLOOD-09','Stormwater Outfall Basin','stormwater','flood_risk_and_drainage','stormwater_agency','flood_conveyance',36000,0,'stormwater_operations','review_required'),
('A-HVAC-04','Hospital HVAC System','public_buildings','critical_facility_support','public_buildings','health_facility_continuity',18000,1,'facility_operations','active'),
('A-DATA-02','Civic Service Data Platform','digital_public_infrastructure','civic_service_delivery','digital_services','public_service_access',160000,1,'digital_operations','active');

INSERT INTO infrastructure_risk_register VALUES
('R-001','A-WATER-01','water','physical_asset','pipe_failure','aging_main_and_pressure_transients',0.42,0.80,0.45,0.58,0.62,'water_utility','open'),
('R-002','A-POWER-07','energy','physical_asset','transformer_failure','thermal_stress_and_limited_spares',0.35,0.88,0.52,0.64,0.70,'power_utility','open'),
('R-003','A-BRIDGE-12','transport','physical_asset','bridge_closure','structural_deterioration_and_flood_exposure',0.28,0.92,0.48,0.60,0.66,'transport_agency','open'),
('R-004','A-CYBER-03','communications','cyber_digital','network_compromise','platform_dependence_and_access_control_gap',0.31,0.86,0.55,0.62,0.58,'communications_agency','open'),
('R-005','A-FLOOD-09','stormwater','environmental_climate','extreme_rainfall','undersized_drainage_and_sensor_gap',0.46,0.74,0.40,0.54,0.60,'stormwater_agency','open'),
('R-006','A-HVAC-04','public_buildings','operational','hvac_failure','heat_event_and_maintenance_backlog',0.30,0.72,0.50,0.66,0.68,'public_buildings','review_required'),
('R-007','A-DATA-02','digital_public_infrastructure','cyber_digital','platform_outage','cloud_dependence_and_demand_surge',0.25,0.82,0.60,0.70,0.72,'digital_services','open');

INSERT INTO criticality_matrix VALUES
('A-WATER-01',0.90,0.70,0.65,0.80,0.775,'high'),
('A-POWER-07',0.95,0.82,0.75,0.76,0.827,'high'),
('A-BRIDGE-12',0.88,0.78,0.70,0.72,0.775,'high'),
('A-CYBER-03',0.92,0.88,0.82,0.75,0.842,'high'),
('A-FLOOD-09',0.78,0.64,0.60,0.84,0.724,'high'),
('A-HVAC-04',0.84,0.58,0.48,0.78,0.688,'medium_high'),
('A-DATA-02',0.86,0.76,0.50,0.70,0.723,'high');

INSERT INTO continuity_recovery_log VALUES
('CON-001','R-001','water_service_continuity','alternate_pressure_zone_and_water_distribution',24,'needs_exercise','pending','water_operations'),
('CON-002','R-002','electric_service_continuity','load_shedding_and_mobile_transformer',8,'current','pending','grid_operations'),
('CON-003','R-003','emergency_route_continuity','alternate_route_and_emergency_signal_priority',12,'needs_exercise','pending','transport_operations'),
('CON-004','R-004','emergency_coordination','radio_fallback_and_manual_dispatch',6,'current','pending','communications_operations'),
('CON-005','R-005','flood_conveyance','pump_deployment_and_blockage_response',18,'needs_exercise','pending','stormwater_operations'),
('CON-006','R-006','health_facility_continuity','portable_cooling_and_patient_transfer_protocol',12,'needs_exercise','pending','facility_operations'),
('CON-007','R-007','public_service_access','offline_forms_and_secondary_platform',4,'current','pending','digital_operations');
