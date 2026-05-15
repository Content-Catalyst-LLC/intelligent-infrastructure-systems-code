# Flood and Disaster Early Warning Infrastructure

This companion directory supports the article **Flood and Disaster Early Warning Infrastructure: Detection, Communication, and Protective Action**.

The article frames early warning as public-safety infrastructure: a full warning-action chain connecting risk knowledge, observation, forecasting, warning dissemination, accessibility, preparedness, protective action, governance, and after-action learning.

## Engineering purpose

This scaffold is designed for engineers, infrastructure analysts, emergency-management researchers, public-sector data teams, hydrology and climate-risk teams, edge/embedded developers, and systems architects.

It does **not** issue live warnings, certify safety, replace emergency-management authority, or substitute for validated operational meteorological/hydrological systems.

## What this scaffold includes

- Data artifacts for hazards, observations, forecasts, channels, preparedness, inclusion, and governance.
- Python and R workflows for warning-chain analysis and reporting.
- SQL schema and auditable queries.
- C and embedded C examples for field sensor validation and threshold logic.
- Rust validator scaffold for strict record checks.
- Go status-service scaffold for lightweight infrastructure-health endpoints.
- Fortran routine for numerical threshold / risk calculations.
- MicroPython example for edge rainfall / river-stage telemetry.
- PYNQ scaffold for FPGA-assisted streaming threshold checks.
- HDL / Verilog module for simple threshold detection.
- Julia scenario model scaffold.
- TypeScript dashboard model scaffold.
- JSON schemas, model cards, governance notes, and tests.

## Run examples

```bash
bash bash/validate_manifests.sh
bash bash/run_local_workflows.sh

python3 python/early_warning_chain_review.py
Rscript r/early_warning_reporting.R

sqlite3 outputs/early_warning_infrastructure.db < sql/schema.sql
sqlite3 outputs/early_warning_infrastructure.db < sql/load_csvs.sql
sqlite3 outputs/early_warning_infrastructure.db < sql/sample_queries.sql
```

Optional systems checks:

```bash
cc c/src/warning_chain_math.c -I c/include -o outputs/warning_chain_math && ./outputs/warning_chain_math
cc embedded_c/edge_threshold_detector.c -o outputs/edge_threshold_detector && ./outputs/edge_threshold_detector
gfortran fortran/warning_risk_model.f90 -o outputs/warning_risk_model && ./outputs/warning_risk_model
go run go/early_warning_status_service.go
(cd rust && cargo run)
julia julia/early_warning_scenario_model.jl
(cd typescript && npm install && npm run build)
pytest tests
```

## Important warning

All data and code are illustrative. Operational early-warning systems require validated sensors, authority to issue warnings, tested communications, redundancy, accessibility protocols, community preparedness, emergency-management governance, and after-action review.
