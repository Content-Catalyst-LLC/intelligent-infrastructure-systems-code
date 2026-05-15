# Engineering Notes

## Design priorities

1. Define monitoring purpose, decision use, valid-use limits, and response owners before selecting sensors.
2. Preserve sensor identity, asset identity, location, unit, timestamp source, calibration status, quality flag, and valid use.
3. Measure signal quality, telemetry reliability, calibration confidence, metadata completeness, sensor coverage, blind spots, and actionability.
4. Distinguish raw readings, calibrated readings, cleaned telemetry, analytical indicators, alerts, response decisions, and public claims.
5. Validate sensors with field inspection, calibration records, drift review, known events, and domain expertise.
6. Secure devices, telemetry, gateways, remote access, firmware, logs, credentials, and monitoring platforms.
7. Connect alerts to inspection, maintenance, dispatch, incident response, planning, reporting, and public communication.

## Common failure modes

- sensor deployment substitutes for observability design
- readings lack asset, location, unit, calibration, or valid-use metadata
- dashboards conceal missing readings or stale telemetry
- blind spots create uneven system visibility
- alerts are not connected to response authority
- cybersecurity treats sensors as low-risk when they are operational entry points
- monitoring creates false confidence without calibration or validation
