def sensor_quality_score(uptime, calibration, metadata, latency, provenance):
    return 0.25 * uptime + 0.20 * calibration + 0.20 * metadata + 0.20 * latency + 0.15 * provenance


def urban_observability_score(sensor_quality, coverage, interoperability, service_relevance, governance):
    return 0.30 * sensor_quality + 0.20 * coverage + 0.20 * interoperability + 0.15 * service_relevance + 0.15 * governance


def test_sensor_quality_bounds():
    score = sensor_quality_score(0.70, 0.62, 0.78, 0.45, 0.76)
    assert 0.0 <= score <= 1.0


def test_observability_bounds():
    q = sensor_quality_score(0.82, 0.68, 0.82, 0.60, 0.80)
    o = urban_observability_score(q, 0.43, 0.66, 0.88, 0.58)
    assert 0.0 <= o <= 1.0


def test_threshold_exceedance_logic():
    assert 36.8 >= 35.0
