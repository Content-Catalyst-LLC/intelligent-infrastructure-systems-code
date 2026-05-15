.PHONY: validate python r sql c embedded-c fortran rust go julia all

validate:
	bash bash/validate_manifests.sh

python:
	python3 python/energy_infrastructure_performance_review.py

r:
	Rscript r/energy_infrastructure_performance_reporting.R

sql:
	sqlite3 outputs/energy_infrastructure_performance.db < sql/schema.sql
	sqlite3 outputs/energy_infrastructure_performance.db < sql/load_csvs.sql
	sqlite3 outputs/energy_infrastructure_performance.db < sql/sample_queries.sql

c:
	cc c/src/energy_performance_metrics.c -I c/include -o outputs/energy_performance_metrics
	./outputs/energy_performance_metrics

embedded-c:
	cc embedded_c/edge_energy_quality_check.c -o outputs/edge_energy_quality_check
	./outputs/edge_energy_quality_check

fortran:
	gfortran fortran/energy_resilience_model.f90 -o outputs/energy_resilience_model
	./outputs/energy_resilience_model

rust:
	cd rust && cargo run

go:
	go run go/energy_asset_status_service.go

julia:
	julia julia/energy_performance_scenario_model.jl

all: validate python c embedded-c
