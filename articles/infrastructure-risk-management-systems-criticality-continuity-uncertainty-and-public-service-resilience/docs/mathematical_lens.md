# Mathematical Lens

Infrastructure risk management requires more than probability-by-consequence scoring. Risk must be connected to criticality, dependency, mitigation, recovery, financing, and governance.

## Basic risk

\[
R_i = P_i \times C_i
\]

Basic risk for asset or function \(i\) is the product of failure probability \(P_i\) and consequence \(C_i\).

## Criticality

\[
K_i = w_1S_i + w_2D_i + w_3U_i + w_4H_i
\]

Criticality combines service importance \(S_i\), dependency centrality \(D_i\), lack of substitutes \(U_i\), and human or public-harm consequence \(H_i\).

## Dependency-adjusted system risk

\[
R^{\mathrm{system}}_i = P_i \times C_i \times (1 + D_i)
\]

System risk increases when local failure can propagate through dependencies.

## Residual risk

\[
R^{\mathrm{residual}}_i = R_i(1 - M_i)
\]

Residual risk remains after mitigation, control effectiveness, redundancy, maintenance, or adaptation is applied.

## Continuity capacity

\[
C_{\mathrm{continuity}} = \frac{P_{\mathrm{essential}}}{T_{\mathrm{recovery}} + D_{\mathrm{disruption}}}
\]

Continuity capacity improves when essential performance is preserved and recovery time and disruption severity are reduced.

## Risk governance quality

\[
Q_{\mathrm{risk\ governance}} =
w_1O +
w_2A +
w_3F +
w_4C +
w_5L +
w_6G
\]

Risk governance quality combines ownership, assessment quality, financing readiness, continuity planning, learning, and governance authority.
