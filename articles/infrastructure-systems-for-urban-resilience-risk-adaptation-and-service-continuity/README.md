# Infrastructure Systems for Urban Resilience

This companion directory supports the article **Infrastructure Systems for Urban Resilience: Risk, Adaptation, and Service Continuity**.

The article frames urban resilience as service-continuity infrastructure: a systems discipline connecting hazards, chronic stresses, critical services, infrastructure dependencies, operations, redundancy, recovery, nature-based systems, social vulnerability, governance capacity, and long-term adaptation.

## Engineering purpose

This scaffold is designed for infrastructure engineers, urban resilience teams, emergency-management analysts, public works departments, utility planners, climate-adaptation teams, transportation and water agencies, data platform teams, embedded monitoring engineers, and public-sector governance researchers.

It does **not** replace official emergency management, certified infrastructure design, public-safety authority, capital planning due diligence, engineering signoff, or community-led resilience planning.

## What this scaffold includes

- Data artifacts for hazards, chronic stresses, critical services, dependency graphs, service-continuity targets, recovery plans, vulnerability reviews, nature-based systems, and governance actions.
- Python and R workflows for service continuity, cascading dependency stress, recovery lag, equity gaps, and resilience watchlists.
- SQL schema and auditable queries for urban resilience records.
- C and embedded C examples for service-continuity and edge status validation.
- Rust validator scaffold for strict critical-service and dependency records.
- Go service scaffold for critical-service status endpoints.
- Fortran routine for numerical continuity, risk, and recovery calculations.
- MicroPython example for low-power urban infrastructure status telemetry.
- PYNQ scaffold for FPGA-assisted stream validation.
- HDL / Verilog module for fixed-point service-threshold checks.
- Julia scenario model scaffold.
- TypeScript dashboard model scaffold.
- JSON schemas, model cards, governance notes, readiness gates, and tests.

## Run examples

```bash
bash bash/validate_manifests.sh
bash bash/run_local_workflows.sh

python3 python/urban_resilience_service_continuity_review.py
Rscript r/urban_resilience_reporting.R

sqlite3 outputs/urban_resilience_infrastructure.db < sql/schema.sql
sqlite3 outputs/urban_resilience_infrastructure.db < sql/load_csvs.sql
sqlite3 outputs/urban_resilience_infrastructure.db < sql/sample_queries.sql
```

Optional systems checks:

```bash
cc c/src/urban_resilience_metrics.c -I c/include -o outputs/urban_resilience_metrics && ./outputs/urban_resilience_metrics
cc embedded_c/service_status_quality_check.c -o outputs/service_status_quality_check && ./outputs/service_status_quality_check
gfortran fortran/urban_resilience_model.f90 -o outputs/urban_resilience_model && ./outputs/urban_resilience_model
go run go/urban_resilience_status_service.go
(cd rust && cargo run)
julia julia/urban_resilience_scenario_model.jl
(cd typescript && npm install && npm run build)
pytest tests
```

## Important warning

All data and code are illustrative. Operational urban resilience work requires validated hazard data, infrastructure engineering review, public-sector authority, emergency-management coordination, community participation, finance and maintenance analysis, accessibility review, and accountable governance.
