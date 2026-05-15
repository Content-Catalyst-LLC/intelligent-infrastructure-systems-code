#[derive(Debug)]
struct UrbanSensorRecord {
    sensor_id: String,
    value: f64,
    threshold: f64,
    latency_seconds: f64,
    sensor_quality_score: f64,
}

impl UrbanSensorRecord {
    fn threshold_exceeded(&self) -> bool {
        self.value >= self.threshold
    }

    fn validate(&self) -> Result<(), String> {
        if self.value.is_nan() {
            return Err("value cannot be NaN".to_string());
        }
        if self.latency_seconds < 0.0 {
            return Err("latency cannot be negative".to_string());
        }
        if !(0.0..=1.0).contains(&self.sensor_quality_score) {
            return Err(format!("sensor_quality_score out of range: {}", self.sensor_quality_score));
        }
        Ok(())
    }
}

fn main() {
    let record = UrbanSensorRecord {
        sensor_id: "USN-AIR-001".to_string(),
        value: 36.8,
        threshold: 35.0,
        latency_seconds: 44.0,
        sensor_quality_score: 0.72,
    };

    record.validate().expect("record validation failed");
    println!("sensor_id={}", record.sensor_id);
    println!("threshold_exceeded={}", record.threshold_exceeded());
}
