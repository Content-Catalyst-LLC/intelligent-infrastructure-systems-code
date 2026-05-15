# Climate Monitoring Infrastructure

This companion directory supports the article **Climate Monitoring Infrastructure: Baselines, Observation, and Long-Term Climate Risk**.

The article frames climate monitoring as long-duration public knowledge infrastructure: an observing, metadata, archive, analytical, governance, and decision-support system that turns measurements into credible climate evidence.

## Engineering purpose

This scaffold is designed for engineers, climate-data teams, environmental monitoring researchers, data platform architects, embedded systems developers, field instrumentation teams, public-sector climate services teams, and infrastructure-risk analysts.

It does **not** replace official climate services, certified meteorological systems, operational observing networks, or authoritative climatological assessments.

## What this scaffold includes

- Data artifacts for Essential Climate Variables, observing platforms, instrument metadata, calibration, sample observations, archives, and governance.
- Python and R workflows for baselines, anomalies, completeness, station quality, and trends.
- SQL schema and auditable queries for climate monitoring records.
- C and embedded C examples for station-quality and sensor-range validation.
- Rust validator scaffold for strict record checks.
- Go service scaffold for station-health and climate-indicator metadata.
- Fortran routine for baseline, anomaly, and trend-style calculations.
- MicroPython example for edge climate observing-node telemetry.
- PYNQ scaffold for FPGA-assisted stream quality checking.
- HDL / Verilog module for fixed-point sensor bounds and quality flags.
- Julia scenario model scaffold.
- TypeScript dashboard model scaffold.
- JSON schemas, model cards, governance notes, readiness gates, and tests.

## Run examples

```bash
bash bash/validate_manifests.sh
bash bash/run_local_workflows.sh

python3 python/climate_baseline_anomaly_review.py
Rscript r/climate_station_trend_reporting.R

sqlite3 outputs/climate_monitoring_infrastructure.db < sql/schema.sql
sqlite3 outputs/climate_monitoring_infrastructure.db < sql/load_csvs.sql
sqlite3 outputs/climate_monitoring_infrastructure.db < sql/sample_queries.sql
```

Optional systems checks:

```bash
cc c/src/climate_record_quality.c -I c/include -o outputs/climate_record_quality && ./outputs/climate_record_quality
cc embedded_c/station_sensor_quality_check.c -o outputs/station_sensor_quality_check && ./outputs/station_sensor_quality_check
gfortran fortran/climate_baseline_model.f90 -o outputs/climate_baseline_model && ./outputs/climate_baseline_model
go run go/climate_monitoring_status_service.go
(cd rust && cargo run)
julia julia/climate_monitoring_scenario_model.jl
(cd typescript && npm install && npm run build)
pytest tests
```

## Important warning

All data and code are illustrative. Operational climate monitoring requires validated instruments, documented station metadata, calibration programs, long-term archive governance, scientific quality-control standards, domain expertise, uncertainty review, and institutional continuity.
