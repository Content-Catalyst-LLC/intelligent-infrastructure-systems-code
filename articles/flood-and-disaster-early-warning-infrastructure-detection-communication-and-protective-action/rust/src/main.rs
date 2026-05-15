#[derive(Debug)]
struct WarningRecord {
    hazard_id: String,
    hazard_severity: f64,
    exposure_score: f64,
    vulnerability_score: f64,
    protective_probability: f64,
}

impl WarningRecord {
    fn residual_warning_risk(&self) -> f64 {
        self.hazard_severity * self.exposure_score * self.vulnerability_score * (1.0 - self.protective_probability)
    }

    fn validate(&self) -> Result<(), String> {
        let values = [
            ("hazard_severity", self.hazard_severity),
            ("exposure_score", self.exposure_score),
            ("vulnerability_score", self.vulnerability_score),
            ("protective_probability", self.protective_probability),
        ];

        for (name, value) in values {
            if !(0.0..=1.0).contains(&value) {
                return Err(format!("{} out of range: {}", name, value));
            }
        }

        Ok(())
    }
}

fn main() {
    let record = WarningRecord {
        hazard_id: "HZ-002".to_string(),
        hazard_severity: 0.82,
        exposure_score: 0.78,
        vulnerability_score: 0.70,
        protective_probability: 0.195,
    };

    record.validate().expect("record validation failed");
    println!("hazard_id={}", record.hazard_id);
    println!("residual_warning_risk={:.3}", record.residual_warning_risk());
}
