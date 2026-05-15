#[derive(Debug)]
struct ControlLoopRecord {
    control_loop_id: String,
    asset_id: String,
    controller_id: String,
    timing_constraint_seconds: f64,
    command_within_bounds: bool,
    operator_acknowledged: bool,
    manual_override_available: bool,
    fallback_available: bool,
}

impl ControlLoopRecord {
    fn validate(&self) -> Result<(), String> {
        if self.control_loop_id.trim().is_empty() {
            return Err("control_loop_id is required".to_string());
        }
        if self.asset_id.trim().is_empty() {
            return Err("asset_id is required".to_string());
        }
        if self.controller_id.trim().is_empty() {
            return Err("controller_id is required".to_string());
        }
        if self.timing_constraint_seconds <= 0.0 {
            return Err("timing_constraint_seconds must be positive".to_string());
        }
        Ok(())
    }

    fn safety_review_required(&self) -> bool {
        !self.command_within_bounds
            || !self.operator_acknowledged
            || !self.manual_override_available
            || !self.fallback_available
    }
}

fn main() {
    let record = ControlLoopRecord {
        control_loop_id: "LOOP-SEC-001".to_string(),
        asset_id: "CP-SEC-001".to_string(),
        controller_id: "CTRL-SEC-001".to_string(),
        timing_constraint_seconds: 60.0,
        command_within_bounds: true,
        operator_acknowledged: true,
        manual_override_available: true,
        fallback_available: false,
    };

    record.validate().expect("control loop validation failed");
    println!("control_loop_id={}", record.control_loop_id);
    println!("safety_review_required={}", record.safety_review_required());
}
