.headers on
.mode column

SELECT
  r.risk_id,
  r.asset_id,
  r.sector,
  r.risk_type,
  ROUND(r.failure_probability * r.consequence_score, 3) AS basic_risk,
  c.criticality_score,
  ROUND(r.failure_probability * r.consequence_score * (1 + c.dependency_centrality), 3) AS system_risk,
  ROUND((r.failure_probability * r.consequence_score * (1 + c.dependency_centrality)) * (1 - r.mitigation_effectiveness), 3) AS residual_risk,
  r.continuity_readiness,
  r.governance_readiness
FROM infrastructure_risk_register r
JOIN criticality_matrix c ON c.asset_id = r.asset_id
ORDER BY residual_risk DESC;

SELECT
  r.sector,
  COUNT(*) AS risks,
  ROUND(AVG(c.criticality_score), 3) AS mean_criticality,
  ROUND(AVG(r.failure_probability * r.consequence_score), 3) AS mean_basic_risk,
  ROUND(AVG((r.failure_probability * r.consequence_score * (1 + c.dependency_centrality)) * (1 - r.mitigation_effectiveness)), 3) AS mean_residual_risk
FROM infrastructure_risk_register r
JOIN criticality_matrix c ON c.asset_id = r.asset_id
GROUP BY r.sector
ORDER BY mean_residual_risk DESC;

SELECT
  r.risk_id,
  r.sector,
  c.criticality_class,
  l.essential_function,
  l.fallback_mode,
  l.recovery_time_objective_hours,
  l.exercise_status
FROM infrastructure_risk_register r
JOIN criticality_matrix c ON c.asset_id = r.asset_id
JOIN continuity_recovery_log l ON l.risk_id = r.risk_id
ORDER BY l.recovery_time_objective_hours DESC;

SELECT
  source_asset_id,
  target_asset_id,
  dependency_type,
  dependency_strength
FROM dependency_graph_edges
ORDER BY dependency_strength DESC;

SELECT
  governance_id,
  risk_id,
  decision,
  owner,
  status,
  public_note_required
FROM risk_governance_log
ORDER BY public_note_required DESC, status DESC;
