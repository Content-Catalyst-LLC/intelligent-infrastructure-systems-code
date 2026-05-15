.PHONY: validate python r sql c embedded-c fortran rust go julia all

validate:
	bash bash/validate_manifests.sh

python:
	python3 python/smart_city_infrastructure_review.py

r:
	Rscript r/smart_city_infrastructure_reporting.R

sql:
	sqlite3 outputs/smart_city_infrastructure.db < sql/schema.sql
	sqlite3 outputs/smart_city_infrastructure.db < sql/load_csvs.sql
	sqlite3 outputs/smart_city_infrastructure.db < sql/sample_queries.sql

c:
	cc c/src/smart_city_metrics.c -I c/include -o outputs/smart_city_metrics
	./outputs/smart_city_metrics

embedded-c:
	cc embedded_c/edge_smart_city_quality_check.c -o outputs/edge_smart_city_quality_check
	./outputs/edge_smart_city_quality_check

fortran:
	gfortran fortran/smart_city_performance_model.f90 -o outputs/smart_city_performance_model
	./outputs/smart_city_performance_model

rust:
	cd rust && cargo run

go:
	go run go/smart_city_status_service.go

julia:
	julia julia/smart_city_scenario_model.jl

all: validate python c embedded-c
