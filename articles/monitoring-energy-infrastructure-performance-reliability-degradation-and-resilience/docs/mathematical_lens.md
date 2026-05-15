# Mathematical Lens

## Availability

\[
A_i =
\frac{T_{\mathrm{available},i}}{T_{\mathrm{total},i}}
\]

Asset availability compares available service time with total monitored time.

## Degradation

\[
D_{i,t} =
\frac{H_{i,0} - H_{i,t}}{H_{i,0}}
\]

Degradation measures relative decline from baseline asset health.

## Stress index

\[
S_{i,t} =
w_1L_{i,t} +
w_2\Theta_{i,t} +
w_3C_{i,t} +
w_4E_{i,t}
\]

Stress can combine loading, thermal stress, cycling, and environmental exposure.

## Asset health transition

\[
H_{i,t+1} =
H_{i,t} -
\phi S_{i,t} +
\psi M_{i,t}
\]

Future health declines with stress and improves with maintenance.

## Service continuity

\[
C_{\mathrm{service},t} =
\frac{P_{\mathrm{served},t}}{P_{\mathrm{demand},t}}
\]

Service continuity compares served power with demand or service obligation.

## Resilience

\[
R_{\mathrm{resilience}} =
\alpha A +
\beta C_{\mathrm{service}} +
\gamma F +
\delta V -
\eta T_{\mathrm{restore}}
\]

Resilience depends on availability, service continuity, fallback capacity, system visibility, and restoration time.
