using Random
using Statistics

Random.seed!(42)

n_assets = 100
failure_probability = 0.08
failures = rand(n_assets) .< failure_probability

println("Simulated failures: ", sum(failures))
println("Failure rate: ", mean(failures))
