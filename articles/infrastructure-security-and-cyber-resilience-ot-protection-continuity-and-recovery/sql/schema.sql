DROP TABLE IF EXISTS cyber_asset_register;
DROP TABLE IF EXISTS ot_zone_conduit_map;
DROP TABLE IF EXISTS cyber_control_baseline;
DROP TABLE IF EXISTS cyber_incident_scenario_manifest;
DROP TABLE IF EXISTS continuity_recovery_log;
DROP TABLE IF EXISTS vendor_risk_register;
DROP TABLE IF EXISTS cyber_governance_log;
DROP TABLE IF EXISTS cyber_resilience_kpis;

CREATE TABLE cyber_asset_register (
  system_id TEXT,
  asset_id TEXT PRIMARY KEY,
  asset_name TEXT,
  sector TEXT,
  environment TEXT,
  asset_type TEXT,
  service_role TEXT,
  criticality TEXT,
  owner TEXT,
  remote_access INTEGER,
  inventory_status TEXT
);

CREATE TABLE ot_zone_conduit_map (
  zone_id TEXT PRIMARY KEY,
  system_id TEXT,
  zone_name TEXT,
  environment TEXT,
  trust_level TEXT,
  connected_to TEXT,
  segmentation_status TEXT,
  remote_access_allowed INTEGER,
  notes TEXT
);

CREATE TABLE cyber_control_baseline (
  control_id TEXT PRIMARY KEY,
  system_id TEXT,
  control_family TEXT,
  control_name TEXT,
  implementation_status TEXT,
  evidence_status TEXT,
  owner TEXT,
  test_frequency_days INTEGER,
  control_effectiveness REAL
);

CREATE TABLE cyber_incident_scenario_manifest (
  scenario_id TEXT PRIMARY KEY,
  system_id TEXT,
  scenario_type TEXT,
  severity TEXT,
  affected_service TEXT,
  detection_objective_minutes INTEGER,
  containment_objective_minutes INTEGER,
  recovery_objective_hours INTEGER,
  assumption_note TEXT,
  status TEXT
);

CREATE TABLE continuity_recovery_log (
  continuity_id TEXT PRIMARY KEY,
  system_id TEXT,
  essential_service TEXT,
  fallback_mode TEXT,
  recovery_time_objective_hours INTEGER,
  backup_test_status TEXT,
  manual_operation_status TEXT,
  public_communication_status TEXT,
  continuity_owner TEXT
);

CREATE TABLE vendor_risk_register (
  vendor_id TEXT PRIMARY KEY,
  system_id TEXT,
  vendor_name TEXT,
  vendor_type TEXT,
  remote_access INTEGER,
  critical_dependency INTEGER,
  contract_security_clause TEXT,
  concentration_risk TEXT,
  review_status TEXT,
  notes TEXT
);

CREATE TABLE cyber_governance_log (
  governance_id TEXT PRIMARY KEY,
  date TEXT,
  system_id TEXT,
  decision TEXT,
  owner TEXT,
  status TEXT,
  public_note_required INTEGER
);

CREATE TABLE cyber_resilience_kpis (
  system_id TEXT PRIMARY KEY,
  sector TEXT,
  service_role TEXT,
  exposure REAL,
  vulnerability REAL,
  control_effectiveness REAL,
  asset_visibility REAL,
  identity_governance REAL,
  detection_capability REAL,
  containment_readiness REAL,
  recovery_readiness REAL,
  continuity_readiness REAL,
  governance_readiness REAL,
  high_criticality INTEGER
);

INSERT INTO cyber_resilience_kpis VALUES
('water-ot-environment','water','treatment_pumping_and_distribution',0.72,0.62,0.58,0.68,0.66,0.64,0.62,0.60,0.58,0.64,1),
('grid-substation-control','energy','critical_distribution',0.68,0.58,0.64,0.72,0.70,0.68,0.66,0.62,0.64,0.68,1),
('transport-dispatch-signaling','transport','signal_dispatch_and_emergency_access',0.64,0.55,0.62,0.70,0.67,0.66,0.63,0.66,0.68,0.69,1),
('emergency-communications-node','communications','emergency_coordination',0.61,0.50,0.70,0.76,0.72,0.74,0.72,0.70,0.72,0.74,1),
('civic-service-platform','digital_public_infrastructure','identity_payments_and_public_access',0.69,0.56,0.66,0.74,0.68,0.70,0.67,0.68,0.63,0.70,1),
('hospital-building-management','public_buildings','critical_facility_support',0.66,0.57,0.60,0.62,0.61,0.60,0.58,0.59,0.57,0.62,1);

INSERT INTO cyber_asset_register VALUES
('water-ot-environment','CYB-WAT-001','Water Treatment SCADA','water','OT','SCADA','treatment_pumping_and_distribution','high','water_utility',1,'current'),
('grid-substation-control','CYB-ENE-001','Substation Control Environment','energy','OT','ICS','critical_distribution','high','power_utility',1,'current'),
('transport-dispatch-signaling','CYB-TRN-001','Transport Dispatch and Signaling','transport','OT','control_system','signal_dispatch_and_emergency_access','high','transport_agency',1,'current'),
('emergency-communications-node','CYB-COM-001','Emergency Communications Node','communications','IT_OT_hybrid','network_node','emergency_coordination','high','communications_agency',1,'current'),
('civic-service-platform','CYB-DPI-001','Civic Service Platform','digital_public_infrastructure','IT_cloud','public_platform','identity_payments_and_public_access','high','digital_services',1,'current'),
('hospital-building-management','CYB-BLD-001','Hospital Building Management System','public_buildings','OT','building_management','critical_facility_support','high','public_buildings',1,'review_required');

INSERT INTO cyber_control_baseline VALUES
('CTRL-001','water-ot-environment','governance','OT cyber risk ownership','current','current','water_security',180,0.62),
('CTRL-002','water-ot-environment','identity','MFA for remote access','current','current','water_security',90,0.66),
('CTRL-003','water-ot-environment','segmentation','IT OT segmentation','review_required','partial','water_security',180,0.58),
('CTRL-004','grid-substation-control','identity','Privileged access review','current','current','power_security',90,0.70),
('CTRL-005','grid-substation-control','recovery','Substation control recovery test','review_required','partial','power_operations',180,0.62),
('CTRL-006','transport-dispatch-signaling','detection','Control-system monitoring','current','current','transport_security',90,0.66),
('CTRL-007','emergency-communications-node','recovery','Backup communications channel','current','current','communications_operations',90,0.72),
('CTRL-008','civic-service-platform','continuity','Offline service fallback','review_required','partial','digital_services',180,0.63),
('CTRL-009','hospital-building-management','segmentation','BMS segmentation and access control','review_required','partial','facility_security',180,0.60);

INSERT INTO cyber_incident_scenario_manifest VALUES
('SCN-001','water-ot-environment','ot_ransomware','high','treatment_pumping_and_distribution',30,60,24,'Ransomware affects engineering workstation and visibility','review_required'),
('SCN-002','grid-substation-control','remote_access_compromise','high','critical_distribution',20,45,8,'Compromised vendor access attempts lateral movement','review_required'),
('SCN-003','transport-dispatch-signaling','dispatch_system_outage','high','signal_dispatch_and_emergency_access',30,60,12,'Dispatch and passenger information disrupted','current'),
('SCN-004','emergency-communications-node','communications_node_compromise','high','emergency_coordination',15,30,6,'Emergency node requires radio fallback','current'),
('SCN-005','civic-service-platform','cloud_platform_outage','high','identity_payments_and_public_access',20,60,4,'Public portal outage during demand surge','current'),
('SCN-006','hospital-building-management','bms_compromise','high','critical_facility_support',30,60,12,'Building management disruption during heat event','review_required');

INSERT INTO continuity_recovery_log VALUES
('CON-001','water-ot-environment','treatment_pumping_and_distribution','manual_pumping_protocol_and_offline_water_quality_reporting',24,'needs_test','partial','needs_update','water_operations'),
('CON-002','grid-substation-control','critical_distribution','manual_dispatch_and_mobile_transformer_protocol',8,'partial','partial','current','grid_operations'),
('CON-003','transport-dispatch-signaling','signal_dispatch_and_emergency_access','manual_dispatch_and_emergency_route_priority',12,'current','current','current','transport_operations'),
('CON-004','emergency-communications-node','emergency_coordination','radio_fallback_and_manual_dispatch',6,'current','current','current','communications_operations'),
('CON-005','civic-service-platform','identity_payments_and_public_access','offline_forms_and_secondary_service_portal',4,'current','partial','current','digital_operations'),
('CON-006','hospital-building-management','critical_facility_support','manual_hvac_override_and_portable_cooling',12,'needs_test','partial','needs_update','facility_operations');
