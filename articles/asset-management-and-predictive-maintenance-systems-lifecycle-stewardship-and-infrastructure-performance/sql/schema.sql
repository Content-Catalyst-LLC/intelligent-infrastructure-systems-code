DROP TABLE IF EXISTS asset_register;
DROP TABLE IF EXISTS condition_inspections;
DROP TABLE IF EXISTS criticality_scores;
DROP TABLE IF EXISTS telemetry_observations;
DROP TABLE IF EXISTS work_orders;
DROP TABLE IF EXISTS failure_events;
DROP TABLE IF EXISTS lifecycle_cost_scenarios;
DROP TABLE IF EXISTS risk_priority_scores;
DROP TABLE IF EXISTS governance_review_log;

CREATE TABLE asset_register (
  asset_id TEXT PRIMARY KEY,
  asset_class TEXT,
  asset_name TEXT,
  location TEXT,
  owner TEXT,
  install_year INTEGER,
  design_life_years INTEGER,
  replacement_cost REAL,
  service_role TEXT,
  operational_status TEXT
);

CREATE TABLE condition_inspections (
  inspection_id TEXT PRIMARY KEY,
  asset_id TEXT,
  inspection_date TEXT,
  condition_score REAL,
  defect_score REAL,
  inspection_method TEXT,
  inspector TEXT,
  notes TEXT
);

CREATE TABLE criticality_scores (
  asset_id TEXT PRIMARY KEY,
  service_consequence INTEGER,
  safety_consequence INTEGER,
  environmental_consequence INTEGER,
  redundancy_score INTEGER,
  recovery_difficulty INTEGER,
  equity_consequence INTEGER,
  criticality_score REAL
);

CREATE TABLE telemetry_observations (
  telemetry_id TEXT PRIMARY KEY,
  asset_id TEXT,
  timestamp TEXT,
  signal_type TEXT,
  value REAL,
  unit TEXT,
  qc_flag TEXT,
  notes TEXT
);

CREATE TABLE work_orders (
  work_order_id TEXT PRIMARY KEY,
  asset_id TEXT,
  created_date TEXT,
  maintenance_strategy TEXT,
  priority TEXT,
  status TEXT,
  estimated_cost REAL,
  planned_start TEXT,
  notes TEXT
);

CREATE TABLE failure_events (
  failure_event_id TEXT PRIMARY KEY,
  asset_id TEXT,
  event_date TEXT,
  failure_mode TEXT,
  downtime_hours REAL,
  service_impact TEXT,
  cost REAL,
  notes TEXT
);

CREATE TABLE lifecycle_cost_scenarios (
  scenario_id TEXT PRIMARY KEY,
  asset_id TEXT,
  strategy TEXT,
  maintenance_cost REAL,
  operations_cost REAL,
  capital_renewal_cost REAL,
  expected_failure_cost REAL,
  discount_rate REAL,
  time_horizon_years INTEGER,
  total_cost_proxy REAL
);

CREATE TABLE risk_priority_scores (
  asset_id TEXT PRIMARY KEY,
  condition_score REAL,
  failure_probability REAL,
  criticality_score REAL,
  risk_score REAL,
  priority_score REAL,
  recommended_strategy TEXT
);

CREATE TABLE governance_review_log (
  review_id TEXT PRIMARY KEY,
  date TEXT,
  asset_id TEXT,
  decision TEXT,
  owner TEXT,
  status TEXT,
  public_note_required INTEGER
);

INSERT INTO asset_register VALUES
('A-0001','pump','North Pump Station Pump 1','north_zone','water_utility',2004,30,250000,'primary_pumping','active'),
('A-0002','pump','North Pump Station Pump 2','north_zone','water_utility',2011,30,240000,'redundant_pumping','active'),
('A-0003','valve','Transmission Valve 17','central_corridor','water_utility',1998,40,45000,'isolation_control','active'),
('A-0004','bridge_component','Bridge Bearing Set B12','river_crossing','transport_agency',1987,50,900000,'strategic_crossing','review_required'),
('A-0005','road_segment','Arterial Segment R-44','freight_corridor','transport_agency',2009,25,1200000,'freight_and_bus_route','active'),
('A-0006','substation_asset','Transformer T7','east_substation','power_utility',1995,45,1800000,'critical_distribution','active'),
('A-0007','pipe_segment','Water Main WM-88','older_neighborhood','water_utility',1965,80,650000,'distribution_main','review_required'),
('A-0008','building_system','Hospital HVAC Unit H3','medical_district','public_buildings',2014,20,350000,'critical_facility_support','active');

INSERT INTO condition_inspections VALUES
('INS-001','A-0001','2026-01-15',0.72,0.28,'vibration_and_visual','asset_team','Moderate bearing wear'),
('INS-002','A-0002','2026-01-15',0.84,0.16,'vibration_and_visual','asset_team','Good condition'),
('INS-003','A-0003','2026-02-01',0.66,0.34,'manual_valve_exercise','field_team','Slow operation'),
('INS-004','A-0004','2026-02-12',0.48,0.52,'structural_inspection','bridge_team','Corrosion and movement noted'),
('INS-005','A-0005','2026-03-03',0.58,0.42,'pavement_condition_survey','transport_team','Rutting and cracking'),
('INS-006','A-0006','2026-03-15',0.62,0.38,'thermal_and_oil_test','power_team','Thermal anomaly under peak load'),
('INS-007','A-0007','2026-03-21',0.44,0.56,'break_history_review','water_team','Repeated breaks and age concern'),
('INS-008','A-0008','2026-04-01',0.76,0.24,'mechanical_inspection','facility_team','Maintenance overdue but stable');

INSERT INTO criticality_scores VALUES
('A-0001',5,3,4,2,4,3,0.82),
('A-0002',4,2,3,3,3,3,0.66),
('A-0003',3,2,3,3,2,2,0.52),
('A-0004',5,5,3,1,5,4,0.90),
('A-0005',4,3,2,2,3,4,0.68),
('A-0006',5,4,4,1,5,4,0.88),
('A-0007',5,3,5,2,4,5,0.86),
('A-0008',5,4,2,2,4,4,0.78);

INSERT INTO risk_priority_scores VALUES
('A-0001',0.72,0.31,0.82,0.254,0.53,'condition_based_maintenance'),
('A-0002',0.84,0.18,0.66,0.119,0.34,'monitor'),
('A-0003',0.66,0.26,0.52,0.135,0.43,'condition_based_maintenance'),
('A-0004',0.48,0.47,0.90,0.423,0.75,'urgent_review'),
('A-0005',0.58,0.36,0.68,0.245,0.56,'planned_intervention'),
('A-0006',0.62,0.42,0.88,0.370,0.68,'urgent_review'),
('A-0007',0.44,0.55,0.86,0.473,0.80,'urgent_review'),
('A-0008',0.76,0.25,0.78,0.195,0.46,'condition_based_maintenance');
