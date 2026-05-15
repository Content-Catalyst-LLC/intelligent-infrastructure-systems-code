# Mathematical Lens

## Environmental anomaly

\[
A_{i,t} = X_{i,t} - B_i
\]

An anomaly compares an observed environmental condition with a baseline or reference condition.

## Threshold indicator

\[
I_{i,t} =
\begin{cases}
1, & X_{i,t} \geq T_v \\
0, & X_{i,t} < T_v
\end{cases}
\]

A threshold indicator flags whether an observation exceeds a variable-specific environmental threshold.

## Monitoring quality

\[
Q_{\mathrm{monitoring}} =
w_1C +
w_2K +
w_3M +
w_4P +
w_5S
\]

Monitoring quality depends on completeness, calibration, metadata, provenance, and sampling design.

## Environmental risk

\[
R_{i,t} = H_{i,t} \times E_i \times V_i \times (1 - G_i)
\]

Environmental risk depends on hazard intensity, exposure, vulnerability, and governance response capacity.
