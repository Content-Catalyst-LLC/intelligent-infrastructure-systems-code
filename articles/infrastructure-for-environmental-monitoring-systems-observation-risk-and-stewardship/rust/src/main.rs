#[derive(Debug)]
struct EnvironmentalObservation {
    site_id: String,
    domain: String,
    variable: String,
    value: f64,
    threshold: f64,
    monitoring_quality: f64,
}

impl EnvironmentalObservation {
    fn threshold_exceeded(&self) -> bool {
        self.value >= self.threshold
    }

    fn validate(&self) -> Result<(), String> {
        if self.value.is_nan() {
            return Err("value cannot be NaN".to_string());
        }

        if self.threshold <= 0.0 {
            return Err("threshold must be positive".to_string());
        }

        if !(0.0..=1.0).contains(&self.monitoring_quality) {
            return Err(format!("monitoring_quality out of range: {}", self.monitoring_quality));
        }

        Ok(())
    }
}

fn main() {
    let record = EnvironmentalObservation {
        site_id: "ENV-AIR-002".to_string(),
        domain: "air_quality".to_string(),
        variable: "no2".to_string(),
        value: 42.0,
        threshold: 40.0,
        monitoring_quality: 0.684,
    };

    record.validate().expect("record validation failed");
    println!("site_id={}", record.site_id);
    println!("domain={}", record.domain);
    println!("variable={}", record.variable);
    println!("threshold_exceeded={}", record.threshold_exceeded());
}
