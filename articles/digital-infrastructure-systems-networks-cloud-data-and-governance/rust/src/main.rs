#[derive(Debug)]
struct DigitalInfrastructureRecord {
    service_zone_id: String,
    users_needing_access: f64,
    users_with_affordable_reliable_access: f64,
    critical_digital_services: f64,
    concentrated_provider_services: f64,
    failover_tested: bool,
    public_note_required: bool,
}

impl DigitalInfrastructureRecord {
    fn validate(&self) -> Result<(), String> {
        if self.service_zone_id.trim().is_empty() {
            return Err("service_zone_id is required".to_string());
        }
        if self.users_needing_access < 0.0 || self.users_with_affordable_reliable_access < 0.0 {
            return Err("user counts cannot be negative".to_string());
        }
        if self.critical_digital_services < 0.0 || self.concentrated_provider_services < 0.0 {
            return Err("service counts cannot be negative".to_string());
        }
        Ok(())
    }

    fn digital_access_score(&self) -> f64 {
        if self.users_needing_access <= 0.0 {
            return 0.0;
        }
        (self.users_with_affordable_reliable_access / self.users_needing_access).clamp(0.0, 1.0)
    }

    fn vendor_dependency_score(&self) -> f64 {
        if self.critical_digital_services <= 0.0 {
            return 0.0;
        }
        (self.concentrated_provider_services / self.critical_digital_services).clamp(0.0, 1.0)
    }

    fn review_required(&self) -> bool {
        self.digital_access_score() < 0.85
            || self.vendor_dependency_score() > 0.70
            || !self.failover_tested
            || self.public_note_required
    }
}

fn main() {
    let record = DigitalInfrastructureRecord {
        service_zone_id: "DIGI-RURAL-EDGE".to_string(),
        users_needing_access: 65000.0,
        users_with_affordable_reliable_access: 42000.0,
        critical_digital_services: 12.0,
        concentrated_provider_services: 10.0,
        failover_tested: false,
        public_note_required: true,
    };

    record.validate().expect("record validation failed");
    println!("service_zone_id={}", record.service_zone_id);
    println!("digital_access_score={:.3}", record.digital_access_score());
    println!("vendor_dependency_score={:.3}", record.vendor_dependency_score());
    println!("review_required={}", record.review_required());
}
