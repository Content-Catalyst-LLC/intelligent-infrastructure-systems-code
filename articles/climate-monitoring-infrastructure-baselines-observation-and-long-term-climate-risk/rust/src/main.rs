#[derive(Debug)]
struct ClimateObservation {
    station_id: String,
    variable: String,
    value: f64,
    baseline: f64,
    completeness: f64,
    metadata_score: f64,
    calibration_score: f64,
}

impl ClimateObservation {
    fn anomaly(&self) -> f64 {
        self.value - self.baseline
    }

    fn quality_score(&self) -> f64 {
        0.35 * self.completeness + 0.35 * self.metadata_score + 0.30 * self.calibration_score
    }

    fn validate(&self) -> Result<(), String> {
        for (name, value) in [
            ("completeness", self.completeness),
            ("metadata_score", self.metadata_score),
            ("calibration_score", self.calibration_score),
        ] {
            if !(0.0..=1.0).contains(&value) {
                return Err(format!("{} out of range: {}", name, value));
            }
        }

        Ok(())
    }
}

fn main() {
    let record = ClimateObservation {
        station_id: "CLM-ATM-001".to_string(),
        variable: "surface_air_temperature".to_string(),
        value: 5.9,
        baseline: 4.3,
        completeness: 0.83,
        metadata_score: 1.0,
        calibration_score: 1.0,
    };

    record.validate().expect("record validation failed");
    println!("station_id={}", record.station_id);
    println!("variable={}", record.variable);
    println!("anomaly={:.3}", record.anomaly());
    println!("quality_score={:.3}", record.quality_score());
}
