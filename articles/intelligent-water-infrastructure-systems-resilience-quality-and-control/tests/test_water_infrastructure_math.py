def quality_compliance(compliant, tested):
    if tested <= 0:
        return 0.0
    return max(0.0, min(1.0, compliant / tested))


def pressure_adequacy(pressure, pmin, pmax):
    if pmax <= pmin:
        return 0.0
    return max(0.0, min(1.0, (pressure - pmin) / (pmax - pmin)))


def leakage_rate(system_input, authorized):
    if system_input <= 0:
        return 0.0
    return max(0.0, min(1.0, (system_input - authorized) / system_input))


def water_observability(telemetry, data_quality, coverage, metadata, latency):
    return max(0.0, min(1.0, 0.25 * telemetry + 0.25 * data_quality + 0.20 * coverage + 0.15 * metadata + 0.15 * latency))


def water_resilience(continuity, quality, backup, observability, response, exposure):
    return max(0.0, min(1.0, 0.25 * continuity + 0.20 * quality + 0.20 * backup + 0.15 * observability + 0.15 * response - 0.15 * exposure))


def test_quality_compliance_bounds():
    assert 0.0 <= quality_compliance(132.0, 140.0) <= 1.0


def test_pressure_adequacy_bounds():
    assert 0.0 <= pressure_adequacy(34.0, 35.0, 80.0) <= 1.0


def test_leakage_rate_bounds():
    assert 0.0 <= leakage_rate(125000.0, 93000.0) <= 1.0


def test_observability_bounds():
    assert 0.0 <= water_observability(0.76, 0.74, 0.70, 0.66, 0.27) <= 1.0


def test_resilience_bounds():
    q = quality_compliance(132.0, 140.0)
    o = water_observability(0.76, 0.74, 0.70, 0.66, 0.27)
    assert 0.0 <= water_resilience(0.79, q, 0.58, o, 0.60, 0.42) <= 1.0
