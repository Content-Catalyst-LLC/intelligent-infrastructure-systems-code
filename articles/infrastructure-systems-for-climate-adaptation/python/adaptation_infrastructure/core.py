from __future__ import annotations

from dataclasses import dataclass
from typing import Dict, Iterable, Mapping

READINESS_WEIGHTS: Dict[str, float] = {
    "scenario_credibility": 0.16,
    "dependency_mapping": 0.14,
    "service_protection": 0.15,
    "equity_screen": 0.14,
    "finance_readiness": 0.12,
    "maintenance_readiness": 0.10,
    "observability": 0.10,
    "governance_clarity": 0.09,
}

REQUIRED_SCORE_FIELDS = tuple(READINESS_WEIGHTS.keys()) + ("maladaptation_risk",)


@dataclass(frozen=True)
class ReviewResult:
    readiness_score: float
    net_readiness_score: float
    review_priority: str
    flags: tuple[str, ...]


def parse_bool(value: object) -> bool:
    if isinstance(value, bool):
        return value
    return str(value).strip().lower() in {"true", "1", "yes", "y"}


def parse_float(row: Mapping[str, object], field: str) -> float:
    try:
        value = float(row[field])
    except KeyError as exc:
        raise ValueError(f"Missing required field: {field}") from exc
    except ValueError as exc:
        raise ValueError(f"Field {field!r} must be numeric; got {row.get(field)!r}") from exc
    if not 0.0 <= value <= 1.0:
        raise ValueError(f"Field {field!r} must be between 0 and 1; got {value}")
    return value


def readiness_score(row: Mapping[str, object]) -> float:
    return sum(parse_float(row, field) * weight for field, weight in READINESS_WEIGHTS.items())


def review_record(row: Mapping[str, object]) -> ReviewResult:
    score = readiness_score(row)
    maladaptation = parse_float(row, "maladaptation_risk")
    net = max(0.0, score - 0.20 * maladaptation)
    high_stakes = parse_bool(row.get("high_stakes_use", "false"))

    flags: list[str] = []
    if maladaptation >= 0.60:
        flags.append("maladaptation_review_required")
    if high_stakes and parse_float(row, "equity_screen") < 0.70:
        flags.append("high_stakes_equity_review")
    if parse_float(row, "finance_readiness") < 0.70:
        flags.append("finance_gap")
    if parse_float(row, "maintenance_readiness") < 0.70:
        flags.append("maintenance_gap")
    if parse_float(row, "dependency_mapping") < 0.70:
        flags.append("dependency_mapping_review")
    if parse_float(row, "observability") < 0.70:
        flags.append("observability_gap")
    if net < 0.70:
        flags.append("readiness_review")

    priority = flags[0] if flags else "implementation_ready"
    return ReviewResult(round(score, 3), round(net, 3), priority, tuple(flags))


def service_continuity(outage_hours: float, critical_hours: float) -> float:
    if critical_hours <= 0:
        raise ValueError("critical_hours must be greater than zero")
    outage = max(0.0, min(float(outage_hours), float(critical_hours)))
    return round(1.0 - outage / critical_hours, 3)


def require_columns(columns: Iterable[str], required: Iterable[str]) -> None:
    missing = sorted(set(required) - set(columns))
    if missing:
        raise ValueError(f"Missing required columns: {missing}")
