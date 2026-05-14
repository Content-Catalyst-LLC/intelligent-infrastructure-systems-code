# Mathematical Lens

Infrastructure cyber resilience requires more than control checklists. It connects exposure, vulnerability, control effectiveness, detection, containment, recovery, service continuity, and public trust.

## Cyber exposure

\[
X_i = E_i \times V_i
\]

Cyber exposure for system \(i\) increases when exposure pathways and vulnerabilities are both present.

## Residual exposure

\[
X^{\mathrm{residual}}_i = X_i(1 - C_i)
\]

Residual exposure remains after controls are applied. No control environment eliminates exposure completely.

## Impact duration

\[
T_{\mathrm{impact}} = T_{\mathrm{detect}} + T_{\mathrm{contain}} + T_{\mathrm{recover}}
\]

Service impact duration is shaped by detection, containment, and recovery time.

## Resilience quality

\[
Q_{\mathrm{resilience}} =
w_1A +
w_2I +
w_3P +
w_4D +
w_5C +
w_6R +
w_7G
\]

Cyber resilience quality combines asset visibility, identity governance, protection, detection, containment, recovery, and governance.

## Service continuity

\[
SC_i = \frac{P_{\mathrm{essential},i}}{T_{\mathrm{impact},i} + L_{\mathrm{degradation},i}}
\]

Service continuity improves when essential performance is preserved and impact duration and degradation level are reduced.

## Public trust

\[
Q_{\mathrm{public\ trust}} =
w_1SC +
w_2M +
w_3R +
w_4E +
w_5A_c
\]

Public trust after cyber disruption depends on continuity, communication, recovery credibility, equity of consequence, and accountability.
