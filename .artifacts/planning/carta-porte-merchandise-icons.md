# Carta Porte merchandise icons

## PLAN — reviewed before source mutation

- Request: complete the two icon TODOs in `CartaPorteMerchendise.swift` (original lines 199 and 228).
- Primary guidance: Swift Web UI checklist; owning IDs `SWWEB-001`, `SWWEB-003`.
- Scope: the merchandise snippet and task archive. Reuse existing `icon_clip.png` and `mobileCamara.png` assets; no new files in source/resources or API changes.
- Add a shared vertical icon group in both removable/non-removable branches, with explicit 24px sizes and Spanish image labels/tooltips. The TODOs specify icons only; do not invent upload/camera behavior or callbacks.
- Reserve the existing 50px side column in both modes so the non-removable variant does not exceed 100% row width. Keep the existing remove callback, fiscal fields, and row presentation intact.
- Preserve current dirty/staged user work with baselines; no staging, commits, builds or tests.

## Completion / AUDIT

- Both TODOs replaced by the same icon group; non-removable rows show only attachment/camera icons, removable rows retain the existing remove action.
- Static asset-path, layout/size, callback and diff review; task-only whitespace and status/staging comparison.
- Document the completed visual-only change. Runtime/compilation remain unverified because the user requested non-build checks only.

## Review

The plan matches the literal TODOs and the existing asset/row conventions. Both row modes already contain the same 50px rail; only the non-removable content width requires adjustment. No architecture boundary or source-map change is needed.

## AUDIT results

- Both original TODO lines now invoke the same icon-group helper. Existing remove image/click callback and all merchandise fields are unchanged in the baseline diff.
- Asset inspection confirmed `icon_clip.png` (512x512), `mobileCamara.png` (128x128), and existing `cross.png` (18x18) under the packaged Skyline media path. New images explicitly render at 24x24 and reuse `.iconWhite` as in `MessageGrid`.
- The vertical group occupies 52px plus 4px bottom spacing; the remove image still fits below it within the existing 85px rail. Both content variants use `calc(100% - 50px)` beside the 50px rail.
- Task-only added-line whitespace is clean; focused `git diff --check` passed. Baseline/status comparison found no existing staging changes and only task evidence additions.
- Source-map/module/architecture ownership remains valid; task archive records the visual-only behavior. No build, compiler, test or browser commands were run. Runtime layout remains unverified.
- Evidence: `carta-porte-merchandise-icons-baseline/`, `carta-porte-merchandise-icons.diff`, and `carta-porte-merchandise-icons-status.txt`.
