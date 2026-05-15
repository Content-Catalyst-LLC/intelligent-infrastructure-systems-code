#[derive(Debug)]
struct SensorRecord {
    sensor_id: String,
    asset_id: String,
    unit: String,
    latency_seconds: f64,
    metadata_fields_present: u8,
    expected_readings: f64,
    missing_readings: f64,
    late_readings: f64,
    invalid_readings: f64,
}

impl SensorRecord {
    fn validate(&self) -> Result<(), String> {
        if self.sensor_id.trim().is_empty() {
            return Err("sensor_id is required".to_string());
        }
        if self.asset_id.trim().is_empty() {
            return Err("asset_id is required".to_string());
        }
        if self.unit.trim().is_empty() {
            return Err("unit is required".to_string());
        }
        if self.latency_seconds < 0.0 {
            return Err("latency_seconds cannot be negative".to_string());
        }
        if self.expected_readings < 0.0 {
            return Err("expected_readings cannot be negative".to_string());
        }
        Ok(())
    }

    fn metadata_completeness(&self) -> f64 {
        (self.metadata_fields_present as f64 / 8.0).clamp(0.0, 1.0)
    }

    fn telemetry_reliability(&self) -> f64 {
        if self.expected_readings <= 0.0 {
            return 0.0;
        }
        (1.0 - (self.missing_readings + self.late_readings + self.invalid_readings) / self.expected_readings).clamp(0.0, 1.0)
    }

    fn review_required(&self) -> bool {
        self.metadata_completeness() < 0.85 || self.telemetry_reliability() < 0.85
    }
}

fn main() {
    let record = SensorRecord {
        sensor_id: "SENS-SEC-001".to_string(),
        asset_id: "ASSET-SEC-001".to_string(),
        unit: "percent".to_string(),
        latency_seconds: 25.0,
        metadata_fields_present: 7,
        expected_readings: 1440.0,
        missing_readings: 130.0,
        late_readings: 110.0,
        invalid_readings: 85.0,
    };

    record.validate().expect("sensor record validation failed");
    println!("sensor_id={}", record.sensor_id);
    println!("metadata_completeness={:.3}", record.metadata_completeness());
    println!("telemetry_reliability={:.3}", record.telemetry_reliability());
    println!("review_required={}", record.review_required());
}
