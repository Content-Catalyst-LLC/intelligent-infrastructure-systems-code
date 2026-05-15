# Requires CSV.jl and DataFrames.jl.
# In Julia: import Pkg; Pkg.add(["CSV", "DataFrames"])
using CSV
using DataFrames

article_dir = normpath(joinpath(@__DIR__, ".."))
data_path = joinpath(article_dir, "data", "asset_exposure_inventory.csv")
output_dir = joinpath(article_dir, "outputs")
mkpath(output_dir)

assets = CSV.read(data_path, DataFrame)
assets.climate_risk_index = round.(assets.exposure_score .* assets.vulnerability_score .* assets.criticality_score, digits=3)
sort!(assets, :climate_risk_index, rev=true)
CSV.write(joinpath(output_dir, "adaptation_asset_risk_index.csv"), assets)
println(assets[:, [:asset_id, :infrastructure_domain, :primary_hazard, :climate_risk_index]])
