.headers on
.mode column

SELECT
  i.infrastructure_id,
  i.asset_name,
  i.domain,
  i.service_zone_id,
  ROUND(o.observed_service_capacity / o.normal_service_capacity, 3) AS service_continuity_score,
  ROUND(
    0.25 * o.data_quality_score +
    0.20 * o.coverage_score +
    0.20 * o.interoperability_score +
    0.15 * o.governance_response_score,
    3
  ) AS approximate_observability_without_latency,
  r.digital_access_gap_score,
  r.privacy_risk_score,
  o.quality_flag
FROM urban_infrastructure_inventory i
LEFT JOIN urban_observability_records o ON i.infrastructure_id = o.infrastructure_id
LEFT JOIN digital_inclusion_rights_review r ON i.service_zone_id = r.service_zone_id
ORDER BY service_continuity_score ASC, r.digital_access_gap_score DESC;

SELECT
  source_infrastructure_id,
  COUNT(*) AS dependency_count,
  ROUND(SUM(dependency_weight), 3) AS total_dependency_weight
FROM cross_domain_dependency_edges
GROUP BY source_infrastructure_id
ORDER BY total_dependency_weight DESC;

SELECT
  g.governance_id,
  g.date,
  g.infrastructure_id,
  i.asset_name,
  g.decision,
  g.owner,
  g.status,
  g.public_note_required
FROM smart_city_governance_response_log g
LEFT JOIN urban_infrastructure_inventory i ON g.infrastructure_id = i.infrastructure_id
WHERE g.status = 'open'
ORDER BY g.date;
