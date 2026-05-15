# Mathematical Lens

## Grid observability

\[
O_{g,t} =
\alpha T_t +
\beta Q_{\mathrm{data},t} +
\gamma C_{\mathrm{coverage},t} +
\delta M_{\mathrm{metadata},t}
-
\eta G_{\mathrm{gaps},t}
\]

Grid observability improves with telemetry reliability, data quality, measurement coverage, and metadata completeness, and weakens with monitoring gaps.

## Flexibility portfolio

\[
F_t =
F_{\mathrm{storage},t} +
F_{\mathrm{demand},t} +
F_{\mathrm{DER},t} +
F_{\mathrm{interconnection},t}
\]

Grid flexibility is a portfolio property created by storage, demand response, distributed resources, interconnection, and operational coordination.

## Balancing pressure

\[
B_t =
\left|S_t + F_t - D_t\right|
\]

Balancing pressure grows when supply plus flexibility does not closely match demand.

## Voltage adequacy

\[
V_{\mathrm{adequacy},z,t} =
1 -
\frac{\left|V_{z,t} - V_{\mathrm{nominal}}\right|}{\Delta V_{\max}}
\]

Voltage adequacy expresses how close a zone remains to nominal voltage within an allowed deviation band.

## Service continuity

\[
C_{\mathrm{service},t} =
\frac{H_{\mathrm{served},t}}{H_{\mathrm{required},t}}
\]

Service continuity compares hours of electricity service delivered with required or expected service hours.

## Grid resilience

\[
R_{\mathrm{grid}} =
\lambda_1 C_{\mathrm{service}} +
\lambda_2 F +
\lambda_3 O_g +
\lambda_4 B_{\mathrm{backup}} +
\lambda_5 A_{\mathrm{response}}
-
\lambda_6 E_{\mathrm{exposure}}
\]

Grid resilience rises with service continuity, flexibility, observability, backup capability, and response capacity, while physical, climate, and cyber-physical exposure reduce resilience.
