def service_continuity(observed, normal):
    if normal <= 0:
        return 0.0
    return max(0.0, min(1.0, observed / normal))


def domain_observability(quality, coverage, interoperability, latency, governance):
    return max(0.0, min(1.0, 0.25 * quality + 0.20 * coverage + 0.20 * interoperability + 0.20 * latency + 0.15 * governance))


def public_value(continuity, accessibility, resilience, inclusion, trust, burden):
    return max(0.0, min(1.0, 0.25 * continuity + 0.20 * accessibility + 0.20 * resilience + 0.20 * inclusion + 0.15 * trust - 0.15 * burden))


def test_service_continuity_bounds():
    score = service_continuity(0.58, 1.0)
    assert 0.0 <= score <= 1.0


def test_domain_observability_bounds():
    score = domain_observability(0.78, 0.56, 0.70, 0.58, 0.62)
    assert 0.0 <= score <= 1.0


def test_public_value_bounds():
    score = public_value(0.58, 0.66, 0.58, 0.62, 0.60, 0.44)
    assert 0.0 <= score <= 1.0
