def grid_observability(telemetry, data_quality, coverage, metadata, latency):
    return max(0.0, min(1.0, 0.25 * telemetry + 0.25 * data_quality + 0.20 * coverage + 0.15 * metadata + 0.15 * latency))


def voltage_adequacy(voltage, nominal, allowed):
    if allowed <= 0:
        return 0.0
    return max(0.0, min(1.0, 1 - abs(voltage - nominal) / allowed))


def flexibility_adequacy(available, need):
    if need <= 0:
        return 1.0
    return max(0.0, min(1.0, available / need))


def balancing_pressure(load, supply, flexibility):
    if load <= 0:
        return 0.0
    return max(0.0, min(1.0, abs(load - supply - flexibility) / load))


def service_continuity(served, required):
    if required <= 0:
        return 0.0
    return max(0.0, min(1.0, served / required))


def grid_resilience(continuity, flexibility, observability, backup, response, exposure):
    return max(0.0, min(1.0, 0.25 * continuity + 0.20 * flexibility + 0.20 * observability + 0.15 * backup + 0.15 * response - 0.15 * exposure))


def test_observability_bounds():
    assert 0.0 <= grid_observability(0.74, 0.72, 0.68, 0.64, 0.27) <= 1.0


def test_voltage_bounds():
    assert 0.0 <= voltage_adequacy(0.94, 1.0, 0.05) <= 1.0


def test_flexibility_bounds():
    assert 0.0 <= flexibility_adequacy(16.0, 30.0) <= 1.0


def test_balancing_bounds():
    assert 0.0 <= balancing_pressure(25.0, 21.0, 16.0) <= 1.0


def test_resilience_bounds():
    o = grid_observability(0.74, 0.72, 0.68, 0.64, 0.27)
    f = flexibility_adequacy(16.0, 30.0)
    c = service_continuity(20.5, 24.0)
    assert 0.0 <= grid_resilience(c, f, o, 0.46, 0.54, 0.56) <= 1.0
