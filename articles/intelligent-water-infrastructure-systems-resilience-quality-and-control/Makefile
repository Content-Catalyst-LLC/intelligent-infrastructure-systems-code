.PHONY: validate python r sql c embedded-c fortran rust go julia all

validate:
	bash bash/validate_manifests.sh

python:
	python3 python/intelligent_water_infrastructure_review.py

r:
	Rscript r/intelligent_water_infrastructure_reporting.R

sql:
	sqlite3 outputs/intelligent_water_infrastructure.db < sql/schema.sql
	sqlite3 outputs/intelligent_water_infrastructure.db < sql/load_csvs.sql
	sqlite3 outputs/intelligent_water_infrastructure.db < sql/sample_queries.sql

c:
	cc c/src/water_infrastructure_metrics.c -I c/include -o outputs/water_infrastructure_metrics
	./outputs/water_infrastructure_metrics

embedded-c:
	cc embedded_c/edge_water_quality_check.c -o outputs/edge_water_quality_check
	./outputs/edge_water_quality_check

fortran:
	gfortran fortran/water_resilience_model.f90 -o outputs/water_resilience_model
	./outputs/water_resilience_model

rust:
	cd rust && cargo run

go:
	go run go/water_status_service.go

julia:
	julia julia/water_infrastructure_scenario_model.jl

all: validate python c embedded-c
