# Engineering Notes

## Design priorities

Climate monitoring infrastructure should be engineered around the full record chain:

1. Define climate variables and decision uses.
2. Observe the variable using suitable platforms and standards.
3. Preserve metadata, calibration, and station history.
4. Archive observations with provenance and versioning.
5. Compute baselines, anomalies, completeness, and quality flags.
6. Publish usable climate services with caveats.
7. Maintain governance and continuity across decades.

## Common failure modes

- station relocation without metadata
- instrument replacement without cross-calibration
- missingness ignored in baselines
- data archive not versioned
- satellite retrieval algorithm changes undocumented
- dashboard indicators missing uncertainty notes
- operational observations reused for climate claims without quality review
- archive access restricted or not reproducible
- short-term funding undermines long-term records
