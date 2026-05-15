.headers on
.mode column

SELECT
  h.hazard_id,
  h.community_name,
  h.hazard_type,
  ROUND(f.forecast_lead_time_minutes - f.decision_delay_minutes - c.communication_delay_minutes - p.mobilization_time_minutes, 1) AS useful_lead_time_minutes,
  ROUND(o.detection_reliability * c.population_reach * c.message_comprehension * c.trust_score * p.action_capacity, 3) AS protective_warning_probability,
  ROUND(h.hazard_severity * h.exposure_score * h.vulnerability_score * (1 - (o.detection_reliability * c.population_reach * c.message_comprehension * c.trust_score * p.action_capacity)), 3) AS residual_warning_risk,
  a.review_status AS accessibility_review_status
FROM hazard_exposure_register h
LEFT JOIN observation_network_inventory o ON h.hazard_id = o.hazard_id
LEFT JOIN forecast_product_register f ON h.hazard_id = f.hazard_id
LEFT JOIN warning_channel_register c ON h.warning_zone_id = c.warning_zone_id
LEFT JOIN preparedness_action_log p ON h.warning_zone_id = p.warning_zone_id
LEFT JOIN accessibility_inclusion_review a ON h.warning_zone_id = a.warning_zone_id
ORDER BY residual_warning_risk DESC;
