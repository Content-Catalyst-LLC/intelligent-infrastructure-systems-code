def availability(available_hours, total_hours):
    if total_hours <= 0:
        return 0.0
    return max(0.0, min(1.0, available_hours / total_hours))


def service_continuity(served, demand):
    if demand <= 0:
        return 1.0
    return max(0.0, min(1.0, served / demand))


def degradation(baseline, current):
    if baseline <= 0:
        return 0.0
    return max(0.0, min(1.0, (baseline - current) / baseline))


def stress(loading, thermal, cycling, environmental):
    return max(0.0, min(1.0, 0.30 * loading + 0.25 * thermal + 0.25 * cycling + 0.20 * environmental))


def resilience(avail, continuity, fallback, observability, restoration_time):
    return max(0.0, min(1.0, 0.25 * avail + 0.25 * continuity + 0.20 * fallback + 0.15 * observability - 0.15 * restoration_time))


def test_availability_bounds():
    assert 0.0 <= availability(20.5, 24.0) <= 1.0


def test_degradation_bounds():
    assert 0.0 <= degradation(0.90, 0.58) <= 1.0


def test_stress_bounds():
    assert 0.0 <= stress(0.88, 0.86, 0.44, 0.54) <= 1.0


def test_resilience_bounds():
    a = availability(20.5, 24.0)
    c = service_continuity(21.0, 25.0)
    assert 0.0 <= resilience(a, c, 0.42, 0.62, 0.86) <= 1.0
