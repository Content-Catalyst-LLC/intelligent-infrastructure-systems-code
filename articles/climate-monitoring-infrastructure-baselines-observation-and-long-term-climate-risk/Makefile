.PHONY: validate python r sql c embedded-c fortran rust go julia all

validate:
	bash bash/validate_manifests.sh

python:
	python3 python/climate_baseline_anomaly_review.py

r:
	Rscript r/climate_station_trend_reporting.R

sql:
	sqlite3 outputs/climate_monitoring_infrastructure.db < sql/schema.sql
	sqlite3 outputs/climate_monitoring_infrastructure.db < sql/load_csvs.sql
	sqlite3 outputs/climate_monitoring_infrastructure.db < sql/sample_queries.sql

c:
	cc c/src/climate_record_quality.c -I c/include -o outputs/climate_record_quality
	./outputs/climate_record_quality

embedded-c:
	cc embedded_c/station_sensor_quality_check.c -o outputs/station_sensor_quality_check
	./outputs/station_sensor_quality_check

fortran:
	gfortran fortran/climate_baseline_model.f90 -o outputs/climate_baseline_model
	./outputs/climate_baseline_model

rust:
	cd rust && cargo run

go:
	go run go/climate_monitoring_status_service.go

julia:
	julia julia/climate_monitoring_scenario_model.jl

all: validate python c embedded-c
