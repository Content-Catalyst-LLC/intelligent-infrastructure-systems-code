def digital_access(users_with_access, users_needing_access):
    if users_needing_access <= 0:
        return 0.0
    return max(0.0, min(1.0, users_with_access / users_needing_access))


def network_capacity(bandwidth, latency, uptime, redundancy):
    return max(0.0, min(1.0, 0.30 * bandwidth + 0.25 * latency + 0.25 * uptime + 0.20 * redundancy))


def compute_storage(compute, storage, geo, edge):
    return max(0.0, min(1.0, 0.30 * compute + 0.25 * storage + 0.25 * geo + 0.20 * edge))


def interoperability(shared, exchange):
    if exchange <= 0:
        return 0.0
    return max(0.0, min(1.0, shared / exchange))


def trust_security(security, privacy, auditability, recovery, governance):
    return max(0.0, min(1.0, 0.25 * security + 0.20 * privacy + 0.20 * auditability + 0.20 * recovery + 0.15 * governance))


def vendor_dependency(concentrated, critical):
    if critical <= 0:
        return 0.0
    return max(0.0, min(1.0, concentrated / critical))


def resilience(access, network, compute, interop, trust, dependency, exposure):
    return max(0.0, min(1.0, 0.20 * access + 0.20 * network + 0.20 * compute + 0.15 * interop + 0.20 * trust - 0.15 * dependency - 0.10 * exposure))


def test_metric_bounds():
    a = digital_access(42000.0, 65000.0)
    n = network_capacity(0.62, 0.58, 0.70, 0.46)
    c = compute_storage(0.62, 0.64, 0.42, 0.38)
    i = interoperability(8.0, 18.0)
    t = trust_security(0.62, 0.58, 0.50, 0.52, 0.48)
    d = vendor_dependency(10.0, 12.0)
    r = resilience(a, n, c, i, t, d, 0.55)

    for value in [a, n, c, i, t, d, r]:
        assert 0.0 <= value <= 1.0
