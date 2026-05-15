program environmental_risk_model
  implicit none

  real :: observed, threshold, hazard_intensity
  real :: exposure, vulnerability, governance_response
  real :: environmental_risk

  observed = 42.0
  threshold = 40.0
  exposure = 0.82
  vulnerability = 0.70
  governance_response = 0.58

  hazard_intensity = min(observed / threshold, 2.0) / 2.0
  environmental_risk = hazard_intensity * exposure * vulnerability * (1.0 - governance_response)

  print *, "hazard_intensity=", hazard_intensity
  print *, "environmental_risk_score=", environmental_risk
end program environmental_risk_model
