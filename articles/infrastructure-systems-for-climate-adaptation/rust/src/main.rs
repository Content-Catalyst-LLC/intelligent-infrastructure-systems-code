#[derive(Debug)]
struct AdaptationRecord {
    project_id: String,
    scenario_credibility: f64,
    finance_readiness: f64,
    maladaptation_risk: f64,
}

fn validate(record: &AdaptationRecord) -> Result<&'static str, &'static str> {
    if record.scenario_credibility < 0.70 {
        return Err("scenario review required");
    }
    if record.finance_readiness < 0.70 {
        return Err("finance readiness gap");
    }
    if record.maladaptation_risk >= 0.65 {
        return Err("maladaptation review required");
    }
    Ok("record accepted")
}

fn main() {
    let record = AdaptationRecord {
        project_id: "adapt-transport-01".to_string(),
        scenario_credibility: 0.80,
        finance_readiness: 0.62,
        maladaptation_risk: 0.62,
    };

    println!("{}: {:?}", record.project_id, validate(&record));
}
