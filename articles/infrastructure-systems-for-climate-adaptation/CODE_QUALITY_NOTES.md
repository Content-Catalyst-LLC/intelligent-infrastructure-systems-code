# Code Quality Notes

This technical-rigor pass adds the following quality controls:

1. Explicit article-directory creation before any file writes.
2. Portable Python examples that use the standard library by default.
3. Separate scoring, validation, and service-continuity workflows.
4. SQL schema constraints for bounded scores and referential structure.
5. A sample SQLite load file so tables can be populated reproducibly.
6. Bash smoke tests that run syntax and workflow checks where tools are available.
7. Unit tests that can run with Python's built-in `unittest` module.
8. Configuration manifests and public-evidence policy files.
9. Systems-code examples that model validation, thresholding, and continuity logic without pretending to be production controllers.
10. Safer git behavior: the scaffold is created locally even if clone, pull, commit, or push fails.

The examples remain educational scaffolds. They do not replace engineering design, local climate analysis, public consultation, hydrologic modeling, asset inspection, or statutory infrastructure review.
