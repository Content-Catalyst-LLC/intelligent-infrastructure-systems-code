.headers on
.mode column

SELECT
  l.control_loop_id,
  a.asset_name,
  a.infrastructure_domain,
  l.control_mode,
  ROUND(
    0.25 * t.accuracy_score +
    0.20 * t.calibration_score +
    0.20 * t.timeliness_score +
    0.20 * t.validity_score +
    0.15 * t.metadata_completeness_score,
    3
  ) AS signal_quality_score,
  ROUND(
    1 - (t.missing_signals + t.late_signals + t.invalid_signals) / NULLIF(t.expected_signals, 0),
    3
  ) AS telemetry_reliability_score,
  ROUND(d.cyber_dependent_functions / NULLIF(d.critical_functions, 0), 3) AS dependency_intensity_score,
  ROUND(
    (
      f.timing_validated +
      f.safety_boundary_validated +
      f.degraded_mode_tested +
      f.manual_override_tested +
      f.recovery_tested
    ) / 5.0,
    3
  ) AS control_validation_score,
  t.security_control_score,
  t.exposure_score,
  t.quality_flag
FROM control_loop_register l
LEFT JOIN cyber_physical_asset_inventory a ON l.asset_id = a.asset_id
LEFT JOIN telemetry_command_records t ON l.control_loop_id = t.control_loop_id
LEFT JOIN dependency_exposure_map d ON a.asset_id = d.asset_id
LEFT JOIN assurance_fallback_review f ON l.control_loop_id = f.control_loop_id
ORDER BY dependency_intensity_score DESC, exposure_score DESC;

SELECT
  asset_id,
  critical_functions,
  cyber_dependent_functions,
  ROUND(cyber_dependent_functions / NULLIF(critical_functions, 0), 3) AS dependency_intensity_score,
  power_dependency,
  communications_dependency,
  identity_dependency,
  cloud_dependency,
  vendor_remote_access_dependency,
  firmware_dependency
FROM dependency_exposure_map
ORDER BY dependency_intensity_score DESC;

SELECT
  g.governance_action_id,
  g.date,
  g.control_loop_id,
  l.loop_name,
  g.asset_id,
  a.asset_name,
  g.decision,
  g.owner,
  g.status,
  g.public_note_required
FROM cyber_physical_governance_action_log g
LEFT JOIN control_loop_register l ON g.control_loop_id = l.control_loop_id
LEFT JOIN cyber_physical_asset_inventory a ON g.asset_id = a.asset_id
WHERE g.status = 'open'
ORDER BY g.date;
