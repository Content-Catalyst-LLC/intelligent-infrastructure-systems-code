# Engineering Notes

## Design priorities

1. Define control purpose, physical service, valid uses, prohibited uses, and response authority before adding automation.
2. Map the full cyber-physical loop: physical state, sensing, telemetry, computation, decision, command, actuation, feedback, fallback, and recovery.
3. Preserve asset identity, sensor identity, controller identity, actuator identity, command provenance, timing, quality flags, and operator authority.
4. Measure signal quality, telemetry reliability, control validation, human oversight, dependency intensity, exposure, fallback capability, and recovery effectiveness.
5. Validate cyber-physical loops against physical consequence, not only software correctness.
6. Secure devices, telemetry, gateways, controllers, credentials, firmware, remote access, logs, APIs, and operator interfaces.
7. Connect findings to engineering review, cybersecurity response, maintenance, operator training, procurement, public communication, or governance review.

## Common failure modes

- automation is added without mapping physical consequence
- control logic uses stale or invalid telemetry
- operators cannot determine automation state or override options
- hidden dependencies on cloud, identity, vendors, or communications are not tested
- segmentation allows compromise to reach control pathways
- fallback modes are documented but not exercised
- governance cannot explain who authorized physical intervention
