.PHONY: validate python r sql c embedded-c fortran rust go julia all

validate:
	bash bash/validate_manifests.sh

python:
	python3 python/environmental_monitoring_indicator_review.py

r:
	Rscript r/environmental_monitoring_reporting.R

sql:
	sqlite3 outputs/environmental_monitoring_infrastructure.db < sql/schema.sql
	sqlite3 outputs/environmental_monitoring_infrastructure.db < sql/load_csvs.sql
	sqlite3 outputs/environmental_monitoring_infrastructure.db < sql/sample_queries.sql

c:
	cc c/src/environmental_monitoring_quality.c -I c/include -o outputs/environmental_monitoring_quality
	./outputs/environmental_monitoring_quality

embedded-c:
	cc embedded_c/environmental_sensor_quality_check.c -o outputs/environmental_sensor_quality_check
	./outputs/environmental_sensor_quality_check

fortran:
	gfortran fortran/environmental_risk_model.f90 -o outputs/environmental_risk_model
	./outputs/environmental_risk_model

rust:
	cd rust && cargo run

go:
	go run go/environmental_monitoring_status_service.go

julia:
	julia julia/environmental_monitoring_scenario_model.jl

all: validate python c embedded-c
