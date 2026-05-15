#[derive(Debug)]
struct WaterTelemetryRecord {
    asset_id: String,
    pressure_psi: f64,
    turbidity_ntu: f64,
    chlorine_mg_l: f64,
    ph: f64,
    latency_seconds: f64,
}

impl WaterTelemetryRecord {
    fn pressure_review(&self, minimum_pressure_psi: f64) -> bool {
        self.pressure_psi < minimum_pressure_psi
    }

    fn quality_review(&self) -> bool {
        self.turbidity_ntu > 1.0 || self.chlorine_mg_l < 0.6 || self.ph < 6.5 || self.ph > 8.5
    }

    fn validate(&self) -> Result<(), String> {
        if self.pressure_psi < 0.0 {
            return Err("pressure_psi cannot be negative".to_string());
        }
        if self.turbidity_ntu < 0.0 {
            return Err("turbidity_ntu cannot be negative".to_string());
        }
        if self.chlorine_mg_l < 0.0 {
            return Err("chlorine_mg_l cannot be negative".to_string());
        }
        if !(0.0..=14.0).contains(&self.ph) {
            return Err("ph must be in [0, 14]".to_string());
        }
        if self.latency_seconds < 0.0 {
            return Err("latency_seconds cannot be negative".to_string());
        }
        Ok(())
    }
}

fn main() {
    let record = WaterTelemetryRecord {
        asset_id: "WAT-DST-001".to_string(),
        pressure_psi: 34.0,
        turbidity_ntu: 0.9,
        chlorine_mg_l: 0.5,
        ph: 7.1,
        latency_seconds: 88.0,
    };

    record.validate().expect("water telemetry validation failed");
    println!("asset_id={}", record.asset_id);
    println!("pressure_review={}", record.pressure_review(35.0));
    println!("quality_review={}", record.quality_review());
}
