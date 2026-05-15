# Intelligent Transportation Networks

Companion repository directory for **Intelligent Transportation Networks: Mobility, Data, and Network Coordination**.

This scaffold treats intelligent transportation as public mobility coordination infrastructure: physical transport assets, sensing, telemetry, data integration, reliability analysis, accessibility review, safety, freight and curb management, traffic and transit operations, cybersecurity, governance, and response workflows.

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

python3 python/intelligent_transportation_network_review.py
Rscript r/intelligent_transportation_reporting.R

sqlite3 outputs/intelligent_transportation_networks.db < sql/schema.sql
sqlite3 outputs/intelligent_transportation_networks.db < sql/load_csvs.sql
sqlite3 outputs/intelligent_transportation_networks.db < sql/sample_queries.sql
```

Optional systems checks:

```bash
cc c/src/transportation_metrics.c -I c/include -o outputs/transportation_metrics && ./outputs/transportation_metrics
cc embedded_c/edge_mobility_quality_check.c -o outputs/edge_mobility_quality_check && ./outputs/edge_mobility_quality_check
gfortran fortran/transportation_network_model.f90 -o outputs/transportation_network_model && ./outputs/transportation_network_model
go run go/transportation_status_service.go
(cd rust && cargo run)
julia julia/transportation_network_scenario_model.jl
(cd typescript && npm install && npm run build)
pytest tests
```

## Warning

All data and code are illustrative. Operational intelligent transportation work requires certified transport engineering review, public authority, cybersecurity testing, accessibility compliance, privacy review, validated field data, emergency-management coordination, and domain-specific planning judgment.
