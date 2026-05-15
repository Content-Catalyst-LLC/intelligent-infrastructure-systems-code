import math


def sensor_coverage(monitored, critical):
    if critical <= 0:
        return 0.0
    return max(0.0, min(1.0, monitored / critical))


def signal_quality(accuracy, precision, completeness, validity, freshness):
    return max(0.0, min(1.0, 0.25 * accuracy + 0.20 * precision + 0.20 * completeness + 0.20 * validity + 0.15 * freshness))


def calibration_confidence(days_since_calibration, decay=0.004):
    if days_since_calibration < 0:
        return 0.0
    return max(0.0, min(1.0, math.exp(-decay * days_since_calibration)))


def telemetry_reliability(expected, missing, late, invalid):
    if expected <= 0:
        return 0.0
    return max(0.0, min(1.0, 1 - (missing + late + invalid) / expected))


def metadata_completeness(present, required):
    if required <= 0:
        return 0.0
    return max(0.0, min(1.0, present / required))


def monitoring_observability(coverage, quality, calibration, telemetry, metadata, blindspot):
    return max(0.0, min(1.0, 0.20 * coverage + 0.20 * quality + 0.20 * calibration + 0.20 * telemetry + 0.15 * metadata - 0.15 * blindspot))


def test_sensor_coverage_bounds():
    assert 0.0 <= sensor_coverage(12.0, 20.0) <= 1.0


def test_signal_quality_bounds():
    assert 0.0 <= signal_quality(0.70, 0.68, 0.66, 0.64, 0.84) <= 1.0


def test_calibration_confidence_bounds():
    assert 0.0 <= calibration_confidence(244.0) <= 1.0


def test_telemetry_reliability_bounds():
    assert 0.0 <= telemetry_reliability(1440.0, 130.0, 110.0, 85.0) <= 1.0


def test_observability_bounds():
    c = sensor_coverage(12.0, 20.0)
    q = signal_quality(0.70, 0.68, 0.66, 0.64, 0.84)
    k = calibration_confidence(244.0)
    t = telemetry_reliability(1440.0, 130.0, 110.0, 85.0)
    m = metadata_completeness(7.0, 8.0)
    b = sensor_coverage(3.0, 6.0)
    assert 0.0 <= monitoring_observability(c, q, k, t, m, b) <= 1.0
