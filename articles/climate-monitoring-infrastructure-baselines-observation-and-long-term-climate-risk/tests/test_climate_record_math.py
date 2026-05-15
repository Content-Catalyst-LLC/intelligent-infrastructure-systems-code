def climate_anomaly(observed, baseline):
    return observed - baseline


def record_completeness(observed_count, expected_count):
    return observed_count / expected_count if expected_count else 0.0


def test_climate_anomaly():
    assert round(climate_anomaly(5.9, 4.3), 3) == 1.6


def test_record_completeness_bounds():
    c = record_completeness(29, 35)
    assert 0.0 <= c <= 1.0


def test_quality_review_logic():
    completeness = 0.75
    metadata_status = "complete"
    calibration_status = "current"

    review_flag = (
        completeness < 0.80
        or metadata_status != "complete"
        or calibration_status != "current"
    )

    assert review_flag is True
