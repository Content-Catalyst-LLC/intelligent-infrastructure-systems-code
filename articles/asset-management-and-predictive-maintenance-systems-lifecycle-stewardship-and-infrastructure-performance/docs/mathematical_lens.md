# Mathematical Lens

Asset management and predictive maintenance can be modeled as a lifecycle stewardship problem across condition, deterioration, risk, consequence, maintenance effect, remaining useful life, and budget constraint.

## Asset portfolio

\[
A=\{a_1,a_2,\ldots,a_n\}
\]

The asset portfolio \(A\) contains individual assets \(a_i\) that must be monitored, maintained, renewed, or retired.

## Condition state

\[
C_i(t)\in[0,1]
\]

Asset condition \(C_i(t)\) describes the health or performance state of asset \(i\) at time \(t\), with lower values often indicating poorer condition.

## Deterioration and maintenance effect

\[
C_i(t+1)=C_i(t)-d_i(t)+m_i(t)
\]

Future condition depends on current condition, deterioration \(d_i(t)\), and maintenance or renewal effect \(m_i(t)\).

## Risk

\[
R_i=P_iF_i
\]

Asset risk \(R_i\) can be approximated as failure probability \(P_i\) multiplied by failure consequence \(F_i\).

## Priority score

\[
Q_i=w_C(1-C_i)+w_FF_i+w_RR_i-w_BB_i
\]

Priority \(Q_i\) increases when condition is poor, consequence is high, and risk is high, while budget or feasibility constraints \(B_i\) may reduce immediate actionability.

## Remaining useful life

\[
RUL_i=\min\{t:C_i(t)\leq C_{\mathrm{min}}\}
\]

Remaining useful life is the time until condition falls below an acceptable minimum threshold.

## Lifecycle cost

\[
LCC_i=\sum_{t=0}^{T}\frac{M_i(t)+O_i(t)+K_i(t)+H_i(t)}{(1+r)^t}
\]

Lifecycle cost includes maintenance \(M_i\), operations \(O_i\), capital renewal \(K_i\), and failure or disruption cost \(H_i\), discounted over time by rate \(r\).

## Portfolio optimization

\[
\max \sum_{i=1}^{n} V_i x_i
\quad \mathrm{subject\ to} \quad
\sum_{i=1}^{n} Cost_i x_i \leq B
\]

Asset managers may seek to maximize intervention value \(V_i\) under a budget constraint \(B\), where \(x_i\) indicates whether intervention \(i\) is selected.
