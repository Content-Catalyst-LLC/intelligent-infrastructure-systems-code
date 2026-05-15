#[derive(Debug)]
struct EnergyPerformanceRecord {
    asset_id: String,
    available_hours: f64,
    total_hours: f64,
    baseline_health: f64,
    current_health: f64,
    voltage_pu: f64,
}

impl EnergyPerformanceRecord {
    fn availability(&self) -> f64 {
        if self.total_hours <= 0.0 {
            return 0.0;
        }
        (self.available_hours / self.total_hours).clamp(0.0, 1.0)
    }

    fn degradation(&self) -> f64 {
        if self.baseline_health <= 0.0 {
            return 0.0;
        }
        ((self.baseline_health - self.current_health) / self.baseline_health).clamp(0.0, 1.0)
    }

    fn validate(&self) -> Result<(), String> {
        if self.available_hours < 0.0 {
            return Err("available_hours cannot be negative".to_string());
        }
        if self.total_hours <= 0.0 {
            return Err("total_hours must be positive".to_string());
        }
        if !(0.0..=1.0).contains(&self.baseline_health) {
            return Err("baseline_health must be in [0, 1]".to_string());
        }
        if !(0.0..=1.0).contains(&self.current_health) {
            return Err("current_health must be in [0, 1]".to_string());
        }
        if self.voltage_pu <= 0.0 {
            return Err("voltage_pu must be positive".to_string());
        }
        Ok(())
    }
}

fn main() {
    let record = EnergyPerformanceRecord {
        asset_id: "EN-TRF-001".to_string(),
        available_hours: 20.5,
        total_hours: 24.0,
        baseline_health: 0.90,
        current_health: 0.58,
        voltage_pu: 0.95,
    };

    record.validate().expect("energy performance record validation failed");
    println!("asset_id={}", record.asset_id);
    println!("availability={:.3}", record.availability());
    println!("degradation={:.3}", record.degradation());
}
