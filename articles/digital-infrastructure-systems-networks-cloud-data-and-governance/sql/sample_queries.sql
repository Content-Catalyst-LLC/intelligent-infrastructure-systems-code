.headers on
.mode column

SELECT
  c.service_zone_id,
  c.region_name,
  ROUND(c.users_with_affordable_reliable_access / NULLIF(c.users_needing_access, 0), 3) AS digital_access_score,
  ROUND(0.30 * c.bandwidth_score + 0.25 * c.latency_score + 0.25 * c.uptime_score + 0.20 * c.redundancy_score, 3) AS network_capacity_score,
  ROUND(0.30 * d.compute_capacity_score + 0.25 * d.storage_capacity_score + 0.25 * d.geo_redundancy_score + 0.20 * d.edge_readiness_score, 3) AS compute_storage_score,
  ROUND(i.systems_using_shared_standards / NULLIF(i.systems_requiring_exchange, 0), 3) AS interoperability_score,
  ROUND(0.25 * t.security_control_score + 0.20 * t.privacy_safeguard_score + 0.20 * t.auditability_score + 0.20 * t.recovery_readiness_score + 0.15 * t.governance_maturity_score, 3) AS trust_security_score,
  ROUND(k.critical_services_dependent_on_concentrated_providers / NULLIF(k.critical_digital_services, 0), 3) AS vendor_dependency_score,
  k.exposure_score,
  a.exclusion_risk_score
FROM connectivity_infrastructure_inventory c
LEFT JOIN cloud_data_infrastructure_register d ON c.service_zone_id = d.service_zone_id
LEFT JOIN interoperability_exchange_register i ON c.service_zone_id = i.service_zone_id
LEFT JOIN identity_trust_register t ON c.service_zone_id = t.service_zone_id
LEFT JOIN digital_dependency_continuity_review k ON c.service_zone_id = k.service_zone_id
LEFT JOIN access_inclusion_review a ON c.service_zone_id = a.service_zone_id
ORDER BY digital_access_score ASC, vendor_dependency_score DESC;

SELECT
  service_zone_id,
  region_name,
  coverage_status,
  primary_gap,
  ROUND(users_with_affordable_reliable_access / NULLIF(users_needing_access, 0), 3) AS access_score
FROM connectivity_infrastructure_inventory
ORDER BY access_score ASC;

SELECT
  g.governance_action_id,
  g.date,
  g.service_zone_id,
  c.region_name,
  g.decision,
  g.owner,
  g.status,
  g.public_note_required
FROM digital_infrastructure_governance_action_log g
LEFT JOIN connectivity_infrastructure_inventory c ON g.service_zone_id = c.service_zone_id
WHERE g.status = 'open'
ORDER BY g.date;
