# Predictive Maintenance Model Card

## Intended use

- prioritize assets for inspection, maintenance, rehabilitation, renewal, or urgent review
- combine asset condition, age, failure probability, service consequence, environmental exposure, and criticality
- support lifecycle planning and governance review
- create auditable intervention shortlists

## Not intended for

- replacing engineering inspection
- automating maintenance deferral
- making public safety decisions without human review
- treating model scores as precise estimates of failure
- ignoring uninstrumented assets or field knowledge

## Required caveats

- model outputs depend on data completeness
- asset classes require different deterioration models
- telemetry may not observe the relevant failure mode
- historical failures may be sparse or biased
- governance review is required before operational decisions
