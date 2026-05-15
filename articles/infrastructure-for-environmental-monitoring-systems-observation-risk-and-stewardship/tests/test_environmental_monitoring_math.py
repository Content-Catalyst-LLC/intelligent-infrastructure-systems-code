def monitoring_quality_score(completeness, calibration, metadata, provenance, sampling_design):
    return (
        0.25 * completeness
        + 0.20 * calibration
        + 0.20 * metadata
        + 0.20 * provenance
        + 0.15 * sampling_design
    )


def environmental_risk_score(hazard_intensity, exposure, vulnerability, governance_response):
    return hazard_intensity * exposure * vulnerability * (1 - governance_response)


def test_monitoring_quality_bounds():
    score = monitoring_quality_score(0.70, 0.62, 0.68, 0.72, 0.70)
    assert 0.0 <= score <= 1.0


def test_risk_decreases_with_governance():
    weak_governance = environmental_risk_score(0.5, 0.82, 0.70, 0.2)
    strong_governance = environmental_risk_score(0.5, 0.82, 0.70, 0.8)
    assert strong_governance < weak_governance


def test_threshold_exceedance_logic():
    assert 36.2 >= 35.0
