#[derive(Debug)]
struct TransportRecord {
    network_element_id: String,
    mean_travel_time: f64,
    std_travel_time: f64,
    accessibility_gap_score: f64,
    safety_risk_score: f64,
}

impl TransportRecord {
    fn reliability(&self) -> f64 {
        if self.mean_travel_time <= 0.0 {
            return 0.0;
        }
        (1.0 - self.std_travel_time / self.mean_travel_time).clamp(0.0, 1.0)
    }

    fn validate(&self) -> Result<(), String> {
        if self.mean_travel_time <= 0.0 {
            return Err("mean_travel_time must be positive".to_string());
        }
        if self.std_travel_time < 0.0 {
            return Err("std_travel_time cannot be negative".to_string());
        }
        if !(0.0..=1.0).contains(&self.accessibility_gap_score) {
            return Err("accessibility_gap_score must be in [0, 1]".to_string());
        }
        if !(0.0..=1.0).contains(&self.safety_risk_score) {
            return Err("safety_risk_score must be in [0, 1]".to_string());
        }
        Ok(())
    }
}

fn main() {
    let record = TransportRecord {
        network_element_id: "NET-BUS-001".to_string(),
        mean_travel_time: 34.0,
        std_travel_time: 13.0,
        accessibility_gap_score: 0.32,
        safety_risk_score: 0.42,
    };

    record.validate().expect("transport record validation failed");
    println!("network_element_id={}", record.network_element_id);
    println!("travel_time_reliability={:.3}", record.reliability());
}
