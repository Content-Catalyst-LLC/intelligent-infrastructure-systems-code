.headers on
.mode column

SELECT
  i.network_element_id,
  i.network_element_name,
  i.mode,
  i.service_zone_id,
  ROUND(1 - (p.travel_time_std_minutes / p.travel_time_mean_minutes), 3) AS travel_time_reliability,
  MAX(p.expected_recovery_minutes - p.target_recovery_minutes, 0) AS recovery_lag_minutes,
  s.accessibility_gap_score,
  s.safety_risk_score,
  p.coordination_score,
  t.quality_flag
FROM transport_network_inventory i
LEFT JOIN service_performance_review p ON i.network_element_id = p.network_element_id
LEFT JOIN safety_accessibility_review s ON i.service_zone_id = s.service_zone_id
LEFT JOIN mobility_telemetry_sample t ON i.network_element_id = t.network_element_id
ORDER BY s.safety_risk_score DESC, s.accessibility_gap_score DESC, recovery_lag_minutes DESC;

SELECT
  mode,
  COUNT(*) AS network_elements,
  ROUND(AVG(1 - (p.travel_time_std_minutes / p.travel_time_mean_minutes)), 3) AS mean_reliability,
  ROUND(AVG(s.accessibility_gap_score), 3) AS mean_accessibility_gap,
  ROUND(AVG(s.safety_risk_score), 3) AS mean_safety_risk,
  ROUND(AVG(p.coordination_score), 3) AS mean_coordination
FROM transport_network_inventory i
LEFT JOIN service_performance_review p ON i.network_element_id = p.network_element_id
LEFT JOIN safety_accessibility_review s ON i.service_zone_id = s.service_zone_id
GROUP BY mode
ORDER BY mean_safety_risk DESC;

SELECT
  g.governance_id,
  g.date,
  g.network_element_id,
  i.network_element_name,
  g.decision,
  g.owner,
  g.status,
  g.public_note_required
FROM transport_governance_operations_log g
LEFT JOIN transport_network_inventory i ON g.network_element_id = i.network_element_id
WHERE g.status = 'open'
ORDER BY g.date;
