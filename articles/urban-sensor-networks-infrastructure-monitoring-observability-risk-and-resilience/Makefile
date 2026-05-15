.PHONY: validate python r sql c embedded-c fortran rust go julia all

validate:
	bash bash/validate_manifests.sh

python:
	python3 python/urban_sensor_network_monitoring_review.py

r:
	Rscript r/urban_sensor_network_reporting.R

sql:
	sqlite3 outputs/urban_sensor_networks.db < sql/schema.sql
	sqlite3 outputs/urban_sensor_networks.db < sql/load_csvs.sql
	sqlite3 outputs/urban_sensor_networks.db < sql/sample_queries.sql

c:
	cc c/src/urban_sensor_quality.c -I c/include -o outputs/urban_sensor_quality
	./outputs/urban_sensor_quality

embedded-c:
	cc embedded_c/edge_sensor_quality_check.c -o outputs/edge_sensor_quality_check
	./outputs/edge_sensor_quality_check

fortran:
	gfortran fortran/urban_observability_model.f90 -o outputs/urban_observability_model
	./outputs/urban_observability_model

rust:
	cd rust && cargo run

go:
	go run go/urban_sensor_status_service.go

julia:
	julia julia/urban_sensor_observability_scenario_model.jl

all: validate python c embedded-c
