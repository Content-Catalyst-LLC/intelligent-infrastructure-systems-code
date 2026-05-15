# Smart Energy Grids and Digital Power Systems

Companion repository directory for **Smart Energy Grids and Digital Power Systems: Resilience, Flexibility and Control**.

This scaffold treats smart grids as public, safety-critical cyber-physical infrastructure: generation, transmission, distribution, storage, DERs, EV charging, demand response, telemetry, observability, voltage adequacy, balancing pressure, reliability, resilience, cybersecurity, interoperability, governance, and operator-centered response workflows.

## Included stack

- Analytics: Python, R, SQL, Julia
- Systems: C, Embedded C, Rust, Go, Fortran
- Edge/hardware: MicroPython, PYNQ, Verilog HDL, VHDL placeholder
- Interface: TypeScript
- Governance: schemas, model cards, policies, readiness gates, tests, evidence package

## Run

```bash
bash bash/validate_manifests.sh
bash bash/run_local_workflows.sh

python3 python/smart_grid_infrastructure_review.py
Rscript r/smart_grid_infrastructure_reporting.R

sqlite3 outputs/smart_grid_infrastructure.db < sql/schema.sql
sqlite3 outputs/smart_grid_infrastructure.db < sql/load_csvs.sql
sqlite3 outputs/smart_grid_infrastructure.db < sql/sample_queries.sql
```

Optional systems checks:

```bash
cc c/src/smart_grid_metrics.c -I c/include -o outputs/smart_grid_metrics && ./outputs/smart_grid_metrics
cc embedded_c/edge_grid_quality_check.c -o outputs/edge_grid_quality_check && ./outputs/edge_grid_quality_check
gfortran fortran/grid_resilience_model.f90 -o outputs/grid_resilience_model && ./outputs/grid_resilience_model
go run go/smart_grid_status_service.go
(cd rust && cargo run)
julia julia/smart_grid_scenario_model.jl
(cd typescript && npm install && npm run build)
pytest tests
```

## Warning

All data and code are illustrative. Operational smart-grid work requires certified grid operations, protection engineering, reliability standards, cybersecurity review, regulatory compliance, validated telemetry, field engineering, operator authority, and emergency-management coordination.
