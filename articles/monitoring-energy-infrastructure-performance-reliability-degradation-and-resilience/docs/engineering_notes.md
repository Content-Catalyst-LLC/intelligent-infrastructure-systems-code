# Engineering Notes

## Design priorities

1. Define reliability, degradation, resilience, maintenance, and capital-planning questions before selecting indicators.
2. Preserve asset and network context: generation, substations, transmission, distribution, storage, inverters, meters, and grid-edge assets.
3. Measure availability, service continuity, stress, degradation, power quality, resilience, and telemetry integrity.
4. Track data quality, timestamps, latency, missingness, calibration, sensor health, and provenance.
5. Distinguish resource variation, operational constraints, asset degradation, congestion, cyber-physical fault, and telemetry error.
6. Document cybersecurity, failover, manual operations, public communication, and incident response.
7. Connect indicators to inspection, work orders, dispatch, restoration, resilience review, regulation, and capital planning.

## Common failure modes

- uptime is treated as a proxy for health
- sensor data are collected without maintenance action pathways
- degradation scores are not validated against field evidence
- power-quality issues are hidden behind service availability
- telemetry systems lack cybersecurity and failover procedures
- dashboards make public claims without reproducible evidence chains
- predictive maintenance is used without model cards or review gates
