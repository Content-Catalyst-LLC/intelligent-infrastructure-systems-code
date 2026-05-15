# Cyber-Physical Infrastructure Systems

Companion repository directory for **Cyber-Physical Infrastructure Systems: Control, Risk and Resilience**.

This scaffold treats cyber-physical infrastructure as a coupled digital-physical control problem: physical assets, sensors, telemetry, control loops, decision logic, actuation, human oversight, cybersecurity, dependency mapping, fallback, recovery, and public accountability.

## Included stack

- Analytics: Python, R, SQL, Julia
- Systems: C, Embedded C, Rust, Go, Fortran
- Edge/hardware: MicroPython, PYNQ, Verilog HDL, VHDL placeholder
- Interface: TypeScript
- Governance: schemas, model cards, policies, readiness gates, tests, public evidence package

## Run

```bash
bash bash/validate_manifests.sh
bash bash/run_local_workflows.sh

python3 python/cyber_physical_infrastructure_review.py
Rscript r/cyber_physical_infrastructure_reporting.R

sqlite3 outputs/cyber_physical_infrastructure.db < sql/schema.sql
sqlite3 outputs/cyber_physical_infrastructure.db < sql/load_csvs.sql
sqlite3 outputs/cyber_physical_infrastructure.db < sql/sample_queries.sql
```

Optional systems checks:

```bash
cc c/src/control_integrity_metrics.c -I c/include -o outputs/control_integrity_metrics && ./outputs/control_integrity_metrics
cc embedded_c/edge_control_safety_check.c -o outputs/edge_control_safety_check && ./outputs/edge_control_safety_check
gfortran fortran/cyber_physical_resilience_model.f90 -o outputs/cyber_physical_resilience_model && ./outputs/cyber_physical_resilience_model
go run go/cyber_physical_status_service.go
(cd rust && cargo run)
julia julia/cyber_physical_resilience_scenario_model.jl
(cd typescript && npm install && npm run build)
pytest tests
```

## Warning

All data and code are illustrative. Production cyber-physical infrastructure requires certified control engineering, domain engineering, operational authority, cybersecurity assessment, safety review, field testing, public-agency review, regulatory compliance, incident response planning, and accountable governance.
