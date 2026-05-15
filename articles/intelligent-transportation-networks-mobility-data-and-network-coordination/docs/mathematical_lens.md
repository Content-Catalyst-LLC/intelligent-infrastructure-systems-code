# Mathematical Lens

## Travel-time reliability

\[
R_m = 1 - \frac{\sigma(T_m)}{\mu(T_m)}
\]

Reliability for mode \(m\) declines as travel-time variability rises relative to mean travel time.

## Accessibility

\[
A_o = \sum_{d=1}^{n} O_d \cdot f(T_{o,d})
\]

Accessibility from origin \(o\) depends on reachable opportunities and the travel burden required to reach them.

## Coordination quality

\[
C_{\mathrm{coord}} =
w_1I +
w_2H +
w_3P +
w_4X +
w_5G
\]

Coordination quality depends on interoperability, schedule/headway alignment, priority management, transfer quality, and governance capacity.

## Mobility quality

\[
Q_{\mathrm{mobility}} =
\alpha R +
\beta A +
\gamma S +
\delta C_{\mathrm{coord}} -
\eta E
\]

Mobility quality rises with reliability, accessibility, safety, and coordination, while emissions burden reduces overall performance.

## Incident recovery lag

\[
L_{\mathrm{incident}} =
\max(0,\ T_{\mathrm{restore}} - T_{\mathrm{target}})
\]

Incident recovery lag measures how far restoration time exceeds the target recovery time.
