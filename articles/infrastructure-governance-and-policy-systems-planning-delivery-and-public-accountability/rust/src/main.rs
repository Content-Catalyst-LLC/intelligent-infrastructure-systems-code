fn classify(governance_quality: f64, governance_risk: f64, maintenance_backlog: f64, accountability_quality: f64) -> &'static str {
    if governance_quality < 0.60 || governance_risk > 0.25 {
        "escalate"
    } else if maintenance_backlog > 0.0 || accountability_quality < 0.65 {
        "review_required"
    } else {
        "ready_with_monitoring"
    }
}

fn main() {
    let status = classify(0.67, 0.19, 5.0, 0.67);
    println!("Infrastructure governance readiness status: {}", status);
}
