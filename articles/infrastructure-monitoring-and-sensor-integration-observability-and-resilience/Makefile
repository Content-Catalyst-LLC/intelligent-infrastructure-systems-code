.PHONY: validate python r sql c embedded-c fortran rust go julia all

validate:
	bash bash/validate_manifests.sh

python:
	python3 python/infrastructure_monitoring_review.py

r:
	Rscript r/infrastructure_monitoring_reporting.R

sql:
	sqlite3 outputs/infrastructure_monitoring.db < sql/schema.sql
	sqlite3 outputs/infrastructure_monitoring.db < sql/load_csvs.sql
	sqlite3 outputs/infrastructure_monitoring.db < sql/sample_queries.sql

c:
	cc c/src/monitoring_observability_metrics.c -I c/include -lm -o outputs/monitoring_observability_metrics
	./outputs/monitoring_observability_metrics

embedded-c:
	cc embedded_c/edge_sensor_quality_check.c -o outputs/edge_sensor_quality_check
	./outputs/edge_sensor_quality_check

fortran:
	gfortran fortran/monitoring_resilience_model.f90 -o outputs/monitoring_resilience_model
	./outputs/monitoring_resilience_model

rust:
	cd rust && cargo run

go:
	go run go/monitoring_status_service.go

julia:
	julia julia/monitoring_observability_scenario_model.jl

all: validate python c embedded-c
