# Infrastructure for Renewable Energy Systems

Companion repository directory for **Infrastructure for Renewable Energy Systems: Grids, Storage and Flexibility**.

This scaffold treats renewable energy infrastructure as a full system integration problem: renewable generation, grid connection, interconnection, transmission and distribution constraints, curtailment, storage, flexibility, forecasting, distributed resources, inverter/device visibility, resilience, cybersecurity, planning governance, and public evidence.

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

python3 python/renewable_infrastructure_review.py
Rscript r/renewable_infrastructure_reporting.R

sqlite3 outputs/renewable_infrastructure.db < sql/schema.sql
sqlite3 outputs/renewable_infrastructure.db < sql/load_csvs.sql
sqlite3 outputs/renewable_infrastructure.db < sql/sample_queries.sql
```

Optional systems checks:

```bash
cc c/src/renewable_infrastructure_metrics.c -I c/include -o outputs/renewable_infrastructure_metrics && ./outputs/renewable_infrastructure_metrics
cc embedded_c/edge_renewable_quality_check.c -o outputs/edge_renewable_quality_check && ./outputs/edge_renewable_quality_check
gfortran fortran/renewable_flexibility_model.f90 -o outputs/renewable_flexibility_model && ./outputs/renewable_flexibility_model
go run go/renewable_status_service.go
(cd rust && cargo run)
julia julia/renewable_infrastructure_scenario_model.jl
(cd typescript && npm install && npm run build)
pytest tests
```

## Warning

All data and code are illustrative. Operational renewable energy infrastructure work requires certified power-system planning, grid-operations review, protection engineering, cybersecurity testing, regulatory compliance, environmental and public-interest review, validated telemetry, and operator authority.
