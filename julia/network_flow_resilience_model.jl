using Statistics

capacities = [100.0, 80.0, 60.0, 50.0]
disrupted = [false, true, false, false]

available_capacity = sum(capacities[.!disrupted])
total_capacity = sum(capacities)
resilience_ratio = available_capacity / total_capacity

println("Available capacity: ", available_capacity)
println("Resilience ratio: ", resilience_ratio)
