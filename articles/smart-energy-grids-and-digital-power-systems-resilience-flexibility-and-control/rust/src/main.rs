#[derive(Debug)]
struct GridTelemetryRecord {
    asset_id: String,
    voltage_pu: f64,
    frequency_hz: f64,
    loading_percent: f64,
    latency_seconds: f64,
}

impl GridTelemetryRecord {
    fn voltage_review(&self) -> bool {
        self.voltage_pu < 0.95 || self.voltage_pu > 1.05
    }

    fn frequency_review(&self) -> bool {
        self.frequency_hz < 59.95 || self.frequency_hz > 60.05
    }

    fn loading_review(&self) -> bool {
        self.loading_percent > 0.95
    }

    fn validate(&self) -> Result<(), String> {
        if self.voltage_pu <= 0.0 {
            return Err("voltage_pu must be positive".to_string());
        }
        if self.frequency_hz <= 0.0 {
            return Err("frequency_hz must be positive".to_string());
        }
        if self.loading_percent < 0.0 {
            return Err("loading_percent cannot be negative".to_string());
        }
        if self.latency_seconds < 0.0 {
            return Err("latency_seconds cannot be negative".to_string());
        }
        Ok(())
    }
}

fn main() {
    let record = GridTelemetryRecord {
        asset_id: "SG-TRF-001".to_string(),
        voltage_pu: 0.94,
        frequency_hz: 59.97,
        loading_percent: 0.96,
        latency_seconds: 88.0,
    };

    record.validate().expect("grid telemetry validation failed");
    println!("asset_id={}", record.asset_id);
    println!("voltage_review={}", record.voltage_review());
    println!("frequency_review={}", record.frequency_review());
    println!("loading_review={}", record.loading_review());
}
