# Data Dictionary

## data_center_environmental_synthetic.csv

| Field | Description |
|---|---|
| facility_id | Synthetic data center identifier |
| region | Synthetic regional context |
| facility_type | Broad facility/workload type |
| it_energy_mwh | Annual IT equipment electricity use in MWh |
| total_facility_energy_mwh | Annual total facility electricity use in MWh |
| water_withdrawal_m3 | Annual water withdrawal in cubic meters |
| water_consumption_m3 | Annual water consumption in cubic meters |
| grid_carbon_intensity_kgco2e_mwh | Grid emissions factor in kg CO2e per MWh |
| ai_workload_share | Share of workload associated with AI training/inference |
| cooling_type | Simplified cooling system type |
| peak_load_mw | Approximate peak electrical load in MW |
| renewable_hourly_match_share | Share of hourly load matched with renewable generation |
| backup_generator_fuel | Backup power technology/fuel category |
| annual_server_refresh_share | Share of servers/accelerators refreshed annually |
| water_stress_level | Simplified regional water-stress classification |

## workload_growth_scenarios_synthetic.csv

| Field | Description |
|---|---|
| scenario | Synthetic demand-growth scenario |
| year | Scenario year |
| baseline_compute_index | Non-AI or baseline compute demand index |
| ai_compute_index | AI compute demand index |
| efficiency_gain_pct | Efficiency gain relative to baseline |
| total_energy_index | Resulting synthetic energy-demand index |
| notes | Plain-language scenario description |
