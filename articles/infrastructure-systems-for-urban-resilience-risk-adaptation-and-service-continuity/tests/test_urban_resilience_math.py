def service_continuity_score(disruption_capacity, normal_capacity):
    if normal_capacity <= 0:
        return 0.0
    return min(disruption_capacity / normal_capacity, 1.0)


def recovery_lag_hours(expected_recovery, target_recovery):
    return max(expected_recovery - target_recovery, 0.0)


def urban_risk_score(hazard, exposure, vulnerability, governance):
    return hazard * exposure * vulnerability * (1 - governance)


def test_service_continuity_bounds():
    score = service_continuity_score(58, 100)
    assert 0.0 <= score <= 1.0


def test_recovery_lag_nonnegative():
    assert recovery_lag_hours(14, 6) == 8
    assert recovery_lag_hours(4, 6) == 0


def test_risk_decreases_with_governance():
    weak_governance = urban_risk_score(0.82, 0.78, 0.76, 0.2)
    strong_governance = urban_risk_score(0.82, 0.78, 0.76, 0.8)
    assert strong_governance < weak_governance
