.headers on
.mode column

SELECT
  a.asset_id,
  a.asset_class,
  a.asset_name,
  r.condition_score,
  r.failure_probability,
  r.criticality_score,
  r.risk_score,
  r.priority_score,
  r.recommended_strategy
FROM risk_priority_scores r
JOIN asset_register a ON a.asset_id = r.asset_id
ORDER BY r.priority_score DESC;

SELECT
  a.asset_class,
  r.recommended_strategy,
  COUNT(*) AS asset_count,
  ROUND(AVG(r.condition_score), 3) AS mean_condition,
  ROUND(AVG(r.failure_probability), 3) AS mean_failure_probability,
  ROUND(AVG(r.criticality_score), 3) AS mean_criticality,
  ROUND(AVG(r.priority_score), 3) AS mean_priority
FROM risk_priority_scores r
JOIN asset_register a ON a.asset_id = r.asset_id
GROUP BY a.asset_class, r.recommended_strategy
ORDER BY mean_priority DESC;

SELECT
  asset_id,
  strategy,
  total_cost_proxy
FROM lifecycle_cost_scenarios
ORDER BY asset_id, total_cost_proxy;

SELECT
  g.asset_id,
  a.asset_name,
  g.decision,
  g.owner,
  g.status,
  g.public_note_required
FROM governance_review_log g
JOIN asset_register a ON a.asset_id = g.asset_id
ORDER BY g.status DESC, g.date;
