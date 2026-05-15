# Mathematical Lens

## Sensor coverage

\[
C_s =
\frac{N_{\mathrm{monitored\ critical\ assets}}}{N_{\mathrm{critical\ assets}}}
\]

Sensor coverage measures the share of critical assets, zones, or conditions that are actually monitored.

## Signal quality

\[
Q_s =
w_1 A_{\mathrm{accuracy}} +
w_2 P_{\mathrm{precision}} +
w_3 C_{\mathrm{completeness}} +
w_4 V_{\mathrm{validity}} +
w_5 F_{\mathrm{freshness}}
\]

Signal quality depends on accuracy, precision, completeness, validity, and freshness.

## Calibration confidence

\[
K_c =
\exp(-\lambda \Delta t_{\mathrm{since\ calibration}})
\]

Calibration confidence can decay as time since calibration increases.

## Telemetry reliability

\[
T_r =
1 -
\frac{N_{\mathrm{missing}} + N_{\mathrm{late}} + N_{\mathrm{invalid}}}{N_{\mathrm{expected}}}
\]

Telemetry reliability weakens when expected readings are missing, late, or invalid.

## Monitoring observability

\[
O_m =
\alpha C_s +
\beta Q_s +
\gamma K_c +
\delta T_r +
\theta M_c -
\eta B_g
\]

Monitoring observability improves with coverage, signal quality, calibration confidence, telemetry reliability, and metadata completeness, and weakens when blind spots grow.

## Monitoring-enabled resilience

\[
R_m =
\lambda_1 O_m +
\lambda_2 A_{\mathrm{action}} +
\lambda_3 B_{\mathrm{backup}} +
\lambda_4 V_{\mathrm{validation}} -
\lambda_5 E_{\mathrm{exposure}}
\]

Monitoring-enabled resilience rises with observability, action linkage, backup capability, and validation, while cyber, physical, organizational, and blind-spot exposure reduce resilience.
