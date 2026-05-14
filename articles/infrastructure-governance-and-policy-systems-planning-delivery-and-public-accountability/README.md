# Infrastructure Governance and Policy Systems

This companion directory supports the article **Infrastructure Governance and Policy Systems: Planning, Delivery, and Public Accountability**.

The article frames infrastructure governance as the institutional operating system through which infrastructure is selected, financed, procured, delivered, operated, maintained, adapted, disclosed, and held accountable.

The companion repository connects:

- governance objective manifests
- infrastructure project registers
- project appraisal and prioritization records
- fiscal-risk and affordability registers
- procurement and delivery logs
- asset stewardship and maintenance records
- institutional responsibility matrices
- transparency and accountability logs
- policy-learning records
- public evidence templates
- Python, R, SQL, TypeScript, Go, Rust, C, C++, shell validation, and notebook scaffolding

## Technical focus

This scaffold models infrastructure governance as a life-cycle evidence system. It supports analysis of whether projects have clear public purpose, credible appraisal, sustainable finance, manageable delivery risk, funded stewardship, usable transparency, public accountability, and mechanisms for policy learning.

Core governance themes:

- strategic planning and project prioritization
- public-value appraisal and options analysis
- fiscal sustainability and life-cycle cost
- procurement integrity and contract management
- operations, maintenance, and asset stewardship
- institutional responsibility and multilevel coordination
- transparency, auditability, consultation, and public evidence
- policy learning and adaptive governance
- reproducible governance indicators and review workflows

## Run examples

```bash
bash bash/validate_manifests.sh
python3 python/governance_readiness_review.py
Rscript r/governance_reporting.R
sqlite3 outputs/infrastructure_governance.db < sql/schema.sql
sqlite3 outputs/infrastructure_governance.db < sql/sample_queries.sql
```
