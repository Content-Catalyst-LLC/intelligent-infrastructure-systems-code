.PHONY: validate python r sql c embedded-c fortran rust go julia all

validate:
	bash bash/validate_manifests.sh

python:
	python3 python/renewable_infrastructure_review.py

r:
	Rscript r/renewable_infrastructure_reporting.R

sql:
	sqlite3 outputs/renewable_infrastructure.db < sql/schema.sql
	sqlite3 outputs/renewable_infrastructure.db < sql/load_csvs.sql
	sqlite3 outputs/renewable_infrastructure.db < sql/sample_queries.sql

c:
	cc c/src/renewable_infrastructure_metrics.c -I c/include -o outputs/renewable_infrastructure_metrics
	./outputs/renewable_infrastructure_metrics

embedded-c:
	cc embedded_c/edge_renewable_quality_check.c -o outputs/edge_renewable_quality_check
	./outputs/edge_renewable_quality_check

fortran:
	gfortran fortran/renewable_flexibility_model.f90 -o outputs/renewable_flexibility_model
	./outputs/renewable_flexibility_model

rust:
	cd rust && cargo run

go:
	go run go/renewable_status_service.go

julia:
	julia julia/renewable_infrastructure_scenario_model.jl

all: validate python c embedded-c
