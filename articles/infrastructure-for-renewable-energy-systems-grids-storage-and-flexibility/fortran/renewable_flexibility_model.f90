program renewable_flexibility_model
  implicit none
  real :: generation, grid_capacity, flexibility, storage_charge
  real :: usable, curtailment, flexibility_need, flex_adequacy
  real :: connection_capacity, grid_constraint, resilience, forecast_quality, storage_readiness
  real :: infrastructure_score

  generation = 118.0
  grid_capacity = 130.0
  flexibility = 34.0
  storage_charge = 18.0
  flexibility_need = 52.0
  connection_capacity = 180.0
  resilience = 0.62
  forecast_quality = 0.70
  storage_readiness = 0.62

  usable = min(generation, max(0.0, grid_capacity + flexibility + storage_charge))
  if (generation > 0.0) then
    curtailment = max(0.0, min(1.0, (generation - usable) / generation))
  else
    curtailment = 0.0
  end if

  if (flexibility_need > 0.0) then
    flex_adequacy = max(0.0, min(1.0, flexibility / flexibility_need))
  else
    flex_adequacy = 1.0
  end if

  if (connection_capacity > 0.0) then
    grid_constraint = max(0.0, min(1.0, 1.0 - grid_capacity / connection_capacity))
  else
    grid_constraint = 0.0
  end if

  infrastructure_score = max(0.0, min(1.0, 0.25 * (1.0 - curtailment) + 0.20 * flex_adequacy + 0.20 * resilience + 0.15 * forecast_quality + 0.10 * storage_readiness - 0.10 * grid_constraint))

  print *, "usable_renewable_mw=", usable
  print *, "curtailment_rate=", curtailment
  print *, "flexibility_adequacy=", flex_adequacy
  print *, "grid_constraint_score=", grid_constraint
  print *, "renewable_infrastructure_score=", infrastructure_score
end program renewable_flexibility_model
