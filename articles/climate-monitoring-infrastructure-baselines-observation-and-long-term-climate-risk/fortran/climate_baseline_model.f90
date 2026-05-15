program climate_baseline_model
  implicit none

  integer, parameter :: n = 6
  real :: values(n)
  real :: baseline, anomaly, trend_proxy
  integer :: i

  values = (/ 4.2, 4.5, 4.1, 5.4, 5.7, 5.9 /)

  baseline = 0.0
  do i = 1, 3
     baseline = baseline + values(i)
  end do
  baseline = baseline / 3.0

  anomaly = values(n) - baseline
  trend_proxy = (values(n) - values(1)) / real(n - 1)

  print *, "baseline=", baseline
  print *, "latest_anomaly=", anomaly
  print *, "trend_proxy_per_step=", trend_proxy
end program climate_baseline_model
