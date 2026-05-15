#[derive(Debug)]
struct RenewableRecord {
    asset_id: String,
    actual_generation_mw: f64,
    forecast_generation_mw: f64,
    grid_transfer_capacity_mw: f64,
    connection_capacity_mw: f64,
    flexibility_mw: f64,
    flexibility_need_mw: f64,
}

impl RenewableRecord {
    fn forecast_error(&self) -> f64 {
        (self.forecast_generation_mw - self.actual_generation_mw).abs()
    }

    fn grid_constraint_score(&self) -> f64 {
        if self.connection_capacity_mw <= 0.0 {
            return 0.0;
        }
        (1.0 - self.grid_transfer_capacity_mw / self.connection_capacity_mw).clamp(0.0, 1.0)
    }

    fn flexibility_adequacy(&self) -> f64 {
        if self.flexibility_need_mw <= 0.0 {
            return 1.0;
        }
        (self.flexibility_mw / self.flexibility_need_mw).clamp(0.0, 1.0)
    }

    fn validate(&self) -> Result<(), String> {
        if self.actual_generation_mw < 0.0 || self.forecast_generation_mw < 0.0 {
            return Err("generation values cannot be negative".to_string());
        }
        if self.grid_transfer_capacity_mw < 0.0 || self.connection_capacity_mw < 0.0 {
            return Err("grid capacities cannot be negative".to_string());
        }
        if self.flexibility_mw < 0.0 || self.flexibility_need_mw < 0.0 {
            return Err("flexibility values cannot be negative".to_string());
        }
        Ok(())
    }
}

fn main() {
    let record = RenewableRecord {
        asset_id: "RE-WND-001".to_string(),
        actual_generation_mw: 118.0,
        forecast_generation_mw: 135.0,
        grid_transfer_capacity_mw: 130.0,
        connection_capacity_mw: 180.0,
        flexibility_mw: 34.0,
        flexibility_need_mw: 52.0,
    };

    record.validate().expect("renewable record validation failed");
    println!("asset_id={}", record.asset_id);
    println!("forecast_error_mw={:.3}", record.forecast_error());
    println!("grid_constraint_score={:.3}", record.grid_constraint_score());
    println!("flexibility_adequacy={:.3}", record.flexibility_adequacy());
}
