#[derive(Debug)]
struct CriticalServiceRecord {
    service_id: String,
    service_domain: String,
    normal_capacity: f64,
    disruption_capacity: f64,
    target_recovery_hours: f64,
    expected_recovery_hours: f64,
    equity_gap_score: f64,
}

impl CriticalServiceRecord {
    fn service_continuity_score(&self) -> f64 {
        if self.normal_capacity <= 0.0 {
            return 0.0;
        }
        (self.disruption_capacity / self.normal_capacity).min(1.0)
    }

    fn recovery_lag_hours(&self) -> f64 {
        (self.expected_recovery_hours - self.target_recovery_hours).max(0.0)
    }

    fn validate(&self) -> Result<(), String> {
        if self.normal_capacity <= 0.0 {
            return Err("normal_capacity must be positive".to_string());
        }

        if !(0.0..=1.0).contains(&self.equity_gap_score) {
            return Err(format!("equity_gap_score out of range: {}", self.equity_gap_score));
        }

        Ok(())
    }
}

fn main() {
    let record = CriticalServiceRecord {
        service_id: "SVC-DRN-001".to_string(),
        service_domain: "drainage".to_string(),
        normal_capacity: 100.0,
        disruption_capacity: 58.0,
        target_recovery_hours: 6.0,
        expected_recovery_hours: 14.0,
        equity_gap_score: 0.42,
    };

    record.validate().expect("record validation failed");
    println!("service_id={}", record.service_id);
    println!("service_domain={}", record.service_domain);
    println!("service_continuity_score={:.3}", record.service_continuity_score());
    println!("recovery_lag_hours={:.1}", record.recovery_lag_hours());
}
