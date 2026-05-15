.PHONY: validate python r sql c embedded-c fortran rust go julia all

validate:
	bash bash/validate_manifests.sh

python:
	python3 python/digital_infrastructure_review.py

r:
	Rscript r/digital_infrastructure_reporting.R

sql:
	sqlite3 outputs/digital_infrastructure.db < sql/schema.sql
	sqlite3 outputs/digital_infrastructure.db < sql/load_csvs.sql
	sqlite3 outputs/digital_infrastructure.db < sql/sample_queries.sql

c:
	cc c/src/digital_infrastructure_capacity_metrics.c -I c/include -o outputs/digital_infrastructure_capacity_metrics
	./outputs/digital_infrastructure_capacity_metrics

embedded-c:
	cc embedded_c/edge_service_continuity_check.c -o outputs/edge_service_continuity_check
	./outputs/edge_service_continuity_check

fortran:
	gfortran fortran/digital_infrastructure_resilience_model.f90 -o outputs/digital_infrastructure_resilience_model
	./outputs/digital_infrastructure_resilience_model

rust:
	cd rust && cargo run

go:
	go run go/digital_infrastructure_status_service.go

julia:
	julia julia/digital_infrastructure_resilience_scenario_model.jl

all: validate python c embedded-c
