DROP TABLE IF EXISTS infrastructure_project_register;
DROP TABLE IF EXISTS project_appraisal_register;
DROP TABLE IF EXISTS fiscal_risk_register;
DROP TABLE IF EXISTS procurement_delivery_log;
DROP TABLE IF EXISTS asset_stewardship_register;
DROP TABLE IF EXISTS accountability_transparency_log;
DROP TABLE IF EXISTS policy_learning_log;

CREATE TABLE infrastructure_project_register (
  project_id TEXT PRIMARY KEY,
  project_name TEXT NOT NULL,
  sector TEXT NOT NULL,
  sponsor TEXT NOT NULL,
  status TEXT NOT NULL,
  capital_cost_musd REAL NOT NULL,
  complexity_score REAL NOT NULL,
  criticality_score REAL NOT NULL,
  strategic_fit_status TEXT NOT NULL
);

CREATE TABLE project_appraisal_register (
  project_id TEXT PRIMARY KEY,
  public_value_score REAL NOT NULL,
  affordability_score REAL NOT NULL,
  resilience_score REAL NOT NULL,
  equity_score REAL NOT NULL,
  alternatives_reviewed TEXT NOT NULL,
  options_appraisal_status TEXT NOT NULL,
  appraisal_note TEXT,
  FOREIGN KEY(project_id) REFERENCES infrastructure_project_register(project_id)
);

CREATE TABLE fiscal_risk_register (
  project_id TEXT PRIMARY KEY,
  funding_source TEXT NOT NULL,
  annual_operations_musd REAL NOT NULL,
  required_annual_maintenance_musd REAL NOT NULL,
  funded_annual_maintenance_musd REAL NOT NULL,
  contingent_liability_musd REAL NOT NULL,
  life_cycle_cost_visibility TEXT NOT NULL,
  fiscal_risk_status TEXT NOT NULL,
  FOREIGN KEY(project_id) REFERENCES infrastructure_project_register(project_id)
);

CREATE TABLE procurement_delivery_log (
  project_id TEXT PRIMARY KEY,
  procurement_method TEXT NOT NULL,
  competition_status TEXT NOT NULL,
  contract_model TEXT NOT NULL,
  delivery_readiness_score REAL NOT NULL,
  variation_orders INTEGER NOT NULL,
  cost_escalation_percent REAL NOT NULL,
  delay_months INTEGER NOT NULL,
  delivery_status TEXT NOT NULL,
  FOREIGN KEY(project_id) REFERENCES infrastructure_project_register(project_id)
);

CREATE TABLE asset_stewardship_register (
  project_id TEXT PRIMARY KEY,
  asset_condition_visibility TEXT NOT NULL,
  maintenance_plan_status TEXT NOT NULL,
  stewardship_readiness_score REAL NOT NULL,
  renewal_plan_status TEXT NOT NULL,
  service_indicator_status TEXT NOT NULL,
  resilience_vulnerability TEXT NOT NULL,
  FOREIGN KEY(project_id) REFERENCES infrastructure_project_register(project_id)
);

CREATE TABLE accountability_transparency_log (
  project_id TEXT PRIMARY KEY,
  transparency_score REAL NOT NULL,
  consultation_score REAL NOT NULL,
  auditability_score REAL NOT NULL,
  disclosure_usability_score REAL NOT NULL,
  public_evidence_status TEXT NOT NULL,
  audit_findings_open INTEGER NOT NULL,
  accountability_note TEXT,
  FOREIGN KEY(project_id) REFERENCES infrastructure_project_register(project_id)
);

CREATE TABLE policy_learning_log (
  learning_id TEXT PRIMARY KEY,
  date TEXT NOT NULL,
  project_id TEXT NOT NULL,
  finding TEXT NOT NULL,
  corrective_action TEXT NOT NULL,
  owner TEXT NOT NULL,
  status TEXT NOT NULL,
  FOREIGN KEY(project_id) REFERENCES infrastructure_project_register(project_id)
);
