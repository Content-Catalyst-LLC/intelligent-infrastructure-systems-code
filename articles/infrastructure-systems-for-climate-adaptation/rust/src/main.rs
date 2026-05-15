#[derive(Debug)]
struct AdaptationRecord {
    project_id: String,
    scenario_credibility: f64,
    finance_readiness: f64,
    equity_screen: f64,
    maladaptation_risk: f64,
}

fn bounded(value: f64) -> bool {
    (0.0..=1.0).contains(&value)
}

fn validate(record: &AdaptationRecord) -> Result<&'static str, &'static str> {
    if !bounded(record.scenario_credibility)
        || !bounded(record.finance_readiness)
        || !bounded(record.equity_screen)
        || !bounded(record.maladaptation_risk)
    {
        return Err("scores must be between 0 and 1");
    }
    if record.scenario_credibility < 0.70 {
        return Err("scenario review required");
    }
    if record.equity_screen < 0.70 {
        return Err("equity review required");
    }
    if record.finance_readiness < 0.70 {
        return Err("finance readiness gap");
    }
    if record.maladaptation_risk >= 0.60 {
        return Err("maladaptation review required");
    }
    Ok("record accepted")
}

fn main() {
    let record = AdaptationRecord {
        project_id: "adapt-transport-01".to_string(),
        scenario_credibility: 0.80,
        finance_readiness: 0.62,
        equity_screen: 0.58,
        maladaptation_risk: 0.62,
    };
    println!("{}: {:?}", record.project_id, validate(&record));
}
