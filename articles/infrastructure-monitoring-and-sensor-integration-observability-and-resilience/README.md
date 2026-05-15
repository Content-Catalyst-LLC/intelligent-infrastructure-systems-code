# Infrastructure Monitoring and Sensor Integration

Companion repository directory for **Infrastructure Monitoring and Sensor Integration: Observability and Resilience**.

This scaffold treats infrastructure monitoring as a cyber-physical observability system: sensing, calibration, telemetry, metadata, device health, blind-spot analysis, data quality, sensor coverage, signal quality, monitoring observability, actionability, security, and governance response.

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

python3 python/infrastructure_monitoring_review.py
Rscript r/infrastructure_monitoring_reporting.R

sqlite3 outputs/infrastructure_monitoring.db < sql/schema.sql
sqlite3 outputs/infrastructure_monitoring.db < sql/load_csvs.sql
sqlite3 outputs/infrastructure_monitoring.db < sql/sample_queries.sql
```

Optional systems checks:

```bash
cc c/src/monitoring_observability_metrics.c -I c/include -lm -o outputs/monitoring_observability_metrics && ./outputs/monitoring_observability_metrics
cc embedded_c/edge_sensor_quality_check.c -o outputs/edge_sensor_quality_check && ./outputs/edge_sensor_quality_check
gfortran fortran/monitoring_resilience_model.f90 -o outputs/monitoring_resilience_model && ./outputs/monitoring_resilience_model
go run go/monitoring_status_service.go
(cd rust && cargo run)
julia julia/monitoring_observability_scenario_model.jl
(cd typescript && npm install && npm run build)
pytest tests
```

## Warning

All data and code are illustrative. Production infrastructure monitoring requires calibrated sensors, certified operations, validated telemetry, domain engineering, cybersecurity review, operational technology governance, field inspection, public-agency review, regulatory compliance, and accountable response authority.
