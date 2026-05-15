.PHONY: validate python r sql tests smoke clean

validate:
	bash bash/validate_manifests.sh
	PYTHONPATH=python python3 python/validate_adaptation_records.py

python:
	PYTHONPATH=python python3 python/adaptation_readiness_scoring.py
	PYTHONPATH=python python3 python/service_continuity_analysis.py

r:
	Rscript r/adaptation_portfolio_reporting.R

sql:
	rm -f outputs/climate_adaptation_infrastructure.db
	sqlite3 outputs/climate_adaptation_infrastructure.db < sql/schema.sql
	sqlite3 outputs/climate_adaptation_infrastructure.db < sql/load_sample_data.sql
	sqlite3 outputs/climate_adaptation_infrastructure.db < sql/sample_queries.sql > outputs/sql_query_results.txt
	tail -n +1 outputs/sql_query_results.txt

tests:
	PYTHONPATH=python python3 -m unittest discover -s tests

smoke:
	bash bash/smoke_test.sh

clean:
	rm -f outputs/*.csv outputs/*.json outputs/*.txt outputs/*.db
