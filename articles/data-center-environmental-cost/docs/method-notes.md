# Method Notes

This scaffold uses simplified infrastructure metrics for data center energy, cooling, water, and workload analysis.

Power usage effectiveness:

\[
PUE = \frac{E_{total}}{E_{IT}}
\]

Water usage effectiveness:

\[
WUE = \frac{W_{site}}{E_{IT}}
\]

Operational emissions:

\[
CO_2e = E_{grid} \cdot CI_{grid}
\]

Compute efficiency:

\[
\eta_{compute} = \frac{C_{useful}}{E_{IT}}
\]

System-level impact relationship:

\[
Impact = Demand \times Intensity
\]

These equations are simplified for teaching and reproducibility. Applied analysis should use facility-level metering, hourly electricity data, regional grid emissions, local water-basin stress, cooling-system details, backup-generator records, embodied-carbon inventories, hardware-lifecycle data, and independent verification.
