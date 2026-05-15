# Digital Infrastructure Systems

Companion repository directory for **Digital Infrastructure Systems: Networks, Cloud, Data and Governance**.

This scaffold treats digital infrastructure as a layered public and institutional capability: connectivity, compute, storage, interoperability, identity, trust, cybersecurity, continuity, access, inclusion, dependency governance, and long-term stewardship.

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

python3 python/digital_infrastructure_review.py
Rscript r/digital_infrastructure_reporting.R

sqlite3 outputs/digital_infrastructure.db < sql/schema.sql
sqlite3 outputs/digital_infrastructure.db < sql/load_csvs.sql
sqlite3 outputs/digital_infrastructure.db < sql/sample_queries.sql
```

Optional systems checks:

```bash
cc c/src/digital_infrastructure_capacity_metrics.c -I c/include -o outputs/digital_infrastructure_capacity_metrics && ./outputs/digital_infrastructure_capacity_metrics
cc embedded_c/edge_service_continuity_check.c -o outputs/edge_service_continuity_check && ./outputs/edge_service_continuity_check
gfortran fortran/digital_infrastructure_resilience_model.f90 -o outputs/digital_infrastructure_resilience_model && ./outputs/digital_infrastructure_resilience_model
go run go/digital_infrastructure_status_service.go
(cd rust && cargo run)
julia julia/digital_infrastructure_resilience_scenario_model.jl
(cd typescript && npm install && npm run build)
pytest tests
```

## Warning

All data and code are illustrative. Production digital infrastructure work requires certified network engineering, cybersecurity assessment, privacy and rights review, public procurement review, competition and vendor-dependency analysis, accessibility testing, operational authority, institutional governance, and real infrastructure data.
