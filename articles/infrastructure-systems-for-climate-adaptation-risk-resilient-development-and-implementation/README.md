# Infrastructure Systems for Climate Adaptation

This companion directory supports the article **Infrastructure Systems for Climate Adaptation: Risk, Resilient Development, and Implementation**.

The article frames climate adaptation as a systems discipline that connects changing climate baselines, infrastructure exposure, social vulnerability, nature-based systems, adaptation finance, standards, governance, monitoring, and public accountability.

## Companion scope

This scaffold connects:

- adaptation objective manifests
- climate scenario manifests
- infrastructure exposure inventories
- vulnerability and adaptive-capacity indicators
- adaptation option portfolios
- nature-based infrastructure registers
- adaptation finance and implementation logs
- maladaptation review templates
- governance evidence records
- SQL metadata
- Python and R readiness workflows
- Julia scenario scaffolding
- TypeScript dashboard scaffolding
- Go status-service scaffolding
- Rust validation scaffolding

## Run examples

```bash
bash bash/validate_manifests.sh
python3 python/adaptation_readiness_review.py
Rscript r/adaptation_portfolio_reporting.R
sqlite3 outputs/climate_adaptation_infrastructure.db < sql/schema.sql
sqlite3 outputs/climate_adaptation_infrastructure.db < sql/sample_queries.sql
```
