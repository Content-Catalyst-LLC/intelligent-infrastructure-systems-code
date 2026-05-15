DROP TABLE IF EXISTS cyber_physical_asset_inventory;
DROP TABLE IF EXISTS control_loop_register;
DROP TABLE IF EXISTS telemetry_command_records;
DROP TABLE IF EXISTS dependency_exposure_map;
DROP TABLE IF EXISTS assurance_fallback_review;
DROP TABLE IF EXISTS cyber_physical_governance_action_log;

CREATE TABLE cyber_physical_asset_inventory (
  asset_id TEXT PRIMARY KEY,
  asset_name TEXT,
  asset_class TEXT,
  infrastructure_domain TEXT,
  service_zone_id TEXT,
  owner_operator TEXT,
  physical_function TEXT,
  cyber_components TEXT,
  vendor_dependency TEXT,
  criticality TEXT,
  automation_level TEXT,
  latitude REAL,
  longitude REAL,
  active_status TEXT
);

CREATE TABLE control_loop_register (
  control_loop_id TEXT PRIMARY KEY,
  asset_id TEXT,
  loop_name TEXT,
  state_variable TEXT,
  sensor_id TEXT,
  controller_id TEXT,
  actuator_or_intervention TEXT,
  operator_role TEXT,
  timing_constraint_seconds REAL,
  safety_boundary TEXT,
  control_mode TEXT,
  valid_use TEXT,
  prohibited_use TEXT
);

CREATE TABLE telemetry_command_records (
  record_id TEXT PRIMARY KEY,
  control_loop_id TEXT,
  timestamp TEXT,
  measurement_value REAL,
  command_issued TEXT,
  command_within_bounds TEXT,
  operator_acknowledged TEXT,
  expected_signals REAL,
  missing_signals REAL,
  late_signals REAL,
  invalid_signals REAL,
  accuracy_score REAL,
  calibration_score REAL,
  timeliness_score REAL,
  validity_score REAL,
  metadata_completeness_score REAL,
  security_control_score REAL,
  exposure_score REAL,
  quality_flag TEXT
);

CREATE TABLE dependency_exposure_map (
  asset_id TEXT PRIMARY KEY,
  critical_functions REAL,
  cyber_dependent_functions REAL,
  power_dependency TEXT,
  communications_dependency TEXT,
  identity_dependency TEXT,
  cloud_dependency TEXT,
  vendor_remote_access_dependency TEXT,
  firmware_dependency TEXT,
  dependency_notes TEXT
);

CREATE TABLE assurance_fallback_review (
  control_loop_id TEXT PRIMARY KEY,
  timing_validated INTEGER,
  safety_boundary_validated INTEGER,
  degraded_mode_tested INTEGER,
  manual_override_tested INTEGER,
  recovery_tested INTEGER,
  operator_visibility INTEGER,
  override_authority INTEGER,
  training_current INTEGER,
  escalation_path_defined INTEGER,
  fallback_capability_score REAL,
  manual_override_score REAL,
  recovery_effectiveness_score REAL,
  assurance_status TEXT
);

CREATE TABLE cyber_physical_governance_action_log (
  governance_action_id TEXT PRIMARY KEY,
  date TEXT,
  control_loop_id TEXT,
  asset_id TEXT,
  decision TEXT,
  owner TEXT,
  status TEXT,
  public_note_required TEXT
);
