# Urban Sensor Networks and Infrastructure Monitoring

Companion repository directory for **Urban Sensor Networks and Infrastructure Monitoring: Observability, Risk, and Resilience**.

This scaffold treats urban sensor networks as public observability infrastructure: devices, telemetry, calibration, asset linkages, metadata, data quality, coverage, cybersecurity, governance, and response workflows.

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

python3 python/urban_sensor_network_monitoring_review.py
Rscript r/urban_sensor_network_reporting.R

sqlite3 outputs/urban_sensor_networks.db < sql/schema.sql
sqlite3 outputs/urban_sensor_networks.db < sql/load_csvs.sql
sqlite3 outputs/urban_sensor_networks.db < sql/sample_queries.sql
```

Optional systems checks:

```bash
cc c/src/urban_sensor_quality.c -I c/include -o outputs/urban_sensor_quality && ./outputs/urban_sensor_quality
cc embedded_c/edge_sensor_quality_check.c -o outputs/edge_sensor_quality_check && ./outputs/edge_sensor_quality_check
gfortran fortran/urban_observability_model.f90 -o outputs/urban_observability_model && ./outputs/urban_observability_model
go run go/urban_sensor_status_service.go
(cd rust && cargo run)
julia julia/urban_sensor_observability_scenario_model.jl
(cd typescript && npm install && npm run build)
pytest tests
```

## Warning

All data and code are illustrative. Operational urban sensing requires calibrated devices, secure communications, privacy and rights review, cybersecurity testing, maintenance workflows, public governance, and domain-specific engineering judgment.
