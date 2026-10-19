# Trip status crystal button colors — 2026-10-08

## Reviewed plan

Scope: three status button declarations in `TripControler+TripViewBeta.swift`, shared trip-scoped semantic color modifiers in `TCCrystalSurfaceTheme.swift`, and focused documentation/evidence. Architecture IDs: SWWEB-001/002/003; existing ownership and boundaries remain unchanged.

1. Keep `goodButton` and the existing crystal geometry/shadows. Add green modifiers to start/complete and a red modifier to cancel.
2. Define color rules after the trip blue control rule, with greater specificity and important border/background declarations. Reuse the existing user-configuration red crystal gradient/border/text and the order-view green accent palette for the green crystal treatment. Supply color-matched hover/focus states and a shared disabled appearance, preserving status-driven visibility and submission disabling.
3. Parse both Swift files, review baseline-relative changes and whitespace, and check repository status. No repeated package build for this presentation-only change: the already-authorized build remains blocked on the unavailable pinned TCFundamentals revision, as recorded in the prior status API audit. No browser session or tests are required for the source-only audit.

Completion: start/complete select green crystal styling; cancel selects red styling; semantic rules override blue normal/hover/focus styles; no behavior, dimensions, API or unrelated edits change. Sync the verified UI fact and task archive. No staging or commits.

Plan reviewed against the current theme cascade, existing palettes, native button control and repository UI checklist before source mutation.
