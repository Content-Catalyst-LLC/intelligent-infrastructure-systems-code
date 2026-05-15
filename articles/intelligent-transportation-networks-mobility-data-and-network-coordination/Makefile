.PHONY: validate python r sql c embedded-c fortran rust go julia all

validate:
	bash bash/validate_manifests.sh

python:
	python3 python/intelligent_transportation_network_review.py

r:
	Rscript r/intelligent_transportation_reporting.R

sql:
	sqlite3 outputs/intelligent_transportation_networks.db < sql/schema.sql
	sqlite3 outputs/intelligent_transportation_networks.db < sql/load_csvs.sql
	sqlite3 outputs/intelligent_transportation_networks.db < sql/sample_queries.sql

c:
	cc c/src/transportation_metrics.c -I c/include -o outputs/transportation_metrics
	./outputs/transportation_metrics

embedded-c:
	cc embedded_c/edge_mobility_quality_check.c -o outputs/edge_mobility_quality_check
	./outputs/edge_mobility_quality_check

fortran:
	gfortran fortran/transportation_network_model.f90 -o outputs/transportation_network_model
	./outputs/transportation_network_model

rust:
	cd rust && cargo run

go:
	go run go/transportation_status_service.go

julia:
	julia julia/transportation_network_scenario_model.jl

all: validate python c embedded-c
