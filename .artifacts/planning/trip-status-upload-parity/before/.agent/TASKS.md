# Active Tasks

Active, approved, executable work only. Completed tasks move to `TASKS_ARCHIVE.md`.

## TRIP-STATUS-EVIDENCE-001 — Trip status asset and evidence validation

- **Status**: Implemented; source audit and focused Swift frontend parsing passed. The follow-up GetTrip contract task fetched the fixed pinned revisions and completed a user-approved `swift build --target App --disable-automatic-resolution` successfully. Browser/upload validation remains unrun.
- **Chunks/IDs**: `API-001`, `API-002`, `API-003`, `SWWEB-*`.
- **Scope**: `ConfirmTripStatusUpdate`, `TripControler+TripViewBeta`, `TripControler+CreateTripView`, `SearchComertialAsset`, the existing ChangeTripStatus wrapper, and affected architecture/source documentation.
- **Behavior**: Validate forward-only status transitions, cancellation comments, supported linked asset routes and unique snapshot evidence IDs/image filenames before submission. Refresh status notes after API success. Allow unavailable assets physically held by a subaccount to be picked up on a later trip while requiring active store/warehouse inventory.
- **Completion criteria**: Contract/route/source diff review and unchanged unrelated user work; focused builds and browser/real-upload validation require explicit confirmation.

---

## BUILD-DOC-001 — Canonical PWA Build Documentation

- **Status**: Planned
- **Chunks/IDs**: `PWA-*`, `APP-*`
- **Goal**: Document the exact commands and expected artifacts for development and distribution builds.
- **Completion criteria**: Verified build commands, output mapping for `DevPublic`/`DistPublic`, and service-worker validation steps.

---

## STATE-AUDIT-001 — SkylineWeb Global State Inventory

- **Status**: Planned
- **Chunks/IDs**: `SEC-*`, `STATE-*`, `API-*`, `WS-*`
- **Goal**: Classify globals in `SkylineWeb.swift` as configuration, server-owned state, derived cache, browser session data, or UI/runtime temporary state.
- **Completion criteria**: Updated architecture/state docs and open decisions resolved or narrowed.

---

## STATE-INIT-001 — Prevent Duplicate Main Configuration Sequence

- **Status**: Planned
- **Chunks/IDs**: `STATE-*`, `APP-*`, `API-*`
- **Important finding**: When opening `/` with an existing session, the main configuration sequence can run twice: `SplashScreen` calls `loadBasicConfiguration()`, routes to Work, and `WorkViewControler` calls `loadBasicConfiguration()` again.
- **Goal**: Establish one owner for the authenticated startup configuration sequence, or safely reuse its completed/in-flight state when Work loads.
- **Completion criteria**: Opening `/` with an existing session runs the main configuration sequence only once while preserving direct Work-route initialization and session recovery behavior.
