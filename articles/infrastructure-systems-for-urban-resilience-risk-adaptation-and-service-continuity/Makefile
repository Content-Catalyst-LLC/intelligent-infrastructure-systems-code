.PHONY: validate python r sql c embedded-c fortran rust go julia all

validate:
	bash bash/validate_manifests.sh

python:
	python3 python/urban_resilience_service_continuity_review.py

r:
	Rscript r/urban_resilience_reporting.R

sql:
	sqlite3 outputs/urban_resilience_infrastructure.db < sql/schema.sql
	sqlite3 outputs/urban_resilience_infrastructure.db < sql/load_csvs.sql
	sqlite3 outputs/urban_resilience_infrastructure.db < sql/sample_queries.sql

c:
	cc c/src/urban_resilience_metrics.c -I c/include -o outputs/urban_resilience_metrics
	./outputs/urban_resilience_metrics

embedded-c:
	cc embedded_c/service_status_quality_check.c -o outputs/service_status_quality_check
	./outputs/service_status_quality_check

fortran:
	gfortran fortran/urban_resilience_model.f90 -o outputs/urban_resilience_model
	./outputs/urban_resilience_model

rust:
	cd rust && cargo run

go:
	go run go/urban_resilience_status_service.go

julia:
	julia julia/urban_resilience_scenario_model.jl

all: validate python c embedded-c
