def travel_time_reliability(mean_minutes, std_minutes):
    if mean_minutes <= 0:
        return 0.0
    return max(0.0, min(1.0, 1 - std_minutes / mean_minutes))


def recovery_lag(expected_recovery, target_recovery):
    return max(0.0, expected_recovery - target_recovery)


def mobility_quality(reliability, accessibility, safety, coordination, emissions_burden):
    return max(0.0, min(1.0, 0.25 * reliability + 0.20 * accessibility + 0.20 * safety + 0.20 * coordination - 0.15 * emissions_burden))


def test_reliability_bounds():
    score = travel_time_reliability(34, 13)
    assert 0.0 <= score <= 1.0


def test_recovery_lag_nonnegative():
    assert recovery_lag(35, 20) == 15
    assert recovery_lag(18, 20) == 0


def test_mobility_quality_bounds():
    q = mobility_quality(0.618, 0.76, 0.70, 0.60, 0.30)
    assert 0.0 <= q <= 1.0
