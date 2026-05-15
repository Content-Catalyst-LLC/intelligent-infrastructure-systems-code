PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS governance_log;
DROP TABLE IF EXISTS adaptation_options;
DROP TABLE IF EXISTS dependency_edges;
DROP TABLE IF EXISTS critical_services;
DROP TABLE IF EXISTS asset_exposure;
DROP TABLE IF EXISTS climate_scenarios;

CREATE TABLE climate_scenarios (
  scenario_id TEXT PRIMARY KEY,
  hazard TEXT NOT NULL,
  time_horizon INTEGER NOT NULL CHECK (time_horizon >= 2026),
  scenario_description TEXT NOT NULL,
  confidence_note TEXT,
  source_note TEXT
);

CREATE TABLE asset_exposure (
  asset_id TEXT PRIMARY KEY,
  asset_name TEXT NOT NULL,
  infrastructure_domain TEXT NOT NULL,
  primary_hazard TEXT NOT NULL,
  exposure_score REAL NOT NULL CHECK (exposure_score BETWEEN 0 AND 1),
  vulnerability_score REAL NOT NULL CHECK (vulnerability_score BETWEEN 0 AND 1),
  criticality_score REAL NOT NULL CHECK (criticality_score BETWEEN 0 AND 1),
  dependent_service TEXT NOT NULL,
  location_type TEXT
);

CREATE TABLE critical_services (
  service_id TEXT PRIMARY KEY,
  service_name TEXT NOT NULL,
  infrastructure_domain TEXT NOT NULL,
  outage_tolerance_hours REAL NOT NULL CHECK (outage_tolerance_hours > 0),
  dependent_assets TEXT NOT NULL,
  vulnerable_population_flag TEXT NOT NULL CHECK (vulnerable_population_flag IN ('true','false')),
  service_continuity_target REAL NOT NULL CHECK (service_continuity_target BETWEEN 0 AND 1)
);

CREATE TABLE dependency_edges (
  from_asset_id TEXT NOT NULL,
  to_asset_id TEXT NOT NULL,
  dependency_type TEXT NOT NULL,
  dependency_strength REAL NOT NULL CHECK (dependency_strength BETWEEN 0 AND 1),
  notes TEXT,
  PRIMARY KEY (from_asset_id, to_asset_id, dependency_type),
  FOREIGN KEY(from_asset_id) REFERENCES asset_exposure(asset_id),
  FOREIGN KEY(to_asset_id) REFERENCES asset_exposure(asset_id)
);

CREATE TABLE adaptation_options (
  option_id TEXT PRIMARY KEY,
  asset_id TEXT NOT NULL,
  intervention_type TEXT NOT NULL,
  description TEXT NOT NULL,
  expected_risk_reduction REAL NOT NULL CHECK (expected_risk_reduction BETWEEN 0 AND 1),
  equity_benefit REAL NOT NULL CHECK (equity_benefit BETWEEN 0 AND 1),
  maladaptation_risk REAL NOT NULL CHECK (maladaptation_risk BETWEEN 0 AND 1),
  maintenance_need TEXT NOT NULL CHECK (maintenance_need IN ('low','medium','high')),
  implementation_status TEXT NOT NULL,
  FOREIGN KEY(asset_id) REFERENCES asset_exposure(asset_id)
);

CREATE TABLE governance_log (
  governance_id TEXT PRIMARY KEY,
  date TEXT NOT NULL,
  program_id TEXT NOT NULL,
  decision TEXT NOT NULL,
  owner TEXT NOT NULL,
  status TEXT NOT NULL,
  public_note_required TEXT NOT NULL CHECK (public_note_required IN ('true','false'))
);
