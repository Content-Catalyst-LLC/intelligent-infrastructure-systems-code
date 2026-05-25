program infrastructure_metrics
  implicit none

  real :: total_energy_mwh, it_energy_mwh, water_consumption_m3
  real :: carbon_intensity, facility_pue, facility_wue, facility_emissions

  total_energy_mwh = 775000.0
  it_energy_mwh = 620000.0
  water_consumption_m3 = 510000.0
  carbon_intensity = 390.0

  facility_pue = total_energy_mwh / it_energy_mwh
  facility_wue = (water_consumption_m3 * 1000.0) / (it_energy_mwh * 1000.0)
  facility_emissions = total_energy_mwh * carbon_intensity / 1000.0

  print *, "PUE:", facility_pue
  print *, "WUE:", facility_wue, "L/kWh IT"
  print *, "Operational emissions:", facility_emissions, "tCO2e"
end program infrastructure_metrics
