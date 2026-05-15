# Mathematical Lens

## Water-quality compliance

\[
Q_{z,t} =
\frac{N_{\mathrm{compliant},z,t}}{N_{\mathrm{tested},z,t}}
\]

Water-quality compliance compares compliant samples or monitored observations with total tested observations.

## Pressure adequacy

\[
P_{\mathrm{adequacy},z,t} =
\frac{P_{z,t} - P_{\min}}{P_{\max} - P_{\min}}
\]

Pressure adequacy expresses whether pressure remains within a useful operating range.

## Leakage / non-revenue water

\[
L_{z,t} =
\frac{V_{\mathrm{input},z,t} - V_{\mathrm{authorized},z,t}}{V_{\mathrm{input},z,t}}
\]

Leakage or non-revenue water is represented as the share of system input volume not accounted for by authorized consumption.

## Service continuity

\[
C_{\mathrm{service},z,t} =
\frac{H_{\mathrm{available},z,t}}{H_{\mathrm{required},z,t}}
\]

Service continuity compares available service hours with required or expected service hours.

## Water observability

\[
O_{\mathrm{water}} =
\alpha T +
\beta Q_{\mathrm{data}} +
\gamma C_{\mathrm{coverage}} +
\delta M_{\mathrm{metadata}} -
\eta G_{\mathrm{gaps}}
\]

Water-system observability depends on telemetry reliability, data quality, coverage, metadata, and monitoring gaps.

## Water resilience

\[
R_{\mathrm{water}} =
\lambda_1 C_{\mathrm{service}} +
\lambda_2 Q +
\lambda_3 B_{\mathrm{backup}} +
\lambda_4 O_{\mathrm{water}} +
\lambda_5 A_{\mathrm{response}}
-
\lambda_6 E_{\mathrm{exposure}}
\]

Water resilience rises with service continuity, quality, backup capability, observability, and response capacity, while drought, flood, contamination, and cyber-physical exposure reduce resilience.
