# Active Tasks

Active, approved, executable work only. Completed tasks move to `TASKS_ARCHIVE.md`.

## ORDER-CHARGE-TYPE-001 — Shared charge BillingType compatibility

- **Status**: Four constructors and the approved-budget SOC.type conversion are aligned. The follow-up shared `CustAcctCharges`/`CustAcctChargesQuick.billingType` rename was audited across PWA consumers; no direct PWA source changes are required. Companion server constructors, queries and TCFoundation schema creation are aligned; existing tenants require `RenameCustAcctChargesBillingType.sql` before deployment. Focused documentation/diff review passed and unrelated UI work is preserved. Builds/tests, SQL and browser execution were not run.
- **Chunks/IDs**: `API-001`, `API-002`, `API-003`, `SWWEB-003`.
- **Approved scope**: Four `CustOrderLoadFolioCharges` constructors in `OrderView.swift` and `TripControler+TripViewBeta.swift`, together with backend/shared-model compatibility fixes in the companion repositories and the follow-up shared account-charge `billingType` contract audit.
- **Reviewed plan**: Pass adjustment-or-charge classification when creating local charges; retain the existing classification when editing; read approved-budget `CustOrderLoadFolioChargesSOC.type` to populate `CustOrderLoadFolioCharges.billingType` using the established response mapping. Use the updated shared account-charge `billingType` field/initializer contract and retain the separate SOC `type` key through backend aliases. Keep the shared model as contract authority and preserve unrelated UI, arithmetic and lifecycle code.
- **Completion criteria**: Audit all shared-charge constructors, review the focused patch, and confirm unrelated user work is unchanged. Builds/tests require separate confirmation; this task uses source checks.
- **Model rename follow-up**: Use `billingType` for the four local order/trip summary constructors and the shared `CustOrderCreateCharges`/`CustOrderLoadFolioCharges` fields and initializer labels. Shared JSON encoding uses the new key while decoding also accepts `chargeType`; companion server conversions and `ChargeObject` JSON coding are aligned. Preserve the separate SOC `type` key, classification values and unrelated UI edits. The field declarations, JSON keys/legacy fallback and 13 companion constructor replacements passed source and focused diff review. Builds/tests were not run and require confirmation.

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
