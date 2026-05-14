# Infrastructure Security and Cyber Resilience

This companion directory supports the article **Infrastructure Security and Cyber Resilience: OT Protection, Continuity, and Recovery**.

The article frames infrastructure security as a cyber-physical public-service continuity discipline rather than a narrow information-technology function.

The companion repository connects:

- cyber resilience objective manifests
- cyber asset registers
- OT zone and conduit maps
- cybersecurity control baselines
- cyber incident scenario manifests
- continuity and recovery logs
- vendor-risk registers
- cyber governance records
- public evidence templates
- Python, R, SQL, TypeScript, Go, Rust, C, C++, shell validation, and notebook scaffolding

## Technical focus

This scaffold models cyber resilience as the ability to prevent compromise where possible, detect compromise quickly when prevention fails, contain disruption, maintain essential services under degraded conditions, restore trustworthy operations, communicate with affected publics, and learn after disruption.

Core engineering themes:

- IT / OT / ICS asset visibility
- identity and privileged-access governance
- network segmentation and zone/conduit mapping
- control baselines aligned to practical cyber-resilience functions
- cyber-physical incident scenarios
- continuity and recovery objectives
- vendor and supply-chain risk
- governance, exception handling, residual-risk acceptance, and public evidence
- operational observability of the cyber-resilience program itself

## Run examples

```bash
bash bash/validate_manifests.sh
python3 python/cyber_resilience_readiness.py
Rscript r/cyber_resilience_reporting.R
sqlite3 outputs/infrastructure_cyber_resilience.db < sql/schema.sql
sqlite3 outputs/infrastructure_cyber_resilience.db < sql/sample_queries.sql
```
