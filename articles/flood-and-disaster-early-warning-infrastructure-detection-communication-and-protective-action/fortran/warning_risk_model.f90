program warning_risk_model
  implicit none

  real :: detection, reach, comprehension, trust, action_capacity
  real :: hazard, exposure, vulnerability
  real :: protective_probability, residual_risk

  detection = 0.78
  reach = 0.76
  comprehension = 0.70
  trust = 0.68
  action_capacity = 0.62

  hazard = 0.82
  exposure = 0.78
  vulnerability = 0.70

  protective_probability = detection * reach * comprehension * trust * action_capacity
  residual_risk = hazard * exposure * vulnerability * (1.0 - protective_probability)

  print *, "protective_warning_probability=", protective_probability
  print *, "residual_warning_risk=", residual_risk
end program warning_risk_model
