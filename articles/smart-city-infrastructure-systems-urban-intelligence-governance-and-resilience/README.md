# Smart City Infrastructure Systems

Companion repository directory for **Smart City Infrastructure Systems: Urban Intelligence, Governance and Resilience**.

This scaffold treats smart city infrastructure as public urban coordination infrastructure: physical infrastructure, digital infrastructure, sensing, telemetry, service continuity, data platforms, cross-domain dependencies, public-value indicators, rights and inclusion review, cybersecurity, governance, and resilience planning.

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

python3 python/smart_city_infrastructure_review.py
Rscript r/smart_city_infrastructure_reporting.R

sqlite3 outputs/smart_city_infrastructure.db < sql/schema.sql
sqlite3 outputs/smart_city_infrastructure.db < sql/load_csvs.sql
sqlite3 outputs/smart_city_infrastructure.db < sql/sample_queries.sql
```

Optional systems checks:

```bash
cc c/src/smart_city_metrics.c -I c/include -o outputs/smart_city_metrics && ./outputs/smart_city_metrics
cc embedded_c/edge_smart_city_quality_check.c -o outputs/edge_smart_city_quality_check && ./outputs/edge_smart_city_quality_check
gfortran fortran/smart_city_performance_model.f90 -o outputs/smart_city_performance_model && ./outputs/smart_city_performance_model
go run go/smart_city_status_service.go
(cd rust && cargo run)
julia julia/smart_city_scenario_model.jl
(cd typescript && npm install && npm run build)
pytest tests
```

## Warning

All data and code are illustrative. Operational smart city infrastructure work requires public authority, certified infrastructure engineering review, cybersecurity testing, privacy and rights review, accessibility compliance, validated field data, emergency-management coordination, procurement review, and domain-specific planning judgment.
