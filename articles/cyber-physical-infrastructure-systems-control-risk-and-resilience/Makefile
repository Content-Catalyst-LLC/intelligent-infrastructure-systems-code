.PHONY: validate python r sql c embedded-c fortran rust go julia all

validate:
	bash bash/validate_manifests.sh

python:
	python3 python/cyber_physical_infrastructure_review.py

r:
	Rscript r/cyber_physical_infrastructure_reporting.R

sql:
	sqlite3 outputs/cyber_physical_infrastructure.db < sql/schema.sql
	sqlite3 outputs/cyber_physical_infrastructure.db < sql/load_csvs.sql
	sqlite3 outputs/cyber_physical_infrastructure.db < sql/sample_queries.sql

c:
	cc c/src/control_integrity_metrics.c -I c/include -o outputs/control_integrity_metrics
	./outputs/control_integrity_metrics

embedded-c:
	cc embedded_c/edge_control_safety_check.c -o outputs/edge_control_safety_check
	./outputs/edge_control_safety_check

fortran:
	gfortran fortran/cyber_physical_resilience_model.f90 -o outputs/cyber_physical_resilience_model
	./outputs/cyber_physical_resilience_model

rust:
	cd rust && cargo run

go:
	go run go/cyber_physical_status_service.go

julia:
	julia julia/cyber_physical_resilience_scenario_model.jl

all: validate python c embedded-c
