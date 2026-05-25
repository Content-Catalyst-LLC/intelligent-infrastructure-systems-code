-- Data center environmental infrastructure schema.
-- Synthetic data only.

DROP TABLE IF EXISTS data_centers;

CREATE TABLE data_centers (
    facility_id TEXT PRIMARY KEY,
    region TEXT NOT NULL,
    facility_type TEXT NOT NULL,
    it_energy_mwh REAL NOT NULL,
    total_facility_energy_mwh REAL NOT NULL,
    water_withdrawal_m3 REAL NOT NULL,
    water_consumption_m3 REAL NOT NULL,
    grid_carbon_intensity_kgco2e_mwh REAL NOT NULL,
    ai_workload_share REAL NOT NULL,
    cooling_type TEXT NOT NULL,
    peak_load_mw REAL NOT NULL,
    renewable_hourly_match_share REAL NOT NULL,
    backup_generator_fuel TEXT NOT NULL,
    annual_server_refresh_share REAL NOT NULL,
    water_stress_level TEXT NOT NULL
);

DROP VIEW IF EXISTS data_center_environmental_metrics;

CREATE VIEW data_center_environmental_metrics AS
SELECT
    facility_id,
    region,
    facility_type,
    total_facility_energy_mwh / NULLIF(it_energy_mwh, 0) AS pue,
    (water_consumption_m3 * 1000.0) / NULLIF(it_energy_mwh * 1000.0, 0) AS wue_l_per_kwh_it,
    total_facility_energy_mwh * grid_carbon_intensity_kgco2e_mwh / 1000.0 AS operational_emissions_tco2e,
    ai_workload_share,
    peak_load_mw,
    renewable_hourly_match_share,
    water_stress_level,
    CASE
      WHEN water_stress_level = 'high' AND water_consumption_m3 > 400000 THEN 1
      ELSE 0
    END AS high_water_stress_consumption_flag
FROM data_centers;
