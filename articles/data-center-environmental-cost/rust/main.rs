fn pue(total_facility_energy_mwh: f64, it_energy_mwh: f64) -> f64 {
    if it_energy_mwh <= 0.0 {
        0.0
    } else {
        total_facility_energy_mwh / it_energy_mwh
    }
}

fn wue_liters_per_kwh(water_consumption_m3: f64, it_energy_mwh: f64) -> f64 {
    if it_energy_mwh <= 0.0 {
        0.0
    } else {
        (water_consumption_m3 * 1000.0) / (it_energy_mwh * 1000.0)
    }
}

fn emissions_tco2e(total_energy_mwh: f64, carbon_intensity_kgco2e_mwh: f64) -> f64 {
    total_energy_mwh * carbon_intensity_kgco2e_mwh / 1000.0
}

fn main() {
    let facility_pue = pue(775000.0, 620000.0);
    let facility_wue = wue_liters_per_kwh(510000.0, 620000.0);
    let facility_emissions = emissions_tco2e(775000.0, 390.0);

    println!("PUE: {:.3}", facility_pue);
    println!("WUE: {:.3} L/kWh IT", facility_wue);
    println!("Operational emissions: {:.2} tCO2e", facility_emissions);
}
