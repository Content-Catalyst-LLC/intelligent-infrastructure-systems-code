#[derive(Debug)]
struct SmartCityRecord {
    infrastructure_id: String,
    observed_capacity: f64,
    normal_capacity: f64,
    digital_access_gap_score: f64,
    privacy_risk_score: f64,
}

impl SmartCityRecord {
    fn service_continuity(&self) -> f64 {
        if self.normal_capacity <= 0.0 {
            return 0.0;
        }
        (self.observed_capacity / self.normal_capacity).clamp(0.0, 1.0)
    }

    fn validate(&self) -> Result<(), String> {
        if self.observed_capacity < 0.0 {
            return Err("observed_capacity cannot be negative".to_string());
        }
        if self.normal_capacity <= 0.0 {
            return Err("normal_capacity must be positive".to_string());
        }
        if !(0.0..=1.0).contains(&self.digital_access_gap_score) {
            return Err("digital_access_gap_score must be in [0, 1]".to_string());
        }
        if !(0.0..=1.0).contains(&self.privacy_risk_score) {
            return Err("privacy_risk_score must be in [0, 1]".to_string());
        }
        Ok(())
    }
}

fn main() {
    let record = SmartCityRecord {
        infrastructure_id: "SCI-STM-001".to_string(),
        observed_capacity: 0.58,
        normal_capacity: 1.0,
        digital_access_gap_score: 0.42,
        privacy_risk_score: 0.34,
    };

    record.validate().expect("smart city record validation failed");
    println!("infrastructure_id={}", record.infrastructure_id);
    println!("service_continuity={:.3}", record.service_continuity());
}
