# Trip merchandise picker origin

Reviewed plan — 2026-10-04

Primary skill: Swift Web UI checklist. Architecture IDs SWWEB-001/SWWEB-003. No boundary changes.

Scope: TripControler+AddMerchandise.swift, TripControler+CreateTripView.swift, and the merchandise-picker fact in architecture/SWIFWEB_APP_ARCHITECTURE.md.

Implementation: import TCFireSignal in the dedicated picker, add required `origin: CustCommercialTripsComponents.TripLocation` initializer argument and stored property, and pass the already-unwrapped origin from CreateTripView.addMerchendise. Preserve all existing account, list, callback, and UI behavior.

Plan review: CreateTripView stores the selected origin using the shared TripLocation snapshot type, and its current addMerchendise guard already unwraps origin. There is exactly one caller. A nonoptional snapshot keeps the picker origin consistent with the caller's requirement without synthesizing or converting IDs.

Completion: inspect the focused constructor/caller diff; run non-build whitespace checks; confirm the staged index and unrelated work remain intact. Builds/tests are not authorized and require explicit user confirmation.

Audit: reviewed the task-only diff in trip-merchandise-origin.diff. The picker imports the owner of TripLocation, requires/stores the complete origin snapshot, and its sole caller passes the origin already unwrapped by the existing guard. All three before/after whitespace checks emitted no diagnostics (no-index exit 1 indicates differing files). Staged-index SHA-256 is unchanged; status comparison shows only new task artifacts, while existing source/document modifications retain their previous status. No build/test/runtime checks were run without user confirmation.
