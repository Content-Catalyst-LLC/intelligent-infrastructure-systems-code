use std::collections::HashSet;

fn main() {
    let required_fields: HashSet<&str> = [
        "asset_id",
        "sector",
        "sensor_type",
        "observed_value",
        "battery_voltage",
        "signal_quality",
        "communication_mode",
        "observed_at",
    ]
    .into_iter()
    .collect();

    let observed_fields: HashSet<&str> = [
        "asset_id",
        "sector",
        "sensor_type",
        "observed_value",
        "battery_voltage",
        "signal_quality",
        "communication_mode",
        "observed_at",
    ]
    .into_iter()
    .collect();

    let missing: Vec<&&str> = required_fields.difference(&observed_fields).collect();

    if missing.is_empty() {
        println!("Infrastructure telemetry schema validation passed.");
    } else {
        println!("Missing fields: {:?}", missing);
    }
}
