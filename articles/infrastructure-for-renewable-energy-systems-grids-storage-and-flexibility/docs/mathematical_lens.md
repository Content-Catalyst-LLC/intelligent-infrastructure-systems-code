# Mathematical Lens

## Usable renewable energy

\[
U_t =
\min(G_{r,t},\ K_{g,t} + F_t + P_{\mathrm{charge},t})
\]

Usable renewable energy depends on generation availability, grid capacity, flexibility, and storage charging capability.

## Curtailment

\[
C_t =
\max(0,\ G_{r,t} - U_t)
\]

Curtailment occurs when renewable generation exceeds the system's ability to transmit, store, or use it.

## Storage state

\[
S_{t+1} =
S_t +
\eta_c P_{\mathrm{charge},t}
-
\frac{P_{\mathrm{discharge},t}}{\eta_d}
\]

Storage evolves through charging and discharging, adjusted by efficiency losses.

## Flexibility portfolio

\[
F_t =
F_{\mathrm{storage},t} +
F_{\mathrm{demand},t} +
F_{\mathrm{interconnection},t} +
F_{\mathrm{dispatch},t}
\]

Flexibility is a portfolio property produced by storage, demand response, interconnection, and dispatchable operational resources.

## Forecast error

\[
E_{\mathrm{forecast},t} =
\left|G_{r,t}^{\mathrm{forecast}} - G_{r,t}^{\mathrm{actual}}\right|
\]

Forecast error affects reserve needs, balancing, storage scheduling, curtailment, and reliability.

## Renewable infrastructure quality

\[
Q_{\mathrm{renewable}} =
\alpha U +
\beta F +
\gamma R_{\mathrm{resilience}}
-
\delta C
-
\eta E_{\mathrm{forecast}}
-
\theta K_{\mathrm{constraint}}
\]

Renewable infrastructure quality rises with usable renewable energy, flexibility, and resilience, while curtailment, forecast error, and grid constraints reduce performance.
