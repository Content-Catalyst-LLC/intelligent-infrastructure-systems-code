# Monitoring Energy Infrastructure Performance

Companion repository directory for **Monitoring Energy Infrastructure Performance: Reliability, Degradation and Resilience**.

This scaffold treats energy performance monitoring as public infrastructure observability and lifecycle stewardship: asset inventories, telemetry, reliability, degradation, asset condition, power quality, service continuity, resilience, digital monitoring, cybersecurity, governance, and maintenance decision pathways.

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

python3 python/energy_infrastructure_performance_review.py
Rscript r/energy_infrastructure_performance_reporting.R

sqlite3 outputs/energy_infrastructure_performance.db < sql/schema.sql
sqlite3 outputs/energy_infrastructure_performance.db < sql/load_csvs.sql
sqlite3 outputs/energy_infrastructure_performance.db < sql/sample_queries.sql
```

Optional systems checks:

```bash
cc c/src/energy_performance_metrics.c -I c/include -o outputs/energy_performance_metrics && ./outputs/energy_performance_metrics
cc embedded_c/edge_energy_quality_check.c -o outputs/edge_energy_quality_check && ./outputs/edge_energy_quality_check
gfortran fortran/energy_resilience_model.f90 -o outputs/energy_resilience_model && ./outputs/energy_resilience_model
go run go/energy_asset_status_service.go
(cd rust && cargo run)
julia julia/energy_performance_scenario_model.jl
(cd typescript && npm install && npm run build)
pytest tests
```

## Warning

All data and code are illustrative. Operational energy infrastructure monitoring requires certified grid-operations review, protection engineering, safety procedures, cybersecurity testing, regulatory compliance, validated telemetry, asset-specific engineering judgment, and operator authority.
