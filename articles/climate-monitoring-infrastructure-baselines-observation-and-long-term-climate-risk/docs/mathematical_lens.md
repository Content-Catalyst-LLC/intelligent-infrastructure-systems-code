# Mathematical Lens

## Climate anomaly

\[
A_{i,t} = X_{i,t} - B_i
\]

An anomaly compares an observed value with a reference-period baseline.

## Baseline

\[
B_i = \frac{1}{N}\sum_{t \in T_{\mathrm{ref}}} X_{i,t}
\]

A baseline is computed over a defined reference period and depends on completeness, continuity, and data quality.

## Simple trend model

\[
X_{i,t} = \alpha_i + \beta_i t + \epsilon_{i,t}
\]

A trend model estimates long-term change while recognizing residual variability.

## Completeness

\[
C_i = \frac{N_{\mathrm{observed},i}}{N_{\mathrm{expected},i}}
\]

Record completeness measures whether a time series has sufficient observations for baseline and trend use.

## Record quality

\[
Q_{\mathrm{record}} =
w_1C +
w_2M +
w_3K +
w_4H +
w_5P +
w_6A
\]

Record quality depends on completeness, metadata, calibration, homogeneity, provenance, and archive integrity.
