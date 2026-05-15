# Infrastructure Systems for Climate Adaptation

This companion directory supports the article **Infrastructure Systems for Climate Adaptation**.

The article frames climate adaptation infrastructure as an auditable service-continuity and vulnerability-reduction system that connects:

- future climate scenarios and changing baselines
- asset exposure, interdependencies, and service continuity
- water, transport, energy, buildings, digital infrastructure, and ecological systems
- nature-based infrastructure and lifecycle stewardship
- adaptation finance, maintenance, public accountability, and implementation gaps
- equity, vulnerability, adaptive capacity, and maladaptation review
- observability, early warning, reporting, and governance revision

## Technical focus

This scaffold models climate adaptation as an evidence system rather than a loose project label. It demonstrates readiness scoring, adaptation portfolio reporting, schema validation, SQL evidence tables, and lightweight systems-code examples.

## Run examples

```bash
bash bash/validate_manifests.sh
python3 python/adaptation_readiness_scoring.py
Rscript r/adaptation_portfolio_reporting.R
sqlite3 outputs/climate_adaptation_infrastructure.db < sql/schema.sql
sqlite3 outputs/climate_adaptation_infrastructure.db < sql/sample_queries.sql
```
