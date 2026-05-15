.PHONY: validate python r sql c embedded-c fortran rust go julia all

validate:
	bash bash/validate_manifests.sh

python:
	python3 python/smart_grid_infrastructure_review.py

r:
	Rscript r/smart_grid_infrastructure_reporting.R

sql:
	sqlite3 outputs/smart_grid_infrastructure.db < sql/schema.sql
	sqlite3 outputs/smart_grid_infrastructure.db < sql/load_csvs.sql
	sqlite3 outputs/smart_grid_infrastructure.db < sql/sample_queries.sql

c:
	cc c/src/smart_grid_metrics.c -I c/include -o outputs/smart_grid_metrics
	./outputs/smart_grid_metrics

embedded-c:
	cc embedded_c/edge_grid_quality_check.c -o outputs/edge_grid_quality_check
	./outputs/edge_grid_quality_check

fortran:
	gfortran fortran/grid_resilience_model.f90 -o outputs/grid_resilience_model
	./outputs/grid_resilience_model

rust:
	cd rust && cargo run

go:
	go run go/smart_grid_status_service.go

julia:
	julia julia/smart_grid_scenario_model.jl

all: validate python c embedded-c
