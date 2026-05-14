# Mathematical Lens

Digital twins can be represented as structured relationships among physical state, observation, estimated state, scenario simulation, error, uncertainty, intervention, and decision value.

## Physical system state

\[
x_t \in \mathbb{R}^n
\]

The physical system state \(x_t\) contains variables describing infrastructure condition, flow, load, performance, environment, or operational status at time \(t\).

## Observation stream

\[
z_t = h(x_t) + \eta_t
\]

Observations \(z_t\) are noisy, partial, or delayed measurements of physical state, where \(\eta_t\) captures measurement error, missingness, or uncertainty.

## Estimated twin state

\[
\hat{x}_t = g(z_t, m_t, r_t)
\]

Estimated twin state \(\hat{x}_t\) is built from observations, model metadata, and records such as asset history, inspection logs, or operational context.

## Scenario simulation

\[
\hat{x}_{t+1} = f(\hat{x}_t, u_t, s_t, \theta)
\]

Future simulated state depends on current estimated state, intervention \(u_t\), scenario assumptions \(s_t\), and model parameters \(\theta\).

## Twin error

\[
e_t = \lVert x_t - \hat{x}_t \rVert
\]

Twin error measures divergence between the physical system and digital representation. Many infrastructure twins can validate only parts of this relationship.

## Scenario outcome value

\[
V(u,s)=B(y_{u,s})-C(u)-R(y_{u,s})
\]

The value of intervention \(u\) under scenario \(s\) depends on benefits, intervention costs, and residual risk.

## Intervention selection

\[
u^*=\arg\max_u \mathbb{E}[V(u,s)]
\]

The preferred intervention may be modeled as the option with highest expected value across scenarios, but final action requires governance review.
