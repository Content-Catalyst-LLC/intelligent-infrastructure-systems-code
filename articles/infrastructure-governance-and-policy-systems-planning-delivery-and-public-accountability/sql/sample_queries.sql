.mode csv
.headers on

.import data/infrastructure_project_register.csv infrastructure_project_register
.import data/project_appraisal_register.csv project_appraisal_register
.import data/fiscal_risk_register.csv fiscal_risk_register
.import data/procurement_delivery_log.csv procurement_delivery_log
.import data/asset_stewardship_register.csv asset_stewardship_register
.import data/accountability_transparency_log.csv accountability_transparency_log
.import data/policy_learning_log.csv policy_learning_log

.output outputs/governance_review_required.csv
SELECT
  p.project_id,
  p.project_name,
  p.sector,
  f.fiscal_risk_status,
  s.maintenance_plan_status,
  a.public_evidence_status,
  a.audit_findings_open
FROM infrastructure_project_register p
JOIN fiscal_risk_register f USING(project_id)
JOIN asset_stewardship_register s USING(project_id)
JOIN accountability_transparency_log a USING(project_id)
WHERE f.fiscal_risk_status = 'review_required'
   OR s.maintenance_plan_status = 'review_required'
   OR a.public_evidence_status = 'review_required'
   OR a.audit_findings_open > 0;

.output stdout
SELECT 'Wrote outputs/governance_review_required.csv' AS status;
