# Mathematical Lens

## Measured state

\[
y_t = h(x_t) + \epsilon_t
\]

Sensors do not provide the physical state directly. They provide measurements shaped by a sensing function and measurement error.

## Estimated state

\[
\hat{x}_t = f(y_t, m_t, c_t, q_t)
\]

Estimated system state depends on measurements, metadata, context, and quality signals.

## Control action

\[
u_t = g(\hat{x}_t, r_t, s_t, H_t)
\]

Control action depends on estimated state, rules or objectives, safety constraints, and human oversight.

## Physical transition

\[
x_{t+1} = F(x_t, u_t, d_t)
\]

The next physical state depends on current state, control action, and disturbance or demand conditions.

## Cyber-physical dependency

\[
D_c =
\frac{N_{\mathrm{functions\ dependent\ on\ cyber\ services}}}{N_{\mathrm{critical\ functions}}}
\]

Dependency measures how many critical physical functions rely on cyber services.

## Control integrity

\[
I_c =
\alpha Q_s +
\beta T_r +
\gamma V_c +
\delta S_c +
\theta H_o -
\eta E_c
\]

Control integrity improves with signal quality, telemetry reliability, control validation, security controls, and human oversight, while exposure reduces integrity.

## Cyber-physical resilience

\[
R_{cp} =
\lambda_1 I_c +
\lambda_2 B_f +
\lambda_3 M_o +
\lambda_4 R_e -
\lambda_5 D_c -
\lambda_6 E_c
\]

Cyber-physical resilience rises with control integrity, fallback capability, manual override, and recovery effectiveness, while dependency and exposure reduce resilience.
