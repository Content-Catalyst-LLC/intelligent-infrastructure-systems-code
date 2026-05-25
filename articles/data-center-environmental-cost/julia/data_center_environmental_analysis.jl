# Data center environmental analysis in Julia.
# Synthetic demonstration only.

using CSV
using DataFrames

root = normpath(joinpath(@__DIR__, ".."))
data_path = joinpath(root, "data", "raw", "data_center_environmental_synthetic.csv")
out_path = joinpath(root, "outputs", "tables", "data_center_environmental_summary_julia.csv")

df = CSV.read(data_path, DataFrame)

df.pue = df.total_facility_energy_mwh ./ df.it_energy_mwh
df.wue_l_per_kwh_it = (df.water_consumption_m3 .* 1000) ./ (df.it_energy_mwh .* 1000)
df.operational_emissions_tco2e =
    df.total_facility_energy_mwh .* df.grid_carbon_intensity_kgco2e_mwh ./ 1000
df.renewable_mismatch_share = 1 .- df.renewable_hourly_match_share
df.high_ai_workload = df.ai_workload_share .>= 0.50

mkpath(dirname(out_path))
CSV.write(out_path, df)

println(df[:, [
    :facility_id,
    :region,
    :facility_type,
    :pue,
    :wue_l_per_kwh_it,
    :operational_emissions_tco2e,
    :ai_workload_share,
    :peak_load_mw
]])
