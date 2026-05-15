def signal_quality(accuracy, calibration, timeliness, validity, metadata):
    return max(0.0, min(1.0, 0.25 * accuracy + 0.20 * calibration + 0.20 * timeliness + 0.20 * validity + 0.15 * metadata))


def telemetry_reliability(expected, missing, late, invalid):
    if expected <= 0:
        return 0.0
    return max(0.0, min(1.0, 1 - (missing + late + invalid) / expected))


def dependency_intensity(dependent, critical):
    if critical <= 0:
        return 0.0
    return max(0.0, min(1.0, dependent / critical))


def control_validation(validated, total):
    if total <= 0:
        return 0.0
    return max(0.0, min(1.0, validated / total))


def control_integrity(signal, telemetry, validation, security, oversight, exposure):
    return max(0.0, min(1.0, 0.25 * signal + 0.20 * telemetry + 0.20 * validation + 0.15 * security + 0.15 * oversight - 0.10 * exposure))


def cyber_physical_resilience(integrity, fallback, manual_override, recovery, dependency, exposure):
    return max(0.0, min(1.0, 0.30 * integrity + 0.20 * fallback + 0.20 * manual_override + 0.20 * recovery - 0.10 * dependency - 0.10 * exposure))


def test_signal_quality_bounds():
    assert 0.0 <= signal_quality(0.70, 0.66, 0.84, 0.64, 0.78) <= 1.0


def test_telemetry_reliability_bounds():
    assert 0.0 <= telemetry_reliability(1440.0, 130.0, 110.0, 85.0) <= 1.0


def test_dependency_intensity_bounds():
    assert 0.0 <= dependency_intensity(9.0, 10.0) <= 1.0


def test_control_integrity_bounds():
    sig = signal_quality(0.70, 0.66, 0.84, 0.64, 0.78)
    tel = telemetry_reliability(1440.0, 130.0, 110.0, 85.0)
    val = control_validation(1.0, 5.0)
    ov = control_validation(3.0, 4.0)
    assert 0.0 <= control_integrity(sig, tel, val, 0.62, ov, 0.55) <= 1.0


def test_resilience_bounds():
    sig = signal_quality(0.70, 0.66, 0.84, 0.64, 0.78)
    tel = telemetry_reliability(1440.0, 130.0, 110.0, 85.0)
    val = control_validation(1.0, 5.0)
    ov = control_validation(3.0, 4.0)
    dep = dependency_intensity(9.0, 10.0)
    integrity = control_integrity(sig, tel, val, 0.62, ov, 0.55)
    assert 0.0 <= cyber_physical_resilience(integrity, 0.58, 0.76, 0.60, dep, 0.55) <= 1.0
