.PHONY: validate python r sql c embedded-c fortran rust go julia all

validate:
	bash bash/validate_manifests.sh

python:
	python3 python/early_warning_chain_review.py

r:
	Rscript r/early_warning_reporting.R

sql:
	sqlite3 outputs/early_warning_infrastructure.db < sql/schema.sql
	sqlite3 outputs/early_warning_infrastructure.db < sql/load_csvs.sql
	sqlite3 outputs/early_warning_infrastructure.db < sql/sample_queries.sql

c:
	cc c/src/warning_chain_math.c -I c/include -o outputs/warning_chain_math
	./outputs/warning_chain_math

embedded-c:
	cc embedded_c/edge_threshold_detector.c -o outputs/edge_threshold_detector
	./outputs/edge_threshold_detector

fortran:
	gfortran fortran/warning_risk_model.f90 -o outputs/warning_risk_model
	./outputs/warning_risk_model

rust:
	cd rust && cargo run

go:
	go run go/early_warning_status_service.go

julia:
	julia julia/early_warning_scenario_model.jl

all: validate python c embedded-c
