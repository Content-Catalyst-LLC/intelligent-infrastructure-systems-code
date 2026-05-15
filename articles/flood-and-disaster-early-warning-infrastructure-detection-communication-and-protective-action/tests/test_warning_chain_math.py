def protective_warning_probability(detection, reach, comprehension, trust, action_capacity):
    return detection * reach * comprehension * trust * action_capacity


def test_protective_warning_probability_bounds():
    p = protective_warning_probability(0.78, 0.76, 0.70, 0.68, 0.62)
    assert 0.0 <= p <= 1.0


def test_residual_risk_decreases_with_protection():
    hazard = 0.82
    exposure = 0.78
    vulnerability = 0.70

    low_protection = hazard * exposure * vulnerability * (1 - 0.2)
    high_protection = hazard * exposure * vulnerability * (1 - 0.8)

    assert high_protection < low_protection
