# Trip location action menu icons

Reviewed plan — 2026-10-02

Scope: Sources/App/Snippits/TripControler/TripControler+AddLocation.swift only, plus the existing SWIFWEB_APP_ARCHITECTURE verified menu fact. Architecture IDs SWWEB-001 and SWWEB-002; no rule changes.

Add compact cyan outline location-plus, storefront, and magnifier icons to the three menu options, matching the supplied screenshot. Use static SVG data-image sources within the picker, with decorative image accessibility attributes. Lay out each button as a flex row with fixed 18px icons and a 10px label gap. Keep callbacks, dropdown dismissal, focus handling, and all unrelated user edits intact.

Plan review: local static SVGs require no network or asset packaging changes and avoid modifying shared control styling. Existing menu buttons retain their own accessible labels via text spans.

Audit: review the focused pre/post diff and git status. No builds/tests without user confirmation.

## Audit result

- Reviewed the task-only source diff against the pre-edit snapshot: changes are limited to static SVG icon sources, decorative image/text button content, row alignment, and the three icon arguments. Existing callbacks and menu lifecycle behavior are unchanged.
- The three SVGs use 24x24 view boxes, 1.5px cyan outline strokes, and 18px rendered sizes. Icons are hidden from accessibility; each button retains its visible text label.
- Reviewed git status: only the scoped source, existing architecture fact, and this task's transient plan/backup reference were edited by this task; unrelated existing work is preserved.
- git diff --check on the architecture document passed. The untracked source's task-only diff has no introduced trailing whitespace.
- Builds/tests and live browser validation were not run; repository build/test confirmation has not been provided.
