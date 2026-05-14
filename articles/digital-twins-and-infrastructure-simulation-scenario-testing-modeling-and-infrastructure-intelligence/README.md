# Digital Twins and Infrastructure Simulation

This companion directory supports the article **Digital Twins and Infrastructure Simulation: Scenario Testing, Modeling, and Infrastructure Intelligence**.

The article frames digital twins as infrastructure intelligence systems that connect:

- physical assets, network topology, environmental context, telemetry, engineering records, and geospatial data
- digital state estimation, model registries, simulation scenarios, validation, uncertainty, and sensitivity testing
- decision-support workflows for maintenance, resilience, operations, planning, and public governance
- Python, R, SQL, TypeScript, Go, Rust, C, C++, shell validation, and notebook scaffolding

## Technical focus

This scaffold models digital twins as auditable infrastructure intelligence systems rather than static 3D models or dashboards.

Core engineering themes:

- digital twin objective manifests
- asset and system registries
- telemetry source catalogs
- digital state tables
- model registry and model cards
- simulation scenario manifests
- scenario outputs and intervention comparisons
- validation and sensitivity logs
- decision and intervention governance
- public evidence packages
- uncertainty, interoperability, trust, and institutional accountability

## Run examples

```bash
bash bash/validate_manifests.sh
python3 python/digital_twin_scenario_workflow.py
Rscript r/digital_twin_scenario_reporting.R
sqlite3 outputs/digital_twin_simulation.db < sql/schema.sql
sqlite3 outputs/digital_twin_simulation.db < sql/sample_queries.sql
```
