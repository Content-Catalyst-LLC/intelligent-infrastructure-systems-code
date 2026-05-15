def usable_renewable(generation, grid_capacity, flexibility, storage_charge):
    return min(generation, max(0.0, grid_capacity + flexibility + storage_charge))


def curtailment_rate(generation, usable):
    if generation <= 0:
        return 0.0
    return max(0.0, min(1.0, (generation - usable) / generation))


def flexibility_adequacy(available, need):
    if need <= 0:
        return 1.0
    return max(0.0, min(1.0, available / need))


def grid_constraint(grid_capacity, connection_capacity):
    if connection_capacity <= 0:
        return 0.0
    return max(0.0, min(1.0, 1 - grid_capacity / connection_capacity))


def infrastructure_score(curtailment, flexibility, resilience, forecast_quality, storage_readiness, constraint):
    return max(0.0, min(1.0, 0.25 * (1 - curtailment) + 0.20 * flexibility + 0.20 * resilience + 0.15 * forecast_quality + 0.10 * storage_readiness - 0.10 * constraint))


def test_curtailment_bounds():
    usable = usable_renewable(118.0, 130.0, 34.0, 18.0)
    score = curtailment_rate(118.0, usable)
    assert 0.0 <= score <= 1.0


def test_flexibility_bounds():
    score = flexibility_adequacy(34.0, 52.0)
    assert 0.0 <= score <= 1.0


def test_grid_constraint_bounds():
    score = grid_constraint(130.0, 180.0)
    assert 0.0 <= score <= 1.0


def test_infrastructure_score_bounds():
    usable = usable_renewable(118.0, 130.0, 34.0, 18.0)
    curt = curtailment_rate(118.0, usable)
    flex = flexibility_adequacy(34.0, 52.0)
    constraint = grid_constraint(130.0, 180.0)
    score = infrastructure_score(curt, flex, 0.62, 0.70, 0.62, constraint)
    assert 0.0 <= score <= 1.0
