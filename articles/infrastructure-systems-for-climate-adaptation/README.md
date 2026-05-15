# Infrastructure Systems for Climate Adaptation

This companion directory supports the article **Infrastructure Systems for Climate Adaptation**.

It treats climate-adaptation infrastructure as an auditable systems-engineering problem rather than a generic resilience theme. The scaffold connects climate scenarios, asset exposure, dependency mapping, service-continuity targets, vulnerable-population review, adaptation options, lifecycle finance, maintenance responsibility, maladaptation screening, monitoring indicators, and governance revision.

## Technical scope

The code and data here are intentionally small but structurally rigorous. They are designed to demonstrate how a climate-adaptation infrastructure evidence package can be organized for reproducible review.

Core engineering concerns:

- non-stationary climate assumptions
- asset exposure and vulnerability
- critical-service continuity
- infrastructure dependencies and cascading risk
- adaptation-option comparison
- lifecycle finance and maintenance readiness
- equity and vulnerable-population protection
- maladaptation screening
- monitoring, validation, and public accountability

## Quick start

```bash
bash bash/smoke_test.sh
python3 python/adaptation_readiness_scoring.py
python3 python/service_continuity_analysis.py
Rscript r/adaptation_portfolio_reporting.R
sqlite3 outputs/climate_adaptation_infrastructure.db < sql/schema.sql
sqlite3 outputs/climate_adaptation_infrastructure.db < sql/load_sample_data.sql
sqlite3 outputs/climate_adaptation_infrastructure.db < sql/sample_queries.sql
```

## Engineering interpretation

A project should not be called adaptation-ready merely because it addresses a climate hazard. It should define the hazard scenario, service target, dependency chain, exposed populations, delivery pathway, maintenance model, monitoring indicators, and revision process. This scaffold makes those claims inspectable.
